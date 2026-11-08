---
typ: theoriephase-block
termin: 6
block_id: "12"
datum: "2026-12-01"
kurztitel: "SQLite im C-Programm"
thema: "SQLite im C-Programm: Datenbank öffnen, Abfragen mit prepare/step/finalize, Werte binden, Fremdschlüssel und Fehlerbehandlung; Vokabeltrainer mit zwei Tabellen und KI-Unterstützung"
lernziele:
  - "Ihr könnt den Ablauf eines SQLite-Zugriffs in C (öffnen, vorbereiten, binden, lesen, freigeben, schließen) beschreiben und in einem Programm erkennen."
  - "Ihr könnt erklären, warum Eingaben mit Parametern gebunden statt in den SQL-Text eingesetzt werden, und warum nach jedem Öffnen die Fremdschlüssel eingeschaltet werden müssen."
  - "Ihr könnt mit KI-Unterstützung ein C-Programm mit SQLite-Anbindung entwickeln, den Vorschlag der KI gegen eine Checkliste prüfen und korrigieren und dokumentieren, was ihr übernommen, geändert und verworfen habt."
musterloesungen_sichtbar: false
fallstudie: "BestTec (Übung); Vokabeltrainer mit den Tabellen lektion und vokabel (Aufgabe)"
ki_einsatz: stufe_3_pflicht_reflexion
bearbeitungsstatus: entworfen
publish_date: 2026-12-01
quiz:
  show_progress: false
  disable_after_submit: false
---

# SQLite im C-Programm (01.12.2026)

## Übung { .modus-uebung }

### Worum geht es?

Eben habt ihr SQLite auf der Konsole benutzt. Jetzt greift ein
**C-Programm** auf dieselbe Datei zu. Die Bibliothek `sqlite3.c`, die ihr
in der Vorbereitung eingerichtet habt, liefert dafür Funktionen, mit
denen ihr die Datenbank öffnet, SQL-Text schickt, Ergebnisse Zeile für
Zeile lest und alles wieder freigebt. Wir entwickeln den Ablauf in dieser
Übung am Beispiel BestTec, in knapp 30 Minuten. Danach baut ihr im
betreuten Selbststudium selbst einen **Vokabeltrainer**, bei dem die
Vokabeln in einer SQLite-Datenbank liegen. Dabei dürft ihr ausdrücklich
eine KI nutzen. Deshalb legen wir hier auch fest, woran ihr gute und
schlechte Vorschläge erkennt.

!!! abstract "Lernziele"
    - Ihr könnt den Ablauf eines SQLite-Zugriffs in C beschreiben:
      öffnen, vorbereiten, binden, Zeilen lesen, freigeben, schließen.
    - Ihr könnt erklären, warum Eingaben mit `sqlite3_bind_*` gebunden
      werden, statt in den SQL-Text eingesetzt zu werden.
    - Ihr könnt erklären, warum ein Programm nach jedem Öffnen die
      Fremdschlüssel selbst einschalten muss, und Fehler anhand der
      Rückgabecodes erkennen.

### Projekt einrichten <span class="zeitangabe">ca. 3 Min.</span> { data-toc-label="Projekt einrichten" }

Aus der Vorbereitung habt ihr ein Projekt, in dem `sqlite3.c`,
`sqlite3.h` und das kleine Programm `version.c` laufen. Wir bauen darauf
auf. Außerdem braucht das Programm die Datenbank aus dem ersten Block:
Kopiert `besttec.db` in den Ordner, aus dem ihr das Programm startet. Habt
ihr sie nicht mehr, stellt ihr sie auf der Konsole mit den beiden
`.read`-Befehlen für
[uebung-11-besttec-schema.sql](code/uebung-11-besttec-schema.sql) und
[uebung-11-besttec-testdaten.sql](code/uebung-11-besttec-testdaten.sql)
neu her.

Wo sucht ein Programm eine Datei, die es nur mit dem Namen `besttec.db`
öffnet, ohne Pfad?

??? quote musterloesung-hervorgehoben "Lösung"
    Im **Arbeitsverzeichnis** des laufenden Programms. Das ist nicht
    unbedingt der Ordner mit der `.c`-Datei: In Visual Studio ist es beim
    Start aus der Entwicklungsumgebung der Projektordner, in der
    Eingabeaufforderung oder im Terminal von Visual Studio Code der Ordner,
    in dem ihr das Programm startet. Findet das Programm die Datei nicht,
    liegt das fast immer an einem falschen Arbeitsverzeichnis.

---

### Datenbank öffnen und schließen <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Datenbank öffnen und schließen" }

Bevor ein Programm etwas abfragen kann, muss es die Datenbank öffnen, und
am Ende muss es sie wieder schließen. Dazwischen sollte es jedes Mal
prüfen, ob die Funktion funktioniert hat. In SQL Server hat euch die
Verbindung SSMS abgenommen. Hier ist es eure Aufgabe: Welche Schritte
braucht ein Programm, und woran merkt es, dass etwas schiefging? Nach dem
Öffnen kommt außerdem der Befehl aus dem letzten Block, den jede neue
Verbindung braucht. Welcher?

