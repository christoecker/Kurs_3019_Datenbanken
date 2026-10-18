---
typ: theoriephase-block
termin: 3
block_id: "06"
datum: "2026-11-03"
kurztitel: "Eigene Abfragen und Datenänderung"
thema: "Abfragen mit Gruppierung, NULL und Unteranfragen (DQL) sowie Datenänderung (DML: INSERT/UPDATE/DELETE) - Statements lesen, prüfen und mit KI-Unterstützung erstellen"
lernziele:
  - "Ihr könnt Abfragen mit Aggregatfunktionen, GROUP BY, HAVING, NULL-Behandlung und einfachen Unteranfragen lesen, ihr Ergebnis vorhersagen und beurteilen, ob sie zur Anforderung passen."
  - "Ihr könnt INSERT-, UPDATE- und DELETE-Anweisungen lesen und schreiben und vorhersagen, welche Zeilen sie betreffen oder ob die Datenbank sie ablehnt."
  - "Ihr könnt ein von einer KI erstelltes Statement systematisch prüfen: Zeilenzahl kontrollieren, eine Zeile von Hand nachrechnen und das Fehlerbild zuordnen."
musterloesungen_sichtbar: false
fallstudie: "BestTec (Lehrbrief Anhang 9.2, S. 97–98)"
ki_einsatz: stufe_2_pair_programmer
bearbeitungsstatus: final
publish_date: 2026-11-03
quiz:
  show_progress: false
  disable_after_submit: false
---

# Eigene Abfragen und Datenänderung (03.11.2026)

## Übung { .modus-uebung }

### Worum geht es?

In der vorherigen Einheit habt ihr gelernt, wie man Zeilen auswählt, sortiert und Tabellen
verbindet. Jetzt geht es in zwei Schritten weiter: Ihr fasst Daten
zusammen (Gruppierung), geht mit fehlenden Werten (`NULL`) um und lest
Abfragen mit Unteranfragen. Danach ändert ihr zum ersten Mal Daten:
einfügen, ändern, löschen. Zwischendurch begegnen euch fertige
Statements, bei denen ihr beurteilt, ob sie die Anforderung erfüllen —
nicht jedes tut das. Wir arbeiten wieder mit der Datenbank BestTec.

!!! abstract "Lernziele"
    - Ihr könnt erklären, was `GROUP BY` und `HAVING` leisten, und den
      Unterschied zwischen `WHERE` und `HAVING` begründen.
    - Ihr könnt vorhersagen, wie sich `NULL` in Rechnungen, Vergleichen
      und Unteranfragen verhält.
    - Ihr könnt `INSERT`, `UPDATE` und `DELETE` einsetzen und erklären,
      warum eine `WHERE`-Bedingung beim Ändern und Löschen so wichtig
      ist.

### Ausgangslage: BestTec <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Ausgangslage: BestTec" }

Die Datenbank BestTec kennt ihr schon; den Datenbestand findet ihr
auf der Seite [BestTec: Datenbestand](besttec-daten.md){ target="_blank" rel="noopener" }.
Gleich verändert ihr erstmals Daten. Ist die Datenbank danach nicht mehr
im Ausgangszustand, führt ihr die beiden Skripte
[uebung-05-besttec-datenbank.sql](code/uebung-05-besttec-datenbank.sql)
und [uebung-05-besttec-testdaten.sql](code/uebung-05-besttec-testdaten.sql)
erneut aus — das erste löscht die Datenbank und legt sie neu an.

---

### Daten zusammenfassen und gruppieren <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Daten zusammenfassen und gruppieren" }

#### Eine Kennzahl über alle Zeilen

Wie viele Mitarbeiter hat BestTec, wie hoch ist die Gehaltssumme, und
was sind das niedrigste und das höchste Gehalt? Was erwartet ihr als
Ergebnis: eine Zeile je Mitarbeiter oder etwas anderes?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-aggregat.sql"
    ```

    Gruppenfunktionen (Aggregatfunktionen) wie `COUNT`, `SUM`, `AVG`,
    `MIN` und `MAX` fassen viele Zeilen zu **einem** Wert zusammen. Das
    Ergebnis hat deshalb nur eine Zeile: 20 Mitarbeiter, Gehaltssumme
    84800, Durchschnitt 4240, niedrigstes Gehalt 2500, höchstes 9800.
<!-- MUSTERLOESUNG-ENDE -->

#### Eine Kennzahl je Gruppe

Wie viele Mitarbeiter gibt es in jeder Abteilung? Die Datenbank soll die
Mitarbeiter also nach Abteilung sortiert in Gruppen einteilen und jede
Gruppe zählen.

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-gruppierung.sql"
    ```

    1. `GROUP BY abtnr` teilt die Zeilen in Gruppen mit gleicher
       Abteilungsnummer ein, die Gruppenfunktion wird dann **je Gruppe**
       ausgewertet: eine Ergebniszeile pro Abteilung (hier 5). Regel in SQL
       Server: Jede Spalte der Auswahlliste, die nicht in einer
       Gruppenfunktion steht, muss auch in `GROUP BY` stehen.
    2. Soll zusätzlich die Bezeichnung der Abteilung erscheinen, steht sie in
       einer anderen Tabelle: `abt` wird verbunden, und die Bezeichnung kommt
       als weitere Spalte in `GROUP BY`. Das Ergebnis hat weiterhin 5 Zeilen,
       denn die Bezeichnung ist je Abteilung eindeutig. Fehlt sie in `GROUP
       BY`, meldet SQL Server einen Fehler (Fehlerbild F12).
