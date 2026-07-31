---
typ: praxisphase-woche
woche: 12
thema: "Wrap-Up-Quiz - Standortbestimmung vor der Theoriephase (kein neuer Stoff)"
workload_minuten: 75
lernziele:
  - "kann das gesamte in der Praxisphase erarbeitete Wissen (Woche 1-11) im Rahmen eines Quiz selbstständig überprüfen, bevor die Theoriephase beginnt"
quelle_lehrbrief: "keine (Wiederholung Kap. 1-5.6; Kap. 6-8 folgen in der Theoriephase)"
quelle_lehrbuch: "keine"
fallstudie: "keine"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-10-05
---

# Woche 12: Wrap-Up — Standortbestimmung vor der Theoriephase

> Zeitbedarf: ca. 1 Stunde.

## Worum geht es?

Das war's — zwölf Wochen Praxisphase liegen (fast) hinter dir. Auch
diese letzte Woche bringt **keinen neuen Stoff**. Stattdessen schaust
du noch einmal auf das gesamte Modul zurück, bevor es mit den
Präsenzterminen der Theoriephase weitergeht.

## Rückblick: Das hast du in der Praxisphase gelernt

- **Woche 1 — Warum Datenbanken?** Du hast gelernt, warum ein reiner
  Dateiansatz für Massendaten ungeeignet ist (Redundanz, Inkonsistenz,
  ungeschützter Mehrbenutzerbetrieb u. a.) und was ein Datenbanksystem
  stattdessen leistet. Die Drei-Ebenen-Schema-Architektur hat dir
  gezeigt, wie sich Datenunabhängigkeit technisch erreichen lässt, und
  die vier Phasen des Datenbankentwurfs haben dir die "Landkarte"
  gegeben, der die gesamte Praxisphase gefolgt ist.
- **Woche 2 — ER-Modell: Grundkonzepte.** Mit dem ER-Modell hast du das
  wichtigste Werkzeug kennengelernt, um mit Fachleuten über eine
  Anwendungswelt zu sprechen, bevor überhaupt eine Datenbank existiert:
  Entity-Typen, Beziehungstypen und Attribute zur Beschreibung der
  Struktur, dazu Kardinalitäten in Chen- und in UML-Notation, um
  festzulegen, in welchem zahlenmäßigen Verhältnis Objekte zueinander
  stehen dürfen.
- **Woche 3 — ER-Modell-Erweiterungen.** Nicht jede Anwendungswelt lässt
  sich mit den Grundkonzepten allein sauber abbilden — deshalb kennst
  du jetzt zwei wichtige Erweiterungen: abhängige Entity-Typen für
  Objekte, die ohne ein anderes Objekt gar nicht existieren können, und
  Spezialisierung/Generalisierung für Objekte, die eigentlich nur
  Spezialfälle eines allgemeineren Typs sind.
- **Woche 4 — Relationenmodell: Grundlagen.** Ab hier ging es vom
  Fachlichen ins Technische: Du kennst jetzt die Grundbegriffe des
  Relationenmodells (Relation, Datensatz, Wertebereich) sowie die
  verschiedenen Schlüsselarten (Schlüsselkandidat, Primärschlüssel,
  Unique Key) und weißt, wie ein Fremdschlüssel Beziehungen zwischen
  Datensätzen abbildet — die Basis für jede weitere Transformation.
- **Woche 5 — Transformation der Beziehungstypen.** Mit einem festen
  Regelwerk kannst du jetzt jeden der vier "klassischen"
  Beziehungstypen (N:M, 1:N, 1:1 sowie rekursiv) systematisch in
  Relationen überführen, statt bei jedem neuen Fall wieder bei null
  anzufangen.
- **Woche 6 — Transformation der erweiterten ER-Konzepte.** Dieselbe
  Systematik hast du auf die beiden Erweiterungen aus Woche 3
  angewendet (abhängige Entity-Typen, Spezialisierungshierarchien) und
  dabei auch gelernt, wo die Transformation an ihre Grenzen stößt:
  Manche im ER-Diagramm festgelegte Mindestteilnahme lässt sich im
  Relationenmodell schlicht nicht mehr ausdrücken (Erhaltung der
  Informationskapazität). Eine empfohlene Reihenfolge hilft dir
  außerdem, bei größeren Modellen den Überblick zu behalten.
- **Woche 7 — Normalisierung.** Mit der Normalisierung hast du gelernt,
  ein fertig transformiertes Schema kritisch zu hinterfragen: Anhand
  funktionaler Abhängigkeiten erkennst du unerwünschte Redundanz und
  kannst sie durch Zerlegung in mehrere Relationen (1. bis 3.
  Normalform) gezielt beseitigen.
- **Woche 8 — Zwischen-Quiz.** Zur Halbzeit hast du in einem Quiz in
  ILIAS ehrlich für dich selbst geprüft, wie sicher du im bisherigen
  Stoff schon warst — ganz ohne neuen Inhalt, aber mit direktem Nutzen
  fürs eigene Lernen.
