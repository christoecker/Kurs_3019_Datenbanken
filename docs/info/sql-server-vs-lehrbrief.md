# SQL Server und Lehrbrief: Abweichungen

Der Lehrbrief beschreibt SQL weitgehend nach dem Standard und nutzt in
Beispielen teils Oracle-Schreibweisen. In diesem Kurs arbeitet ihr mit
**Microsoft SQL Server** und dessen Dialekt **T-SQL**. Diese Seite
sammelt die Stellen, an denen ihr beim Lesen des Lehrbriefs umdenken
müsst. Die Tabellen wachsen mit dem Kurs; alle Einträge sind auf dem
Kurs-Server (SQL Server 2025 Express) ausprobiert.

## Datendefinition (Lehrbrief Kapitel 6)

| Thema | Lehrbrief | SQL Server (T-SQL) | Hinweis |
|---|---|---|---|
| Wahrheitswerte | `BOOLEAN` | `BIT` | `1` = wahr, `0` = falsch |
| Datum und Uhrzeit | `TIMESTAMP` | `DATETIME2(n)` | In SQL Server bedeutet `TIMESTAMP` etwas anderes (Zeilenversion). |
| Datumswerte | z. B. `'26.10.2026'` | `'2026-10-26'` | Jahr-Monat-Tag |
| Tabelle samt Abhängigkeiten löschen | `DROP TABLE … CASCADE` | gibt es nicht | Tabellen in umgekehrter Anlegereihenfolge einzeln löschen. |
| Schema / Datenbank | `CREATE SCHEMA` | `CREATE DATABASE`, dann `USE` | Zwischen den Anweisungen steht `GO` (ein Kommando von SSMS, kein SQL). |
| Bezeichner | keine Umlaute, keine reservierten Wörter | ebenso | Groß-/Kleinschreibung spielt bei Namen keine Rolle. |

## Datenbankanfragen (Lehrbrief Kapitel 7)

| Thema | Lehrbrief | SQL Server (T-SQL) | Beispiel / Hinweis |
|---|---|---|---|
| NULL ersetzen | `NVL(prov, 0)` | `ISNULL(prov, 0)` oder `COALESCE(prov, 0)` | `NVL` gibt es nicht. `COALESCE` ist Standard-SQL und akzeptiert mehr als zwei Werte. |
| Länge einer Zeichenkette | `LENGTH(name)` | `LEN(name)` | `LEN` ignoriert Leerzeichen am Ende. |
| Textwerte | `'Manager'` | `'Manager'` | Der Lehrbrief druckt die Hochkommas teils typografisch (`´` oder `` ` ``) – eingegeben werden immer gerade Hochkommas `'`. |
| Groß-/Kleinschreibung bei Textvergleichen | je nach System unterschiedlich | im Standard nicht unterscheidend | `WHERE name = 'HANSEN'` findet auch `Hansen`. |
| Gruppierung | Alle nicht aggregierten Spalten der Auswahlliste gehören in `GROUP BY` | wird streng geprüft | `SELECT abtnr, name, COUNT(*) … GROUP BY abtnr` ergibt eine Fehlermeldung. |
| Alias in `HAVING` | `HAVING anzahl > 3` | nicht erlaubt | Stattdessen den Ausdruck wiederholen: `HAVING COUNT(*) > 3`. In `ORDER BY` ist der Alias dagegen erlaubt. |
| Ganzzahldivision | – | `5 / 2` ergibt `2` | Mindestens ein Operand mit Nachkommastelle verwenden: `5 / 2.0`. |
| Sortierung von `NULL` | – | `NULL` steht bei `ASC` zuerst | Anders als in Oracle, wo `NULL` bei `ASC` am Ende steht. |
| Anzahl Ergebniszeilen begrenzen | `ROWNUM` (Oracle) | `TOP n` oder `OFFSET … FETCH` | `SELECT TOP 2 name FROM ma ORDER BY gehalt DESC` |
| Aktuelles Datum | `SYSDATE` | `GETDATE()` oder `SYSDATETIME()` | |
| Verbund | Verknüpfung im `WHERE`-Teil | zusätzlich `INNER JOIN … ON` | Beides ist gleichwertig. KI-Werkzeuge liefern meist die `JOIN`-Schreibweise. |
| Outer Join | nicht behandelt | `LEFT JOIN`, `RIGHT JOIN` | Nimmt auch Zeilen ohne Partner in das Ergebnis auf. |

!!! info "Gilt auch für KI-generierte Statements"
    Ein Statement, das in einem anderen Dialekt geschrieben wurde,
    erzeugt in SQL Server oft eine Fehlermeldung (z. B. `NVL` oder
    `LENGTH`). Das ist ein guter Hinweis darauf, dass ihr der KI den
    Dialekt mitteilen müsst.