<!-- MUSTERLOESUNG-ENDE -->

#### Ein gegebenes Statement lesen

Gesucht ist je Abteilung das Gesamtgehalt **einschließlich Provision**
(Lehrbrief, Kap. 7.10, Nr. 16, S. 89). Gegeben ist dieses Statement:

```sql
SELECT x.abtnr, x.bezeichnung,
       SUM(y.gehalt) + SUM(ISNULL(y.prov, 0)) AS ges_gehalt
FROM abt x, ma y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung;
```

Welchen Wert erwartet ihr für die Abteilungen 10 und 20? Erfüllt das
Statement die Anforderung?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-gesamtgehalt.sql"
    ```

    Das Statement ist richtig. Zentrale: Gehälter 25500 plus
    Provisionen 2600 ergibt **28100**. Engineering: **27000**, denn
    dort hat niemand eine Provision. Wichtig ist das `ISNULL`:
    `SUM(y.prov)` wäre für Engineering `NULL`, und `27000 + NULL` ergäbe
    ebenfalls `NULL`. Das Statement verbindet außerdem zwei Tabellen und
    gruppiert nach beiden Spalten der Auswahlliste.
<!-- MUSTERLOESUNG-ENDE -->

---

### Gruppen auswählen: HAVING <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Gruppen auswählen: HAVING" }

Zu welchen Tätigkeiten gibt es mehr als drei Mitarbeiter? Hier wird
nicht eine Zeile, sondern eine **Gruppe** ausgewählt.

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-having.sql"
    ```

    1. `WHERE` wählt Zeilen aus, **bevor** gruppiert wird. `HAVING` wählt
       Gruppen aus, **nachdem** gruppiert wurde, und darf deshalb
       Gruppenfunktionen verwenden. Ergebnis: Engineer (6) und Manager (4).
       Achtung: Der Alias `anzahl` darf in SQL Server in `HAVING` nicht
       verwendet werden — dort steht `COUNT(*)` noch einmal.
<!-- MUSTERLOESUNG-ENDE -->

Gesucht sind die Abteilungen, deren **Durchschnittsgehalt** über 4000 €
liegt. Gegeben ist dieses Statement:

```sql
SELECT abtnr, AVG(gehalt) AS durchschnitt
FROM ma
WHERE gehalt > 4000
GROUP BY abtnr;
```

Welche Abteilungen und Werte liefert es? Erfüllt es die Anforderung?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-having-durchschnitt.sql"
    ```

    Das Statement erfüllt die Anforderung nicht. Es filtert zuerst die
    **Mitarbeiter** mit mehr als 4000 € und bildet den Durchschnitt nur
    über diese: Alle fünf Abteilungen erscheinen, mit zu hohen Werten
    (Zentrale 6500 statt 5100). Gefragt war aber nach dem
    Durchschnitt **aller** Mitarbeiter einer Abteilung. Richtig ist
    `HAVING AVG(gehalt) > 4000`: Es bleiben Zentrale (5100) und
    Engineering (4500). Das ist das Fehlerbild F6 im
    [Fehlerbildkatalog](../../info/fehlerbildkatalog.md).
<!-- MUSTERLOESUNG-ENDE -->

---

### Der Umgang mit NULL <span class="zeitangabe">ca. 6 Min.</span> { data-toc-label="Der Umgang mit NULL" }

Wie hoch sind die Gesamtbezüge (Grundgehalt plus Provision) der
Mitarbeiter der Abteilung 10? Probiert zuerst die einfachste Formulierung
und schaut euch die Ergebnisse von Hansen und John an.

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-null.sql"
    ```

    1. Ein Rechenausdruck mit `NULL` ergibt wieder `NULL`: Wer keine
       Provision hat, hat nach `gehalt + prov` kein Gesamtgehalt.
    2. `ISNULL(prov, 0)` (oder `COALESCE(prov, 0)`) ersetzt einen fehlenden
       Wert **vor** der Addition durch 0. Hansen hat dann 9800, John 4900.
