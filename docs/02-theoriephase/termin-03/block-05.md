---
typ: theoriephase-block
termin: 3
block_id: "05"
datum: "2026-11-03"
kurztitel: "SQL-Abfragen mit BestTec"
thema: "SQL-Abfragen (DQL) an Fallbeispielen aus dem Lehrbrief: Projektion, Selektion, Sortierung, Verbund"
lernziele:
  - "Ihr könnt zu einer fachlichen Fragestellung eine SELECT-Abfrage mit Projektion, Selektion, Sortierung und Verbund über mehrere Tabellen aufbauen und ihr Ergebnis von Hand herleiten."
  - "Ihr könnt die Aussage einer fremden Abfrage lesen, ihr Ergebnis vorhersagen und typische Fehlerbilder (fehlende Verknüpfung, Duplikate, Klammerfehler) erkennen."
musterloesungen_sichtbar: true
fallstudie: "BestTec (Lehrbrief Anhang 9.2, S. 97–98)"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-11-03
---

# SQL-Abfragen mit BestTec (03.11.2026)

## Übung { .modus-uebung }

### Worum geht es?

Ihr habt Kapitel 7 des Lehrbriefs gelesen und kennt die Bausteine einer
SELECT-Abfrage vom Papier. Heute probiert ihr sie zum ersten Mal an
einer echten Datenbank aus. Wir gehen dabei immer gleich vor: Wir
beginnen mit einer praktischen Frage an die Daten, überlegen gemeinsam,
welche Angaben die Datenbank dafür braucht, und leiten daraus die
Syntax ab. Anschließend führen wir die Abfrage aus und schauen uns an,
worauf man achten muss. Wo SQL Server von der Schreibweise im Lehrbrief
abweicht, steht es auf der Seite
[SQL Server und Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md).

!!! abstract "Lernziele"
    - Ihr könnt aus einer fachlichen Frage an die Daten eine
      SELECT-Abfrage ableiten und erklären, wofür `SELECT`, `FROM`,
      `WHERE` und `ORDER BY` jeweils zuständig sind.
    - Ihr könnt erklären, warum bei Abfragen über mehrere Tabellen eine
      Verknüpfungsbedingung nötig ist, und das Ergebnis einer Abfrage
      mit `AND` und `OR` vorhersagen.

### Kurzer Rückblick <span class="zeitangabe">ca. 3 Min.</span> { data-toc-label="Kurzer Rückblick" }

**1.** Wozu dient ein Fremdschlüssel, und woran erkennt ihr in einem
Relationenschema, welche Tabellen miteinander zusammenhängen?

<!-- MUSTERLOESUNG-START -->
??? note "Musterlösung anzeigen"
    Ein Fremdschlüssel verweist auf den Primärschlüssel einer anderen
    Relation und bildet so die Beziehung zwischen Datensätzen ab. Im
    Relationenschema erkennt man ihn an der Kennzeichnung „FK“; die
    Tabelle, auf die er verweist, ist die verbundene Tabelle. In
    BestTec verweisen z. B. `ma.abtnr` und `prj.abtnr` auf `abt.abtnr`.
<!-- MUSTERLOESUNG-ENDE -->

**2.** Ihr habt in Kapitel 7 die Grundform einer Abfrage gelesen. Aus
welchen drei Teilen besteht sie, und was leistet jeder Teil?

<!-- MUSTERLOESUNG-START -->
??? note "Musterlösung anzeigen"
    `SELECT` bestimmt die Spalten der Ergebnistabelle, `FROM` legt fest,
    aus welchen Tabellen die Daten gelesen werden, und `WHERE` nennt die
    Bedingung, die eine Zeile erfüllen muss, um ins Ergebnis zu gehören.
    `WHERE` ist optional; fehlt es, gehören alle Zeilen zum Ergebnis.
<!-- MUSTERLOESUNG-ENDE -->

---

### Das Szenario: BestTec <span class="zeitangabe">ca. 4 Min.</span> { data-toc-label="Das Szenario: BestTec" }

