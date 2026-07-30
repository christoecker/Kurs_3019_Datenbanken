---
typ: praxisphase-woche
woche: 11
thema: "Beispielprojekt nachvollziehen (bereitgestellte Beispiel-Datenbank)"
workload_minuten: 75
lernziele:
  - "kann ein bereitgestelltes SQL-Skript zur Datenbank- und Tabellenerstellung (CREATE DATABASE, CREATE TABLE inkl. Primär- und Fremdschlüssel) in SSMS ausführen und das Ergebnis im Object Explorer überprüfen"
  - "kann Beispieldaten mittels eines bereitgestellten INSERT-Skripts in die angelegten Tabellen einfügen"
  - "kann einfache, bereitgestellte SELECT-Abfragen (Projektion, Selektion, Sortierung) ausführen und ihr Ergebnis nachvollziehen, ohne die SQL-Syntax bereits im Detail gelernt zu haben"
  - "kann den Zusammenhang zwischen dem eigenen Relationenschema aus Woche 9 und seiner konkreten Umsetzung als SQL-Tabelle erkennen (Wertebereich -> Datentyp, PK/FK -> PRIMARY KEY/FOREIGN KEY)"
quelle_lehrbrief: "keine (SQL-Syntax im Detail folgt in der Theoriephase, Kap. 6-7)"
quelle_lehrbuch: "keine"
fallstudie: "mea-pruefmittel (Prüfmittelverwaltung/Kalibrierung, identisch zum Ergebnis aus Woche 9) - siehe 04-fallstudien/README.md"
ki_einsatz: stufe_1_nachschlagewerk
bearbeitungsstatus: entworfen
publish_date: 2026-09-28
---

# Woche 11: Beispielprojekt nachvollziehen

> Zeitbedarf: ca. 1 Stunde.

## Worum geht es?

Du hast in Woche 9 ein eigenes kleines Datenbankschema komplett selbst
entworfen (ER-Modell → Relationenmodell → Normalisierung) und in
Woche 10 SQL Server 2025 Express samt SSMS lauffähig auf deinem Rechner
installiert. Diese Woche führst du beides zusammen: Du legst die
Datenbank aus deiner Woche-9-Lösung **wirklich** in SQL Server an,
füllst sie mit Beispieldaten und liest zum ersten Mal Daten daraus aus.

Die **SQL-Syntax selbst lernst du erst in der Theoriephase** im Detail
(Datendefinition, Abfragen mit `WHERE`, Verbundabfragen zwischen
mehreren Tabellen usw.). Diese Woche bekommst du deshalb fertige
SQL-Skripte an die Hand — deine Aufgabe ist es, sie in SSMS
auszuführen, das Ergebnis nachzuvollziehen und ein paar sehr einfache
eigene Abfragen nach demselben Muster zu bauen. Nutze einen
KI-Assistenten dabei gern als Nachschlagewerk, wenn dir eine
Fehlermeldung oder ein Begriff unklar ist — die Skripte selbst sind
aber bereits fertig, du musst nichts davon neu schreiben.

## Das solltest du danach können

- Du kannst ein fertiges SQL-Skript in SSMS ausführen und im Object
  Explorer prüfen, ob die erwarteten Tabellen entstanden sind.
- Du kannst Beispieldaten per Skript einfügen.
- Du kannst ein paar einfache `SELECT`-Abfragen ausführen und
  nachvollziehen, welchen Ausschnitt der Daten sie jeweils liefern.
- Du erkennst wieder, wie dein Relationenschema aus Woche 9 in der
  SQL-Tabelle steckt: Wertebereich → Datentyp, PK → `PRIMARY KEY`,
  FK → `FOREIGN KEY ... REFERENCES`.

## Voraussetzungen

Deine Installation aus Woche 10 muss lauffähig sein: SSMS lässt sich
starten und mit `.\SQLEXPRESS` per Windows-Authentifizierung
verbinden. Falls das noch nicht klappt, hol das zuerst nach — diese
Woche baut direkt darauf auf.

## SQL-Anweisungen in SSMS ausführen

In dieser Einheit begegnen dir zwei Situationen:

- **Ganzes Skript ausführen**: Steht nur ein
  zusammengehöriger Block im Query-Fenster, führt `ALT+X` bzw. der
  Button "Ausführen" den kompletten Text aus.
- **Nur eine einzelne Anweisung ausführen**: Was ist, wenn mehrere Anweisungen im selben Fenster stehen, du aber nur eine davon ausführen möchtest? Markiere dann zunächst mit der
  Maus genau die eine Anweisung, die du ausführen möchtest, und drücke
  danach ebenfalls `ALT+X` (bzw. "Ausführen"). SSMS führt dann *nur*
  den markierten Text aus. Ohne Markierung würde stattdessen wieder
  das gesamte Fenster ausgeführt.

## Schritt 1: Datenbank und Tabellen anlegen

Öffne in SSMS ein neues Query-Fenster (wie in Woche 10) und führe das
folgende Skript aus. Es legt eine neue Datenbank an und darin die vier
Tabellen aus deiner Musterlösung zu Woche 9 (Teil B und Teil C).

```sql linenums="1"
CREATE DATABASE Pruefmittelverwaltung;
GO
USE Pruefmittelverwaltung;
GO

CREATE TABLE PRUEFMITTELART (
    artnr                      INT          NOT NULL PRIMARY KEY,
    artbezeichnung             VARCHAR(50)  NOT NULL,
    kalibrierintervall_monate  INT          NOT NULL
);

CREATE TABLE PRUEFLABOR (
    labornr        INT           NOT NULL PRIMARY KEY,
    laborname      VARCHAR(50)   NOT NULL,
    laboradresse   VARCHAR(100)  NOT NULL
);

CREATE TABLE PRUEFMITTEL (
    pruefmittelnr  INT          NOT NULL PRIMARY KEY,
    bezeichnung    VARCHAR(50)  NOT NULL,
    messbereich    VARCHAR(50)  NOT NULL,
    artnr          INT          NOT NULL,
    FOREIGN KEY (artnr) REFERENCES PRUEFMITTELART(artnr)
);

CREATE TABLE KALIBRIERUNG (
    pruefmittelnr  INT          NOT NULL,
    kalibriernr    INT          NOT NULL,
    datum          DATE         NOT NULL,
    ergebnis       VARCHAR(20)  NOT NULL,
    labornr        INT          NOT NULL,
    PRIMARY KEY (pruefmittelnr, kalibriernr),
    FOREIGN KEY (pruefmittelnr) REFERENCES PRUEFMITTEL(pruefmittelnr),
    FOREIGN KEY (labornr) REFERENCES PRUEFLABOR(labornr)
);
```

!!! info "Was hier schon wiedererkennbar ist"
    Auch ohne die SQL-Syntax im Detail zu kennen, erkennst du hier dein
    Relationenschema aus Woche 9 wieder: Der `Wertebereich` aus deinen
    Tabellen wird zum konkreten SQL-**Datentyp** (`int` → `INT`,
    `string` → `VARCHAR(n)` mit einer festgelegten Maximallänge `n`,
    `date` → `DATE`). Ein Attribut, das bei dir als "nicht optional"
    markiert war, steht hier als `NOT NULL`. `PK` wird zu
    `PRIMARY KEY`, `FK` zu `FOREIGN KEY ... REFERENCES` — bei
    `KALIBRIERUNG` siehst du außerdem, wie ein aus zwei Attributen
    zusammengesetzter Primärschlüssel (`pruefmittelnr`, `kalibriernr`)
    in SQL notiert wird. Das `GO` nach der ersten Zeile ist übrigens
    kein SQL-Befehl, sondern ein reines SSMS-Kommando, das den Text in
    getrennte Ausführungsblöcke unterteilt.

Führe das Skript mit `ALT+X` oder dem Button "Ausführen" aus. Prüfe
anschließend im **Object Explorer** (links in SSMS, ggf. mit
Rechtsklick auf "Databases" → "Refresh"): Unter
`Pruefmittelverwaltung` → `Tables` sollten jetzt alle vier Tabellen
(`PRUEFMITTELART`, `PRUEFLABOR`, `PRUEFMITTEL`, `KALIBRIERUNG`)
auftauchen.