<!-- MUSTERLOESUNG-ENDE -->

Wie viele Mitarbeiter erhalten keine Provision? Gegeben ist dieses
Statement:

```sql
SELECT COUNT(*) AS ohne_provision
FROM ma
WHERE prov = NULL;
```

Welchen Wert liefert es? Erfüllt es die Anforderung?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-null-vergleich.sql"
    ```

    Das Statement liefert **0**, obwohl 17 Mitarbeiter keine Provision
    haben. `NULL` bedeutet „unbekannt“; ein Vergleich mit `=` ist
    deshalb weder wahr noch falsch, und die Zeile fällt aus dem
    Ergebnis. Auf `NULL` prüft man mit `IS NULL` bzw. `IS NOT NULL`
    (Fehlerbild F8).
<!-- MUSTERLOESUNG-ENDE -->

---

### Unteranfragen lesen <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Unteranfragen lesen" }

Wer verdient mehr als das höchste Grundgehalt in der Abteilung mit Sitz
in Münster (Lehrbrief, Kap. 7.10, Nr. 17, S. 89)? Gegeben ist dieses
Statement:

```sql
SELECT x.manr, x.name, x.gehalt, y.sitz
FROM ma x, abt y
WHERE x.abtnr = y.abtnr
  AND x.gehalt > (SELECT MAX(m.gehalt)
                  FROM ma m, abt a
                  WHERE m.abtnr = a.abtnr AND a.sitz = 'Münster');
```

Was liefert die Unteranfrage in den Klammern für sich allein? Welche
Mitarbeiter erwartet ihr im Gesamtergebnis?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-unteranfrage.sql"
    ```

    Die Unteranfrage liefert **einen** Wert: 5200, das höchste Gehalt in
    Münster (Kron). Die äußere Abfrage vergleicht jedes Gehalt mit
    diesem Wert. Es bleiben Hansen, Karl, Meier und Sorge; Kron selbst
    fällt heraus, denn 5200 ist nicht größer als 5200. Man liest eine
    solche Abfrage von innen nach außen.
<!-- MUSTERLOESUNG-ENDE -->

Gesucht sind alle Mitarbeiter **ohne Untergebene** (Lehrbrief, Nr. 18).
Gegeben ist dieses Statement:

```sql
SELECT manr, name, abtnr
FROM ma
WHERE manr NOT IN (SELECT vorgnr FROM ma);
```

Welche Zeilen liefert die Unteranfrage? Wie viele Mitarbeiter erwartet
ihr im Ergebnis?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-unteranfrage-notin.sql"
    ```

    Erwartet würden 14 Mitarbeiter, geliefert werden **0 Zeilen**. Die
    Liste aus der Unteranfrage enthält auch `NULL` (Hansen hat keinen
    Vorgesetzten). Gegen eine Liste mit `NULL` kann `NOT IN` nie wahr
    werden, also ist die Bedingung für jede Zeile unbekannt. Abhilfe:
    `NULL` in der Unteranfrage mit `WHERE vorgnr IS NOT NULL`
    herausfiltern (Fehlerbild F9).
<!-- MUSTERLOESUNG-ENDE -->

---

### Daten ändern <span class="zeitangabe">ca. 10 Min.</span> { data-toc-label="Daten ändern" }

Bisher habt ihr Daten nur gelesen. Mit `INSERT`, `UPDATE` und `DELETE`
verändert ihr sie — immer in genau **einer** Tabelle je Anweisung.

#### Zeile einfügen

Die Abteilung 30 übernimmt ein neues Projekt: Nummer 471, Titel
„WindControl“, Kunde „A12“. Wie bekommt die Datenbank diesen
Datensatz?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-insert.sql"
    ```

    1. `INSERT INTO` nennt die Tabelle und (empfohlen) die Spalten.
    2. `VALUES` nennt die passenden Werte in derselben Reihenfolge.

    Die Meldung „1 Zeile betroffen“ bestätigt das Einfügen. Zuvor muss die
    Abteilung 30 existieren — sonst lehnt der Fremdschlüssel ab.
<!-- MUSTERLOESUNG-ENDE -->

#### Zeilen ändern