> BestTec ist ein Unternehmen der Automatisierungstechnik, das
> Steuerungssysteme entwickelt und seinen Kunden auch Schulungen
> anbietet. Das Unternehmen ist in **Abteilungen** gegliedert, die an
> verschiedenen Standorten sitzen (Gütersloh, Verl, Paderborn,
> Bielefeld, Münster). Jeder **Mitarbeiter** gehört zu genau einer
> Abteilung, hat eine Tätigkeit, ein Grundgehalt und kann zusätzlich
> eine Provision bekommen. Die meisten Mitarbeiter haben einen
> direkten Vorgesetzten, der selbst Mitarbeiter ist. Abteilungen führen
> **Projekte** für Kunden durch; jedes Projekt wird von genau einer
> Abteilung verantwortet.

*(Fallbeispiel nach Lehrbrief, Anhang 9.2,
S. 97–98.)*

Das Relationenschema besteht aus drei Relationen:

**:octicons-table-16: Relation `abt`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | abtnr | int | nein |
| – | bezeichnung | string (eindeutig) | nein |
| – | sitz | string | nein |

**:octicons-table-16: Relation `ma`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | manr | int | nein |
| – | name | string | nein |
| – | job | string | nein |
| FK | vorgnr | int (verweist auf `ma`) | ja |
| – | gehalt | decimal | nein |
| – | prov | decimal | ja |
| FK | abtnr | int (verweist auf `abt`) | nein |

**:octicons-table-16: Relation `prj`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | prjnr | int | nein |
| FK | abtnr | int (verweist auf `abt`) | nein |
| – | kdnr | string | nein |
| – | titel | string | nein |

Der Datenbestand, mit dem wir heute arbeiten (`NULL` steht für „kein
Wert“):

| abtnr | bezeichnung | sitz |
|---|---|---|
| 10 | Zentrale | Gütersloh |
| 20 | Engineering | Verl |
| 30 | Automotive | Paderborn |
| 40 | Robotik | Bielefeld |
| 50 | Education | Münster |

| manr | name | job | vorgnr | gehalt | prov | abtnr |
|---|---|---|---|---|---|---|
| 7656 | Hansen | Geschäftsführer | NULL | 9800 | NULL | 10 |
| 7900 | Karl | Manager | 7656 | 7200 | NULL | 20 |
| 8801 | Langer | Vertrieb | 7656 | 4800 | 1200 | 10 |
| 7329 | Frohn | Programmierer | 7900 | 2900 | NULL | 20 |
| 8722 | Werther | Programmierer | 7900 | 2700 | NULL | 20 |
| 7643 | Kurt | Vertrieb | 8801 | 3100 | 900 | 10 |
| 7767 | John | Controller | 7656 | 4900 | NULL | 10 |
| 7783 | Kron | Manager | 7656 | 5200 | NULL | 50 |
| 8800 | Beier | Trainer | 7783 | 2700 | NULL | 50 |
| 7621 | Klaas | Trainer | 7783 | 3200 | NULL | 50 |
| 7768 | Schulte | Vertrieb | 8801 | 2900 | 500 | 10 |
| 7745 | Meier | Manager | 7656 | 5500 | NULL | 40 |
| 8956 | Dorn | Engineer | 7745 | 3000 | NULL | 40 |
| 7112 | Born | Manager | 7656 | 4800 | NULL | 30 |
| 8969 | Walter | Engineer | 7112 | 2500 | NULL | 30 |
| 8322 | Frei | Engineer | 7745 | 2500 | NULL | 40 |
| 7769 | Meyer | Engineer | 7900 | 5200 | NULL | 20 |
| 8659 | Sorge | Engineer | 7900 | 5800 | NULL | 20 |
| 8247 | Holle | Engineer | 7112 | 2900 | NULL | 30 |
| 7739 | Meier | Projektleiter | 7900 | 3200 | NULL | 20 |

| prjnr | abtnr | kdnr | titel |
|---|---|---|---|
| 232 | 20 | M341 | PeakControl |
| 244 | 10 | T56 | AutoRob |
| 212 | 20 | A12 | HydroControl |
| 256 | 20 | M341 | AvisyTurb |

Legt die Datenbank jetzt auf eurem Rechner an: Öffnet in SQL Server
Management Studio zuerst das Skript
[uebung-05-besttec-datenbank.sql](code/uebung-05-besttec-datenbank.sql)
und führt es aus, danach das Skript
[uebung-05-besttec-testdaten.sql](code/uebung-05-besttec-testdaten.sql).
Speichert die Dateien dafür vorher über „Link speichern unter…“.

---

### Spalten auswählen: Projektion <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Spalten auswählen: Projektion" }

