<!--
Dozenten-Skript (Zettel für die Übung) zu docs/02-theoriephase/termin-03/block-05.md.
Wird NICHT von MkDocs veröffentlicht (exclude_docs) und das PDF nicht versioniert.
Bauen: docs/02-theoriephase/_skript-werkzeuge/build-skripte.ps1
Box-Typen: aufgabe | loesung | hinweis | warnung | ergaenzung | bs
Code-Musterlösungen werden per "--8<-- "pfad"" aus docs/ eingelesen (Filter).
-->

```{=latex}
{\Large\bfseries\color{cUebung} Termin 3, Block 05 -- Übung: SQL-Abfragen mit BestTec}\hfill{\color{black!65}45 Min.}\par
\vspace{-2pt}{\color{cUebung}\rule{\linewidth}{1.6pt}}\par\vspace{2pt}
{\small\textbf{Fallstudie:} BestTec (Lehrbrief Anhang 9.2, S. 97--98) \quad|\quad \textbf{KI-Einsatz:} keiner \quad|\quad \textbf{Werkzeug:} SSMS, SQL Server 2025 Express (T-SQL)}
```

::: hinweis
**Ziel:** Aus einer fachlichen Frage eine SELECT-Abfrage ableiten
(Projektion, Selektion, Sortierung, Verbund) und das Ergebnis von Hand
herleiten. Vorgehen immer gleich: **Frage an die Daten → was braucht die
Datenbank? → Syntax ableiten → ausführen → Stolpersteine.**
:::

| Phase | Zeit |
|:--------------------------------------------|----------:|
| Kurzer Rückblick (2 Fragen)                  | 3 Min.  |
| Szenario BestTec (+ Datenbank anlegen)       | 4 Min.  |
| Spalten auswählen: Projektion                | 5 Min.  |
| Zeilen auswählen: Selektion                  | 7 Min.  |
| Bedingungen kombinieren                      | 6 Min.  |
| Sortieren                                    | 3 Min.  |
| Mehrere Tabellen: der Verbund                | 12 Min. |
| Gesamtergebnis                               | 2 Min.  |

::: warnung
**Vor Beginn:** Studierende legen die Datenbank selbst an --
`uebung-05-besttec-datenbank.sql`, danach `uebung-05-besttec-testdaten.sql`
(Code-Ordner Termin 3, "Link speichern unter ..."). **Dialektabweichungen**
(T-SQL ↔ Lehrbrief): Seite "SQL Server und Lehrbrief: Abweichungen" im
Info-Bereich.
:::

# Kurzer Rückblick [ca. 3 Min.]{.zeit}

::: aufgabe
**Frage 1:** Wozu dient ein Fremdschlüssel, und woran erkennt ihr im
Relationenschema, welche Tabellen zusammenhängen?
:::

::: loesung
FK verweist auf den **PK einer anderen Relation** und bildet die
Beziehung ab; im Schema als "FK" gekennzeichnet. In BestTec: `ma.abtnr`
und `prj.abtnr` → `abt.abtnr`.
:::

::: aufgabe
**Frage 2:** Aus welchen drei Teilen besteht die Grundform einer
Abfrage (Kap. 7), was leistet jeder?
:::

::: loesung
`SELECT` = Spalten der Ergebnistabelle · `FROM` = aus welchen Tabellen ·
`WHERE` = Bedingung, die eine Zeile erfüllen muss (optional; fehlt es:
alle Zeilen).
:::

# Das Szenario: BestTec [ca. 4 Min.]{.zeit}

Automatisierungstechnik-Unternehmen (Steuerungssysteme + Schulungen),
*(Lehrbrief Anhang 9.2, S. 97--98)*:

- **Abteilungen** an 5 Standorten (Gütersloh, Verl, Paderborn, Bielefeld, Münster)
- **Mitarbeiter:** genau 1 Abteilung, Tätigkeit, Grundgehalt, optional Provision; meist ein direkter Vorgesetzter (selbst Mitarbeiter)
- **Projekte** für Kunden; je Projekt genau 1 verantwortliche Abteilung

| Relation | Attribute (PK fett, FK kursiv) |
|:------|:--------------------------------------------------------|
| `abt` | **abtnr**, bezeichnung (eindeutig), sitz |
| `ma` | **manr**, name, job, *vorgnr* (FK→`ma`, optional), gehalt, prov (optional), *abtnr* (FK→`abt`) |
| `prj` | **prjnr**, *abtnr* (FK→`abt`), kdnr, titel |

```{=latex}
\clearpage
```

# Referenz: BestTec-Datenbestand

Zum Mitlesen beim Herleiten von Hand (`NULL` = kein Wert). Entspricht der
Seite "BestTec: Datenbestand" (Lehrbrief S. 98).

