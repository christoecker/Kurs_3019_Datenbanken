<!--
Dozenten-Skript (Zettel für die Übung) zu docs/02-theoriephase/termin-03/block-06.md.
Wird NICHT von MkDocs veröffentlicht (exclude_docs) und das PDF nicht versioniert.
Bauen: docs/02-theoriephase/_skript-werkzeuge/build-skripte.ps1
Box-Typen: aufgabe | loesung | hinweis | warnung | ergaenzung | bs
Code-Musterlösungen werden per "--8<-- "pfad"" aus docs/ eingelesen (Filter).
-->

```{=latex}
{\Large\bfseries\color{cUebung} Termin 3, Block 06 -- Übung: Eigene Abfragen und Datenänderung}\hfill{\color{black!65}45 Min.}\par
\vspace{-2pt}{\color{cUebung}\rule{\linewidth}{1.6pt}}\par\vspace{2pt}
{\small\textbf{Fallstudie:} BestTec (Lehrbrief Anhang 9.2, S. 97--98) \quad|\quad \textbf{KI-Einsatz:} Stufe 2 (im bS) \quad|\quad \textbf{Werkzeug:} SSMS, SQL Server 2025 Express (T-SQL)}
```

::: hinweis
**Ziel:** Daten zusammenfassen (`GROUP BY`, `HAVING`), mit `NULL` und
Unteranfragen umgehen, Daten ändern (`INSERT`/`UPDATE`/`DELETE`).
Zwischendurch fertige Statements **beurteilen**: Nicht jedes erfüllt die
Anforderung.
:::

| Phase | Zeit |
|:--------------------------------------------|----------:|
| Ausgangslage BestTec                         | 2 Min.  |
| Daten zusammenfassen und gruppieren          | 8 Min.  |
| Gruppen auswählen: HAVING                    | 5 Min.  |
| Der Umgang mit NULL                          | 6 Min.  |
| Unteranfragen lesen                          | 5 Min.  |
| Daten ändern                                 | 10 Min. |
| Gesamtergebnis                               | 2 Min.  |

::: warnung
**Datenbank wird verändert!** Nach den Änderungs-Beispielen (insbesondere
`UPDATE` ohne `WHERE`) den Ausgangszustand wiederherstellen:
`uebung-05-besttec-datenbank.sql` (löscht und legt die DB neu an), dann
`uebung-05-besttec-testdaten.sql`.
:::

```{=latex}
\clearpage
```

# Ausgangslage: BestTec [ca. 2 Min.]{.zeit}

Datenbank BestTec aus der vorherigen Einheit; Datenbestand zum Mitlesen
(`NULL` = kein Wert):

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

# Daten zusammenfassen und gruppieren [ca. 8 Min.]{.zeit}

## Eine Kennzahl über alle Zeilen

::: aufgabe
Wie viele Mitarbeiter hat BestTec, wie hoch ist die **Gehaltssumme**,
was sind **niedrigstes** und **höchstes** Gehalt? Was erwartet ihr als
Ergebnis: eine Zeile je Mitarbeiter oder etwas anderes?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-aggregat.sql"
```

**Gruppenfunktionen** (`COUNT`, `SUM`, `AVG`, `MIN`, `MAX`) fassen viele
Zeilen zu **einem** Wert zusammen → **eine Ergebniszeile**: 20
Mitarbeiter, Summe 84800, Durchschnitt 4240, min 2500, max 9800.
:::

## Eine Kennzahl je Gruppe

::: aufgabe
Wie viele Mitarbeiter gibt es **in jeder Abteilung**? Die Datenbank soll
die Mitarbeiter nach Abteilung in Gruppen einteilen und jede Gruppe
zählen.
:::

::: ergaenzung
**Whiteboard: Was `GROUP BY abtnr` intern bildet** (aus dem Datenbestand
berechnet). Je Gruppe wird die Gruppenfunktion einzeln ausgewertet.

| abtnr | Zeilen in der Gruppe | Σ gehalt | Σ prov | Ø gehalt |
|---:|---:|---:|---:|---:|
| 10 | 5 (Hansen, Langer, Kurt, John, Schulte) | 25500 | 2600 | 5100 |
| 20 | 6 (Karl, Frohn, Werther, Meyer, Sorge, Meier) | 27000 | NULL | 4500 |
| 30 | 3 (Born, Walter, Holle) | 10200 | NULL | 3400 |
| 40 | 3 (Meier, Dorn, Frei) | 11000 | NULL | 3666,67 |
| 50 | 3 (Kron, Beier, Klaas) | 11100 | NULL | 3700 |
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-gruppierung.sql"
```