#### Eine einfache Liste

Die Personalabteilung möchte eine Liste mit Name, Tätigkeit und
Grundgehalt aller Mitarbeiter — ohne Vorgesetzten, Provision und
Abteilung. Welche Angaben braucht die Datenbank, um das zu liefern?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-projektion-liste.sql"
    ```

    Die Datenbank muss wissen, **welche Spalten** das Ergebnis haben
    soll (`SELECT`) und **aus welcher Tabelle** sie stammen (`FROM`).
    Das Ergebnis hat 20 Zeilen, eine je Mitarbeiter. Wollt ihr alle
    Spalten, schreibt ihr `SELECT *` — das ist zum Ausprobieren
    praktisch, in echten Abfragen nennt man die gewünschten Spalten
    besser ausdrücklich. Jede Abfrage liefert wieder eine Tabelle
    (Relation) als Ergebnis.
<!-- MUSTERLOESUNG-ENDE -->

#### Rechnen und umbenennen

Die Geschäftsführung fragt nach dem Jahresgehalt jedes Mitarbeiters
(zwölf Monatsgehälter). In der Tabelle gibt es dafür keine Spalte. Muss
man die Tabelle erweitern?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-projektion-jahresgehalt.sql"
    ```

    Nein: In der Auswahlliste dürfen **Werteausdrücke** stehen, also
    Berechnungen mit Spalten und Zahlen. Mit `AS` bekommt die
    berechnete Spalte einen Namen. Die Berechnung gilt nur für das
    Ergebnis — in der Tabelle `ma` ändert sich nichts.
<!-- MUSTERLOESUNG-ENDE -->

#### Doppelte Werte entfernen

Welche Tätigkeiten kommen im Unternehmen überhaupt vor? Was passiert,
wenn man einfach nur die Spalte `job` abfragt?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-projektion-jobs.sql"
    ```

    Ohne `DISTINCT` steht jede Tätigkeit so oft im Ergebnis, wie es
    Mitarbeiter mit dieser Tätigkeit gibt (20 Zeilen). `DISTINCT`
    entfernt doppelte Ergebniszeilen — übrig bleiben die 8
    verschiedenen Tätigkeiten.
<!-- MUSTERLOESUNG-ENDE -->

---

### Zeilen auswählen: Selektion <span class="zeitangabe">ca. 7 Min.</span> { data-toc-label="Zeilen auswählen: Selektion" }

#### Vergleiche und Listen

Wer in den Abteilungen 10 oder 20 verdient mehr als 4000 €? Ausgegeben
werden sollen Name, Gehalt und Abteilungsnummer. Womit sagt ihr der
Datenbank, welche Zeilen ins Ergebnis gehören?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-selektion-gehalt.sql"
    ```

    Der `WHERE`-Teil enthält die Bedingung, die jede Zeile erfüllen
    muss. Hier sind zwei Bedingungen mit `AND` verknüpft: ein
    **Vergleich** (`gehalt > 4000`; weitere Operatoren sind `=`, `<>`,
    `<`, `<=` und `>=`) und eine **Liste** (`abtnr IN (10, 20)` ist
    die Kurzform für „Abteilung 10 oder Abteilung 20“). Ergebnis: 6
    Zeilen (Hansen, Langer, John, Karl, Meyer, Sorge).
<!-- MUSTERLOESUNG-ENDE -->

#### Muster in Texten