??? quote musterloesung-hervorgehoben "Lösung"
    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/uebung-12-oeffnen.c"
    ```

    1. `sqlite3 *db` ist ein Zeiger auf die Verbindung. SQLite setzt ihn
       beim Öffnen, und alle weiteren Funktionen bekommen ihn als erstes
       Argument.
    2. `sqlite3_open_v2` öffnet die Datei. Mit `SQLITE_OPEN_READWRITE`
       muss sie schon existieren.
    3. Jede SQLite-Funktion liefert einen **Rückgabecode**.
       `SQLITE_OK` (der Wert 0) heißt Erfolg, alles andere ist ein Fehler.
       Ohne diese Prüfung läuft das Programm mit einem Fehler im Hintergrund
       weiter.
    4. `sqlite3_errmsg(db)` liefert den Fehlertext im Klartext.
    5. `sqlite3_exec` führt SQL-Text aus, der keine Ergebniszeilen liefert.
       Hier ist es das `PRAGMA` aus dem letzten Block, denn die
       Fremdschlüssel sind in jeder neuen Verbindung aus.
    6. Den Fehlertext, den `sqlite3_exec` liefert, gehört SQLite. Man gibt
       ihn mit `sqlite3_free` wieder frei.
    7. `sqlite3_close` schließt die Verbindung. Das gehört in jeden Weg
       aus dem Programm, auch in den Fehlerfall.

Es gibt auch die kürzere Funktion `sqlite3_open(datei, &db)`. Was passiert
mit ihr, wenn ihr euch beim Dateinamen vertippt (`besttec.dp`), und wie
würdet ihr das merken?

??? quote musterloesung-hervorgehoben "Lösung"
    `sqlite3_open` meldet Erfolg, denn sie legt die fehlende Datei
    einfach **neu und leer** an. Der Tippfehler fällt erst bei der ersten
    Abfrage auf, mit der Meldung `no such table: ma`, und im Ordner liegt
    eine überflüssige leere Datei. Mit `sqlite3_open_v2` und
    `SQLITE_OPEN_READWRITE` ohne `SQLITE_OPEN_CREATE` scheitert schon das
    Öffnen mit `unable to open database file`. Legt ein Programm dagegen
    absichtlich eine neue Datenbank an, nimmt man die Option
    `SQLITE_OPEN_CREATE` dazu.

---

### Abfragen lesen <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Abfragen lesen" }

Das Programm soll alle Mitarbeiter der Zentrale mit Gehalt und Provision
ausgeben, absteigend nach Gehalt. Eine Abfrage läuft in drei Schritten:
vorbereiten, Zeile für Zeile lesen, freigeben. Überlegt:

- Woran erkennt die Schleife, dass keine Zeile mehr kommt, und warum prüft
  man danach den Rückgabewert noch einmal?
- Ab welcher Nummer zählen die Spalten?
- Was liefert die Funktion für die Provision, wenn der Wert `NULL` ist?
  (Denkt an Termin 3.)

??? quote musterloesung-hervorgehoben "Lösung"
    Der Code gehört in die `main`-Funktion aus dem Abschnitt „Datenbank öffnen
    und schließen“, hinter das `PRAGMA`. Die Variable `rc` ist dort schon
    deklariert und wird hier weiterverwendet.

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/uebung-12-abfrage.c:abfrage"
    ```

    1. `sqlite3_prepare_v2` übersetzt den SQL-Text in eine vorbereitete
       Anweisung (`stmt`). Die `-1` bedeutet: Der Text endet mit einem
       Null-Zeichen, wie jeder C-String. Hier wird noch nichts ausgeführt.
    2. `sqlite3_step` holt die nächste Zeile. Es liefert `SQLITE_ROW`, solange
       eine Zeile da ist, und `SQLITE_DONE`, wenn die Ergebnisse zu Ende sind.
    3. `sqlite3_column_text`, `sqlite3_column_int` und
       `sqlite3_column_double` lesen die Spalten der aktuellen Zeile. Die
       Zählung beginnt bei **0**, in der Reihenfolge des `SELECT`. Der Zeiger
       des Textes gilt nur bis zum nächsten `step`, also nicht aufheben.
    4. Bei `NULL` liefert `sqlite3_column_text` einen `NULL`-Zeiger, und
       `sqlite3_column_double` liefert 0. Wer den Wert ausgeben will, muss
       vorher mit `sqlite3_column_type` auf `SQLITE_NULL` prüfen.
    5. Die Schleife endet bei `SQLITE_DONE` **und** bei einem Fehler. Deshalb
       prüft man danach, ob der Code wirklich `SQLITE_DONE` war.
    6. `sqlite3_finalize` gibt die vorbereitete Anweisung frei. Es gehört zu
       jedem `prepare`, auch wenn dazwischen etwas schiefging.

    Nur wenn alle drei Schritte vorkommen, ist der Ablauf vollständig.

---

### Werte sicher übergeben <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Werte sicher übergeben" }

Das Programm soll Mitarbeiter nach einem Namen suchen, den jemand eintippt.
Naheliegend ist, den Namen mit `snprintf` in den SQL-Text einzusetzen. Es
geht aber auch mit einem Platzhalter `?`, in den man später einen Wert
einsetzt. Das nennt man **Werte binden**.