- **Woche 9 — Transfer.** Den größten Sprung hast du in der
  Transfer-Woche gemacht: ein komplettes Mini-Projekt
  (Prüfmittelverwaltung/Kalibrierung) eigenständig von der ersten
  Textbeschreibung bis zur normalisierten Relation durchgeführt — ganz
  ohne Anleitung Schritt für Schritt. Genau das ist die Fähigkeit, die
  am Ende zählt.
- **Woche 10 — Installation.** Damit aus der Theorie auch etwas
  Anfassbares wird, hast du SQL Server 2025 Express und SSMS auf
  deinem eigenen Rechner installiert und lauffähig gemacht — die
  technische Grundlage für alles Weitere.
- **Woche 11 — Beispielprojekt.** Zum Abschluss hast du die Datenbank
  aus Woche 9 wirklich angelegt, mit Beispieldaten gefüllt und zum
  ersten Mal mit einfachen `SELECT`-Abfragen ausgelesen — dein eigenes
  Relationenschema, real umgesetzt in einer echten Datenbank.

Kurz gesagt: Du kannst inzwischen eine Anwendungswelt konzeptuell
modellieren, dieses Modell nach festen Regeln in ein relationales
Schema überführen, dieses Schema auf Qualität prüfen — und weißt, wie
das alles in einer echten Datenbank landet.

## Wichtig: Auch dieses Quiz findet in ILIAS statt

Wie schon das Zwischen-Quiz in Woche 8 findest du auch dieses
Wrap-Up-Quiz **nicht auf dieser Kurswebseite**, sondern in ILIAS.

**Link zum ILIAS-Quiz:**
<a href="https://www.hsbi.de/elearning/ilias.php?baseClass=ilrepositorygui&ref_id=1700711" target="_blank" rel="noopener">ILIAS-Kursraum</a>

Das Wrap-Up-Quiz zu Woche 12 findest du dort im Kursbereich in einem Block auf der Startseite.

## Ausblick: Wie es in der Theoriephase weitergeht

Ab dem nächsten Präsenztermin ändert sich das Format spürbar: Statt
allein mit Text und Selbstkontrollfragen zu arbeiten, geht es jetzt
**praktisch** weiter — mit Live-Modellierung, neuen Fallstudien und
vielen Übungen direkt am SQL Server, den du in Woche 10 installiert
hast. Gleich zu Beginn arbeiten wir den gesamten Weg vom ER-Modell über
die Transformationsregeln bis zur Normalisierung noch einmal
gemeinsam durch — diesmal an einer neuen Fallstudie und mit Blick auf
praktische Aspekte, die im Selbststudium zu kurz kommen mussten, etwa:
Wann verzichtet man in der Praxis bewusst auf (vollständige)
Normalisierung, weil andere Anforderungen (z. B. Lesegeschwindigkeit)
wichtiger sind als die Vermeidung jeder Redundanz? Darauf aufbauend
vertiefen wir dein Wissen in drei weiteren Schritten:

1. **SQL vertiefen.** Aus deinem eigenen Relationenschema werden
   echte Tabellen (DDL) — und du lernst, Daten gezielt abzufragen
   (Projektion, Selektion, Sortierung, **Verbundabfragen zwischen
   mehreren Tabellen**, Gruppierung/Aggregation, Unteranfragen) sowie
   zu verändern (`INSERT`, `UPDATE`, `DELETE`).
2. **Benutzerverwaltung und Zugriffsrechte (DCL).** Wer darf in einer
   Datenbank überhaupt was sehen oder ändern — und wie legt man das
   fest?
3. **Prozeduren und Trigger.** Wiederverwendbare Logik, die direkt in
   der Datenbank selbst hinterlegt wird.

Zum Abschluss des Moduls schaust du an zwei Stellen über den
Tellerrand von SQL Server hinaus — und triffst dabei auf Module, die du
bereits aus deinem bisherigen Studium kennst. Mit **SQLite** lernst du
ein sehr leichtgewichtiges, dabei aber enorm verbreitetes DBMS kennen
— auch in mechatronischen Systemen im Einsatz — und bindest es direkt
aus **C/C++** heraus an: Hier schließt sich der Kreis zu den Modulen *Grundlagen der Informatik* und *Objektorientierte Programmierung*. Unabhängig davon bindest du außerdem eine echte
**MS-SQL-Server-Datenbank an eine SPS in TwinCAT 3** an — die
Datenbank-Anbindung an die Automatisierungstechnik, mit der du bereits
aus dem Modul *Industrielle Steuerungstechnik* vertraut bist. Ein kurzer Ausblick auf
NoSQL-Datenbanken rundet das Modul ab.

Bis dahin: Danke fürs Durchhalten durch zwölf Wochen Selbststudium —
und bis zum ersten Präsenztermin.