Welche Mitarbeiter der Abteilungen 20, 30 oder 40 haben einen Namen mit
genau vier Buchstaben, dessen zweiter Buchstabe ein „o“ ist? Wie
beschreibt man ein solches Muster in SQL?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-selektion-namen.sql"
    ```

    `LIKE` vergleicht einen Text mit einem Muster. Der Unterstrich
    `_` steht für **genau ein** beliebiges Zeichen, das Prozentzeichen
    `%` für **beliebig viele** (auch null) Zeichen. `'_o__'` passt also
    auf vierbuchstabige Namen mit „o“ an zweiter Stelle. Ergebnis:
    Born und Dorn. Textwerte stehen immer in einfachen Hochkommas.

    Noch eine Kurzform für Bereiche: `gehalt BETWEEN 2800 AND 3000`
    schließt beide Grenzen ein.
<!-- MUSTERLOESUNG-ENDE -->

---

### Bedingungen kombinieren <span class="zeitangabe">ca. 6 Min.</span> { data-toc-label="Bedingungen kombinieren" }

Gesucht sind die Mitarbeiter der Abteilungen 10 oder 20, die Manager
sind **oder** mehr als 5000 € verdienen. Formuliert die Bedingung
zuerst so, wie ihr den Satz sprecht, und sagt vorher: Wie viele Zeilen
erwartet ihr? Vergleicht dann mit dem tatsächlichen Ergebnis.

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-bedingungen.sql"
    ```

    Die erste Abfrage liefert **6 Zeilen** — darunter Meier (Abteilung
    40) und Kron (Abteilung 50), die gar nicht gemeint waren. Der
    Grund: `AND` bindet stärker als `OR`. Die Datenbank liest die
    Bedingung als „(Abteilung 10/20 **und** Manager) **oder** Gehalt
    über 5000“. Erst mit **Klammern** um die `OR`-Bedingung erhält man
    das gewünschte Ergebnis mit **4 Zeilen** (Hansen, Karl, Meyer,
    Sorge). Merkregel: Sobald `AND` und `OR` gemeinsam vorkommen,
    setzt man Klammern.
<!-- MUSTERLOESUNG-ENDE -->

---

### Sortieren <span class="zeitangabe">ca. 3 Min.</span> { data-toc-label="Sortieren" }

Die Geschäftsführung möchte eine Gehaltsliste: das höchste Gehalt
zuerst, bei gleichem Gehalt alphabetisch nach Name. Woran erkennt die
Datenbank, in welcher Reihenfolge sie die Zeilen liefern soll?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-sortieren.sql"
    ```

    Die Sortierung steht in `ORDER BY` am Ende der Abfrage.
    `ASC` (aufsteigend) ist der Standard, `DESC` kehrt die Richtung
    um. Mehrere Sortierkriterien werden durch Kommas getrennt; das
    zweite gilt nur bei Gleichstand beim ersten. Ohne `ORDER BY`
    garantiert die Datenbank keine bestimmte Reihenfolge — verlasst
    euch nie darauf, dass das Ergebnis „zufällig richtig“ sortiert ist.
<!-- MUSTERLOESUNG-ENDE -->

---

### Mehrere Tabellen: der Verbund <span class="zeitangabe">ca. 12 Min.</span> { data-toc-label="Mehrere Tabellen: der Verbund" }

#### Was passiert ohne Verknüpfung?

Gesucht ist für jedes Projekt die Bezeichnung der verantwortlichen
Abteilung. Die Tabelle `prj` kennt nur die Abteilungsnummer — die
Bezeichnung steht in `abt`. Schreibt einmal beide Tabellen in den
`FROM`-Teil, ohne weitere Bedingung. Wie viele Zeilen erwartet ihr?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-kreuzprodukt.sql"
    ```

    Die Datenbank kombiniert jede der 5 Abteilungen mit jedem der 4
    Projekte: **20 Zeilen**, von denen die meisten inhaltlich
    unsinnig sind (z. B. „Zentrale“ mit dem Projekt „PeakControl“,
    das zu Engineering gehört). Dieses Ergebnis heißt **Kreuzprodukt**.
    Bei `ma` und `abt` wären es schon 100 Zeilen.
<!-- MUSTERLOESUNG-ENDE -->

#### Zeilen über den Fremdschlüssel verknüpfen