!!! info "Was bedeutet „Werte binden“?"
    Beim Binden wird ein Wert **getrennt vom SQL-Text** an eine vorbereitete
    Anweisung übergeben. Das läuft in drei Schritten ab:

    1. `sqlite3_prepare_v2` übersetzt den SQL-Text, in dem an der Stelle des
       Wertes ein Platzhalter `?` steht, z. B. `WHERE name = ?`. Damit steht
       die Struktur der Anweisung fest.
    2. `sqlite3_bind_text(stmt, 1, eingabe, …)` ordnet dem Platzhalter einen
       Wert zu. Die `1` ist die Nummer des Platzhalters. Für Zahlen gibt es
       `sqlite3_bind_int` und `sqlite3_bind_double`, für `NULL`
       `sqlite3_bind_null`.
    3. `sqlite3_step` führt die Anweisung mit dem gebundenen Wert aus.

    SQLite liest den gebundenen Wert nie als SQL, sondern behandelt ihn immer
    nur als Wert, egal welche Zeichen darin stehen. Im betreuten
    Selbststudium bezieht sich die Checkliste auf genau diese Schritte.

Sagt vorher, was bei diesen drei Eingaben mit beiden Varianten passiert:

1. `Meier`
   { .buchstaben }
2. `O'Brien`
3. `x' OR '1'='1`

??? quote musterloesung-hervorgehoben "Lösung"
    **Variante 1: Wert in den SQL-Text einsetzen**

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/uebung-12-bind.c:unsicher"
    ```

    1. Der Name wird einfach in den SQL-Text gesetzt. Der Text, den jemand
       eintippt, wird dadurch zu einem **Teil des SQL-Befehls**.
    2. `sqlite3_prepare_v2` übersetzt den fertigen SQL-Text in eine
       vorbereitete Anweisung (`stmt`). Dabei prüft SQLite, ob der Text
       gültiges SQL ist und ob Tabellen und Spalten existieren. Es geht also
       nicht darum, ob die Datenbank erreichbar ist, denn die Verbindung `db`
       ist schon offen. Ist der Text fehlerhaft, liefert die Funktion einen
       Wert ungleich `SQLITE_OK`, und `sqlite3_errmsg(db)` nennt den Grund.
       Dann gibt es keine Anweisung, mit der man weiterarbeiten könnte,
       deshalb endet die Funktion mit `return`. Genau hier scheitert später
       die Eingabe (b).

    **Variante 2: Wert binden**

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/uebung-12-bind.c:sicher"
    ```

    1. Der Platzhalter `?` steht für einen Wert. Der SQL-Text bleibt
       unverändert, egal was später eingesetzt wird.
    2. Wieder wird der SQL-Text vorbereitet und das Ergebnis geprüft. Weil
       der Text nur den Platzhalter enthält, kann hier keine Eingabe etwas
       kaputt machen.
    3. `sqlite3_bind_text` setzt den Wert für den ersten Platzhalter ein.
       Parameter zählen ab **1** (Spalten dagegen ab 0). `SQLITE_TRANSIENT`
       sagt SQLite, dass es den Text kopieren soll, damit er nach dem Aufruf
       ungültig werden darf.

    | Eingabe | mit `snprintf` | mit `bind` |
    |---|---|---|
    | (a) `Meier` | 2 Treffer (Manager und Projektleiter) | 2 Treffer |
    | (b) `O'Brien` | **Syntaxfehler**: Das Apostroph beendet den Text zu früh | 0 Treffer, kein Fehler |
    | (c) `x' OR '1'='1` | **alle 20 Mitarbeiter**: Die Eingabe hat die Bedingung verändert | 0 Treffer |

    Fall (c) ist eine **SQL-Injection** (eine Vertiefung, die sonst nicht
    zum Programm gehört): Wer Eingaben in den SQL-Text einsetzt, lässt den
    Benutzer SQL schreiben. Fall (b) tritt auch ohne böse Absicht auf, etwa
    bei einem Nachnamen mit Apostroph. Mit gebundenen Werten gibt es beide
    Probleme nicht, weil der Wert nie als SQL gelesen wird. Merkregel: **Der
    SQL-Text ist fest, die Werte werden gebunden.**

---

### Fremdschlüssel im C-Programm <span class="zeitangabe">ca. 3 Min.</span> { data-toc-label="Fremdschlüssel im C-Programm" }

Das Programm soll einen Mitarbeiter in die Abteilung 99 einfügen, die es nicht
gibt. Einmal ohne und einmal mit dem `PRAGMA`. Wie sieht ein Programm aus,
das diesen Fehler erkennt, und woran sieht es, dass es ein
Fremdschlüssel-Fehler war?

