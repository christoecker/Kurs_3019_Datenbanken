---
typ: theoriephase-block
termin: 2
block_id: "04"
datum: "2026-10-27"
kurztitel: "Relationenschema in SQL Server anlegen"
thema: "Erste Implementierung: Relationenschema in SQL Server als Datenbank anlegen (DDL)"
lernziele:
  - "Ihr könnt die Relationen eines Relationenschemas selbstständig in T-SQL anlegen (Datenbank, Tabellen, Datentypen, Primär- und Fremdschlüssel) und die Reihenfolge der Anweisungen begründen."
  - "Ihr könnt aus den Regeln einer Anwendungswelt die passenden Constraints (NOT NULL, UNIQUE, CHECK, DEFAULT) ableiten und vorhersagen, welche Datenänderungen die Datenbank daraufhin ablehnt."
  - "Ihr könnt ein (KI-)generiertes Skript zum Anlegen von Tabellen auf Logikfehler prüfen, die der Server nicht meldet, und sie begründet korrigieren."
musterloesungen_sichtbar: false
fallstudie: "Übung: Kompressor-Zustandsüberwachung (Fortsetzung aus der Übung zur Normalisierung); betreutes Selbststudium: Lackproduktion Schnüffel GmbH (Fortsetzung aus Aufgabe 03) - beides eigene MEA-Szenarien"
ki_einsatz: stufe_2_pair_programmer
bearbeitungsstatus: final
publish_date: 2026-10-27
---

# Relationenschema in SQL Server anlegen (27.10.2026)

## Übung { .modus-uebung }

### Worum geht es?

Bisher habt ihr Datenbanken **entworfen**: erst als ER-Modell, dann als
Relationenschema, zuletzt normalisiert. Jetzt macht ihr den nächsten
Schritt und bringt ein Schema in eine echte Datenbank: Ihr legt
Datenbank und Tabellen in SQL Server an. In Woche 11 der Praxisphase
habt ihr solche Skripte schon ausgeführt — heute schreibt ihr sie
selbst, und ihr lernt, wie ihr der Datenbank mit sogenannten
**Constraints** die Regeln eurer Anwendungswelt beibringt, damit sie
fehlerhafte Daten selbstständig ablehnt.

!!! abstract "Lernziele"
    - Ihr könnt ein Relationenschema Schritt für Schritt in T-SQL
      umsetzen: Wertebereiche werden zu Datentypen, Schlüssel zu
      `PRIMARY KEY` und `FOREIGN KEY`.
    - Ihr könnt erklären, welche Regel ein Constraint (`UNIQUE`,
      `CHECK`, `DEFAULT`) absichert, und vorhersagen, welche
      Datenänderung die Datenbank daraufhin ablehnt.
    - Ihr könnt begründen, warum Tabellen in einer bestimmten
      Reihenfolge angelegt werden müssen.

### Kurzer Rückblick <span class="zeitangabe">ca. 4 Min.</span> { data-toc-label="Kurzer Rückblick" }

1. Was passiert in der letzten Phase des Datenbankentwurfs, der Datendefinition?

    ??? note "Musterlösung anzeigen"
        Das logische Schema (hier: das Relationenschema) wird in die
        Datenstrukturen einer Datenbanksprache umgesetzt — bei uns also in
        SQL-Anweisungen, die die Tabellen im Datenbanksystem anlegen.

2. Wie erkennt man im Relationenschema einen Primärschlüssel und einen Fremdschlüssel, und wofür sind sie da?

    ??? note "Musterlösung anzeigen"
        Der Primärschlüssel (PK) ist das Attribut bzw. die
        Attributkombination, die jeden Datensatz einer Relation eindeutig
        identifiziert. Ein Fremdschlüssel (FK) verweist auf den Schlüssel
        einer anderen Relation und bildet so die Beziehung zwischen den
        Datensätzen ab.

3. Eine Tabelle `AUFTRAG` hat einen Fremdschlüssel auf die Tabelle `KUNDE`. Was muss gelten, damit ein neuer Datensatz in `AUFTRAG` überhaupt eingetragen werden kann — und was bedeutet das für die Reihenfolge, in der man Daten einträgt?

    ??? note "Musterlösung anzeigen"
        Wegen der Fremdschlüsselintegrität muss der Kunde, auf den der
        Auftrag verweist, bereits in `KUNDE` existieren. Ein Auftrag kann
        also erst eingetragen werden, wenn die Beziehung zu einem
        vorhandenen Datensatz der anderen Tabelle hergestellt werden kann.
        Daten müssen deshalb zuerst in die Tabelle, auf die verwiesen wird
        (`KUNDE`), und erst danach in die verweisende Tabelle (`AUFTRAG`).

---

### Das Szenario: Kompressor-Datenbank wird real <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Das Szenario: Kompressor-Datenbank wird real" }

> Das Datenmodell der Kompressor-Zustandsüberwachung von Pustefix & Co.
> kennt ihr aus der Normalisierungs-Übung: Am Kompressor werden
> minütlich Messwerte gespeichert, einmal täglich
> läuft ein Analyse-Lauf, der mit mehreren Auswertealgorithmen
> Schädigungswerte berechnet und lokale Extremwerte der Druckdifferenz
> verarbeitet. Dieses Modell besteht aus sechs Relationen:
> `MESSUNG`, `VERFAHREN`, `ALGORITHMUS`, `ANALYSE_LAUF`, `SCHAEDIGUNG`
> und `EXTREMWERT`. Heute legt ihr diese sechs Tabellen auf eurem
> eigenen Rechner an — in SQL Server.

