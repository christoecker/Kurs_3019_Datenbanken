---
typ: konzept
status: entwurf
---

# KI-Nutzung im Kurs "Datenbanken" — Konzept

## Grundidee (überarbeitet)

**Kein durchgängiges Extra-Projekt.** In der Theoriephase ist dafür schlicht
zu wenig Zeit (16 Blöcke à 45 Min bS, dazwischen laufender Übungsstoff).
Stattdessen wird KI-Nutzung dort eingebracht, wo sie in der echten Praxis
auch vorkommt: **Studierende bekommen eine bereits bestehende, für sie
neue, realistisch komplexe Datenbank und müssen darin Änderungen oder
Erweiterungen vornehmen** — genau wie Softwareentwickler im Berufsalltag
selten auf der grünen Wiese anfangen, sondern sich in fremden, gewachsenen
Systemen zurechtfinden müssen. KI ist hier das naheliegende Werkzeug, um
sich schnell in ein unbekanntes Schema einzuarbeiten — der Kern der
Aufgabe ist aber, die vorgeschlagenen Änderungen zu verstehen, zu prüfen
und zu verantworten.

Das ersetzt das frühere Konzept eines wachsenden Querschnittsprojekts.

## Format: Erweiterungsaufgaben

Eine Erweiterungsaufgabe besteht aus:

1. **Einer fertigen Datenbank** (Schema + Beispieldaten, ggf. kurze
   Dokumentation/ER-Diagramm) — bewusst NICHT von den Studierenden selbst
   entworfen, damit das Gefühl "fremdes System" echt ist. Quelle: Pool aus
   `04-fallstudien/`, idealerweise eine der komplexeren Fallstudien (z. B.
   aus dem Lehrbuch Kapitel 2–9, oder eigene MEA-nahe Cases).
2. **Einer konkreten Änderungs-/Erweiterungsaufgabe**, passend zum Thema
   des jeweiligen Blocks, z. B.:
   - DCL-Block: "Richte für eine neue Nutzerrolle passende Zugriffsrechte
     auf dieser bestehenden DB ein."
   - Prozeduren/Trigger-Block: "Ergänze einen Trigger, der bei dieser
     bestehenden DB automatisch X sicherstellt."
   - SQLite/TwinCAT-Block: "Binde diese bestehende SQLite-DB in ein
     gegebenes C-Programm/TwinCAT-Projekt ein und ergänze Y."
   - Normalisierung/Tabellenstruktur: "Diese bestehende Tabelle verletzt
     die 3. NF — löse das auf, ohne bestehende Daten zu verlieren."
3. **Einer expliziten KI-Erwartung**: KI-Einsatz ist hier nicht optional,
   sondern Teil der Aufgabe — mit der Auflage, kurz zu dokumentieren, was
   die KI vorgeschlagen hat und was die Studierenden davon übernommen,
   angepasst oder verworfen haben (siehe Vorlage unten).

## Wo im Kurs?

Erweiterungsaufgaben sind **kein eigener Kursbaustein**, sondern ein
**Aufgabenformat**, das gezielt für einzelne bS-Blöcke verwendet wird
(Feld `format: erweiterungsaufgabe` im bS-Template). Geeignete Kandidaten
sind die Themen, bei denen man ohnehin an einer bestehenden Struktur
arbeitet statt bei null anzufangen — vor allem DCL, Prozeduren/Trigger,
SQLite/TwinCAT. Genaue Platzierung wird zusammen mit der Themenzuordnung
in `curriculum-map.yaml` festgelegt (Feld `erweiterungsaufgabe: true` an
den betroffenen Blöcken), nicht hier pauschal vorgeschrieben.

## Weiterhin gültig: Eskalationsstufen

Für alle anderen (Nicht-Erweiterungs-)Aufgaben gilt weiterhin ein
gestuftes Modell, damit KI-Nutzung nicht "aus dem Nichts" in den
Erweiterungsaufgaben auftaucht:

- **Stufe 0 — ohne KI**: frühe Praxisphase-Wochen, Grundverständnis
  (ER-Modellierung von Hand, SQL-Grundsyntax).
- **Stufe 1 — KI als Nachschlagewerk**: Syntax nachschlagen,
  Fehlermeldungen erklären lassen — Lösung selbst entwickelt.
- **Stufe 2 — KI als Pair Programmer**: KI hilft aktiv beim Schreiben,
  Vorschlag muss geprüft/erklärt werden können.
- **Stufe 3 — KI-Pflicht mit Reflexion**: das Format der
  Erweiterungsaufgaben (s. o.) — KI-Einsatz gefordert, inkl.
  Pflicht-Dokumentation "was habe ich übernommen/geändert/verworfen und
  warum".

Jede Aufgabe trägt weiterhin ein `ki_einsatz`-Feld im Frontmatter mit
genau einer dieser vier Stufen.

## Was das NICHT ist

Kein Bewertungsinstrument für "KI-Kompetenz" im Sinne einer Prüfung, und
keine Pflicht, KI bei jeder Erweiterungsaufgabe tatsächlich zu nutzen —
aber die Aufgabenstellung ist so gebaut, dass KI-Nutzung der naheliegende
Weg ist, in der knappen Zeit (45 Min) mit einem fremden, komplexen Schema
zurechtzukommen.