??? quote musterloesung-hervorgehoben "Lösung"
    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/uebung-12-fremdschluessel.c"
    ```

    1. Der Rückgabecode ist nur `SQLITE_CONSTRAINT` (19) für jede Art von
       Constraint-Verletzung. `sqlite3_extended_errcode` unterscheidet sie
       genauer: 787 steht für einen Fremdschlüssel-Fehler
       (`SQLITE_CONSTRAINT_FOREIGNKEY`).

    Die Ausgabe:

    ```text
    ohne PRAGMA: eingefuegt (Abteilung 99 gibt es gar nicht!)
    mit PRAGMA : Fehler 19 (erweitert 787): FOREIGN KEY constraint failed
    ```

    Ohne das `PRAGMA` merkt das Programm gar nichts: Es gibt keine Meldung,
    und die Datenbank wird inkonsistent. Ein Programm muss einen solchen
    Fehler außerdem **selbst abfangen** und der Anwenderin verständlich
    melden, denn die Datenbank liefert nur den Code und den Text.

---

### Die Aufgabe: ein Vokabeltrainer <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Die Aufgabe: ein Vokabeltrainer" }

Im betreuten Selbststudium baut ihr einen Vokabeltrainer für Technik-Englisch.
Die Vokabeln sind in **Lektionen** geordnet. Die Daten liegen in einer
SQLite-Datei mit zwei Tabellen und einem Fremdschlüssel:

**:octicons-table-16: Relation `LEKTION`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | lektion_id | ganze Zahl | nein |
| – | titel | Text (eindeutig) | nein |

**:octicons-table-16: Relation `VOKABEL`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | vokabel_id | ganze Zahl | nein |
| FK | lektion_id | ganze Zahl (verweist auf `LEKTION`) | nein |
| – | englisch | Text | nein |
| – | deutsch | Text | nein |
| – | richtig | ganze Zahl (Zähler, Start 0) | nein |
| – | falsch | ganze Zahl (Zähler, Start 0) | nein |
| – | zuletzt_geprueft | Text (Datum und Uhrzeit) | ja |

Das Programm soll ein Menü haben. Pflicht sind **Lektionen anzeigen**
(mit der Anzahl der Vokabeln) und **Lektion abfragen**: Das Programm zeigt die
englische Vokabel, ihr tippt die deutsche, es meldet richtig oder falsch und
zählt das Ergebnis in der Datenbank mit. Dazu kommen wählbare Erweiterungen,
die ihr im betreuten Selbststudium findet.

Überlegt, welche SQL-Anweisung hinter jeder Funktion steckt und welche
Werte gebunden werden müssen.

??? quote musterloesung-hervorgehoben "Lösung"
    | Funktion | SQL | Gebundene Werte |
    |---|---|---|
    | Lektionen anzeigen | `SELECT … FROM lektion LEFT JOIN vokabel … GROUP BY …` mit `COUNT` | keine |
    | Lektion abfragen: Vokabeln wählen | `SELECT vokabel_id … WHERE lektion_id = ? ORDER BY RANDOM()` | Nummer der Lektion |
    | Lektion abfragen: Ergebnis speichern | `UPDATE vokabel SET richtig = richtig + ?, …` | Zählerstände, Nummer der Vokabel |
    | Vokabel hinzufügen | `INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (?, ?, ?)` | Lektion, beide Texte |
    | Lektion löschen | `DELETE FROM lektion WHERE lektion_id = ?` | Nummer der Lektion |

    Jede Eingabe, die ein Benutzer tippt, wird gebunden. `RANDOM()` ist eine
    SQLite-Funktion, die die Zeilen in zufälliger Reihenfolge liefert.

    !!! info "Auffrischung: LEFT JOIN"
        Verbundabfragen kennt ihr aus Termin 3, dort wurde auch die Schreibweise
        `LEFT JOIN` kurz gezeigt. Er ist eine Verbundabfrage wie der normale
        `JOIN`, geht aber mit Zeilen ohne Partner anders um: Beim normalen
        `JOIN` fallen sie weg, eine Lektion ohne Vokabeln würde in der Liste
        fehlen. Der `LEFT JOIN` behält alle Zeilen der **linken** Tabelle (hier
        `lektion`). Hat eine Lektion keine Vokabeln, stehen in den Spalten der
        rechten Tabelle `NULL`-Werte. Mit `COUNT(v.vokabel_id)` zählt ihr dann
        0, denn `COUNT` einer Spalte zählt nur Zeilen ohne `NULL`. Eine KI
        verwendet `LEFT JOIN` häufig, ihr müsst ihn deshalb lesen können.

---

### Checkliste für SQLite im C-Programm <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Checkliste für SQLite im C-Programm" }

Diese Checkliste prüft jedes Programm, das SQLite benutzt, auch jeden
Vorschlag einer KI. Ihr braucht sie gleich im betreuten Selbststudium:

| Schritt | Worauf achten |
|---|---|
| 1. Öffnen | `sqlite3_open_v2` mit `SQLITE_OPEN_READWRITE`, Rückgabecode prüfen, bei Fehler `sqlite3_errmsg` ausgeben |
| 2. Fremdschlüssel | `PRAGMA foreign_keys = ON;` direkt nach dem Öffnen |
| 3. Vorbereiten | SQL-Text fest, Werte als `?`, Rückgabe von `sqlite3_prepare_v2` prüfen |
| 4. Binden | `sqlite3_bind_*` für jede Eingabe, Parameter zählen ab 1, nie `sprintf` für Werte |
| 5. Lesen | Schleife über `SQLITE_ROW`, danach `SQLITE_DONE` prüfen, Spalten ab 0, `NULL` beachten |
| 6. Schreiben | `step` einmal aufrufen, `SQLITE_DONE` erwarten, Constraint-Fehler abfangen |
| 7. Freigeben | `sqlite3_finalize` für jedes `prepare`, auch im Fehlerfall |
| 8. Schließen | `sqlite3_close` am Ende, `sqlite3_free` für Fehlertexte von `sqlite3_exec` |

---

## Betreutes Selbststudium { .modus-selbststudium }

### Worum geht es?

Jetzt seid ihr dran: Ihr baut einen Vokabeltrainer in C, dessen Daten in
SQLite liegen. Die KI darf dabei ausdrücklich mithelfen, und ihr werdet sie
brauchen, denn in der Zeit ist das Programm sonst kaum zu schaffen. Ihr
bleibt aber im Lead: Die KI liefert Vorschläge, ihr prüft sie gegen die
Checkliste aus der Übung, korrigiert sie und dokumentiert, was ihr
übernommen, geändert und verworfen habt.

!!! abstract "Lernziele"
    - Ihr könnt eine Datenbank mit zwei Tabellen und einem Fremdschlüssel in
      SQLite anlegen.
    - Ihr könnt von einer KI erzeugten C-Code mit SQLite-Zugriff gegen die
      Checkliste prüfen und korrigieren.
    - Ihr könnt ein Programm um eine Funktion mit Datenbankzugriff
      erweitern und dabei Fehler der Datenbank abfangen.
    - Ihr könnt dokumentieren, was ihr von der KI übernommen, angepasst
      oder verworfen habt, und begründen warum.

### Aufgabe 11: Vokabeltrainer mit SQLite

??? info "Bezug zu Lehrinhalten"
    Die Übung oben und der erste Block dieses Termins (SQLite auf der
    Konsole, `PRAGMA foreign_keys`, `STRICT`, `INTEGER PRIMARY KEY`). <br>
    SQL aus Termin 3 (`SELECT`, `JOIN`, `GROUP BY`, `NULL`) und
    Fremdschlüssel aus Termin 2. <br>
    KI-Einsatz gem. [KI-Nutzungsrichtlinie](../../03-ki-erweiterungsaufgaben/ki-nutzungsrichtlinie.md)
    (Stufe 3, KI-Pflicht mit Reflexion): Ihr nutzt die KI gezielt und
    dokumentiert, was ihr von ihr übernommen, korrigiert und verworfen habt.

Das Relationenschema steht oben in der Übung (`LEKTION` und `VOKABEL`).
Arbeitet in einem Ordner, der auch die Dateien `sqlite3.c` und `sqlite3.h`
enthält. Die Datenbank `vokabeln.db` legt ihr in Teil A an.

#### Teil A — Datenbank anlegen und testen <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Teil A — Datenbank anlegen und testen" }

In diesem Teil bereitet ihr die Datenbank vor, mit der euer Vokabeltrainer
später arbeitet. Das Anlegen der Datenbank gehört **nicht** zum Programm:
Der Vokabeltrainer ist nur die Anwendung, die in einer fertigen Datenbank
Daten ergänzt, verändert und abfragt. Deshalb führt ihr **alle Aufgaben
dieses Teils direkt in der Konsole `sqlite3` (`sqlite3.exe`) aus**. Das gilt
auch für die Aufgaben 3 und 4: Dort probiert ihr Abfragen aus, wie das
Programm sie später braucht.

1\. Startet `sqlite3 vokabeln.db` und legt beide Tabellen nach dem
Relationenschema an. Schaltet die Fremdschlüssel ein und verwendet strenge
Typen (`STRICT`). Die Zähler `richtig` und `falsch` sollen mit 0 beginnen.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.1 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-vokabeltrainer-teil-a.sql:a1"
    ```

    1. `INTEGER PRIMARY KEY` vergibt die Nummer automatisch, wenn man beim
       `INSERT` keine angibt.
    2. `STRICT` erzwingt die Typen.
    3. Der Fremdschlüssel sorgt dafür, dass jede Vokabel zu einer Lektion
       gehört, die es wirklich gibt.
    4. Der Zeitpunkt der letzten Prüfung darf leer sein (`NULL`), solange
       eine Vokabel noch nie abgefragt wurde. Er steht später als Text im
       ISO-Format.

    Die Zähler stehen mit `DEFAULT 0` bei jeder neuen Vokabel zunächst auf 0.