| abtnr | bezeichnung | sitz |
|---:|:------------|:----------|
| 10 | Zentrale | Gütersloh |
| 20 | Engineering | Verl |
| 30 | Automotive | Paderborn |
| 40 | Robotik | Bielefeld |
| 50 | Education | Münster |

| manr | name | job | vorgnr | gehalt | prov | abtnr |
|---:|:--------|:----------------|-----:|-----:|-----:|----:|
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
|---:|---:|:-----|:-----------|
| 232 | 20 | M341 | PeakControl |
| 244 | 10 | T56 | AutoRob |
| 212 | 20 | A12 | HydroControl |
| 256 | 20 | M341 | AvisyTurb |

```{=latex}
\clearpage
```

# Spalten auswählen: Projektion [ca. 5 Min.]{.zeit}

## Eine einfache Liste

::: aufgabe
Personalabteilung will eine Liste mit **Name, Tätigkeit, Grundgehalt**
aller Mitarbeiter -- ohne Vorgesetzten, Provision, Abteilung. Welche
Angaben braucht die Datenbank dafür?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-projektion-liste.sql"
```

Datenbank muss wissen: **welche Spalten** (`SELECT`) und **aus welcher
Tabelle** (`FROM`). Ergebnis: **20 Zeilen**. Alle Spalten: `SELECT *`
(zum Ausprobieren; in echten Abfragen Spalten nennen). Jede Abfrage
liefert wieder eine **Tabelle (Relation)**.
:::

## Rechnen und umbenennen

::: aufgabe
Geschäftsführung will das **Jahresgehalt** (12 Monatsgehälter). Es gibt
keine Spalte dafür -- muss man die Tabelle erweitern?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-projektion-jahresgehalt.sql"
```

**Nein:** In der Auswahlliste dürfen **Werteausdrücke** stehen; `AS`
vergibt einen Namen. Berechnung gilt nur fürs Ergebnis, `ma` bleibt
unverändert.
:::

## Doppelte Werte entfernen

::: aufgabe
Welche **Tätigkeiten** kommen im Unternehmen vor? Was passiert, wenn man
nur `job` abfragt?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-projektion-jobs.sql"
```

Ohne `DISTINCT`: jede Tätigkeit so oft wie Mitarbeiter (**20 Zeilen**).
`DISTINCT` entfernt doppelte Ergebniszeilen → **8** verschiedene
Tätigkeiten.
:::

# Zeilen auswählen: Selektion [ca. 7 Min.]{.zeit}

## Vergleiche und Listen

::: aufgabe
Wer in den Abteilungen **10 oder 20** verdient **mehr als 4000 €**?
Ausgabe: Name, Gehalt, Abteilungsnummer. Womit sagt man der Datenbank,
welche Zeilen ins Ergebnis gehören?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-selektion-gehalt.sql"
```

- **Liste:** `abtnr IN (10, 20)` = Kurzform für "10 oder 20".
- **Vergleich:** `=`, `<>`, `<`, `<=`, `>=`; beide Bedingungen mit `AND`
  im `WHERE`-Teil.

Ergebnis: **6 Zeilen** (Hansen, Langer, John, Karl, Meyer, Sorge).
:::

## Muster in Texten

::: aufgabe
Welche Mitarbeiter der Abteilungen **20, 30 oder 40** haben einen Namen
mit **genau vier Buchstaben**, dessen **zweiter Buchstabe „o"** ist? Wie
beschreibt man das Muster in SQL?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-selektion-namen.sql"
```

`LIKE` vergleicht Text mit Muster: `_` = **genau ein** Zeichen, `%` =
**beliebig viele** (auch null). `'_o__'` → Ergebnis: **Born, Dorn**.
Textwerte immer in einfachen Hochkommas. Bereiche: `gehalt BETWEEN 2800
AND 3000` schließt **beide Grenzen** ein.
:::

# Bedingungen kombinieren [ca. 6 Min.]{.zeit}

::: aufgabe
Gesucht: Mitarbeiter der Abteilungen **10 oder 20**, die **Manager sind
oder mehr als 5000 €** verdienen. Bedingung zuerst **so formulieren, wie
man den Satz spricht**; **vorher sagen**: wie viele Zeilen? Dann
vergleichen.
:::

::: ergaenzung
**Whiteboard: Wie liest die Datenbank die Bedingung?** (`AND` vor `OR`)

| Geschrieben | Gelesen als |
|:----------------------------------------|:---------------------------------------|
| `A AND B OR C` | `(A AND B) OR C` |
| `A AND (B OR C)` | wie gemeint: A muss immer gelten |

mit **A** = `abtnr IN (10, 20)`, **B** = `job = 'Manager'`,
**C** = `gehalt > 5000`.
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-bedingungen.sql"
```

