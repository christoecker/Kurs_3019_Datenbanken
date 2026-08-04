"""MkDocs-Hook: steuerbare Sichtbarkeit von Musterloesungen.

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


def on_page_markdown(markdown, page, config, files):
    """Entfernt Musterloesungs-Abschnitte, wenn sie explizit ausgeblendet sind."""
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