<!-- MUSTERLOESUNG-ENDE -->

2\. Ladet die Daten mit
[aufg-11-vokabeln-daten.sql](code/aufg-11-vokabeln-daten.sql) (`.read`).
Eine Vokabel enthält ein Apostroph. Wie steht sie im Skript, und warum? Wie
viele Vokabeln und Lektionen sind jetzt in der Datenbank?

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.2 anzeigen"
    Es sind 4 Lektionen und 12 Vokabeln. Die Lektion „Pneumatik“ hat noch
    keine Vokabeln, das ist Absicht und taucht später noch auf. Das Apostroph
    in `it's broken` steht im Skript **doppelt** (`'it''s broken'`): In
    SQL beendet ein einzelnes Apostroph den Text, ein doppeltes steht für
    ein Apostroph im Text. Genau an dieser Stelle scheitern Programme, die
    Eingaben in den SQL-Text einsetzen (siehe Übung).
<!-- MUSTERLOESUNG-ENDE -->

3\. Zeigt alle Vokabeln mit dem Titel ihrer Lektion an, sortiert nach
Lektion und Englisch.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.3 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-vokabeltrainer-teil-a.sql:a3"
    ```

    Es entstehen 12 Zeilen. Der `JOIN` über die Lektionsnummer verbindet jede
    Vokabel mit ihrer Lektion.
<!-- MUSTERLOESUNG-ENDE -->

4\. Wie viele Vokabeln hat jede Lektion? Auch die Lektion ohne Vokabeln soll
mit dem Wert 0 erscheinen. *Tipp:* Ein normaler `JOIN` lässt Lektionen ohne
Vokabeln weg. Ein `LEFT JOIN` behält alle Lektionen und füllt die fehlenden
Vokabel-Spalten mit `NULL` (siehe Übung).

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.4 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-vokabeltrainer-teil-a.sql:a4"
    ```

    1. `COUNT(v.vokabel_id)` zählt nur Zeilen, in denen die Vokabel-Nummer
       nicht `NULL` ist, deshalb ergibt sich für „Pneumatik“ die 0.
       `COUNT(*)` würde dort 1 liefern, weil die Zeile mit den `NULL`-Werten
       auch eine Zeile ist.

    Ergebnis: Mechanik 4, Elektrik 4, Steuerung 4, Pneumatik 0.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil B — Den Rohbau von der KI erzeugen und prüfen <span class="zeitangabe">ca. 15 Min.</span> { data-toc-label="Teil B — Den Rohbau von der KI erzeugen und prüfen" }

