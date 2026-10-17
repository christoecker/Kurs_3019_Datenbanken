---
typ: theoriephase-termin-uebersicht
termin: 2
datum: "2026-10-27"
thema_termin: "Normalisierung & Implementierung"
workload_minuten: 60
lernziele:
  - "Ihr könnt die Kernbegriffe der Normalisierung (funktionale Abhängigkeit, 1.-3. Normalform, Redundanz) aus dem Gedächtnis abrufen."
  - "Ihr könnt anhand von Lehrbrief Kapitel 6 erklären, aus welchen Bestandteilen eine CREATE-TABLE-Anweisung besteht (Attribut-Definitionen, Primär-, Unique- und Fremdschlüssel-Constraints) und warum die Reihenfolge beim Anlegen von Tabellen zählt."
bearbeitungsstatus: final
publish_date: 2026-10-20
---

# Termin 2 (27.10.2026) — Normalisierung & Implementierung

Heute geht es in zwei Schritten weiter: Im ersten Block, [Normalisierung
anwenden](block-03.md), prüft und verbessert ihr Relationenschemata
mithilfe der Normalformen und lernt außerdem, wann bewusste Redundanz
eine gerechtfertigte Entwurfsentscheidung ist. Im zweiten Block,
[Relationenschema in SQL Server anlegen](block-04.md), setzt ihr ein
Relationenschema erstmals aktiv in einer echten Datenbank um.

> Zeitbedarf zur Vorbereitung: ca. 60 Minuten (davon ca. 45 Minuten für die Lektüre von Lehrbrief Kapitel 6).

## Vorbereitung

### Worum geht es?

Termin 2 baut auf der Normalisierung auf, die ihr in der Praxisphase
(Woche 7) bereits vollständig durchgearbeitet habt — Block 1 ist
deshalb bewusst nur ein knappes Wrap-Up. Block 2 führt euch dagegen
erstmals in die praktische Umsetzung eines Relationenschemas in SQL
Server ein — dafür ist die Lektüre von **Kapitel 6 des Lehrbriefs**
**Pflicht**: Ihr lest dort vorab, wie Tabellen mit SQL angelegt
werden, damit die Übung direkt mit dem Anwenden beginnen kann.

### Zu bearbeiten: Lehrbrief Kapitel 6

Arbeitet vor dem Termin das Kapitel **6 "Datenbankdefinition"**
(S. 54–62) aus dem Lehrbrief durch. Plant dafür ca. 45 Minuten ein.

- **6.1 Syntax-Definition und Bezeichner (S. 54–55):** Wie die
  Syntaxschreibweise im Lehrbrief zu lesen ist und welche Regeln für
  Namen von Tabellen und Spalten gelten.
- **6.2 Werte und Datentypen (S. 55–57):** Welche Datentypen es für
  Zahlen, Texte und Datumswerte gibt und wie man Werte hinschreibt.
- **6.3 Tabellen anlegen (S. 58–60):** Aufbau von `CREATE TABLE` aus
  Attribut-Definitionen und Tabellenbedingungen (Constraints):
  `PRIMARY KEY`, `UNIQUE`, `FOREIGN KEY`, außerdem `NOT NULL` und
  `DEFAULT`.
- **6.4 und 6.5 Tabellen löschen und ändern (S. 60–61):** `DROP TABLE`
  und `ALTER TABLE` im Überblick.
- **6.6 Projektaufgabe (S. 62):** Optional, wenn ihr das Gelernte
  gleich anwenden möchtet.