Erste Abfrage: **6 Zeilen**, darunter Meier (Abt. 40) und Kron (Abt. 50),
die gar nicht gemeint waren: `AND` bindet stärker als `OR` → gelesen als
"(Abt. 10/20 **und** Manager) **oder** Gehalt > 5000". Mit **Klammern**:
**4 Zeilen** (Hansen, Karl, Meyer, Sorge).
:::

::: warnung
**Merkregel:** Sobald `AND` und `OR` gemeinsam vorkommen → **Klammern
setzen** (Fehlerbild F3).
:::

# Sortieren [ca. 3 Min.]{.zeit}

::: aufgabe
Gehaltsliste: **höchstes Gehalt zuerst, bei Gleichstand alphabetisch nach
Name.** Woran erkennt die Datenbank die Reihenfolge?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-sortieren.sql"
```

`ORDER BY` am **Ende** der Abfrage; `ASC` (Standard) / `DESC`; mehrere
Kriterien mit Komma, das zweite gilt nur bei Gleichstand beim ersten.
:::

::: warnung
Ohne `ORDER BY` **keine garantierte Reihenfolge** -- sich nie darauf
verlassen, dass ein Ergebnis "zufällig richtig" sortiert ist.
:::

# Mehrere Tabellen: der Verbund [ca. 12 Min.]{.zeit}

## Was passiert ohne Verknüpfung?

::: aufgabe
Für jedes Projekt die **Bezeichnung der verantwortlichen Abteilung**
(`prj` kennt nur die Nummer, die Bezeichnung steht in `abt`). Beide
Tabellen in den `FROM`-Teil, **ohne weitere Bedingung** -- wie viele
Zeilen erwartet ihr?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-kreuzprodukt.sql"
```

Jede der 5 Abteilungen mit jedem der 4 Projekte: **20 Zeilen**, die
meisten unsinnig (z. B. "Zentrale" mit "PeakControl", das zu Engineering
gehört). Heißt **Kreuzprodukt**. Bei `ma` × `abt` wären es 100 Zeilen.
:::

::: ergaenzung
**Whiteboard: Kreuzprodukt und Verknüpfung.** Alle 5 × 4 Kombinationen;
nur die mit **gleicher Abteilungsnummer** (**x**) bleiben:

| `abt` ↓ / `prj` → | 232 (Abt. 20) | 244 (Abt. 10) | 212 (Abt. 20) | 256 (Abt. 20) |
|:----------------|:-:|:-:|:-:|:-:|
| 10 Zentrale | | **x** | | |
| 20 Engineering | **x** | | **x** | **x** |
| 30 Automotive | | | | |
| 40 Robotik | | | | |
| 50 Education | | | | |

→ **4** Treffer von 20 Kombinationen. Abteilungen 30/40/50 haben **kein**
Projekt und fallen im Verbund heraus (Fehlerbild F11, später).
:::

## Zeilen über den Fremdschlüssel verknüpfen

::: aufgabe
Welche Bedingung sortiert die unsinnigen Kombinationen aus? Gesucht:
Abteilungsnummer, Bezeichnung, Projekttitel, Kundennummer, geordnet nach
Abteilungsnummer.
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-verbund-projekte.sql"
```

- `abtnr` kommt in **beiden** Tabellen vor → Spalte eindeutig angeben,
  dafür kurze **Aliase** (`x`, `y`) im `FROM`-Teil.
- Zusammengehörig: **Fremdschlüssel = Primärschlüssel**
  (`prj.abtnr = abt.abtnr`) als Verknüpfungsbedingung im `WHERE`-Teil →
  **4 Zeilen**.
- Zweite Abfrage gleichwertig mit **`INNER JOIN ... ON`** -- die
  Schreibweise liefert KI meist; beide Formen lesen können.
:::

## Eine Tabelle mit sich selbst verknüpfen

::: aufgabe
Wer sind die **Untergebenen von Kron**, und wie weit liegt ihr Gehalt
unter seinem? Ausgabe: Name, Tätigkeit, Gehalt, Gehaltsdifferenz.
Vorgesetzter und Untergebener stehen beide in `ma` -- wie löst man das?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-05-selbstverbund.sql"
```

- `ma` **zweimal** im `FROM`-Teil mit zwei Aliasen: `x` = Untergebener,
  `y` = Vorgesetzter.
- Verknüpfung `x.vorgnr = y.manr` = **Selbstverbund**. Ergebnis: **Klaas**
  (Differenz 2000), **Beier** (2500).
- `INNER JOIN`: Bedingung hinter `ON`, im `WHERE` bleibt nur die Auswahl
  von Kron.
:::

# Gesamtergebnis [ca. 2 Min.]{.zeit}

::: loesung
Jede Abfrage folgt diesem Gerüst:

```sql
SELECT [DISTINCT] Spalten oder Ausdrücke
FROM Tabellen
WHERE Bedingungen
ORDER BY Sortierkriterien;
```

| Die Frage lautet ... | ... also brauche ich |
|:-------------------------------|:------------------------------------|
| Welche Spalten soll das Ergebnis haben? | `SELECT` (mit `AS` und `DISTINCT`) |
| Aus welchen Tabellen kommen die Daten? | `FROM` (mehrere Tabellen: Aliase) |
| Welche Zeilen gehören ins Ergebnis? | `WHERE` (Vergleich, `IN`, `LIKE`, `BETWEEN`, `AND`/`OR`/`NOT`) |
| Wie hängen die Tabellen zusammen? | Verknüpfung: Fremdschlüssel = Primärschlüssel |
| In welcher Reihenfolge? | `ORDER BY` |

**Gedankliche Reihenfolge der Datenbank:** `FROM` (Tabellen bilden) →
`WHERE` (Zeilen auswählen) → `SELECT` (Spalten berechnen) → `ORDER BY`.
Als Nächstes: Gruppierung und Unteranfragen.
:::

```{=latex}
\clearpage
```

::::: bs
**Betreutes Selbststudium (45 Min.): Aufgabe 05 -- BestTec-Abfragen
anwenden und bewerten.** **Ohne KI.** Einzeln oder zu zweit auf
`BestTec`; Zeilenzahlen zur Kontrolle stehen bei A und B dabei.
*Warum selbst schreiben?* Das Schreiben ist Teil des **Lernwegs** -- wer
jede Klausel einmal benutzt hat, kann fremde (KI-)Statements verstehen und
gegen die Anforderung bewerten.

| Teil | Auftrag | Kernpunkt der Lösung |
|:-----|:------------------------------|:-----------------------------|
| **A** ca. 10 Min. Filtern/Sortieren | (1) Profil "Gehalt < 5000 und weder Programmierer noch Administrator" **oder** Controller/Trainer (12 Z.); (2) Gehalt 2800--3000, absteigend, dann Name (4); (3) Name mit "M" und kein Manager (2); (4) Jahresgehalt Abt. 30 (3) | (1) zwei Profile mit `OR`, Klammern; (2) `BETWEEN` schließt Grenzen ein, 2. Sortierkriterium bei Gleichstand (2900); (3) zweiter Meier ist Manager; (4) Alias in `ORDER BY` erlaubt |
| **B** ca. 12 Min. Verbund | (1) Projekte der Abteilung von MA 7739 (3 Z.); (2) Projekte von Abt. mit Engineer/Programmierer, mit und ohne `DISTINCT` (3); (3) MA in Abt. mit Sitz Verl/Münster (9); (4) MA in Abt. mit Projekt für Kunde M341, jeder einmal (6) | (1) 3 Tabellen → **2** Verknüpfungen (*n* Tabellen, *n*−1); (2) ohne `DISTINCT` **12** Zeilen (4 MA × 3 Projekte, F2); (3) Sortierung über Spalten beider Tabellen; (4) `DISTINCT`, sonst jeder MA doppelt |
| **C** ca. 8 Min. Vorhersage | Zu 2 fertigen Abfragen: Ziel erkennen und tatsächliches Ergebnis von Hand herleiten (Quiz), erst danach ausführen | **1:** Selbstverbund -- "mehr als direkter Vorgesetzter"; Ergebnis **leer** (korrektes Ergebnis!). **2:** Ziel "Projekte Abt. 20"; liefert **4 Zeilen** (Verknüpfung fehlt, F1) |
| **D** ca. 12 Min. Erkennen | 5 ähnliche Abfragen a)--e): Wer ist in Verl/Paderborn und kein Engineer? Hand-Herleitung, richtige finden, Fehler der anderen dem Fehlerbildkatalog zuordnen, Ergebnis vorhersagen | Erwartung **5** MA (Karl, Frohn, Werther, Meier, Born); **a)** korrekt. b) Verknüpfung fehlt (F1, 28 Z.); c) `AND`/`OR` ohne Klammern (F3, 20 Z.); d) `=` statt `<>` (F4, 4 Z.); e) Sitz Verl **und** Paderborn (F5, leer) |

::: hinweis
Musterlösungen: `aufg-05-besttec-teil-a.sql`, `-teil-b.sql`, `-teil-d.sql`
(Code-Ordner Termin 3). Fehlerbilder F1--F5: Seite "Fehlerbildkatalog"
im Info-Bereich.
:::

::: warnung
**Moderation:** Betonen, dass **Herleiten von Hand vor Ausführen** der
Kern ist (Vorbereitung für KI-Bewertung in Block 06). Teil C: "leeres
Ergebnis" ist kein Fehler.
:::
:::::