Lasst euch von einer KI einen ersten Vokabeltrainer erzeugen. Der Prompt
enthält absichtlich keine Hinweise auf Fehlerbehandlung oder Sicherheit.
Ihr sollt sehen, was die KI von selbst daraus macht.

```text
Schreibe ein Konsolenprogramm in C (Standard C99) für einen Vokabeltrainer.
Es nutzt SQLite über die C-Schnittstelle (#include "sqlite3.h"). Die Datenbank
vokabeln.db gibt es schon, mit diesen Tabellen:

CREATE TABLE lektion (lektion_id INTEGER PRIMARY KEY, titel TEXT NOT NULL UNIQUE) STRICT;
CREATE TABLE vokabel (vokabel_id INTEGER PRIMARY KEY,
  lektion_id INTEGER NOT NULL REFERENCES lektion (lektion_id),
  englisch TEXT NOT NULL, deutsch TEXT NOT NULL,
  richtig INTEGER NOT NULL DEFAULT 0, falsch INTEGER NOT NULL DEFAULT 0,
  zuletzt_geprueft TEXT) STRICT;

Das Programm hat ein Menü: 1 Lektionen anzeigen (Nummer, Titel, Anzahl der
Vokabeln), 2 Lektion abfragen, 0 Beenden. Bei "Lektion abfragen" gibt der
Benutzer eine Lektionsnummer ein. Das Programm zeigt dann alle Vokabeln dieser
Lektion in zufälliger Reihenfolge: Es zeigt das englische Wort, der Benutzer
tippt die deutsche Übersetzung, das Programm meldet richtig oder falsch und
erhöht in der Datenbank den Zähler richtig bzw. falsch und setzt
zuletzt_geprueft.
```

1\. Übersetzt und startet das Programm. Läuft es, ohne dass ihr etwas
ändern müsst? Wenn nicht, was musstet ihr ändern?

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.1 anzeigen"
    Das hängt vom Vorschlag der KI ab. Häufige Dinge, die man anpassen
    muss: Der Dateiname in `#include` oder die fehlende Zeile
    `#define _CRT_SECURE_NO_WARNINGS` (Visual Studio), der Aufruf von
    `scanf` oder `gets` statt `fgets`, oder eine falsche Annahme zum
    Arbeitsverzeichnis. Notiert jede Änderung für die Dokumentation in
    Teil C.
<!-- MUSTERLOESUNG-ENDE -->

2\. Prüft den Quelltext gegen die Checkliste aus der Übung
und tragt eure Beobachtungen ein:

| Prüfpunkt | Eure Notiz |
|---|---|
| Wird die Datei so geöffnet, dass ein Tippfehler im Namen keine neue leere Datenbank erzeugt (`sqlite3_open_v2`)? Wird der Rückgabecode geprüft? | |
| Schaltet das Programm nach dem Öffnen `PRAGMA foreign_keys = ON;` ein? | |
| Werden Eingaben mit `sqlite3_bind_*` übergeben oder mit `sprintf` in den SQL-Text eingesetzt? | |
| Hat jedes `sqlite3_prepare_v2` ein `sqlite3_finalize`, auch auf den Fehlerwegen? | |
| Prüft die Leseschleife `SQLITE_ROW` und danach `SQLITE_DONE` (nicht nur `!= SQLITE_DONE`)? | |
| Stimmen die Nummern (Parameter ab 1, Spalten ab 0), und wird `NULL` beachtet? | |
| Was habt ihr am Vorschlag der KI geändert oder verworfen? | |

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.2 anzeigen"
    Welche Fehler eure KI gemacht hat, kann von Programm zu Programm
    verschieden sein. Diese fünf sind typisch, hier jeweils falsch und
    richtig:

    **Werte in den SQL-Text einsetzen (Prüfpunkt 3):** Bei `it's broken`
    bricht der SQL-Text. Mit `sqlite3_bind_text` gibt es das Problem nicht.

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-typische-fehler.c:f1"
    ```

    **`sqlite3_finalize` fehlt (Prüfpunkt 4):** Die vorbereitete Anweisung
    bleibt offen und hält Speicher und eine Sperre auf der Datenbank. Bei
    langen Programmläufen wird das zum Problem.

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-typische-fehler.c:f2"
    ```

    **Schleife mit `!= SQLITE_DONE` (Prüfpunkt 5):** Liefert `sqlite3_step`
    einen Fehler statt `SQLITE_ROW`, endet die Schleife nie, oder sie liest
    falsche Werte.

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-typische-fehler.c:f3"
    ```

    **`PRAGMA foreign_keys` fehlt (Prüfpunkte 1 und 2):** Die Datenbank lässt
    ungültige Verweise zu, ohne zu melden, dass etwas nicht stimmt. Dazu legt
    `sqlite3_open` bei einem Tippfehler im Namen eine neue leere Datei an.

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-typische-fehler.c:f4"
    ```

    **Falsche Nummern (Prüfpunkt 6):** Parameter zählen ab 1, Spalten ab 0.
    Parameter 0 liefert den Fehler `SQLITE_RANGE`, was nur auffällt, wenn der
    Rückgabecode geprüft wird.

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-typische-fehler.c:f5"
    ```
<!-- MUSTERLOESUNG-ENDE -->

3\. Testet das Programm mit diesen Fällen, und korrigiert, was nicht
stimmt:

| Test | Erwartung |
|---|---|
| (a) Menü 1 | vier Lektionen mit den Anzahlen 4, 4, 4 und 0 |
| (b) Lektion 3 abfragen, bei `it's broken` die richtige Antwort `es ist kaputt` tippen | „Richtig“; danach zeigt `SELECT englisch, richtig, falsch FROM vokabel WHERE lektion_id = 3;` in der Konsole den neuen Zähler |
| (c) Lektion 99 oder einen Buchstaben statt einer Zahl eingeben | eine verständliche Meldung, kein Absturz |
| (d) Lektion 4 abfragen (leer) | eine Meldung, dass keine Vokabeln da sind |
| (e) `vokabeln.db` umbenennen und das Programm starten | eine Fehlermeldung, und es entsteht **keine** neue leere Datei |
| (f) Programm beenden und neu starten | die Zähler sind noch da |

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.3 anzeigen"
    Typische Ursachen, wenn ein Test scheitert:

    1. Die Anzahl der Vokabeln stimmt nicht: Die Lektion „Pneumatik“ fehlt in
       der Liste, weil `JOIN` statt `LEFT JOIN` verwendet wurde, oder sie zeigt
       1 statt 0, weil `COUNT(*)` statt `COUNT(v.vokabel_id)` zählt.
       { .buchstaben }
    2. Der Zähler ändert sich nicht: Das `UPDATE` wird nicht ausgeführt (kein
       `sqlite3_step`) oder steht in einer Transaktion, die nie beendet wird.
       Auch ein vertauschter Parameter kommt vor. Führt das Apostroph in
       `it's broken` zu einem Fehler, wurde der Text mit `sprintf` eingesetzt.
    3. Absturz oder Endlosschleife: Die Eingabe wird mit `scanf` gelesen.
       Besser ist `fgets` mit `atoi` oder `strtol`, wie im Beispielprogramm.
       Eine ungültige Eingabe ergibt dann 0, und es gibt keine Lektion mit der
       Nummer 0.
    4. Das Programm fragt nichts ab und hört ohne Meldung auf, oder es greift
       auf ein leeres Ergebnis zu.
    5. Das Programm öffnet eine neue leere Datenbank (`sqlite3_open` statt
       `sqlite3_open_v2`) und läuft dann in `no such table`.
    6. Die Zähler sind weg: Die Daten liegen nur im Speicher des Programms,
       nicht in der Datenbank.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil C — Erweitern und dokumentieren <span class="zeitangabe">ca. 35 Min.</span> { data-toc-label="Teil C — Erweitern und dokumentieren" }

Baut den geprüften Rohbau jetzt aus. Wählt **mindestens eine** dieser
Erweiterungen und lasst euch dabei von der KI helfen. Die Datenbank kann bei
jeder Erweiterung Fehler melden, die euer Programm abfangen muss.

- **E1 — Vokabel hinzufügen:** Neuer Menüpunkt. Der Benutzer wählt die
  Lektion und tippt Englisch und Deutsch ein, das Programm speichert die
  Vokabel. Gibt es die Lektion nicht, kommt eine verständliche Meldung statt
  eines Absturzes. Die Vokabel `it's fine` / `es ist gut` muss funktionieren.
- **E2 — Statistik:** Neuer Menüpunkt. Je Lektion werden die Summe der
  richtigen und der falschen Antworten und die Erfolgsquote in Prozent
  angezeigt. Eine Lektion, die noch nie abgefragt wurde, zeigt statt der
  Quote einen Strich.
- **E3 — Schwierige Vokabeln üben:** Neuer Menüpunkt. Abgefragt werden nur
  Vokabeln einer Lektion, bei denen `falsch` größer ist als `richtig`, die
  mit den meisten Fehlern zuerst.
- **E4 — Lektion löschen:** Neuer Menüpunkt. Eine Lektion, die noch Vokabeln
  enthält, darf nicht gelöscht werden, und das Programm sagt, warum. Eine
  leere Lektion lässt sich löschen. Eine Lektion, die es nicht gibt, wird
  gemeldet.

Zeigt am Ende mit mindestens einem Testlauf pro Erweiterung, dass sie
funktioniert, auch im Fehlerfall.

**Pflicht-Dokumentation** (kurz, Stichpunkte genügen): Führt eine Tabelle mit
dem Vorschlag der KI, eurer Entscheidung (übernommen, angepasst oder
verworfen) und der Begründung. Tragt dort auch die Änderungen aus Teil B ein.