- `GROUP BY abtnr` bildet Gruppen gleicher Abteilungsnummer; die
  Gruppenfunktion wird **je Gruppe** ausgewertet → 1 Zeile pro Abteilung
  (**5**). **Regel (SQL Server):** Jede Spalte der Auswahlliste, die nicht
  in einer Gruppenfunktion steht, muss auch in `GROUP BY` stehen.
- Mit **Bezeichnung** der Abteilung: `abt` verbinden, Bezeichnung als
  weitere Spalte in `GROUP BY` → weiter 5 Zeilen (je Abteilung eindeutig).
  Fehlt sie in `GROUP BY`: **Fehlermeldung** (Fehlerbild F12).
:::

## Ein gegebenes Statement lesen

::: aufgabe
Gesucht: je Abteilung das **Gesamtgehalt einschließlich Provision**
(Lehrbrief Kap. 7.10, Nr. 16, S. 89). Gegeben:

```sql
SELECT x.abtnr, x.bezeichnung,
       SUM(y.gehalt) + SUM(ISNULL(y.prov, 0)) AS ges_gehalt
FROM abt x, ma y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung;
```

Welchen Wert für die Abteilungen 10 und 20? Erfüllt das Statement die
Anforderung?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-gesamtgehalt.sql"
```

**Richtig.** Zentrale: 25500 + 2600 = **28100**; Engineering: **27000**
(keine Provision). Das `ISNULL` ist wichtig: `SUM(y.prov)` wäre für
Engineering `NULL`, und `27000 + NULL` = `NULL`. Außerdem: zwei Tabellen
verbunden, nach beiden Spalten der Auswahlliste gruppiert.
:::

# Gruppen auswählen: HAVING [ca. 5 Min.]{.zeit}

::: aufgabe
Zu welchen **Tätigkeiten gibt es mehr als drei Mitarbeiter**? Hier wird
nicht eine Zeile, sondern eine **Gruppe** ausgewählt.
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-having.sql"
```

`WHERE` wählt Zeilen **vor** dem Gruppieren, `HAVING` wählt Gruppen
**nach** dem Gruppieren (darf Gruppenfunktionen verwenden). Ergebnis:
**Engineer (6), Manager (4)**.
:::

::: warnung
In SQL Server darf der **Alias** (`anzahl`) **nicht** in `HAVING` stehen
-- dort `COUNT(*)` wiederholen.
:::

::: {.aufgabe platz=12}
Gesucht: Abteilungen, deren **Durchschnittsgehalt über 4000 €** liegt.
Gegeben:

```sql
SELECT abtnr, AVG(gehalt) AS durchschnitt
FROM ma
WHERE gehalt > 4000
GROUP BY abtnr;
```

Welche Abteilungen und Werte? Erfüllt es die Anforderung?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-having-durchschnitt.sql"
```

**Erfüllt nicht.** Es filtert zuerst die **Mitarbeiter** über 4000 € und
mittelt nur über diese → alle 5 Abteilungen mit zu hohen Werten (Zentrale
6500 statt 5100). Gefragt: Durchschnitt **aller** Mitarbeiter der
Abteilung → `HAVING AVG(gehalt) > 4000` → **Zentrale (5100),
Engineering (4500)**. Fehlerbild **F6**.
:::

# Der Umgang mit NULL [ca. 6 Min.]{.zeit}

::: aufgabe
**Gesamtbezüge** (Grundgehalt + Provision) der Mitarbeiter der Abteilung
10. Zuerst die **einfachste** Formulierung probieren, Ergebnisse von
**Hansen** und **John** ansehen.
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-null.sql"
```

- Rechenausdruck mit `NULL` ergibt wieder `NULL`: ohne Provision kein
  Gesamtgehalt.