---

### Datenbank und Tabellen anlegen <span class="zeitangabe">ca. 19 Min.</span> { data-toc-label="Datenbank und Tabellen anlegen" }

#### Die Datenbank

Zuerst braucht ihr eine leere Datenbank, in der die Tabellen entstehen
sollen. Welche Anweisung legt eine neue Datenbank an, und wie sagt ihr
SQL Server anschließend, dass die folgenden Anweisungen *in dieser*
Datenbank ausgeführt werden sollen?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/uebung-04-datenbank.sql"
    ```

    1. `CREATE DATABASE` legt die Datenbank an.
    2. `GO` ist, wie in Woche 11, kein SQL-Befehl, sondern ein SSMS-Kommando:
       Es trennt das Skript in einzelne Ausführungsblöcke (sogenannte
       Batches). Ohne `GO` hinter `CREATE DATABASE` würde `USE` versuchen, in
       eine Datenbank zu wechseln, die zu diesem Zeitpunkt noch nicht
       existiert.
    3. `USE` wechselt in die Datenbank; alle folgenden Anweisungen gelten
       dort.

#### Erste Tabelle: MESSUNG

Beginnen wir mit der Relation, die keine Verbindung zu den anderen
hat:

**:octicons-table-16: Relation `MESSUNG`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | zeitstempel | datetime | nein |
| – | druck_eingang | decimal | nein |
| – | druck_ausgang | decimal | nein |
| – | volumenstrom | decimal | nein |
| – | temperatur | decimal | nein |
| – | luftfeuchtigkeit | decimal | nein |

Das Relationenschema nennt nur "decimal" und "datetime" — SQL Server
will es genauer wissen. Überlegt: Wie viele Stellen braucht ein
Druckwert in bar, wie viele Nachkommastellen sind bei einer
minütlichen Messung sinnvoll? Wie genau muss der Zeitstempel sein?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/uebung-04-messung.sql"
    ```

    1. `DATETIME2(0)` speichert den Zeitstempel sekundengenau, bei einer
       minütlichen Messung genügt das. `PRIMARY KEY` direkt hinter dem
       Attribut ist die übliche Kurzschreibweise; der Primärschlüssel ist
       ohnehin nie leer. Sie hat einen kleinen Nachteil: SQL Server vergibt
       den Namen des Schlüssels dabei selbst (im Object Explorer unter der
       Tabelle bei *Keys* einsehbar). Wie ihr Schlüsseln einen eigenen Namen
       gebt, schauen wir uns im Abschnitt zu den Constraints an.
    2. `DECIMAL(6,2)` erlaubt z. B. Werte bis 9999,99 mit zwei
       Nachkommastellen — für Druck in bar und andere Prozessgrößen
       reichlich. `NOT NULL` steht bei jedem Attribut, das im Schema "nicht
       optional" war.

    Aus dem Wertebereich wird ein konkreter Datentyp:

    | Wertebereich im Relationenschema | Datentyp in SQL Server |
    |---|---|
    | int | `INT` |
    | decimal | `DECIMAL(p,s)` — `p` Stellen insgesamt, davon `s` nach dem Komma |
    | string | `VARCHAR(n)` — höchstens `n` Zeichen |
    | date | `DATE` |
    | datetime | `DATETIME2(n)` — `n` Nachkommastellen bei den Sekunden |

#### VERFAHREN und ALGORITHMUS

Jetzt kommen zwei Relationen mit einer Fremdschlüsselbeziehung:

**:octicons-table-16: Relation `VERFAHREN`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | verfahren | string | nein |
| – | grenzwert_meldung | int | nein |
| – | grenzwert_alarm | int | nein |

**:octicons-table-16: Relation `ALGORITHMUS`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | algorithmus_id | int | nein |
| FK | verfahren | string | nein |
| – | version | string | nein |
| – | release_datum | date | nein |
| – | status | string | nein |