**Kontrollfrage zu Schritt 1:**

<quiz>
Ergänze die Lücken mit den passenden SQL-Schlüsselwörtern aus dem Skript oben (Zeile 1 bzw. Zeile 5): 

Um eine komplett neue Datenbank zu erzeugen, verwendet man die Anweisung [[CREATE DATABASE]]; um darin eine neue Tabelle anzulegen, die Anweisung [[CREATE TABLE]]. Ein Attribut, das keinen NULL-Wert annehmen darf, wird mit dem Zusatz [[NOT NULL]] gekennzeichnet, der Primärschlüssel einer Tabelle mit dem Schlüsselwort [[PRIMARY KEY]].

---
Alle vier Schlüsselwörter stehen wörtlich im Skript oben.
</quiz>

## Schritt 2: Beispieldaten einfügen

Führe als Nächstes dieses Skript aus, um jede Tabelle mit ein paar
Beispieldatensätzen zu füllen:

```sql linenums="1"
INSERT INTO PRUEFMITTELART (artnr, artbezeichnung, kalibrierintervall_monate) VALUES
    (1, 'Messschieber', 12),
    (2, 'Drehmomentschlüssel', 24);

INSERT INTO PRUEFLABOR (labornr, laborname, laboradresse) VALUES
    (1, 'Kalibrierlabor Nord GmbH', 'Industriestraße 5, 33602 Bielefeld'),
    (2, 'Präzisionslabor Süd', 'Musterweg 12, 70173 Stuttgart');

INSERT INTO PRUEFMITTEL (pruefmittelnr, bezeichnung, messbereich, artnr) VALUES
    (100, 'Messschieber Mitutoyo 500', '0-150 mm', 1),
    (101, 'Messschieber Mahr', '0-300 mm', 1),
    (200, 'Drehmomentschlüssel Gedore', '10-100 Nm', 2);

INSERT INTO KALIBRIERUNG (pruefmittelnr, kalibriernr, datum, ergebnis, labornr) VALUES
    (100, 1, '2024-01-15', 'bestanden', 1),
    (100, 2, '2025-01-20', 'bestanden', 1),
    (101, 1, '2024-03-10', 'bestanden', 2),
    (200, 1, '2023-11-05', 'nicht bestanden', 1),
    (200, 2, '2024-11-10', 'bestanden', 1);
```

Läuft das Skript ohne Fehlermeldung durch, sind die Beispieldaten
eingefügt. (Die Reihenfolge der `INSERT`-Blöcke ist dabei kein Zufall:
Wegen der Fremdschlüssel müssen `PRUEFMITTELART` und `PRUEFLABOR`
zuerst befüllt werden, dann `PRUEFMITTEL`, zuletzt `KALIBRIERUNG` —
sonst würde die Fremdschlüsselintegrität aus Woche 4 verletzt.)

**Kontrollfrage zu Schritt 2:**

<quiz>
Warum müssen die Datensätze für `PRUEFMITTELART` und `PRUEFLABOR` vor denen für `PRUEFMITTEL` und `KALIBRIERUNG` eingefügt werden?

- [ ] Weil SQL Server Tabellen grundsätzlich in alphabetischer Reihenfolge befüllt.
- [x] Weil `PRUEFMITTEL` und `KALIBRIERUNG` Fremdschlüssel auf `PRUEFMITTELART` bzw. `PRUEFLABOR` enthalten — die referenzierten Datensätze müssen also bereits existieren (Fremdschlüsselintegrität, siehe Woche 4).
- [ ] Weil eine `INSERT INTO`-Anweisung pro Tabelle nur einmal ausgeführt werden darf.
</quiz>

## Schritt 3: Erste eigene Abfragen

Führe die folgenden vier Abfragen **einzeln** aus (jeweils markieren,
dann `ALT+X` — siehe Hinweis weiter oben) und vergleiche jeweils, was
im Ergebnisbereich von SSMS erscheint:

```sql linenums="1"
-- Alle Spalten und Zeilen einer Tabelle anzeigen
SELECT * FROM PRUEFMITTEL;

-- Nur bestimmte Spalten anzeigen
SELECT bezeichnung, messbereich FROM PRUEFMITTEL;

-- Nur Zeilen anzeigen, die eine Bedingung erfüllen
SELECT * FROM KALIBRIERUNG WHERE ergebnis = 'nicht bestanden';

-- Ergebnis sortieren (absteigend nach Datum)
SELECT * FROM KALIBRIERUNG ORDER BY datum DESC;
```

In der Theoriephase lernst du diese und weitere Bausteine
systematisch kennen. Für jetzt reicht es, das Muster zu erkennen:
`SELECT <Spalten> FROM <Tabelle>` liefert eine Tabelle als Ergebnis
zurück — mit `WHERE` schränkst du ein, *welche* Zeilen erscheinen, mit
`ORDER BY`, in welcher *Reihenfolge*.

**Kontrollfrage zu Schritt 3:**

Ohne die Abfrage in Zeile 8 auszuführen: Wie viele Zeilen liefert
`SELECT * FROM KALIBRIERUNG WHERE ergebnis = 'nicht bestanden';`
zurück, wenn du dir die Beispieldaten aus Schritt 2 genau ansiehst?
Zu welchem Prüfmittel gehört diese Zeile?

??? question "Antwort anzeigen"
    Genau **eine** Zeile: der Datensatz mit `pruefmittelnr = 200` und
    `kalibriernr = 1` — das ist in den Beispieldaten aus Schritt 2 die
    einzige Kalibrierung, deren `ergebnis` als `'nicht bestanden'`
    eingetragen wurde. Alle anderen vier Kalibrierungen haben den Wert
    `'bestanden'`.

## Jetzt du: eigene Abfragen nach demselben Muster

Schreibe die folgenden vier Anweisungen selbst, indem du die Beispiele
aus Schritt 2 und 3 als Vorlage nimmst:

1. Eine Abfrage, die nur die Spalten `artbezeichnung` und
   `kalibrierintervall_monate` aus `PRUEFMITTELART` anzeigt.
2. Eine Abfrage, die alle Kalibrierungen anzeigt, die im
   Kalibrierlabor mit der Nummer `1` durchgeführt wurden.
3. Eine `INSERT`-Anweisung (nach dem Muster aus Schritt 2), die einen
   neuen Kalibrierungsdatensatz für Prüfmittel `101` einfügt:
   Kalibriernummer `2`, Datum `2025-05-10`, Ergebnis `bestanden`,
   durchgeführt von Kalibrierlabor `2`.
4. Eine Abfrage, mit der du prüfst, dass dein neuer Datensatz aus
   Aufgabe 3 tatsächlich in der Tabelle steht: Zeige alle
   Kalibrierungen für Prüfmittel `101` an.

??? note "Musterlösung anzeigen"
    ```sql linenums="1"
    -- 1.
    SELECT artbezeichnung, kalibrierintervall_monate FROM PRUEFMITTELART;

    -- 2.
    SELECT * FROM KALIBRIERUNG WHERE labornr = 1;

    -- 3.
    INSERT INTO KALIBRIERUNG (pruefmittelnr, kalibriernr, datum, ergebnis, labornr) VALUES
        (101, 2, '2025-05-10', 'bestanden', 2);

    -- 4.
    SELECT * FROM KALIBRIERUNG WHERE pruefmittelnr = 101;
    ```

    Die Abfrage aus Aufgabe 4 sollte jetzt **zwei** Zeilen liefern:
    die bereits in Schritt 2 eingefügte Kalibrierung `1` und die neu
    eingefügte Kalibrierung `2` für Prüfmittel `101`.

!!! tip "Bei Fehlermeldungen"
    Meldet SSMS einen Fehler, lies zuerst die Fehlermeldung selbst
    genau — sie benennt meist exakt Zeile und Ursache (z. B. eine
    Tabelle, die noch nicht existiert, weil ein früheres Skript nicht
    vollständig durchgelaufen ist). Ein KI-Assistent kann dir helfen,
    eine unklare Fehlermeldung einzuordnen; die Korrektur nimmst du
    aber selbst vor und führst das Skript erneut aus.