Die Programmierer der Abteilung 20 bekommen 5 % mehr Gehalt. Wie
beschreibt man, welche Zeilen sich ändern und wie?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-update.sql"
    ```

    1. `SET` nennt die neue Wertzuweisung (hier ein Ausdruck mit dem alten
       Wert).
    2. `WHERE` legt fest, welche Zeilen sich ändern. Vorab zeigt dasselbe
       `WHERE` in einem `SELECT`, welche Zeilen getroffen werden: Frohn und
       Werther. Die Meldung „2 Zeilen betroffen“ passt dazu.
<!-- MUSTERLOESUNG-ENDE -->

Die Gehälter der gesamten Abteilung 20 sollen um 5 % steigen. Gegeben
ist dieses Statement:

```sql
UPDATE ma
SET gehalt = gehalt * 1.05;
```

Wie viele Zeilen werden geändert? Erfüllt das Statement die
Anforderung?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-update-ohne-where.sql"
    ```

    Ohne `WHERE` gilt die Änderung für **alle 20** Mitarbeiter, nicht für
    die 6 der Abteilung 20. Die Datenbank fragt nicht zurück.
    Vorbeugung: erst das `SELECT` mit derselben Bedingung ausführen, nach
    der Änderung die Meldung „n Zeilen betroffen“ mit der Erwartung
    vergleichen (Fehlerbild F10). Danach stellt ihr den Ausgangszustand
    mit den beiden Skripten wieder her.
<!-- MUSTERLOESUNG-ENDE -->

#### Zeilen löschen