Welche Bedingung sortiert die unsinnigen Kombinationen aus? Gesucht ist
dabei eine Liste mit Abteilungsnummer, Bezeichnung, Projekttitel und
Kundennummer, geordnet nach Abteilungsnummer.

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-verbund-projekte.sql"
    ```

    Zusammengehörig sind genau die Zeilen, in denen der
    **Fremdschlüssel** `prj.abtnr` gleich dem **Primärschlüssel**
    `abt.abtnr` ist. Diese Gleichheit steht als Verknüpfungsbedingung
    im `WHERE`-Teil — übrig bleiben 4 Zeilen. Weil `abtnr` in beiden
    Tabellen vorkommt, muss ein Spaltenname eindeutig angegeben werden;
    dafür vergibt man im `FROM`-Teil kurze **Aliase** (`x`, `y`).

    Die zweite Abfrage ist gleichwertig, nur mit der Schreibweise
    `INNER JOIN … ON`. Sie begegnet euch in KI-generierten Abfragen
    häufig, deshalb solltet ihr beide Formen lesen können.
<!-- MUSTERLOESUNG-ENDE -->

#### Eine Tabelle mit sich selbst verknüpfen

Wer sind die Untergebenen von Kron, und wie weit liegt ihr Gehalt unter
seinem? Gesucht sind Name, Tätigkeit, Gehalt und die Gehaltsdifferenz.
Vorgesetzter und Untergebener stehen beide in der Tabelle `ma` — wie
löst man das?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-05-selbstverbund.sql"
    ```

    Die Tabelle `ma` wird zweimal in den `FROM`-Teil aufgenommen, mit
    zwei verschiedenen Aliasen: `x` ist der Untergebene, `y` der
    Vorgesetzte. Verknüpft werden sie über `x.vorgnr = y.manr`. Das
    nennt man einen **Selbstverbund**. Ergebnis: Klaas (Differenz 2000)
    und Beier (Differenz 2500).

    Gleichwertig mit `INNER JOIN`: Die Verknüpfungsbedingung steht
    dann hinter `ON`, im `WHERE`-Teil bleibt nur die Auswahl von Kron.
<!-- MUSTERLOESUNG-ENDE -->

---

### Gesamtergebnis <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Gesamtergebnis" }

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    Jede Abfrage, die ihr heute geschrieben habt, folgt diesem Gerüst:

    ```sql
    SELECT [DISTINCT] Spalten oder Ausdrücke
    FROM Tabellen
    WHERE Bedingungen
    ORDER BY Sortierkriterien;
    ```

    | Die Frage lautet … | … also brauche ich |
    |---|---|
    | Welche Spalten soll das Ergebnis haben? | `SELECT` (mit `AS` und `DISTINCT`) |
    | Aus welchen Tabellen kommen die Daten? | `FROM` (bei mehreren Tabellen mit Aliasen) |
    | Welche Zeilen gehören ins Ergebnis? | `WHERE` (Vergleich, `IN`, `LIKE`, `BETWEEN`, `AND`/`OR`/`NOT`) |
    | Wie hängen die Tabellen zusammen? | Verknüpfungsbedingung: Fremdschlüssel = Primärschlüssel |
    | In welcher Reihenfolge soll das Ergebnis stehen? | `ORDER BY` |

    Die Datenbank arbeitet dabei gedanklich von innen nach außen: Sie
    bildet zuerst die Tabellen aus `FROM`, wählt dann mit `WHERE` die
    passenden Zeilen aus, berechnet danach die Spalten aus `SELECT` und
    sortiert zuletzt. Gruppierung und Unteranfragen kommen als Nächstes
    dazu.
<!-- MUSTERLOESUNG-ENDE -->

---

## Betreutes Selbststudium { .modus-selbststudium }

### Worum geht es?

Jetzt wendet ihr die Syntax selbstständig an: zuerst beim Filtern und
Sortieren, dann beim Verbund. Anschließend dreht sich der Blick um —
ihr bekommt fertige Abfragen, sagt ihr Ergebnis vorher und entscheidet,
welche Abfrage zu einer Anforderung passt.

Warum schreibt ihr die Abfragen überhaupt selbst? Ihr schreibt in diesem
Kurs später nicht regelmäßig eigene SQL-Skripte. Das Schreiben ist hier
ein Teil des **Lernwegs**: Wer jede Klausel einmal selbst benutzt hat,
versteht, was ein fremdes Statement — zum Beispiel eines, das eine KI
erstellt hat — wirklich aussagt, und kann beurteilen, ob es zur
Anforderung passt. Darum geht es in diesem Block. KI-Werkzeuge nutzt ihr
dafür bewusst noch nicht.

!!! abstract "Lernziele"
    - Ihr könnt Abfragen mit Projektion, Selektion, Sortierung und
      Verbund selbstständig formulieren und ihr Ergebnis auf
      Plausibilität prüfen.
    - Ihr könnt das Ergebnis einer fremden Abfrage von Hand
      herleiten.
    - Ihr könnt aus mehreren ähnlichen Abfragen die passende auswählen
      und typische Fehlerbilder benennen.

### Aufgabe 05: BestTec-Abfragen anwenden und bewerten