Zwei Fragen dazu: In welcher Reihenfolge müssen die beiden Tabellen
angelegt werden? Und `algorithmus_id` ist ein künstlicher Schlüssel
(ein Surrogatschlüssel) — muss man die Nummern wirklich bei jedem
neuen Algorithmus selbst vergeben?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/uebung-04-verfahren-algorithmus.sql"
    ```

    1. `IDENTITY(1,1)` lässt SQL Server die Nummern selbst vergeben
       (Startwert 1, Schrittweite 1). Beim `INSERT` lässt man die Spalte
       einfach weg. Das ist die übliche Umsetzung eines Surrogatschlüssels;
       Lücken in der Nummernfolge sind dabei normal (z. B. wenn ein `INSERT`
       scheitert).
    2. Der Fremdschlüssel verweist auf `VERFAHREN(verfahren)`, und SQL Server
       prüft schon beim Anlegen, ob das Ziel existiert. Deshalb muss
       `VERFAHREN` zuerst angelegt werden. Auch die `FOREIGN KEY`-Zeile ist
       eine Kurzschreibweise, bei der SQL Server den Namen vergibt.

    **Abweichung vom Relationenschema:** In `ALGORITHMUS` heißen zwei
    Spalten anders als in der Tabelle oben — `version` wurde zu `ver`
    und `status` zu `release_status`. Beide Wörter haben in T-SQL eine
    besondere Bedeutung bzw. sind als Schlüsselwörter belegt. Als
    Spaltennamen führen solche Wörter schnell zu Verwechslungen und
    zu Fehlern, die man erst suchen muss (je nach Fall müsste man sie
    in eckige Klammern setzen). Im Relationenschema stören sie nicht,
    es ist ja noch kein SQL; beim Umsetzen weicht man deshalb auf einen
    unkritischen Namen aus. Das ist ein typischer Fall, in dem sich die
    Implementierung bewusst vom Entwurf unterscheidet — die Abweichung
    gehört dokumentiert. Auch im weiteren Verlauf der Übung heißen die
    Spalten `ver` und `release_status`.

#### ANALYSE_LAUF, SCHAEDIGUNG und EXTREMWERT

Die drei restlichen Relationen:

**:octicons-table-16: Relation `ANALYSE_LAUF`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | analyse_lauf_id | int | nein |
| – | zeitstempel | datetime | nein |

**:octicons-table-16: Relation `SCHAEDIGUNG`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK, FK | analyse_lauf_id | int | nein |
| PK, FK | algorithmus_id | int | nein |
| – | schaedigungswert | int (0–100) | nein |

**:octicons-table-16: Relation `EXTREMWERT`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | zeitstempel | datetime | nein |
| – | typ | string (Maximum/Minimum) | nein |
| – | wert | decimal | nein |
| – | verarbeitet | boolean | nein |

`SCHAEDIGUNG` hat einen Primärschlüssel aus *zwei* Attributen, die
beide gleichzeitig Fremdschlüssel sind. Wie schreibt man das auf? Und
welchen Datentyp hat ein "boolean" in SQL Server?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/uebung-04-lauf-schaedigung-extremwert.sql"
    ```

    1. Ein zusammengesetzter Primärschlüssel wird nicht mehr direkt hinter
       das Attribut geschrieben, sondern als eigene Zeile `PRIMARY KEY (a,
       b)` unter die Attribute.
    2. Genauso stehen die beiden Fremdschlüssel jeweils als eigene Zeile
       `FOREIGN KEY (...) REFERENCES ...`.
    3. Für den Wahrheitswert gibt es in SQL Server keinen Typ `BOOLEAN`,
       stattdessen `BIT` (0 oder 1).

    Die Tabellen sind damit angelegt, aber noch nicht abgesichert:
    Nichts verhindert bisher, dass jemand einen Schädigungswert von 250
    % einträgt oder den Freigabestatus eines Algorithmus mit "fertig"
    angibt.

---

### Constraints: die Regeln der Datenbank <span class="zeitangabe">ca. 16 Min.</span> { data-toc-label="Constraints: die Regeln der Datenbank" }

#### Was Constraints leisten

Eine Datenbank soll nicht jeden Wert annehmen, der ihr angeboten wird.
Mit **Constraints** (Einschränkungen) legt ihr fest, welche Regeln der
Anwendungswelt das Datenbanksystem selbst durchsetzt — unabhängig
davon, welches Programm oder welche Person Daten einträgt. Ein paar
davon kennt ihr schon, ohne sie so genannt zu haben:

| Constraint | Frage, die er beantwortet | Beispiel im Kompressor-Modell |
|---|---|---|
| `NOT NULL` | Muss ein Wert vorhanden sein? | alle Messwerte |
| `PRIMARY KEY` | Wie wird ein Datensatz eindeutig identifiziert? | `zeitstempel` in `MESSUNG` |
| `FOREIGN KEY` | Muss der Verweis auf einen vorhandenen Datensatz zeigen? | `ALGORITHMUS.verfahren` |
| `UNIQUE` | Darf ein Wert (oder eine Kombination) nur einmal vorkommen, obwohl er nicht Primärschlüssel ist? | siehe unten |
| `CHECK` | Liegt der Wert in einem zulässigen Bereich oder einer Liste? | siehe unten |
| `DEFAULT` | Welcher Wert gilt, wenn keiner angegeben wird? | siehe unten |

#### Regeln aus dem Szenario ableiten und nachrüsten

Aus dem Szenario ergeben sich noch ein paar Regeln, die die Tabellen
bisher nicht durchsetzen:

1. Verfahren und Version (`ver`) zusammen legen einen Algorithmus
   eindeutig fest.
2. Zu jedem Zeitpunkt gibt es höchstens einen Analyse-Lauf.
3. Schädigungswerte sind Prozentangaben zwischen 0 und 100.
4. Die Melde- und Alarm-Grenzwerte eines Verfahrens sind ebenfalls
   Prozentangaben zwischen 0 und 100.
5. Der Freigabestatus (`release_status`) eines Algorithmus ist
   `alpha`, `beta` oder `stable`.
6. Ein Extremwert ist entweder ein `Maximum` oder ein `Minimum`.
7. Ein neu erfasster Extremwert gilt zunächst als unverarbeitet.

Ordnet jeder Regel den passenden Constraint zu und rüstet sie mit
`ALTER TABLE` nachträglich an den bestehenden Tabellen nach. Die
Grundform lautet:

```sql
ALTER TABLE <Tabelle>
    ADD CONSTRAINT <Name> <Definition>;
```

Für `<Definition>` kommen die Constraint-Arten aus der Tabelle oben in
Frage:

| Constraint | `<Definition>` |
|---|---|
| `PRIMARY KEY` | `PRIMARY KEY (spalte [, spalte ...])` |
| `FOREIGN KEY` | `FOREIGN KEY (spalte) REFERENCES zieltabelle(zielspalte)` |
| `UNIQUE` | `UNIQUE (spalte [, spalte ...])` |
| `CHECK` | `CHECK (bedingung)` |
| `DEFAULT` | `DEFAULT wert FOR spalte` |

