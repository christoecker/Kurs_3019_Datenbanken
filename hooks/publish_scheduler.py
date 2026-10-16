"""MkDocs-Hook: zeitgesteuerte Veroeffentlichung von Seiten.

Erlaubt, Arbeitsauftraege bereits vorab ins Repository zu pushen, aber
erst ab einem bestimmten Datum auf der gebauten Kurswebseite erscheinen
zu lassen. Dazu wird im YAML-Frontmatter der Markdown-Datei ein Feld
"publish_date" (Format YYYY-MM-DD) gesetzt. Liegt dieses Datum in der
Zukunft, wird die Seite beim Bauen komplett aus dem Build entfernt
(nicht nur aus der Navigation) - sie landet also gar nicht im
Ausgabeverzeichnis. Dateien ohne "publish_date" werden wie bisher immer
eingebaut.

Da eine aus den Files entfernte Seite in "mkdocs.yml" trotzdem noch in
der "nav"-Konfiguration referenziert sein darf (das ist ja gerade der
Sinn - man traegt sie schon ein, bevor sie sichtbar wird), wuerde MkDocs
dafuer sonst einen kaputten Link erzeugen (Klartext-Pfad auf die
.md-Datei statt eines echten Seitenlinks). Der zweite Hook (on_nav)
entfernt genau diese kaputten Verweise wieder aus der Navigation.

Der dritte Hook (on_page_markdown) entschaerft Links im Fliesstext, die
auf eine noch nicht veroeffentlichte Seite zeigen (z. B. der Link von
einer bereits veroeffentlichten Termin-Uebersichtsseite auf eine
Block-Seite, die erst am Veranstaltungstag erscheint): Der Link wird
durch seinen reinen Linktext ersetzt, damit Studierende nicht auf einer
404-Seite landen. Sobald die Zielseite veroeffentlicht ist, entsteht der
Link beim naechsten Build automatisch wieder - es muss nichts im Text
gepflegt werden.

Ein taeglicher, zeitgesteuerter Rebuild (siehe
.github/workflows/deploy-docs.yml) sorgt dafuer, dass eine Seite am
Stichtag automatisch erscheint, ohne dass dafuer erneut gepusht werden
muss.

Testmodus: Ist die Umgebungsvariable MKDOCS_TESTMODE auf "1" gesetzt,
wird die gesamte publish_date-Filterlogik uebersprungen - alle Seiten
werden unabhaengig von ihrem publish_date eingebunden, so als laege das
Datum immer in der Vergangenheit. Ausschliesslich fuer den lokalen
Aufruf von "mkdocs serve" gedacht (siehe CLAUDE.md); im automatischen
Deploy-Workflow (.github/workflows/deploy-docs.yml) darf diese
Variable nicht gesetzt werden.
"""

from __future__ import annotations

import datetime
import logging
import os
import posixpath
import re

from mkdocs.structure.files import Files
from mkdocs.structure.nav import Link, Navigation, Section
from mkdocs.utils import meta

log = logging.getLogger("mkdocs.hooks.publish_scheduler")

# Wird in on_files befuellt und in on_nav gelesen (pro Build-Lauf neu
# gesetzt - wichtig fuer "mkdocs serve", das mehrfach neu baut).
_excluded_src_uris: set[str] = set()


def _parse_publish_date(value: object) -> datetime.date | None:
    """Wandelt den Rohwert des "publish_date"-Feldes in ein date-Objekt um."""
    if value is None:
        return None
    if isinstance(value, datetime.datetime):
        return value.date()
    if isinstance(value, datetime.date):
        return value
    if isinstance(value, str):
        try:
            return datetime.date.fromisoformat(value.strip())
        except ValueError:
            log.warning(
                "publish_date '%s' hat nicht das Format YYYY-MM-DD - wird ignoriert.",
                value,
            )
            return None
    return None


def on_files(files: Files, config):
    """Entfernt Seiten mit zukuenftigem "publish_date" komplett aus dem Build."""
    _excluded_src_uris.clear()

    if os.environ.get("MKDOCS_TESTMODE") == "1":
        log.info(
            "MKDOCS_TESTMODE=1 - publish_date-Filterung wird uebersprungen, "
            "alle Seiten werden eingebunden."
        )
        return files

    today = datetime.date.today()
    kept = []

    for file in files:
        if not file.is_documentation_page() or file.inclusion.is_excluded():
            # Nicht-Markdown-Dateien sowie bereits per "exclude_docs" (z. B.
            # Templates) ausgeschlossene Dateien werden nicht angefasst.
            kept.append(file)
            continue

        with open(file.abs_src_path, encoding="utf-8") as handle:
            source = handle.read()
        _, page_meta = meta.get_data(source)

        publish_date = _parse_publish_date(page_meta.get("publish_date"))
        if publish_date is not None and publish_date > today:
            log.info(
                "'%s' wird erst ab %s veroeffentlicht - aus dem Build ausgeschlossen.",
                file.src_uri,
                publish_date.isoformat(),
            )
            _excluded_src_uris.add(file.src_uri)
            continue

        kept.append(file)

    return Files(kept)


def _prune_nav_items(items: list) -> list:
    """Entfernt Nav-Eintraege, die auf ausgeschlossene Seiten zeigen.

    MkDocs loest einen nav-Eintrag, dessen Datei nicht (mehr) in den
    Files existiert, zu einem "Link" mit dem rohen Konfigurationspfad
    als URL auf - genau diese Faelle werden hier erkannt und entfernt.
    Leer gewordene Sections werden ebenfalls entfernt.
    """
    kept = []
    for item in items:
        if isinstance(item, Section):
            item.children = _prune_nav_items(item.children)
            if item.children:
                kept.append(item)
        elif isinstance(item, Link) and item.url in _excluded_src_uris:
            continue
        else:
            kept.append(item)
    return kept


def on_nav(nav: Navigation, config, files: Files):
    """Entfernt Navigationseintraege, die auf ausgeschlossene Seiten verweisen."""
    nav.items = _prune_nav_items(nav.items)
    return nav


# Markdown-Inline-Link auf eine .md-Datei: [Text](pfad/datei.md#anker "Titel").
# Der Linktext darf Zeilenumbrueche enthalten (Absaetze werden im Quelltext
# umbrochen); Bilder ("![...](...)") werden bewusst nicht angefasst.
_MD_LINK = re.compile(
    r"(?<!!)\[(?P<text>[^\]]+)\]\((?P<target>[^)\s#]+\.md)(?:#[^)\s]*)?(?:\s+\"[^\"]*\")?\)"
)


def on_page_markdown(markdown, page, config, files):
    """Ersetzt Links auf (noch) nicht veroeffentlichte Seiten durch ihren Linktext."""
    if not _excluded_src_uris:
        return markdown

    base = posixpath.dirname(page.file.src_uri)

    def _replace(match: re.Match) -> str:
        target = posixpath.normpath(posixpath.join(base, match.group("target")))
        if target in _excluded_src_uris:
            return match.group("text")
        return match.group(0)

    return _MD_LINK.sub(_replace, markdown)
