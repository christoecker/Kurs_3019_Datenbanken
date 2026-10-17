---
typ: theoriephase-termin-uebersicht
termin: 3
datum: "2026-11-03"
thema_termin: "SQL-Abfragen und Datenänderungen"
workload_minuten: 120
lernziele:
  - "Ihr könnt anhand von Lehrbrief Kapitel 7 erklären, aus welchen Klauseln eine SELECT-Anweisung besteht (SELECT, FROM, WHERE, GROUP BY, HAVING, ORDER BY) und was jede Klausel leistet."
  - "Ihr könnt anhand von Lehrbrief Kapitel 8 beschreiben, wie Datensätze mit INSERT, UPDATE und DELETE eingefügt, geändert und gelöscht werden."
bearbeitungsstatus: final
publish_date: 2026-10-27
---

# Termin 3 (03.11.2026) — SQL-Abfragen und Datenänderungen

Bisher habt ihr Datenbanken entworfen und angelegt — jetzt arbeitet ihr
mit den Daten. Im ersten Block, [SQL-Abfragen mit BestTec](block-05.md),
schreibt und lest ihr eure ersten Datenbankabfragen. Im zweiten Block,
[Eigene Abfragen und Datenänderung](block-06.md), fasst ihr Daten zusammen,
ändert sie und prüft Statements, die ihr auch mit KI-Unterstützung
erstellen dürft.

> Zeitbedarf zur Vorbereitung: ca. 120 Minuten.

## Vorbereitung

### Worum geht es?

Dieser Termin dreht sich um die Sprache, mit der man Datenbanken
befragt und verändert: SQL. Lest dafür vorab die Kapitel 7 und 8 des
Lehrbriefs. Ihr müsst dabei noch nichts selbst anwenden oder
auswendig können — es genügt, wenn ihr die Syntax einmal gesehen
habt, denn die Übung setzt genau dort an.

### Zu bearbeiten: Lehrbrief Kapitel 7 und 8

**Pflicht — Kapitel 7 „Datenbankanfragen“ (S. 63–86):**

- **7.1 Projektion (S. 64–65):** Wie ihr bestimmt, welche Spalten ein
  Ergebnis enthält, und wie `DISTINCT` doppelte Zeilen entfernt.
- **7.2 Werteausdrücke (S. 66):** Rechnen in der Abfrage und Umbenennen
  von Spalten mit `AS`.
- **7.3 Selektion (S. 67–71):** Zeilen mit `WHERE` auswählen:
  Vergleiche, `IN`, `BETWEEN`, `LIKE`, und die Kombination von
  Bedingungen mit `AND`, `OR` und `NOT`.
- **7.4 Sortieren (S. 71):** `ORDER BY`.
- **7.5 Verbundbildung (S. 72–74):** Daten aus mehreren Tabellen
  zusammenführen, Aliase und der Selbstverbund.
- **7.6 Daten konsolidieren (S. 75–80):** Gruppenfunktionen,
  `GROUP BY` und `HAVING`.
- **7.7 Behandlung von NULL-Werten (S. 80–83):** Was `NULL` in
  Rechnungen und Vergleichen bewirkt.
- **7.8 Unteranfragen (S. 84–85):** Abfragen in Abfragen.
- **7.9 Zusammenfassung (S. 86):** Die Klauseln im Überblick und die
  Reihenfolge, in der die Datenbank sie auswertet.

Die Aufgaben in 7.10 (S. 87–89) solltet ihr noch nicht bearbeiten. Die gehen wir in
der Übung und im betreuten Selbststudium an.

**Empfohlen — Kapitel 8 „Datenmanipulation“ (S. 90–93):** `INSERT`,
`UPDATE` und `DELETE` zum Einfügen, Ändern und Löschen von
Datensätzen. Auch dieses Kapitel wird in diesem Termin inhaltlich
behandelt.

**Fallstudie:** Lest vor Kapitel 7 den Anhang **9.2 „Fallstudie
BestTec“ (S. 97–98)**. Alle Beispiele des Kapitels und die Übung
arbeiten mit dieser Datenbank.

SQL Server weicht an einigen Stellen vom Lehrbrief ab. Die Unterschiede
sind auf der Seite [SQL Server und Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md)
zusammengestellt.

### Alles verstanden?

Prüft euer Verständnis mit diesen drei Fragen:

**1. In welcher Reihenfolge wertet die Datenbank die Klauseln einer
Abfrage aus, und warum ist das für das Verständnis wichtig?**
(S. 86–87)

??? note "Musterlösung anzeigen"
    Die Datenbank bildet zuerst die Tabellen aus dem `FROM`-Teil
    (bei mehreren Tabellen das Kreuzprodukt), wählt dann mit `WHERE`
    Zeilen aus, gruppiert sie mit `GROUP BY`, wählt mit `HAVING`
    Gruppen aus und wertet zuletzt die Auswahlliste im `SELECT` aus;
    danach wird mit `ORDER BY` sortiert. Wer diese Reihenfolge kennt,
    kann nachvollziehen, warum z. B. ein Alias aus dem `SELECT` in
    `WHERE` noch nicht zur Verfügung steht.

**2. Was passiert, wenn im `FROM`-Teil zwei Tabellen stehen, aber im
`WHERE`-Teil keine Verknüpfungsbedingung?** (S. 72–73)

??? note "Musterlösung anzeigen"
    Die Datenbank kombiniert jede Zeile der ersten Tabelle mit jeder
    Zeile der zweiten Tabelle (Kreuzprodukt). Es entstehen viele
    Zeilen, die inhaltlich nicht zusammengehören.

**3. Wodurch unterscheiden sich `WHERE` und `HAVING`?** (S. 77–79)

??? note "Musterlösung anzeigen"
    `WHERE` wählt einzelne Zeilen aus, bevor gruppiert wird.
    `HAVING` wählt dagegen ganze Gruppen aus, nachdem gruppiert wurde,
    und kann deshalb Gruppenfunktionen wie `COUNT` verwenden.

### Zur Auffrischung

**Für Block 05 (SQL-Abfragen mit BestTec)** — aus Termin 2 und der
Praxisphase:

- Schlüssel und Fremdschlüssel: Sie bilden die Verknüpfungen, über die
  ihr später Tabellen zusammenführt (Praxisphase Woche 4).
- Das Ausführen von SQL-Skripten in SQL Server Management Studio
  (Praxisphase Woche 11).