- `ISNULL(prov, 0)` (oder `COALESCE(prov, 0)`) ersetzt den fehlenden Wert
  **vor** der Addition durch 0 → Hansen **9800**, John **4900**.
:::

::: {.ergaenzung platz=14}
**Whiteboard: NULL-Regeln im Überblick** (`prov` hat 17 × `NULL`, 3 Werte)

| Ausdruck | Ergebnis |
|:----------------------------|:-------------------------------|
| `5 + NULL` | `NULL` |
| `prov = NULL` | **unbekannt** (nie wahr!) |
| `prov IS NULL` | wahr für die 17 Mitarbeiter ohne Provision |
| `AVG(prov)` | ignoriert `NULL`: Ø über 3 Werte = 866,67 |
| `COUNT(prov)` / `COUNT(*)` | 3 / 20 (`COUNT(spalte)` zählt nur Nicht-`NULL`) |
:::

::: aufgabe
Wie viele Mitarbeiter erhalten **keine Provision**? Gegeben:

```sql
SELECT COUNT(*) AS ohne_provision
FROM ma
WHERE prov = NULL;
```

Welchen Wert liefert es? Erfüllt es die Anforderung?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-null-vergleich.sql"
```

Liefert **0**, obwohl **17** keine Provision haben. `NULL` = "unbekannt":
Vergleich mit `=` ist weder wahr noch falsch → Zeile fällt heraus. Prüfen
mit **`IS NULL` / `IS NOT NULL`** (Fehlerbild **F8**).
:::

# Unteranfragen lesen [ca. 5 Min.]{.zeit}

::: aufgabe
Wer verdient **mehr als das höchste Grundgehalt in der Abteilung mit Sitz
in Münster** (Lehrbrief Nr. 17, S. 89)? Gegeben:

```sql
SELECT x.manr, x.name, x.gehalt, y.sitz
FROM ma x, abt y
WHERE x.abtnr = y.abtnr
  AND x.gehalt > (SELECT MAX(m.gehalt)
                  FROM ma m, abt a
                  WHERE m.abtnr = a.abtnr AND a.sitz = 'Münster');
```

Was liefert die **Unteranfrage allein**? Welche Mitarbeiter im
Gesamtergebnis?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-unteranfrage.sql"
```

Unteranfrage: **ein** Wert, **5200** (Kron, Münster). Äußere Abfrage
vergleicht jedes Gehalt damit → **Hansen, Karl, Meier, Sorge** (Kron
selbst nicht: 5200 > 5200 ist falsch). Von **innen nach außen** lesen.
:::

::: aufgabe
Alle Mitarbeiter **ohne Untergebene** (Lehrbrief Nr. 18). Gegeben:

```sql
SELECT manr, name, abtnr
FROM ma
WHERE manr NOT IN (SELECT vorgnr FROM ma);
```

Welche Zeilen liefert die Unteranfrage? Wie viele Mitarbeiter im
Ergebnis?
:::

::: ergaenzung
**Whiteboard: Was die Unteranfrage liefert.** Spalte `vorgnr` aller 20
Zeilen, ohne Doppelte: **7656, 7900, 8801, 7783, 7745, 7112, `NULL`**
(Hansen hat keinen Vorgesetzten). Erwartet: 20 − 6 Vorgesetzte = **14**
Mitarbeiter ohne Untergebene -- aber: `x NOT IN (…, NULL)` ist nie wahr.
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-unteranfrage-notin.sql"
```

Erwartet 14, geliefert **0 Zeilen**: Die Liste enthält `NULL`; gegen eine
Liste mit `NULL` wird `NOT IN` nie wahr → Bedingung für jede Zeile
unbekannt. Abhilfe: `WHERE vorgnr IS NOT NULL` in der Unteranfrage
(Fehlerbild **F9**).
:::

# Daten ändern [ca. 10 Min.]{.zeit}

`INSERT`, `UPDATE`, `DELETE` verändern Daten -- jeweils in genau
**einer** Tabelle pro Anweisung.

::: warnung
Anders als ein `SELECT` ändern sie den Bestand **dauerhaft**, die
Datenbank fragt **nicht zurück**. Immer: (1) `SELECT` mit derselben
`WHERE`-Bedingung, (2) Änderung, (3) "n Zeilen betroffen" mit Erwartung
vergleichen.
:::

## Zeile einfügen

::: aufgabe
Abteilung 30 übernimmt ein **neues Projekt**: Nr. 471, Titel
"WindControl", Kunde "A12". Wie bekommt die Datenbank den Datensatz?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-insert.sql"
```

