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

## Zugriffsrechte (Lehrbuch Kapitel 11)

Das Lehrbuch arbeitet mit einem anderen Datenbanksystem (MySQL); die
Grundidee ist dieselbe, die Befehle und der Aufbau unterscheiden sich.

| Thema | Lehrbuch / andere Systeme | SQL Server (T-SQL) | Beispiel / Hinweis |
|---|---|---|---|
| Nutzer anlegen | ein Benutzerkonto in einem Schritt | zwei Schritte: **Login** (Server) und **Benutzer** (Datenbank) | `CREATE LOGIN l_x WITH PASSWORD = '…'; CREATE USER u_x FOR LOGIN l_x;` |
| Rollen | je nach System unterschiedlich | `CREATE ROLE`, Mitglieder mit `ALTER ROLE … ADD MEMBER` | `ALTER ROLE r_projekt ADD MEMBER u_projektleiter;` |
| Rechte vergeben | `GRANT … ON … TO …` | gleiche Grundform, zusätzlich auf einzelne Spalten und Sichten | `GRANT SELECT ON prj (prjnr, titel) TO r_pruefstand;` |
| Rechte verbieten | je nach System nicht vorhanden | `DENY` (stärker als `GRANT`) | `DENY SELECT ON ma (gehalt, prov) TO r_projekt;` |
| Rechte zurücknehmen | `REVOKE` | `REVOKE`; nimmt `GRANT` und `DENY` zurück | `REVOKE SELECT ON ma FROM r_projekt;` |
| Rechte ausprobieren | mit dem Konto anmelden | zusätzlich `EXECUTE AS USER = '…'` und `REVERT` | gilt nur für die aktuelle Sitzung |
| Feste Rollen | – | z. B. `db_datareader`, `db_owner` | Vergeben sehr weitreichende Rechte (Fehlerbild F13); in diesem Kurs nicht verwenden |
| Fehlermeldungen | – | 229: Recht auf Objekt fehlt; 230: Recht auf Spalte fehlt; 207: Spalte existiert nicht | |

## Prozeduren und Trigger (Lehrbuch Kapitel 12)

Das Lehrbuch erklärt Prozeduren und Trigger in PL/SQL. Die Konzepte
übertragen sich, die Schreibweise und einige Eigenschaften nicht.

| Thema | Lehrbuch (PL/SQL) | SQL Server (T-SQL) | Beispiel / Hinweis |
|---|---|---|---|
| Prozedur anlegen | `CREATE PROCEDURE … IS … BEGIN … END;` | `CREATE PROCEDURE … AS BEGIN … END;` | Parameter beginnen mit `@`: `@prjnr NUMERIC(3)`. |
| Prozedur aufrufen | `CALL` bzw. aus PL/SQL-Block | `EXEC p_name @param = wert;` | Benannte Parameter sind lesbarer. |
| Variablen | `DECLARE x …` | `DECLARE @x …` | Zuweisung mit `SET @x = …` oder `SELECT @x = …`. |
| Eigenen Fehler auslösen | `RAISE_APPLICATION_ERROR` | `THROW 50001, 'Text', 1;` | Eigene Fehlernummern ab 50000. |
| Zeitpunkt des Triggers | `BEFORE` oder `AFTER` | nur `AFTER` oder `INSTEAD OF` | Kein `BEFORE`: Werte prüft man besser mit `CHECK`. |
| Ebene des Triggers | zeilenweise (`FOR EACH ROW`) oder je Anweisung | **immer je Anweisung**, einmal für alle Zeilen | Ein `UPDATE` auf 6 Zeilen löst den Trigger einmal aus. |
| Alte und neue Werte | `:OLD` und `:NEW` | Pseudotabellen `deleted` (alt) und `inserted` (neu) | Bei `UPDATE` beide gefüllt, bei `INSERT` nur `inserted`, bei `DELETE` nur `deleted`. Zusammengehörige Zeilen über den Primärschlüssel verbinden. |
| Trigger aktivieren/deaktivieren | `ALTER TRIGGER … ENABLE/DISABLE` | `ENABLE TRIGGER name ON tabelle;` und `DISABLE TRIGGER name ON tabelle;` | Direkt nach `CREATE TRIGGER` ist er aktiv. Status in `sys.triggers`. |
| Namen von Prozeduren | beliebig | Präfix `sp_` vermeiden | `sp_` ist für Systemprozeduren reserviert; im Kurs `p_…`. |
| Trennzeichen im Skript | `/` am Ende | `GO` zwischen den Anweisungen | `CREATE PROCEDURE` und `CREATE TRIGGER` müssen am Anfang eines Batches stehen. |

!!! info "Gilt auch für KI-generierte Trigger"
    Eine KI liefert oft Trigger im Stil eines anderen Systems (`BEFORE`,
    `FOR EACH ROW`, `NEW`/`OLD`) oder mit der Annahme, dass nur eine Zeile
    geändert wird. Beides erkennt ihr an den Fehlerbildern F16 und F17.