| Vorschlag der KI | Entscheidung | Begründung |
|---|---|---|
| | | |

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil C anzeigen"
    Das vollständige Programm mit allen vier Erweiterungen steht zum
    Herunterladen bereit: [aufg-11-vokabeltrainer.c](code/aufg-11-vokabeltrainer.c).
    Die Teile im Einzelnen:

    **E1 — Vokabel hinzufügen**

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-vokabeltrainer.c:hinzufuegen"
    ```

    1. Leere Eingaben fängt das Programm selbst ab. `NOT NULL` in der
       Datenbank verhindert nur `NULL`, nicht einen leeren Text.
    2. Der SQL-Text ist fest. Die drei `?` stehen für die Werte.
    3. Die Platzhalter werden der Reihe nach ab 1 gebunden: Lektionsnummer als
       Zahl, die beiden Texte mit `sqlite3_bind_text`. So funktioniert auch
       `it's fine`.
    4. Der erweiterte Fehlercode wird gleich nach `sqlite3_step` gelesen und
       **vor** `sqlite3_finalize`, denn danach ist er nicht mehr zuverlässig.
    5. `SQLITE_CONSTRAINT_FOREIGNKEY` (787) bedeutet: Die Lektion gibt es nicht.
       Das Programm erkennt das aber nur, weil `main` nach dem Öffnen das
       `PRAGMA foreign_keys = ON;` ausgeführt hat. Ohne das `PRAGMA` würde die
       Vokabel ohne Meldung einer nicht vorhandenen Lektion zugeordnet.

    **E2 — Statistik**

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-vokabeltrainer.c:statistik"
    ```

    1. `SUM` liefert bei einer Lektion ohne Vokabeln `NULL`. `COALESCE` ersetzt
       `NULL` durch 0, sonst kämen dort `NULL`-Werte an.
    2. Die Quote berechnet SQLite. `100.0` statt `100` erzwingt eine
       Rechnung mit Dezimalstellen. Bei einer Lektion ohne Abfragen ist die
       Summe im Nenner 0 oder `NULL`, und SQLite liefert dann `NULL` statt
       einer Fehlermeldung.
    3. Der `LEFT JOIN` behält auch die leere Lektion in der Liste.
    4. Das Programm prüft den Typ der Spalte, bevor es sie ausgibt: `NULL`
       heißt „noch nichts abgefragt“ und wird als Strich dargestellt, nicht
       als 0 %.

    **E3 — Schwierige Vokabeln**

    Im Beispielprogramm ist das eine zweite SQL-Anweisung in der Funktion
    `vokabel_ids_laden` (Abschnitt `abfragen`):

    ```sql
    SELECT vokabel_id FROM vokabel
    WHERE lektion_id = ? AND falsch > richtig -- (1)!
    ORDER BY falsch - richtig DESC, RANDOM(); -- (2)!
    ```

    1. Nur Vokabeln, bei denen es mehr falsche als richtige Antworten gibt.
    2. Der größte Rückstand kommt zuerst, bei Gleichstand entscheidet der
       Zufall.

    Der Rest des Programms bleibt gleich: Ein Parameter entscheidet, welche
    der beiden Anweisungen verwendet wird.

    **E4 — Lektion löschen**

    ```c linenums="1"
    --8<-- "02-theoriephase/termin-06-sqlite/code/aufg-11-vokabeltrainer.c:loeschen"
    ```

    1. Der Fehlercode wird sofort gesichert, vor weiteren Aufrufen.
    2. `sqlite3_changes` liefert die Zahl der Zeilen, die die letzte Anweisung
       gelöscht hat. 0 heißt: Es gab keine Lektion mit dieser Nummer. Ein
       `DELETE` ohne Treffer ist in SQL kein Fehler, das Programm muss es
       selbst erkennen.
    3. Das `DELETE` einer Lektion mit Vokabeln scheitert am Fremdschlüssel
       (787). Das Programm erkennt den Fehler und meldet ihn.

    Eine leere Lektion lässt sich löschen. Eine andere Entscheidung wäre
    `ON DELETE CASCADE` im Fremdschlüssel: Dann würden mit der Lektion alle
    ihre Vokabeln gelöscht. Das ist bequemer, aber ein versehentliches
    Löschen vernichtet dann viele Daten. Welche Variante besser ist, hängt
    von der Anwendung ab und sollte begründet werden.

    **Beispiel für die Dokumentation**

    | Vorschlag der KI | Entscheidung | Begründung |
    |---|---|---|
    | SQL-Text mit `sprintf` zusammensetzen | verworfen | `it's broken` bricht den SQL-Text; stattdessen `sqlite3_bind_text` |
    | `sqlite3_open` zum Öffnen | angepasst auf `sqlite3_open_v2` mit `SQLITE_OPEN_READWRITE` | Ein Tippfehler im Namen würde sonst eine leere Datenbank anlegen |
    | Menü und Eingabe mit `scanf` | angepasst auf `fgets` mit `atoi` | `scanf` stürzt bei Buchstaben statt einer Zahl ab oder bleibt hängen |
    | Abfrage der Lektionen mit `JOIN` | angepasst auf `LEFT JOIN` | Sonst fehlt die leere Lektion „Pneumatik“ in der Liste |
    | Schleife mit `!= SQLITE_DONE` | übernommen mit Änderung | Auf `SQLITE_ROW` umgestellt und den Rückgabecode danach geprüft |
    | Funktion für die Statistik in der KI-Fassung | übernommen | Die Quote wird in SQL berechnet und `NULL` korrekt behandelt |
<!-- MUSTERLOESUNG-ENDE -->