!!! warning "Achtung: SQL Server weicht vom Lehrbrief ab"
    Der Lehrbrief beschreibt den SQL-Standard. In unserem Datenbanksystem
    (SQL Server mit dem Dialekt T-SQL) gibt es ein paar Abweichungen,
    die ihr beim Lesen im Hinterkopf behalten solltet:

    - Statt `BOOLEAN` heißt der Typ für Wahrheitswerte `BIT`. Statt
      `TIMESTAMP` für Datum und Uhrzeit verwendet ihr `DATETIME2` (in
      SQL Server bedeutet `TIMESTAMP` etwas anderes).
    - Datumswerte schreibt ihr in der Form `'2026-10-26'` (Jahr, Monat,
      Tag), nicht als `'26.10.2026'`.
    - `DROP TABLE ... CASCADE` gibt es in T-SQL nicht — dort müssen die
      Tabellen in der richtigen Reihenfolge gelöscht werden.
    - Die Empfehlung zu Bezeichnern (S. 55) gilt weiterhin sinngemäß:
      keine Umlaute, keine reservierten Wörter als Namen.

    Alles, was die Übung zusätzlich braucht und im Lehrbrief nicht
    steht (z. B. `CHECK`, `IDENTITY`, `DATETIME2`), wird dort erklärt.

    Alle Abweichungen im Überblick: [SQL Server und Lehrbrief](../../info/sql-server-vs-lehrbrief.md).

### Alles verstanden?

Prüft euer Verständnis mit diesen drei Fragen:

**1. Woraus besteht eine `CREATE TABLE`-Anweisung, und was ist der
Unterschied zwischen einer Attribut-Definition und einer
Tabellenbedingung?** (S. 58–59)

??? note "Musterlösung anzeigen"
    Eine `CREATE TABLE`-Anweisung besteht aus dem Tabellennamen, einer
    Liste von Attribut-Definitionen und optional Tabellenbedingungen.
    Eine Attribut-Definition betrifft eine einzelne Spalte (Name,
    Datentyp, optional `DEFAULT` und `NOT NULL`). Tabellenbedingungen
    sind Constraints für die Tabelle als Ganzes — Primärschlüssel,
    weitere Schlüssel (`UNIQUE`) und Fremdschlüssel; sie können einen
    eigenen Namen bekommen, über den man sie später ansprechen kann.

**2. Was ist der Unterschied zwischen `CHAR(L)` und `VARCHAR(L)`?**
(S. 56)

??? note "Musterlösung anzeigen"
    `CHAR(L)` speichert immer genau `L` Zeichen und füllt nicht
    verwendete Stellen mit Leerzeichen auf. `VARCHAR(L)` speichert
    höchstens `L` Zeichen, aber nur die tatsächlich benötigten.

**3. Warum muss in dem Beispiel auf S. 58 die Tabelle `ABT` vor der
Tabelle `MA` angelegt werden?** (S. 59–60)

??? note "Musterlösung anzeigen"
    `MA` enthält einen Fremdschlüssel, der auf `ABT` verweist. Eine
    Tabelle, die eine andere über einen Fremdschlüssel referenziert,
    kann erst angelegt werden, wenn die referenzierte Tabelle bereits
    existiert.

### Zur Auffrischung

**Für Block 1 (Normalisierung anwenden)** — aus Praxisphase Woche 7,
Lehrbrief Kap. 5.6:

- Funktionale Abhängigkeit und Redundanz als Ursache von Inkonsistenz
  (S. 49–50).
- Zweite Normalform: Kriterium und Zerlegung (S. 51).
- Dritte Normalform: Kriterium und Zerlegung (S. 52).

**Für Block 2 (Relationenschema in SQL Server anlegen)** — zusätzlich
zur Pflichtlektüre von Lehrbrief Kapitel 6 (siehe oben) aus
Praxisphase Woche 11 und Woche 4:

- Das Anlegen einer Datenbank und von Tabellen in SQL Server:
  `CREATE DATABASE`, `CREATE TABLE` mit `PRIMARY KEY` und
  `FOREIGN KEY` (Woche 11, Schritt 1).
- Warum die Reihenfolge der Anweisungen wegen der
  Fremdschlüsselintegrität nicht beliebig ist (Woche 11, Schritt 2,
  und Woche 4).