(Primär- und Fremdschlüssel gibt es in unseren Tabellen schon; für die
sieben Regeln unten braucht ihr nur `UNIQUE`, `CHECK` und `DEFAULT`.)

Gebt jedem Constraint einen sprechenden Namen nach dem Schema
`PK_` / `FK_` / `UQ_` / `CK_` / `DF_` + Tabelle + Gegenstand, z. B.
`UQ_ANALYSE_LAUF_ZEITSTEMPEL`.

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/uebung-04-constraints.sql"
    ```

    1. Regel 1 und 2 sind `UNIQUE`-Constraints. Regel 1 gilt über *zwei*
       Spalten gemeinsam — einzeln dürfen sich Verfahren und Version (`ver`)
       durchaus wiederholen, nur die Kombination muss eindeutig sein.
    2. Regel 3 und 4 sind `CHECK`-Constraints mit einem Wertebereich
       (`BETWEEN`, beide Grenzen eingeschlossen).
    3. Regel 5 und 6 sind `CHECK`-Constraints mit einer Liste erlaubter Werte
       (`IN`).
    4. Regel 7 ist ein `DEFAULT`: Wird beim `INSERT` kein Wert für
       `verarbeitet` angegeben, setzt SQL Server `0`.

!!! info "Tabelle und Constraints in einem Schritt"
    Dass hier erst die Tabellen angelegt und die Constraints danach
    einzeln nachgerüstet wurden, hat didaktische Gründe: So seht ihr
    jeden Constraint für sich. In der Praxis schreibt man Tabelle und
    Constraints meist in **einer** `CREATE TABLE`-Anweisung — das fertige
    Gesamtskript am Ende dieses Abschnitts zeigt genau das.

    `ALTER TABLE` bleibt trotzdem wichtig, denn es gibt Fälle, in denen
    Constraints nachträglich ergänzt werden **müssen**:

    - **Anforderungen ändern sich** in einer bereits laufenden
      Datenbank (Tabellen und Daten existieren schon, siehe auch der
      Nachtrag aus Aufgabe 03). Beim Nachrüsten prüft SQL Server
      allerdings die vorhandenen Daten: Verstoßen sie gegen die neue
      Regel, wird der Constraint abgelehnt.
    - **Zwei Tabellen verweisen gegenseitig aufeinander.** Dann kann
      keine von beiden zuerst mit ihrem Fremdschlüssel angelegt werden;
      der zweite Fremdschlüssel muss nachträglich ergänzt werden.
    - **Große Datenmengen werden importiert.** Hier werden Constraints
      manchmal vorübergehend entfernt oder deaktiviert und danach wieder
      eingerichtet.

#### Vorhersage-Test: Wer lehnt was ab?

Füllt zuerst die Tabellen mit ein paar Ausgangsdaten (wenn ihr die
Tabellen frisch angelegt habt, bekommen die ersten beiden Algorithmen
die Nummern 1 und 2 und der Analyse-Lauf die Nummer 1):

```sql
INSERT INTO VERFAHREN (verfahren, grenzwert_meldung, grenzwert_alarm) VALUES
    ('DIN', 60, 80),
    ('PFIX', 50, 75);

INSERT INTO ALGORITHMUS (verfahren, ver, release_datum, release_status) VALUES
    ('DIN', '1.00', '2025-03-01', 'stable'),
    ('DIN', '1.01', '2025-09-15', 'beta');

INSERT INTO ANALYSE_LAUF (zeitstempel) VALUES ('2026-10-26 02:00:00');
```

Jetzt kommen sechs weitere Anweisungen. **Sagt jeweils vorher
voraus:** Läuft sie durch oder wird sie abgelehnt? Wenn sie abgelehnt
wird: Von welchem Constraint? Führt sie danach in dieser Reihenfolge
einzeln aus und vergleicht.

```sql
-- 1
INSERT INTO SCHAEDIGUNG VALUES (1, 1, 45);

-- 2
INSERT INTO SCHAEDIGUNG VALUES (1, 2, 120);

-- 3
INSERT INTO ALGORITHMUS (verfahren, ver, release_datum, release_status)
    VALUES ('DIN', '1.01', '2026-01-10', 'alpha');

-- 4
INSERT INTO ALGORITHMUS (verfahren, ver, release_datum, release_status)
    VALUES ('XYZ', '1.00', '2026-01-10', 'stable');

-- 5
INSERT INTO EXTREMWERT (zeitstempel, typ, wert)
    VALUES ('2026-10-25 13:42:00', 'Maximum', 3.2);