Das Projekt 471 wird wieder gestrichen. Und was passiert, wenn man die
Abteilung 40 (Robotik) mit `DELETE` löschen möchte, obwohl dort noch
Mitarbeiter arbeiten?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-delete.sql"
    ```

    1. `DELETE FROM` mit `WHERE` löscht die passenden Zeilen.

    ```sql
    --8<-- "02-theoriephase/termin-03/code/uebung-06-delete-abteilung.sql"
    ```

    Beim Löschen der Abteilung lehnt SQL Server mit einer Fehlermeldung zum
    Fremdschlüssel `fk_ma_abt` ab: Mitarbeiter verweisen noch auf die
    Abteilung. Die Datenbank schützt so die
    Fremdschlüsselintegrität.

    Soll die Abteilung trotzdem aufgelöst werden, muss zuerst nichts
    mehr auf sie verweisen: Die Mitarbeiter werden mit einem `UPDATE`
    einer anderen Abteilung zugewiesen (im Beispiel Abteilung 20), erst
    danach lässt sich die Abteilung ohne Fehlermeldung löschen. Die
    Reihenfolge ist also: erst die verweisenden Zeilen ändern (oder
    löschen), dann die Zeile, auf die verwiesen wurde.
<!-- MUSTERLOESUNG-ENDE -->

---

### Gesamtergebnis <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Gesamtergebnis" }

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    **Abfragen.** Mit Gruppierung, `HAVING` und Unteranfragen ist die
    Grundform einer Abfrage vollständig. Heute sind zwei Klauseln
    dazugekommen: `GROUP BY` teilt die Zeilen in Gruppen ein, `HAVING`
    wählt aus diesen Gruppen aus. Jede Klausel hat ihre feste Aufgabe,
    und viele Fehler entstehen, wenn eine Bedingung in der falschen
    Klausel steht:

    ```sql
    SELECT [DISTINCT] Spalten, Ausdrücke, Gruppenfunktionen
    FROM Tabellen
    WHERE Bedingung für Zeilen
    GROUP BY Spalten
    HAVING Bedingung für Gruppen
    ORDER BY Sortierkriterien;
    ```

    Gedanklich arbeitet die Datenbank von oben nach unten durch die
    Klauseln `FROM`, `WHERE`, `GROUP BY`, `HAVING`, `SELECT` und zuletzt
    `ORDER BY`. Daraus folgt: `WHERE` wirkt auf einzelne Zeilen **vor**
    dem Gruppieren, `HAVING` auf ganze Gruppen **danach**. Unteranfragen
    liest man von innen nach außen.

    **Datenänderung.** Mit `INSERT`, `UPDATE` und `DELETE` verändert ihr
    Daten, jeweils in genau einer Tabelle. Anders als eine Abfrage
    ändern sie den Datenbestand dauerhaft; die Datenbank fragt nicht
    zurück. Deshalb gehört zu jeder Änderung ein prüfender Blick auf die
    betroffenen Zeilen:

    | Anweisung | Aufgabe | Wichtig |
    |---|---|---|
    | `INSERT` | Zeile einfügen | Spaltenliste angeben; Fremdschlüssel müssen passen |
    | `UPDATE` | Zeilen ändern | Ohne `WHERE` sind alle Zeilen betroffen |
    | `DELETE` | Zeilen löschen | Ohne `WHERE` sind alle Zeilen betroffen; Fremdschlüssel können ablehnen |

    Die Stolperfallen dieses Abschnitts — `WHERE` statt `HAVING`,
    unvollständiges `GROUP BY`, `NOT IN` mit `NULL`, Änderungen ohne oder
    mit zu weitem `WHERE` — stehen im
    [Fehlerbildkatalog](../../info/fehlerbildkatalog.md).
<!-- MUSTERLOESUNG-ENDE -->

---

## Betreutes Selbststudium { .modus-selbststudium }

### Worum geht es?

Jetzt sind die Rollen anders verteilt: Ihr müsst Statements nicht mehr
nur selbst schreiben, sondern vor allem **beurteilen**. In der Praxis
entstehen Statements oft mit KI-Unterstützung oder stammen von
Kolleginnen und Kollegen, und sie sehen meist plausibel aus. Ob sie auch
das Richtige tun, entscheidet ihr. Deshalb dürft und sollt ihr in diesem
Teil eine KI nutzen — aber jedes Ergebnis wird von euch geprüft: Stimmt
die Zeilenzahl? Lässt sich eine Ergebniszeile von Hand nachrechnen?
Welches Fehlerbild könnte vorliegen?

!!! abstract "Lernziele"
    - Ihr könnt Abfragen mit Gruppierung, `NULL`-Behandlung und
      Unteranfragen mit KI-Unterstützung erstellen und systematisch
      prüfen.
    - Ihr könnt gegebene Statements beurteilen, Fehler benennen und
      korrigieren.
    - Ihr könnt Änderungsanweisungen vor dem Ausführen absichern.

### Aufgabe 06: Abfragen und Datenänderungen mit KI erstellen und prüfen

??? info "Bezug zu Lehrinhalten"
    Die Übung oben und Lehrbrief Kapitel 7.6–7.8 und Kapitel 8. <br>
    SQL-Server-Besonderheiten: [SQL Server und Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md). <br>
    Typische Fehlerbilder: [Fehlerbildkatalog](../../info/fehlerbildkatalog.md). <br>
    KI-Einsatz gem. [KI-Nutzungsrichtlinie](../../03-ki-erweiterungsaufgaben/ki-nutzungsrichtlinie.md)
    (Stufe 2, KI als Pair Programmer): KI darf aktiv helfen, ihr müsst
    jeden Vorschlag aber erklären und prüfen können.

Alle Aufgaben beziehen sich auf die Datenbank `BestTec`. Stellt zu
Beginn den Ausgangszustand wieder her, indem ihr die Skripte
[uebung-05-besttec-datenbank.sql](code/uebung-05-besttec-datenbank.sql)
und [uebung-05-besttec-testdaten.sql](code/uebung-05-besttec-testdaten.sql)
ausführt. Den Datenbestand seht ihr auf der Seite
[BestTec: Datenbestand](besttec-daten.md){ target="_blank" rel="noopener" }.

#### Teil A — Mit KI Abfragen erstellen und prüfen <span class="zeitangabe">ca. 13 Min.</span> { data-toc-label="Teil A — Mit KI Abfragen erstellen und prüfen" }

Damit eine KI brauchbare Statements liefert, braucht sie Kontext. Gebt
in jedem Prompt an:

- das **Schema**, am einfachsten als `CREATE TABLE`-Skript (siehe
  Datenbank-Skript oben),
- den **Dialekt**: „Microsoft SQL Server (T-SQL)“,
- die **Anforderung** in Worten und die gewünschten Spalten mit Namen.

Meldet SQL Server beim Ausführen, dass eine Funktion unbekannt ist (z. B.
`NVL`), stammt das Statement aus einem anderen Dialekt — siehe die Seite
[SQL Server und Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md).

Lasst euch zu diesen drei Anforderungen jeweils ein Statement erstellen:

1. Bestimmt für jede Führungskraft die Anzahl der ihr direkt
   unterstellten Mitarbeiter. Ausgabe: Personalnummer, Name, Anzahl.
   (Lehrbrief, Kap. 7.10, Nr. 11, S. 88; Kontrolle: 6 Zeilen; Hansen hat
   6 Untergebene.)
2. Bestimmt für die Mitarbeiter der Abteilung 10 eine Sonderprämie: Für
   jedes Zeichen im Namen gibt es 10 % der Provision. Wer keine Provision
   erhält, bekommt stattdessen 50 € je Zeichen. Ausgabe: Name,
   Tätigkeit, Sonderprämie. (Lehrbrief, Nr. 15, S. 89; Kontrolle: 5
   Zeilen; Langer erhält 720.)
3. Bestimmt für jede Abteilung die Anzahl der Mitarbeiter, aber nur für
   Abteilungen, die mehr Mitarbeiter haben als die Abteilung 10.
   (Lehrbrief, Nr. 19, S. 89; Kontrolle: 1 Zeile.)

Prüft jedes Ergebnis und notiert dazu kurz:

| Prüfpunkt | Eure Notiz |
|---|---|
| Stimmt die Zeilenzahl mit der Kontrolle überein? | |
| Habt ihr eine Ergebniszeile von Hand nachgerechnet? | |
| Was habt ihr am Vorschlag der KI geändert (oder bewusst nicht)? | |
| Welches Fehlerbild aus dem [Fehlerbildkatalog](../../info/fehlerbildkatalog.md) wäre möglich gewesen? | |

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil A anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-a.sql"
    ```

    **Zu 1:** Die Tabelle `ma` wird mit sich selbst verbunden; gruppiert
    wird nach den Spalten der Führungskraft (`y`). Achtet darauf, dass
    beide Spalten der Auswahlliste in `GROUP BY` stehen.

    **Zu 2:** Entscheidend ist, wo `ISNULL` steht: `ISNULL(0.1 * prov, 50)`
    liefert für fehlende Provision 50. Ein Statement, das stattdessen
    `ISNULL(prov, 0)` verwendet, ergäbe für Hansen 0 € statt 300 €
    (Fehlerbild F8).

    **Zu 3:** Die Unteranfrage zählt die Mitarbeiter der Abteilung 10 (5);
    `HAVING` vergleicht jede Gruppe mit diesem Wert. Es bleibt nur
    Abteilung 20 mit 6 Mitarbeitern. Ein `WHERE` statt `HAVING` würde
    mit einer Fehlermeldung scheitern (Fehlerbild F6).
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil B — Gegebene Statements prüfen <span class="zeitangabe">ca. 12 Min.</span> { data-toc-label="Teil B — Gegebene Statements prüfen" }

