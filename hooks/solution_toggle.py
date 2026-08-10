"""MkDocs-Hook: steuerbare Sichtbarkeit von Musterloesungen und Nachtraegen.

Manueller Gegenpart zu "publish_scheduler.py" (dort zeitgesteuert, hier
manuell per Frontmatter-Flag umschaltbar). Im YAML-Frontmatter einer
Markdown-Datei kann das Feld "musterloesungen_sichtbar: false" gesetzt
werden. Ist das Feld auf false gesetzt, wird beim Bauen jeder Abschnitt
zwischen den HTML-Kommentaren

    <!-- MUSTERLOESUNG-START -->
    ...
    <!-- MUSTERLOESUNG-ENDE -->

aus dem Markdown-Text entfernt, bevor er zu HTML gerendert wird - die
Musterloesung landet dann gar nicht erst im gebauten Output (kein
CSS-Trick, kein Client-seitiges Verstecken). Fehlt das Feld oder steht es
auf true, bleibt der Text unveraendert.

Zusaetzlich gibt es denselben Mechanismus fuer *Nachtraege* - Abschnitte,
die erst waehrend der Veranstaltung freigegeben werden sollen (z. B. eine
Anforderungsaenderung, die die Studierenden nicht vorab lesen duerfen):

    <!-- NACHTRAG-START -->
    ...
    <!-- NACHTRAG-ENDE -->

gesteuert ueber das Frontmatter-Feld "nachtrag_sichtbar". Wichtiger
Unterschied zu den Musterloesungen: Fehlt das Feld, gilt der Nachtrag als
AUSGEBLENDET (nur ein ausdrueckliches "nachtrag_sichtbar: true" zeigt ihn
an). So kann ein vergessenes Feld einen geplanten Ueberraschungseffekt
nicht versehentlich zerstoeren. Musterloesungen innerhalb eines
Nachtrag-Blocks werden mit ausgeblendet, solange der Nachtrag verborgen
ist - HTML-Kommentare koennen dafuer nicht verwendet werden, weil
Python-Markdown mehrzeilige Kommentare an Leerzeilen aufbricht und der
Inhalt dann doch im gebauten HTML landet (am gebauten Ergebnis getestet).

Setzt am "on_page_markdown"-Event an: dort ist "page.meta" bereits aus
dem Frontmatter befuellt, aber der Markdown-Text noch nicht zu HTML
konvertiert.
"""

from __future__ import annotations

import logging
import re

log = logging.getLogger("mkdocs.hooks.solution_toggle")

_SOLUTION_BLOCK = re.compile(
    r"<!--\s*MUSTERLOESUNG-START\s*-->.*?<!--\s*MUSTERLOESUNG-ENDE\s*-->",
    re.DOTALL,
)

_NACHTRAG_BLOCK = re.compile(
    r"<!--\s*NACHTRAG-START\s*-->.*?<!--\s*NACHTRAG-ENDE\s*-->",
    re.DOTALL,
)


def on_page_markdown(markdown, page, config, files):
    """Blendet Nachtrags- und Musterloesungs-Abschnitte aus, wenn gesetzt."""
    # Nachtraege zuerst: ein verborgener Nachtrag nimmt die darin
    # enthaltenen Musterloesungen mit, egal wie deren Flag steht.
    if not page.meta.get("nachtrag_sichtbar", False):
        markdown, count = _NACHTRAG_BLOCK.subn("", markdown)
        if count:
            log.info(
                "'%s': %d Nachtrags-Abschnitt(e) ausgeblendet (nachtrag_sichtbar nicht auf true).",
                page.file.src_uri,
                count,
            )

    if page.meta.get("musterloesungen_sichtbar", True):
        return markdown

    cleaned, count = _SOLUTION_BLOCK.subn("", markdown)
    if count:
        log.info(
            "'%s': %d Musterloesungs-Abschnitt(e) ausgeblendet (musterloesungen_sichtbar: false).",
            page.file.src_uri,
            count,
        )
    return cleaned