-- 6
INSERT INTO SCHAEDIGUNG VALUES (1, 1, 50);
```

??? quote musterloesung-hervorgehoben "Lösung"
    | Nr. | Ergebnis | Begründung |
    |---|---|---|
    | 1 | läuft durch | Lauf 1 und Algorithmus 1 existieren, 45 liegt zwischen 0 und 100. |
    | 2 | abgelehnt | `CK_SCHAEDIGUNG_WERT`: 120 liegt außerhalb von 0–100. |
    | 3 | abgelehnt | `UQ_ALGORITHMUS_VERFAHREN_VER`: Verfahren `DIN` in Version `1.01` gibt es schon. |
    | 4 | abgelehnt | Fremdschlüssel von `ALGORITHMUS`: Das Verfahren `XYZ` gibt es in `VERFAHREN` nicht. |
    | 5 | läuft durch | `verarbeitet` fehlt, `DEFAULT` setzt `0`. Mit `SELECT * FROM EXTREMWERT` könnt ihr das nachsehen. |
    | 6 | abgelehnt | Primärschlüssel von `SCHAEDIGUNG`: Die Kombination (1, 1) gibt es seit Anweisung 1 schon. |

    Schaut euch die Fehlermeldungen genau an (je nach
    Installationssprache auf Deutsch oder Englisch): Bei Nr. 2 und 3
    steht der Name, den *ihr* vergeben habt, in der Meldung — man sieht
    sofort, welche Regel gegriffen hat. Bei Nr. 4 und 6 steht dagegen
    ein von SQL Server erzeugter Name wie `FK__ALGORITHM__verfa__...`
    bzw. `PK__SCHAEDIG__...`, denn Primär- und Fremdschlüssel haben wir
    oben in der Kurzschreibweise angelegt, bei der SQL Server den Namen
    vergibt. Mit so einer Meldung lässt sich schlecht arbeiten — wie
    ihr auch diese Schlüssel selbst benennt, zeigt der nächste
    Abschnitt.

#### Primär- und Fremdschlüssel mit eigenem Namen

Die Kurzschreibweise `PRIMARY KEY` hinter dem Attribut bzw.
`FOREIGN KEY (...) REFERENCES ...` als eigene Zeile ist üblich und
funktioniert einwandfrei. Sie ist aber nur die Kurzform der
ausführlichen Schreibweise mit `CONSTRAINT`, und bei der Kurzform
vergibt SQL Server den Namen selbst. Ihr könnt diese Namen im Object
Explorer ansehen (Datenbank → *Tables* → Tabelle → *Keys*); sie sind
lang und nichtssagend. Mit `CONSTRAINT <Name>` bestimmt ihr den Namen
selbst — so wie ihr im Relationenschema die Beziehungen auch
bezeichnet:

```sql
-- Kurzform: SQL Server vergibt die Namen selbst
algorithmus_id  INT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
FOREIGN KEY (verfahren) REFERENCES VERFAHREN(verfahren)

-- Langform: ihr vergebt die Namen selbst
CONSTRAINT PK_ALGORITHMUS PRIMARY KEY (algorithmus_id),
CONSTRAINT FK_ALGORITHMUS_VERFAHREN
    FOREIGN KEY (verfahren) REFERENCES VERFAHREN(verfahren)
```

In der Langform stehen die Constraints als eigene Zeilen unter den
Attributen (bei `NOT NULL` und `IDENTITY` ändert sich nichts). Das
vollständige Skript im Gesamtergebnis unten ist durchgehend so
geschrieben: Dort tragen *alle* Constraints einen Namen, und jede
Fehlermeldung nennt die verletzte Regel im Klartext.

#### Reihenfolge und Fremdschlüssel

Zum Schluss noch ein Experiment: Löscht die Tabelle `VERFAHREN` mit
`DROP TABLE VERFAHREN;`. Was erwartet ihr, und in welcher Reihenfolge
müsste man die Tabellen löschen, um die ganze Datenbank sauber
abzubauen?

??? quote musterloesung-hervorgehoben "Lösung"
    SQL Server verweigert das Löschen: `ALGORITHMUS` hat einen
    Fremdschlüssel auf `VERFAHREN`, die Tabelle wird also noch
    gebraucht. Beim Abbau gilt deshalb die umgekehrte Reihenfolge wie
    beim Aufbau: zuerst die Tabellen, die auf andere verweisen
    (`SCHAEDIGUNG`, dann `ALGORITHMUS`), erst danach die Tabellen, auf
    die verwiesen wird (`VERFAHREN`, `ANALYSE_LAUF`).

---

### Gesamtergebnis <span class="zeitangabe">ca. 3 Min.</span> { data-toc-label="Gesamtergebnis" }

So sieht das vollständige Skript aus, wenn Tabellen und Constraints in
einem Schritt angelegt und alle Constraints benannt werden:

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/uebung-04-gesamt.sql"
    ```

    Zur Merkhilfe, wie sich das Relationenschema im SQL-Skript
    wiederfindet:

    | Im Relationenschema | In SQL Server |
    |---|---|
    | Wertebereich | Datentyp: `INT`, `DECIMAL(p,s)`, `VARCHAR(n)`, `DATE`, `DATETIME2(n)`, `BIT` |
    | "nicht optional" | `NOT NULL` |
    | PK (auch zusammengesetzt) | `PRIMARY KEY (...)` |
    | FK | `FOREIGN KEY (...) REFERENCES ...` — Zieltabelle zuerst anlegen |
    | Surrogatschlüssel | `IDENTITY(1,1)` |
    | Unique Key | `UNIQUE (...)` |
    | Regel zu Wertebereich/Liste | `CHECK (...)` |
    | Vorbelegter Wert | `DEFAULT ... ` |

---

## Betreutes Selbststudium { .modus-selbststudium }

### Worum geht es?

Ihr arbeitet jetzt selbstständig weiter und setzt ein Schema um, das ihr
schon kennt: die Prozessdatenbank der Schnüffel GmbH aus Aufgabe 03.
Dort habt ihr sie in drawDB entworfen — jetzt schreibt ihr die
SQL-Skripte, mit denen sie wirklich in SQL Server entsteht. Anschließend
prüft ihr ein Skript, wie es eine KI liefern könnte, auf Fehler, die der
Server nicht meldet, und testet eure Datenbank mit gezielten
Fehlversuchen.