`INSERT INTO` nennt Tabelle und (empfohlen) die Spalten, `VALUES` die
Werte in **derselben Reihenfolge**. "1 Zeile betroffen" bestätigt. Abt. 30
muss existieren, sonst lehnt der **Fremdschlüssel** ab.
:::

## Zeilen ändern

::: aufgabe
Die **Programmierer der Abteilung 20** bekommen **5 % mehr** Gehalt. Wie
beschreibt man, welche Zeilen sich ändern und wie?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-update.sql"
```

`SET` = neue Wertzuweisung (Ausdruck mit dem alten Wert); `WHERE` = welche
Zeilen. Vorab zeigt dasselbe `WHERE` im `SELECT`: **Frohn, Werther** →
"2 Zeilen betroffen" passt.
:::

::: aufgabe
**Alle Mitarbeiter der Abteilung 20** sollen 5 % mehr bekommen. Gegeben:

```sql
UPDATE ma
SET gehalt = gehalt * 1.05;
```

Wie viele Zeilen werden geändert? Erfüllt es die Anforderung?
:::

::: loesung
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-update-ohne-where.sql"
```

Ohne `WHERE` trifft es **alle 20**, nicht die 6 der Abt. 20. Vorbeugung:
erst `SELECT`, danach "n Zeilen betroffen" prüfen (Fehlerbild **F10**).
**Danach Ausgangszustand mit den beiden Skripten wiederherstellen.**
:::

## Zeilen löschen

::: aufgabe
Projekt 471 wird gestrichen. Und was passiert, wenn man **Abteilung 40
(Robotik)** per `DELETE` löschen will, obwohl dort noch Mitarbeiter
arbeiten?
:::

::: {.loesung platz=20}
```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-delete.sql"
```

```sql
--8<-- "02-theoriephase/termin-03/code/uebung-06-delete-abteilung.sql"
```

Abteilung: SQL Server **lehnt ab** (Fehlermeldung zum FK `fk_ma_abt`),
Mitarbeiter verweisen noch darauf → **Fremdschlüsselintegrität**.
Abteilung trotzdem auflösen: erst Mitarbeiter per `UPDATE` einer anderen
Abteilung zuweisen (Beispiel Abt. 20), dann löschen. **Reihenfolge:** erst
die verweisenden Zeilen ändern/löschen, dann die Zeile, auf die verwiesen
wird.
:::

```{=latex}
\clearpage
```

# Gesamtergebnis [ca. 2 Min.]{.zeit}

::: loesung
**Abfragen:** Grundform jetzt vollständig:

```sql
SELECT [DISTINCT] Spalten, Ausdrücke, Gruppenfunktionen
FROM Tabellen
WHERE Bedingung für Zeilen
GROUP BY Spalten
HAVING Bedingung für Gruppen
ORDER BY Sortierkriterien;
```

Gedankliche Reihenfolge: `FROM` → `WHERE` → `GROUP BY` → `HAVING` →
`SELECT` → `ORDER BY`. `WHERE` wirkt auf **Zeilen vor**, `HAVING` auf
**Gruppen nach** dem Gruppieren. Unteranfragen von **innen nach außen**
lesen.

**Datenänderung:**

| Anweisung | Aufgabe | Wichtig |
|:----------|:--------------|:-----------------------------------------|
| `INSERT` | Zeile einfügen | Spaltenliste angeben; Fremdschlüssel müssen passen |
| `UPDATE` | Zeilen ändern | ohne `WHERE`: **alle** Zeilen |
| `DELETE` | Zeilen löschen | ohne `WHERE`: **alle** Zeilen; Fremdschlüssel können ablehnen |

Stolperfallen: Fehlerbildkatalog F6, F8--F12.
:::

```{=latex}
\clearpage
```