Zu vier Anforderungen liegt jeweils ein Statement vor. Alle laufen ohne
Fehlermeldung durch — aber nicht jedes liefert, was gefragt war. Für
jedes Statement: Welches Ergebnis erwartet ihr? Erfüllt es die
Anforderung? Wenn nein: Was ist falsch, wie wirkt es sich auf das
Ergebnis aus, wie lautet die Korrektur, und welches Fehlerbild liegt vor?

1\. Gesucht sind alle Abteilungen, denen **höchstens ein Projekt**
(also eines oder keines) zugeordnet ist. (Lehrbrief, Nr. 13, S. 89)

```sql
SELECT x.abtnr, x.bezeichnung
FROM abt x, prj y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung
HAVING COUNT(*) <= 1;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.1 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-b.sql:b1"
    ```

    **Erfüllt die Anforderung nicht** (Fehlerbild F11). Der Verbund
    blendet Abteilungen ohne Projekt aus: Es erscheint nur die Zentrale,
    die Abteilungen 30, 40 und 50 fehlen. Korrektur: die Projekte je
    Abteilung in einer Unteranfrage zählen (4 Zeilen).
<!-- MUSTERLOESUNG-ENDE -->

2\. Gesucht ist die **durchschnittliche Provision je Mitarbeiter**;
Mitarbeiter ohne Provision zählen mit 0.

```sql
SELECT AVG(prov) AS durchschnitt_prov
FROM ma;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.2 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-b.sql:b2"
    ```

    **Erfüllt die Anforderung nicht** (Fehlerbild F8). `AVG` ignoriert
    `NULL`: Es zählen nur die 3 Mitarbeiter mit Provision, Ergebnis
    866,67 statt 130. Korrektur: `AVG(ISNULL(prov, 0))`.
<!-- MUSTERLOESUNG-ENDE -->

3\. Gesucht ist für jede Abteilung, die ein Projekt hat, die **Anzahl
ihrer Mitarbeiter**.

```sql
SELECT a.abtnr, a.bezeichnung, COUNT(*) AS anzahl_ma
FROM abt a, ma m, prj p
WHERE a.abtnr = m.abtnr AND a.abtnr = p.abtnr
GROUP BY a.abtnr, a.bezeichnung;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.3 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-b.sql:b3"
    ```

    **Erfüllt die Anforderung nicht** (Fehlerbild F7). Der Verbund mit
    `prj` vervielfacht die Mitarbeiter: Engineering hat 6 Mitarbeiter
    und 3 Projekte, gezählt werden 18. Korrektur: `COUNT(DISTINCT
    m.manr)`.
<!-- MUSTERLOESUNG-ENDE -->

4\. Gesucht sind die **Namen aller Mitarbeiter**, die in einer
Abteilung mit **mindestens zwei Projekten** arbeiten.

```sql
SELECT name
FROM ma
WHERE abtnr IN (SELECT abtnr FROM prj GROUP BY abtnr HAVING COUNT(*) >= 2);
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.4 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-b.sql:b4"
    ```

    **Erfüllt die Anforderung.** Die Unteranfrage liefert Abteilung 20
    (3 Projekte); die 6 Mitarbeiter dieser Abteilung stehen im Ergebnis.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil C — Abfragen bewerten <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Teil C — Abfragen bewerten" }