!!! abstract "Lernziele"
    - Ihr könnt ein Relationenschema selbstständig in ein T-SQL-Skript
      umsetzen: Datentypen, Primär- und Fremdschlüssel, passende
      Constraints und die richtige Reihenfolge.
    - Ihr könnt in einem Skript, das fehlerfrei läuft, Logikfehler
      finden, ihre Auswirkung benennen und sie korrigieren.
    - Ihr könnt vorhersagen, welche Datenänderungen eine Datenbank
      wegen ihrer Constraints ablehnt.
    - Ihr könnt ein Skript aus einem Werkzeug (drawDB) mit einem
      selbst geschriebenen vergleichen und die Unterschiede bewerten.

### Aufgabe 04: Prozessdatenbank der Schnüffel GmbH anlegen

??? info "Bezug zu Lehrinhalten"
    Datentypen, Constraints und `ALTER TABLE`: die Übung oben.
    Schlüssel und Fremdschlüssel: Praxisphase Woche 4 und Woche 11. <br>
    Das Schema selbst stammt aus Aufgabe 03 (Teil A und B). <br>
    KI-Einsatz gem. [KI-Nutzungsrichtlinie](../../03-ki-erweiterungsaufgaben/ki-nutzungsrichtlinie.md):
    Teil A bearbeitet ihr mit KI höchstens als Nachschlagewerk, ab Teil B
    ist sie als Unterstützung ausdrücklich erlaubt.

#### Teil A — Kernschema von Hand anlegen

Plant für diesen Teil ca. 15 Minuten ein. Nutzt die KI hier höchstens
als Nachschlagewerk für Syntaxfragen — das Skript schreibt ihr selbst.

Das Kernschema der Schnüffel GmbH (Chargenbetrieb in der
Lackproduktion) besteht aus fünf Relationen:

**:octicons-table-16: Relation `REAKTOR`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | reaktor_id | string | nein |
| – | saeureresistent | boolean | nein |

**:octicons-table-16: Relation `REZEPT`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | rezept_id | string | nein |

**:octicons-table-16: Relation `REZEPT_PARAMETER`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK, FK | rezept_id | string | nein |
| PK | parameter_name | string | nein |
| – | wert | decimal | nein |

**:octicons-table-16: Relation `CHARGE`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | charge_nr | int | nein |
| FK | reaktor_id | string | nein |
| FK | rezept_id | string | nein |

**:octicons-table-16: Relation `PROZESSWERT`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK, FK | charge_nr | int | nein |
| PK | zeitstempel | datetime | nein |
| – | viskositaet | decimal | nein |
| – | temperatur | decimal | nein |
| – | fuellstand | decimal (Prozent) | nein |

1. Legt in SQL Server eine neue Datenbank `Schnueffel` an und darin die
   fünf Tabellen. Die Datentypen wählt ihr selbst: Wie lang sind
   Reaktor- und Rezeptkennungen (z. B. `R-02`, `LAK-100`) höchstens?
   Wie viele Stellen brauchen die Messwerte?
2. Haltet fest, in welcher Reihenfolge ihr die Tabellen angelegt habt,
   und begründet kurz, warum diese Reihenfolge nötig ist.
3. Der Füllstand wird in Prozent erfasst. Sichert diese Regel mit
   einem passenden Constraint ab.