??? info "Bezug zu Lehrinhalten"
    Die Übung oben und Lehrbrief Kapitel 7 (7.1–7.5). Die Datenbank
    `BestTec` habt ihr in der Übung angelegt. <br>
    SQL-Server-Besonderheiten: [SQL Server und Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md). <br>
    Typische Fehlerbilder: [Fehlerbildkatalog](../../info/fehlerbildkatalog.md). <br>
    KI-Einsatz gem. [KI-Nutzungsrichtlinie](../../03-ki-erweiterungsaufgaben/ki-nutzungsrichtlinie.md):
    In dieser Aufgabe bearbeitet ihr alle Teile ohne KI.

Alle Abfragen beziehen sich auf die Datenbank `BestTec` aus der Übung.
Bei den Teilen A und B steht jeweils die Zeilenzahl dabei, mit der ihr
euer Ergebnis kontrollieren könnt.

#### Teil A — Zeilen filtern und sortieren <span class="zeitangabe">ca. 10 Min.</span> { data-toc-label="Teil A — Zeilen filtern und sortieren" }

1. Gesucht sind alle Mitarbeiter, die einem von zwei Profilen
   entsprechen: *Entweder* ist das Grundgehalt kleiner als 5000 und die
   Tätigkeit weder Programmierer noch Administrator, *oder* die
   Tätigkeit ist Controller oder Trainer. Ausgabe: Name,
   Abteilungsnummer, Tätigkeit, Gehalt. (Aufgabe nach Lehrbrief,
   Kap. 7.10, Nr. 4, S. 88; Kontrolle: 12 Zeilen)
2. Welche Mitarbeiter verdienen zwischen 2800 und 3000 € (einschließlich
   der Grenzen)? Ausgabe: Name und Gehalt, das höchste Gehalt zuerst,
   bei Gleichstand alphabetisch nach Name. (Kontrolle: 4 Zeilen)
3. Welche Mitarbeiter haben einen Namen, der mit „M“ beginnt, und sind
   keine Manager? Ausgabe: Name, Tätigkeit, Abteilungsnummer.
   (Kontrolle: 2 Zeilen)
4. Wie hoch ist das Jahresgehalt (zwölf Monatsgehälter) der
   Mitarbeiter der Abteilung 30? Ausgabe: Name und Jahresgehalt, das
   höchste zuerst. (Kontrolle: 3 Zeilen)

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil A anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-05-besttec-teil-a.sql"
    ```

    **Zu 1:** Die beiden Profile sind zwei Bedingungen, die mit `OR`
    verbunden werden; die Klammern um das erste Profil machen die
    Struktur sichtbar. Die Bedingung `NOT IN` mit „Administrator“
    schadet nicht, obwohl es diese Tätigkeit nicht gibt.

    **Zu 2:** `BETWEEN` schließt beide Grenzen ein. Frohn, Schulte und
    Holle verdienen gleich viel (2900) — das zweite Sortierkriterium
    entscheidet über ihre Reihenfolge.

    **Zu 3:** Der zweite Meier (Abteilung 40) ist Manager und fällt
    heraus; es bleiben Meier (Projektleiter) und Meyer.

    **Zu 4:** Der Alias `jahresgehalt` darf in `ORDER BY` verwendet
    werden.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil B — Über mehrere Tabellen abfragen <span class="zeitangabe">ca. 12 Min.</span> { data-toc-label="Teil B — Über mehrere Tabellen abfragen" }

1. Welche Projekte finden in der Abteilung von Mitarbeiter 7739 statt?
   Ausgabe: Abteilungsnummer, Bezeichnung, Titel, Kundennummer.
   (Lehrbrief, Nr. 7, S. 88; Kontrolle: 3 Zeilen)
2. Welche Projekte gehören zu Abteilungen, in denen es Mitarbeiter
   gibt, die Engineer oder Programmierer sind? Ausgabe wie bei 1. Wie
   viele Zeilen entstehen, wenn ihr `DISTINCT` weglasst — und warum?
   (Lehrbrief, Nr. 8, S. 88; Kontrolle mit `DISTINCT`: 3 Zeilen)
3. Welche Mitarbeiter arbeiten in Abteilungen mit Sitz in Verl oder
   Münster? Ausgabe: Name, Bezeichnung der Abteilung und Sitz,
   sortiert nach Sitz und Name. (Kontrolle: 9 Zeilen)
4. Welche Mitarbeiter arbeiten in Abteilungen, die ein Projekt für den
   Kunden „M341“ durchführen? Ausgabe: Name und Tätigkeit, jeder
   Mitarbeiter nur einmal. (Kontrolle: 6 Zeilen)

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil B anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-05-besttec-teil-b.sql"
    ```

    **Zu 1:** Hier werden drei Tabellen verknüpft, also braucht es
    zwei Verknüpfungsbedingungen (Mitarbeiter–Abteilung und
    Abteilung–Projekt). Faustregel: *n* Tabellen, *n − 1*
    Verknüpfungen.

    **Zu 2:** Ohne `DISTINCT` entstehen **12 Zeilen**: Abteilung 20
    hat vier Mitarbeiter mit passender Tätigkeit (Frohn, Werther,
    Meyer, Sorge) und drei Projekte, und der Verbund erzeugt jede
    Kombination. Das ist ein typisches Fehlerbild (F2 im
    Fehlerbildkatalog).

    **Zu 3:** Die Sortierung nach `a.sitz` und `m.name` kann sich auf
    Spalten beider Tabellen beziehen.

    **Zu 4:** Beide M341-Projekte (232 und 256) gehören zu Abteilung 20.
    Ohne `DISTINCT` stünde jeder der sechs Mitarbeiter zweimal im
    Ergebnis.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil C — Ergebnis vorhersagen <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Teil C — Ergebnis vorhersagen" }