Leitet das Ergebnis jeweils zuerst von Hand aus den Tabellen auf der Seite
[BestTec: Datenbestand](besttec-daten.md){ target="_blank" rel="noopener" }
her, bevor ihr eine Antwort wählt.

**Abfrage 1**

```sql
SELECT a.bezeichnung, COUNT(*) AS anzahl
FROM ma m, abt a
WHERE m.abtnr = a.abtnr AND m.gehalt > 3000
GROUP BY a.bezeichnung
HAVING COUNT(*) >= 2;
```

<quiz>
Was ist das Ziel dieser Abfrage?

- [ ] Abteilungen mit mindestens zwei Mitarbeitern, zusammen mit der Anzahl aller ihrer Mitarbeiter.
  > Falsch: Die Bedingung `m.gehalt > 3000` steht im `WHERE`-Teil und wirkt vor der Gruppierung. Gezählt werden also nur Mitarbeiter über 3000 €, nicht alle.
- [ ] Abteilungen, deren Mitarbeiter im Durchschnitt mehr als 3000 € verdienen.
  > Falsch: Es gibt keine Durchschnittsbildung; verglichen wird das einzelne Gehalt (`m.gehalt > 3000`).
- [x] Abteilungen mit mindestens zwei Mitarbeitern, die mehr als 3000 € verdienen, zusammen mit der Anzahl dieser Mitarbeiter.
  > Richtig: `WHERE` wählt die Mitarbeiter über 3000 € aus, `GROUP BY` gruppiert sie je Abteilung, `HAVING COUNT(*) >= 2` behält nur Gruppen mit mindestens zwei Mitarbeitern.
- [ ] Abteilungen mit genau zwei Mitarbeitern, die mehr als 3000 € verdienen.
  > Falsch: `HAVING COUNT(*) >= 2` bedeutet „mindestens zwei“, nicht „genau zwei“.
- [ ] Alle Abteilungen mit der Anzahl ihrer Mitarbeiter über 3000 €, auch wenn es weniger als zwei sind.
  > Falsch: Die `HAVING`-Bedingung entfernt Abteilungen mit weniger als zwei Mitarbeitern über 3000 €.
</quiz>

<quiz>
Welches Ergebnis liefert die Abfrage?

- [ ] 5 Zeilen: alle Abteilungen mit der Anzahl aller ihrer Mitarbeiter.
  > Falsch: Das wäre die Abfrage ohne `WHERE` und ohne `HAVING`.
- [x] 3 Zeilen: Zentrale (4), Engineering (4) und Education (2).
  > Richtig: Über 3000 € verdienen in der Zentrale 4, in Engineering 4 und in Education 2 Mitarbeiter. Automotive und Robotik haben je nur einen Mitarbeiter über 3000 € und fallen durch `HAVING` heraus.
- [ ] 3 Zeilen: Zentrale (5), Engineering (6) und Education (3).
  > Falsch: Das sind die Anzahlen **aller** Mitarbeiter dieser Abteilungen. Wegen `WHERE m.gehalt > 3000` werden nur die Mitarbeiter über 3000 € gezählt.
- [ ] 5 Zeilen: Zentrale (4), Engineering (4), Automotive (1), Robotik (1) und Education (2).
  > Falsch: Das wäre das Ergebnis ohne die `HAVING`-Bedingung.
- [ ] 2 Zeilen: Zentrale (4) und Engineering (4).
  > Falsch: Education hat mit Kron und Klaas genau zwei Mitarbeiter über 3000 €; `>= 2` schließt sie ein.
</quiz>

**Abfrage 2.** Gesucht ist für jede Tätigkeit, die von **mindestens zwei
Mitarbeitern** ausgeübt wird, das höchste Grundgehalt. Fünf Statements
sehen ähnlich aus:

```sql
-- a)
SELECT job, MAX(gehalt) FROM ma
GROUP BY job HAVING MAX(gehalt) >= 2;

-- b)
SELECT job, MIN(gehalt) FROM ma
GROUP BY job HAVING COUNT(*) >= 2;

-- c)
SELECT job, MAX(gehalt) FROM ma
GROUP BY job HAVING COUNT(*) >= 2;

-- d)
SELECT job, MAX(gehalt) FROM ma
GROUP BY job, abtnr HAVING COUNT(*) >= 2;

-- e)
SELECT job, MAX(gehalt) FROM ma
WHERE gehalt >= 2 GROUP BY job;
```

<quiz>
Welches Statement erfüllt die Anforderung?

- [ ] Statement a)
  > Falsch: `HAVING MAX(gehalt) >= 2` ist für jede Tätigkeit erfüllt (jedes Gehalt ist größer als 2). Es erscheinen alle 8 Tätigkeiten, auch solche mit nur einem Mitarbeiter. Gemeint war `COUNT(*) >= 2`.