4. Testet euer Schema mit diesem Skript. Es muss ohne Fehlermeldung
   durchlaufen (`1` steht hier für "säureresistent", `0` für "nicht
   säureresistent"). Meldet es einen Fehler, liegt die Ursache in
   eurem Schema.

```sql
--8<-- "02-theoriephase/termin-02/code/aufg-04-testdaten.sql"
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil A anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-02/code/aufg-04-schnueffel-teil-a.sql"
    ```

    **Reihenfolge:** `REAKTOR` und `REZEPT` haben keine Fremdschlüssel
    und stehen vorn. `REZEPT_PARAMETER` und `CHARGE` verweisen auf sie,
    und `PROZESSWERT` verweist auf `CHARGE` — also kommt `PROZESSWERT`
    zuletzt.

    **Datentypen:** Die Längen (`VARCHAR(10)`, `VARCHAR(20)`) sind
    bewusst großzügig gegenüber den Beispielwerten gewählt, aber nicht
    "so groß wie möglich". Viskosität, Temperatur und Füllstand haben
    im Beispiel höchstens eine Nachkommastelle; `DECIMAL(6,1)` und
    `DECIMAL(5,1)` genügen. Aus "boolean" wird `BIT`.

    **Constraint:** Der Füllstand in Prozent bekommt ein
    `CHECK (fuellstand BETWEEN 0 AND 100)` — hier direkt in der
    Tabellendefinition, denn die Tabelle wird ja gerade erst angelegt.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil B — Logikfehler im KI-Skript finden

Plant für diesen Teil ca. 15 Minuten ein. Ab hier dürft ihr KI als
Unterstützung nutzen — prüft aber jeden Vorschlag, ihr müsst ihn
erklären können.

Die Schnüffel GmbH hat in [Aufgabe 03](block-03.md#aufgabe-03-prozessdatenbank-der-schnuffel-gmbh) zwei Erweiterungen beschlossen,
die jetzt in die Datenbank sollen: Die Leitwarte dokumentiert
besondere Ereignisse während einer Charge (auch nachträglich und
sekundengenau, ein Kommentar ist optional, denn bei einer Störung
bleibt keine Zeit für Freitext). Außerdem werden pro Charge mehrere
Qualitätskennzahlen mit Messwert und Prüfdatum erfasst, jede
Kennzahl hat eine feste Einheit und ein festes Prüfverfahren. Dafür
gibt es drei Relationen:

**:octicons-table-16: Relation `EREIGNIS`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | ereignis_id | int | nein |
| FK | charge_nr | int | nein |
| – | zeitpunkt | datetime | nein |
| – | ereignistyp | string | nein |
| – | kommentar | string | ja |
| – | bediener | string | nein |

**:octicons-table-16: Relation `QUALITAETSERGEBNIS`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK, FK | charge_nr | int | nein |
| PK, FK | kennzahl | string | nein |
| – | wert | decimal | nein |
| – | pruefdatum | date | nein |

**:octicons-table-16: Relation `KENNZAHL`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | kennzahl | string | nein |
| – | einheit | string | nein |
| – | pruefverfahren | string | nein |

Ein KI-Assistent hat daraus das folgende Skript erzeugt (es setzt
voraus, dass die Tabellen aus Teil A bereits existieren). **Es läuft
ohne Fehlermeldung durch** — die Fehler darin sind keine
Syntaxfehler, sondern **Logikfehler**: Das Skript tut etwas anderes,
als das Relationenschema und die Anforderungen verlangen.

```sql
--8<-- "02-theoriephase/termin-02/code/aufg-04-ki-skript.sql"
```

Ein Fehler ist bereits gefunden: **`wert` ist als `FLOAT` angelegt.**
`FLOAT` speichert Näherungswerte, keine exakten Dezimalzahlen —
Summen und Vergleiche von Messwerten können dadurch überraschende
Abweichungen zeigen. Für Messwerte mit festen Nachkommastellen nimmt
man `DECIMAL(p,s)`.

Fünf weitere Logikfehler stecken noch im Skript.

1. Findet sie und haltet für jeden fest, **wo** er steht, **was
   fachlich schiefgeht** und **wie** ihr ihn korrigiert. Zwei Fragen
   helfen beim Suchen: Was kann ich eintragen, obwohl es fachlich nicht
   sein dürfte? Und was kann ich *nicht* eintragen, obwohl es fachlich
   nötig ist?
2. Schreibt das korrigierte Skript und führt es aus.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil B anzeigen"
    | Nr. | Wo | Fehler | Auswirkung | Korrektur |
    |---|---|---|---|---|
    | – | `QUALITAETSERGEBNIS.wert` | `FLOAT` (Beispiel aus der Aufgabe) | Näherungswerte statt exakter Dezimalzahlen. | `DECIMAL(8,2)` |
    | 1 | `QUALITAETSERGEBNIS` | Kein Fremdschlüssel auf `KENNZAHL` | Es lassen sich Kennzahlen eintragen, die es gar nicht gibt — Einheit und Prüfverfahren sind dann unbekannt. | `FOREIGN KEY (kennzahl) REFERENCES KENNZAHL(kennzahl)` |
    | 2 | `QUALITAETSERGEBNIS` | Primärschlüssel nur `charge_nr` | Pro Charge ließe sich nur *eine* Kennzahl speichern; ein zweiter Eintrag zur selben Charge wird als doppelter Schlüssel abgelehnt. | `PRIMARY KEY (charge_nr, kennzahl)` |
    | 3 | `EREIGNIS.kommentar` | `NOT NULL` | Das Schema nennt den Kommentar optional. So muss die Leitwarte mitten in der Störung einen Text eintippen — oder trägt irgendeinen Platzhalter ein, der die Daten verfälscht. | `NULL` zulassen |
    | 4 | `EREIGNIS.zeitpunkt` | `DATE` statt Datum mit Uhrzeit | Die Uhrzeit geht verloren, die geforderte sekundengenaue Nachtragung ist unmöglich. | `DATETIME2(0)` |
    | 5 | `QUALITAETSERGEBNIS.pruefdatum` | `VARCHAR(20)` statt `DATE` | Auch Unsinn wie `gestern` oder `31.02.2026` ist speicherbar; Sortieren und Zeitraumabfragen liefern falsche Ergebnisse. | `DATE` |

    ```sql
    --8<-- "02-theoriephase/termin-02/code/aufg-04-schnueffel-teil-b.sql"
    ```

    Gemeinsames Muster: Ein Server meldet nur, was er nicht ausführen
    *kann* — nicht, was fachlich falsch ist. Dieses Wissen muss aus dem
    Schema und den Anforderungen kommen, und genau das prüft ihr bei
    jedem KI-Skript.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil C — Constraint-Vorhersage

Plant für diesen Teil ca. 5 Minuten ein. Testdaten und Schema stammen
aus Teil A und eurem korrigierten Skript aus Teil B.

Legt zuerst zwei Kennzahlen an:

```sql
INSERT INTO KENNZAHL (kennzahl, einheit, pruefverfahren) VALUES
    ('Glanzgrad',     'GU', 'Glanzmessung 60 Grad'),
    ('Deckvermoegen', '%',  'Kontrastverhaeltnis');
```

Sagt für jede der folgenden fünf Anweisungen **vorher** voraus, ob sie
durchläuft oder abgelehnt wird (und von welchem Constraint). Führt sie
danach der Reihe nach aus:

```sql
-- 1
INSERT INTO EREIGNIS (charge_nr, zeitpunkt, ereignistyp, bediener)
    VALUES (4711, '2026-10-12 08:00:17', 'Regelung uebersteuert', 'Meier');

-- 2
INSERT INTO EREIGNIS (charge_nr, zeitpunkt, ereignistyp, kommentar, bediener)
    VALUES (9999, '2026-10-12 08:00:17', 'Regelung uebersteuert', 'Ventil klemmt', 'Meier');

-- 3
INSERT INTO QUALITAETSERGEBNIS (charge_nr, kennzahl, wert, pruefdatum)
    VALUES (4711, 'Glanzgrad', 87.5, '2026-10-13');

-- 4
INSERT INTO QUALITAETSERGEBNIS (charge_nr, kennzahl, wert, pruefdatum)
    VALUES (4711, 'Deckvermoegen', 96.2, '2026-10-13');

-- 5
INSERT INTO QUALITAETSERGEBNIS (charge_nr, kennzahl, wert, pruefdatum)
    VALUES (4711, 'Glanzgrad', 88.0, '2026-10-14');
```

Zusatzfrage: Bei welchen dieser Anweisungen wäre das Ergebnis mit dem
*fehlerhaften* KI-Skript aus Teil B anders ausgefallen?

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil C anzeigen"
    | Nr. | Ergebnis | Begründung |
    |---|---|---|
    | 1 | läuft durch | Charge 4711 existiert, der Kommentar ist optional, der Zeitpunkt wird sekundengenau gespeichert. |
    | 2 | abgelehnt | Fremdschlüssel auf `CHARGE`: Charge 9999 gibt es nicht. |
    | 3 | läuft durch | Charge und Kennzahl existieren. |
    | 4 | läuft durch | Zweite Kennzahl derselben Charge — möglich, weil der Primärschlüssel aus `charge_nr` *und* `kennzahl` besteht. |
    | 5 | abgelehnt | Primärschlüssel: Die Kombination (4711, `Glanzgrad`) gibt es seit Anweisung 3 schon. |

    **Zusatzfrage:** Beim fehlerhaften Skript wäre Nr. 1 gescheitert
    (`kommentar` ist dort `NOT NULL`) und Nr. 4 ebenfalls (der
    Primärschlüssel enthält dort nur `charge_nr`). Nr. 2, 3 und 5
    verhalten sich unverändert. Zwei der fünf Fehler aus Teil B hätten
    sich also schon bei diesem kleinen Test gezeigt — ein guter Grund,
    jedes generierte Schema mit ein paar gezielten Fehlversuchen zu
    prüfen.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil D — Gegenprobe mit dem drawDB-Export

Plant für diesen Teil ca. 10 Minuten ein.

In Aufgabe 03 habt ihr das Schema der Schnüffel GmbH in drawDB gebaut.
drawDB kann daraus selbst ein SQL-Skript erzeugen.

1. Öffnet euer drawDB-Diagramm aus Aufgabe 03 (Datenbank **MSSQL**)
   und exportiert es über **Datei → SQL exportieren**. (Habt ihr es
   nicht gesichert, nehmt die Musterlösung zu Aufgabe 03.)
2. Vergleicht das erzeugte Skript mit eurem eigenen aus Teil A und B.
   Achtet auf: Datentypen, `NOT NULL`, Fremdschlüssel, Constraints
   (z. B. euer `CHECK` für den Füllstand), die Reihenfolge der
   Anweisungen. Haltet drei Unterschiede fest und bewertet jeweils:
   Ist das Skript von drawDB besser, schlechter oder nur anders?
3. Kurzrecherche: drawDB verwendet für Zeitstempel den Typ `DATETIME`,
   ihr habt `DATETIME2` genutzt. Was unterscheidet die beiden Typen in
   SQL Server, und welchen empfiehlt Microsoft für neue Datenbanken?
   (Dokumentation: Microsoft Learn.)

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil D anzeigen"
    **Zu 2 — typische Unterschiede** (die genaue Ausgabe hängt von der
    drawDB-Version ab):

    - Ein Werkzeug exportiert nur, was im Diagramm steht: Ein `CHECK`
      für den Füllstand oder benannte Constraints sind nur enthalten,
      wenn ihr sie dort eingetragen habt. Eigene Skripte enthalten dafür
      genau die Regeln, die ihr bewusst gesetzt habt.
    - Fremdschlüssel können vom Werkzeug als eigene Anweisungen am Ende
      erzeugt werden statt innerhalb von `CREATE TABLE`. Das umgeht
      Reihenfolgeprobleme, ist aber ein anderer Stil als in der Übung.
    - Datentypen und Längen sind die, die im Diagramm stehen — hier lohnt
      der Vergleich mit euren eigenen Begründungen.

    Gute Bewertung: Ein exportiertes Skript ist ein brauchbarer
    Startpunkt, aber kein Ersatz für die inhaltliche Prüfung — dieselbe
    Haltung wie bei KI-Skripten.

    **Zu 3:** `DATETIME` deckt nur Datumswerte ab 1753 ab, ist auf etwa
    drei Millisekunden gerundet und hat eine feste Genauigkeit.
    `DATETIME2` umfasst einen größeren Datumsbereich (ab dem Jahr 1),
    erlaubt eine wählbare Genauigkeit (`DATETIME2(0)` bis
    `DATETIME2(7)`) und ist laut Microsoft-Dokumentation für neue Arbeit
    der empfohlene Typ. Für sekundengenaue Prozessdaten wie hier
    reicht `DATETIME2(0)`.
<!-- MUSTERLOESUNG-ENDE -->