Leitet das Ergebnis jeweils
zuerst von Hand aus den Tabellen im Szenario oben her, bevor ihr die
Aussagen lest. Genau eine Aussage ist korrekt. Prüft euer Ergebnis erst
danach in SQL Server.

**Abfrage 1**

```sql
SELECT x.name, x.gehalt, y.name AS chef, y.gehalt AS chefgehalt
FROM ma x, ma y
WHERE x.vorgnr = y.manr AND x.gehalt > y.gehalt;
```

Welche Aussage über das Ergebnis stimmt?

- a) Hansen erscheint, weil er das höchste Gehalt hat.
- b) Es erscheinen alle 19 Mitarbeiter, die einen Vorgesetzten haben.
- c) Das Ergebnis ist leer.
- d) SQL Server meldet einen Fehler, weil `ma` zweimal im `FROM`-Teil steht.
- e) Meyer und Sorge erscheinen, weil sie mehr als 5000 € verdienen.

**Abfrage 2**

```sql
SELECT a.bezeichnung, p.titel
FROM abt a, prj p
WHERE a.abtnr = 20;
```

Welche Aussage über das Ergebnis stimmt?

- a) 3 Zeilen: die drei Projekte der Abteilung Engineering.
- b) 4 Zeilen: Engineering, kombiniert mit allen vier Projekten.
- c) 20 Zeilen: alle Abteilungen mit allen Projekten.
- d) 1 Zeile: Engineering mit dem ersten Projekt.
- e) Eine Fehlermeldung, weil die Verknüpfungsbedingung fehlt.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil C anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-05-besttec-teil-c.sql"
    ```

    **Abfrage 1 — richtig ist c).** Niemand verdient mehr als sein
    direkter Vorgesetzter (z. B. Meyer 5200 und Sorge 5800 bei Karl
    mit 7200), also bleibt die Gehaltsbedingung für keine Zeile
    erfüllt. Ein leeres Ergebnis ist hier ein korrektes Ergebnis.

    - a) falsch: Hansen hat keinen Vorgesetzten (`vorgnr` ist `NULL`)
      und fällt schon beim Verbund heraus.
    - b) falsch: Das wäre das Ergebnis ohne die Gehaltsbedingung
      (siehe Gegenprobe im Skript).
    - d) falsch: Mit zwei verschiedenen Aliasen darf dieselbe Tabelle
      mehrfach im `FROM`-Teil stehen.
    - e) falsch: Eine Grenze von 5000 € kommt in der Abfrage nicht vor;
      verglichen wird mit dem Gehalt des Vorgesetzten.

    **Abfrage 2 — richtig ist b).** Die Bedingung `a.abtnr = 20` wählt
    nur Zeilen aus `abt` aus (genau eine: Engineering); eine
    Verknüpfung mit `prj` fehlt. Deshalb wird diese eine Zeile mit allen
    vier Projekten kombiniert, auch mit dem Projekt AutoRob der
    Zentrale. Das ist das Fehlerbild F1 im Fehlerbildkatalog.

    - a) wäre das Ergebnis mit der Bedingung `a.abtnr = p.abtnr`.
    - c) wäre das Ergebnis ganz ohne `WHERE`.
    - d) falsch: Es gibt keinen Grund, nur das erste Projekt zu liefern.
    - e) falsch: SQL Server prüft die Syntax, nicht den Sinn der
      Abfrage. Eine fehlende Verknüpfung bemerkt die Datenbank nicht.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil D — Die richtige Abfrage erkennen <span class="zeitangabe">ca. 12 Min.</span> { data-toc-label="Teil D — Die richtige Abfrage erkennen" }

Gesucht sind Name und Abteilungsbezeichnung aller Mitarbeiter, die in
einer Abteilung mit Sitz in **Verl oder Paderborn** arbeiten und
**keine Engineers** sind. Fünf Abfragen sehen ähnlich aus, genau eine
ist korrekt:

```sql
-- a)
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz IN ('Verl', 'Paderborn')
  AND m.job <> 'Engineer';