::::: bs
**Betreutes Selbststudium (45 Min.): Aufgabe 06 -- Abfragen und
Datenänderungen mit KI erstellen und prüfen.** KI-**Stufe 2** (Pair
Programmer): KI darf helfen, jeder Vorschlag wird **erklärt und geprüft**.
Rollenwechsel: Statements nicht nur schreiben, sondern **beurteilen**.
Start: Ausgangszustand der DB wiederherstellen.

| Teil | Auftrag | Kernpunkt der Lösung |
|:-----|:------------------------------|:-----------------------------|
| **A** ca. 13 Min. KI erstellt | Prompt mit **Schema** (`CREATE TABLE`), **Dialekt** (T-SQL), **Anforderung + Spaltennamen**. (1) Untergebene je Führungskraft (6 Z.; Hansen 6); (2) Sonderprämie Abt. 10: 10 % der Provision je Zeichen im Namen, sonst 50 € je Zeichen (5 Z.; Langer 720); (3) Abteilungen mit mehr Mitarbeitern als Abt. 10 (1 Z.). Prüftabelle: Zeilenzahl, Zeile von Hand, Änderungen an KI-Vorschlag, mögliches Fehlerbild | (1) Selbstverbund, `GROUP BY` über beide Spalten der Führungskraft; (2) `ISNULL(0.1 * prov, 50)` (mit `ISNULL(prov,0)` Hansen 0 statt 300, F8); (3) Unteranfrage zählt Abt. 10 (5), `HAVING`; nur Abt. 20 (6); `WHERE` statt `HAVING` scheitert (F6). Fehler "unbekannte Funktion" (z. B. `NVL`) = fremder Dialekt |
| **B** ca. 12 Min. Statements prüfen | 4 Statements, alle laufen ohne Fehler: Erwartung? Erfüllt? Fehler, Auswirkung, Korrektur, Fehlerbild | **1** höchstens 1 Projekt: Verbund blendet Abt. ohne Projekt aus (F11; 4 Z. mit Unteranfrage). **2** Ø Provision: `AVG` ignoriert `NULL` → 866,67 statt 130 (F8; `AVG(ISNULL(prov,0))`). **3** Mitarbeiter je Abt. mit Projekt: Verbund vervielfacht (Engineering 18 statt 6; F7; `COUNT(DISTINCT m.manr)`). **4** korrekt (Abt. 20, 6 Mitarbeiter) |
| **C** ca. 8 Min. Bewerten | Von Hand herleiten, dann Quiz: Abfrage 1 (`WHERE gehalt > 3000` + `HAVING COUNT(*) >= 2`), Abfrage 2 (fünf Statements a)--e)) | Abfr. 1: **3 Zeilen**: Zentrale (4), Engineering (4), Education (2). Abfr. 2: **c)** richtig; a) `MAX(gehalt) >= 2` immer wahr, b) `MIN`, d) zusätzlich nach `abtnr`, e) `WHERE` statt Anzahlbedingung |
| **D** ca. 10 Min. Ändern | Vorgehen: `SELECT` → Änderung → "n Zeilen" prüfen. (1) Projekt 471 anlegen (KI); (2) +3 % für Abt. 20 -- Statement mit `OR job = 'Engineer'` prüfen; (3) Meier 7739 → Abt. 30, Chef Born 7112; (4) Abt. 40 auflösen | (2) `OR` trifft auch Engineers anderer Abt.: **10** statt 6 Zeilen (F10). (3) `SET abtnr = 30, vorgnr = 7112 WHERE manr = 7739`. (4) `DELETE` scheitert am FK; Dorn und Frei verweisen auf Meier (7745) → Reihenfolge: Untergebene (8956, 8322), dann Meier, zuletzt Abteilung (`fk_vorg`) |

::: hinweis
Musterlösungen: `aufg-06-besttec-teil-a.sql`, `-teil-b.sql`, `-teil-d.sql`
(Code-Ordner Termin 3). Fehlerbilder: Seite "Fehlerbildkatalog" im
Info-Bereich.
:::

::: warnung
**Moderation:** Kernbotschaft: Ein Statement, das **fehlerfrei läuft**,
tut nicht automatisch das Richtige. Prüfen in drei Schritten:
**Zeilenzahl → Zeile von Hand → Fehlerbild zuordnen.**
:::
:::::