- [ ] Statement b)
  > Falsch: `MIN` liefert das niedrigste statt das höchste Gehalt. Die Auswahl der Tätigkeiten ist richtig, der Wert nicht.
- [x] Statement c)
  > Richtig: Es wird nach Tätigkeit gruppiert, `HAVING COUNT(*) >= 2` behält Tätigkeiten mit mindestens zwei Mitarbeitern, `MAX(gehalt)` liefert das höchste Gehalt. Ergebnis: 5 Zeilen (Engineer, Manager, Programmierer, Trainer, Vertrieb).
- [ ] Statement d)
  > Falsch: Zusätzlich nach `abtnr` zu gruppieren zählt die Mitarbeiter je Tätigkeit **und** Abteilung. Tätigkeiten erscheinen mehrfach (Engineer in drei Abteilungen), und Tätigkeiten ohne zwei Mitarbeiter in derselben Abteilung fallen weg.
- [ ] Statement e)
  > Falsch: `WHERE gehalt >= 2` filtert nichts Sinnvolles, und eine Bedingung für die Anzahl fehlt ganz. Es erscheinen alle 8 Tätigkeiten.
</quiz>

---

#### Teil D — Daten ändern und absichern <span class="zeitangabe">ca. 10 Min.</span> { data-toc-label="Teil D — Daten ändern und absichern" }

Stellt die Datenbank zu Beginn mit den beiden Skripten wieder her. Geht bei
jeder Änderung so vor: (1) mit einem `SELECT` und derselben
`WHERE`-Bedingung die betroffenen Zeilen ansehen, (2) die Änderung
ausführen, (3) die Meldung „n Zeilen betroffen“ mit eurer Erwartung
vergleichen.

1\. Legt mit Hilfe der KI ein neues Projekt an: Nummer 471, Titel
„WindControl“, Kunde „A12“, Abteilung 30.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.1 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-d.sql:d1"
    ```

    `INSERT INTO` nennt die Tabelle und die Spalten, `VALUES` die
    passenden Werte in derselben Reihenfolge. Die Abteilung 30
    existiert, deshalb nimmt der Fremdschlüssel `fk_prj_abt` die Zeile
    an.
<!-- MUSTERLOESUNG-ENDE -->

2\. Die Gehälter der Mitarbeiter der **Abteilung 20** sollen um 3 %
steigen. Gegeben ist dieses Statement:

```sql
UPDATE ma
SET gehalt = gehalt * 1.03
WHERE abtnr = 20 OR job = 'Engineer';
```

Wie viele Zeilen würden geändert? Erfüllt das Statement die
Anforderung? Prüft die Zeilenzahl mit einem `SELECT`, bevor ihr
korrigiert und ausführt.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.2 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-d.sql:d2"
    ```

    Wegen `OR` trifft das Statement auch die Engineers anderer
    Abteilungen (Dorn, Walter, Frei, Holle): 10 statt der 6 Zeilen der
    Abteilung 20. Richtig ist die Bedingung allein mit `abtnr = 20`
    (Fehlerbild F10).
<!-- MUSTERLOESUNG-ENDE -->

3\. Mitarbeiter 7739 (Meier, Projektleiter) wechselt in die Abteilung 30
und bekommt Born (Personalnummer 7112) als neuen Vorgesetzten. Lasst
euch die Anweisung von der KI erstellen und prüft sie vor dem
Ausführen.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.3 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-d.sql:d3"
    ```

    Mit `SET abtnr = 30, vorgnr = 7112` werden beide Spalten in einer
    Anweisung geändert; `WHERE manr = 7739` stellt sicher, dass nur
    diese Zeile betroffen ist. Der Fremdschlüssel prüft, dass Abteilung
    30 und Mitarbeiter 7112 existieren.
<!-- MUSTERLOESUNG-ENDE -->

4\. Die Abteilung 40 (Robotik) wird aufgelöst. Was passiert, wenn ihr nur
`DELETE FROM abt WHERE abtnr = 40` ausführt? Lasst euch von der KI
eine Vorgehensweise vorschlagen und beurteilt, ob die Reihenfolge der
Anweisungen stimmt. Begründet sie.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.4 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-03/code/aufg-06-besttec-teil-d.sql:d4"
    ```

    Der Löschversuch scheitert am Fremdschlüssel, weil in der Abteilung
    noch Mitarbeiter arbeiten. Außerdem verweisen Dorn und Frei auf
    Meier (7745) als Vorgesetzten. Zulässige Reihenfolge: zuerst die
    Untergebenen (8956, 8322), dann Meier, zuletzt die Abteilung. Wer
    zuerst Meier löscht, scheitert wieder am Fremdschlüssel `fk_vorg`.
<!-- MUSTERLOESUNG-ENDE -->