-- b)
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE a.sitz IN ('Verl', 'Paderborn')
  AND m.job <> 'Engineer';

-- c)
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz = 'Verl' OR a.sitz = 'Paderborn'
  AND m.job <> 'Engineer';

-- d)
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz IN ('Verl', 'Paderborn')
  AND m.job = 'Engineer';

-- e)
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz = 'Verl' AND a.sitz = 'Paderborn'
  AND m.job <> 'Engineer';
```

1. Leitet zuerst von Hand her: Welche Mitarbeiter gehören ins
   gewünschte Ergebnis?
2. Welche der fünf Abfragen liefert genau dieses Ergebnis?
3. Bei den übrigen vier: Was ist jeweils falsch? Ordnet jede einem
   Eintrag im [Fehlerbildkatalog](../../info/fehlerbildkatalog.md) zu
   und sagt vorher, was sie stattdessen liefert.
4. Führt zur Kontrolle alle fünf Abfragen aus.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil D anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-05-besttec-teil-d.sql"
    ```

    Verl ist die Abteilung Engineering (Karl, Frohn, Werther, Meyer,
    Sorge, Meier), Paderborn ist Automotive (Born, Walter, Holle).
    Ohne die Engineers (Meyer, Sorge, Walter, Holle) bleiben **5
    Mitarbeiter**: Karl, Frohn, Werther, Meier und Born. Richtig ist
    **a)**.

    | Abfrage | Fehler | Fehlerbild | Ergebnis |
    |---|---|---|---|
    | b) | Verknüpfung `m.abtnr = a.abtnr` fehlt | F1 | 28 Zeilen: jeder Nicht-Engineer (14) mit beiden Abteilungen (2) |
    | c) | `AND` bindet stärker als `OR`: gelesen als „(Verknüpfung und Verl) oder (Paderborn und kein Engineer)“ | F3 | 20 Zeilen: alle 6 Mitarbeiter aus Verl (auch die Engineers) plus Paderborn ohne Verknüpfung |
    | d) | `=` statt `<>`: es werden genau die Engineers geliefert | F4 | 4 Zeilen: Meyer, Sorge, Walter, Holle |
    | e) | Ein Sitz kann nicht gleichzeitig Verl und Paderborn sein | F5 | leer |
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil E — Zum Mitnehmen <span class="zeitangabe">ca. 3 Min.</span> { data-toc-label="Teil E — Zum Mitnehmen" }

Ihr bekommt später Abfragen zu sehen, die jemand anderes geschrieben
hat. Notiert drei Prüfpunkte, mit denen ihr in der ersten Minute
einschätzt, ob eine Abfrage zur Anforderung passt.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil E anzeigen"
    Mögliche Prüfpunkte:

    - **Tabellen und Verknüpfungen zählen:** Gibt es für *n* Tabellen im
      `FROM`-Teil mindestens *n − 1* Verknüpfungsbedingungen?
    - **`AND` und `OR` prüfen:** Wo beide gemeinsam vorkommen, müssen
      Klammern zur Absicht passen.
    - **Ergebnis plausibilisieren:** Passt die Zeilenzahl ungefähr? Sind
      Duplikate möglich? Stimmt mindestens eine Zeile, wenn ihr sie von
      Hand nachrechnet?
<!-- MUSTERLOESUNG-ENDE -->
