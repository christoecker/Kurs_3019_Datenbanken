-- Teil B: Musterlösung zu den vier gegebenen Rechteskripten
-- Ausgangszustand: Rechtekonzept am Ende der Übung (uebung-07-besttec-rechte-gesamt.sql).
-- Die Abschnitte 1 bis 4 gehören zu den gleichnamigen Aufgaben und lassen sich nacheinander ausführen.
-- Zeilen mit "NICHT AUSFÜHREN" sind die gegebenen, fehlerhaften Anweisungen und stehen nur als Kommentar da.

USE BestTec;
GO

-- --8<-- [start:b1]
-- ===== Aufgabe 1: Der Controller soll alle Tabellen lesen, aber nichts ändern =====

-- Gegeben (falsch), NICHT AUSFÜHREN:
--   GRANT CONTROL ON DATABASE::BestTec TO u_controller;
-- CONTROL erlaubt fast alles: lesen, ändern, löschen, Tabellen entfernen, Rechte vergeben.
-- Außerdem wäre das Recht direkt an eine Person vergeben statt an eine Rolle.

-- Korrektur: Es muss nichts vergeben werden. u_controller ist Mitglied von r_controlling,
-- und diese Rolle hat bereits SELECT auf abt, ma, prj und testlauf.
-- Kommt später eine weitere Tabelle hinzu, bekommt die ROLLE das Recht:
--   GRANT SELECT ON <neue_tabelle> TO r_controlling;

-- Prüfen: Lesen funktioniert, Ändern nicht.
EXECUTE AS USER = 'u_controller';
GO
SELECT COUNT(*) AS anzahl_ma FROM ma;         -- funktioniert: 20
GO
UPDATE ma SET gehalt = gehalt * 1.1 WHERE manr = 7656;   -- Fehler 229: UPDATE-Recht fehlt
GO
REVERT;
GO
-- --8<-- [end:b1]

-- --8<-- [start:b2]
-- ===== Aufgabe 2: Der Prüfstand soll Testläufe eintragen und Projekte nachschlagen (nur Nummer und Titel) =====

-- Gegeben (falsch), NICHT AUSFÜHREN:
--   GRANT INSERT ON testlauf TO r_pruefstand;
--   GRANT SELECT ON prj      TO r_pruefstand;
-- Das erste GRANT ist richtig. Das zweite erlaubt aber ALLE Spalten von prj,
-- auch die vertrauliche Kundennummer kdnr.

-- Korrektur: Das Leserecht auf die benötigten Spalten beschränken.
-- Im Endzustand der Übung ist das bereits so vergeben:
--   GRANT SELECT ON prj (prjnr, titel) TO r_pruefstand;

-- Prüfen:
EXECUTE AS USER = 'u_pruefstand';
GO
SELECT prjnr, titel FROM prj;                 -- funktioniert: 4 Zeilen
GO
SELECT prjnr, kdnr FROM prj;                  -- Fehler 230: kdnr ist nicht freigegeben
GO
REVERT;
GO
-- --8<-- [end:b2]

-- --8<-- [start:b3]
-- ===== Aufgabe 3: Projektleiter sollen testlauf nicht mehr lesen; der Controller weiterhin =====
-- Der Controller vertritt die Projektleiter und ist deshalb zusätzlich Mitglied von r_projekt.
-- Er ist weiterhin auch Mitglied von r_controlling.

-- Vorbereitung laut Aufgabenstellung: u_controller wird Mitglied einer zweiten Rolle.
ALTER ROLE r_projekt ADD MEMBER u_controller;
GO

-- Gegeben (falsch): Die Rolle r_projekt bekommt ein DENY.
DENY SELECT ON testlauf TO r_projekt;
GO

-- Wirkung: Das DENY gilt für ALLE Mitglieder von r_projekt, also auch für u_controller.
-- Ein DENY ist stärker als jedes GRANT, auch als das GRANT von r_controlling.
EXECUTE AS USER = 'u_controller';
GO
SELECT * FROM testlauf;                       -- Fehler 229: der Controller ist mitgesperrt
GO
REVERT;
GO

-- Korrektur: Die Rolle r_projekt bekommt kein DENY, sondern ihr Leserecht wird zurückgenommen.
-- REVOKE löscht den Eintrag von r_projekt für testlauf vollständig. Das gilt hier für das DENY.
-- (Wäre das DENY nie ausgeführt worden, hätte dasselbe REVOKE direkt das ursprüngliche GRANT
-- von r_projekt entfernt. Das Ergebnis wäre identisch.)
REVOKE SELECT ON testlauf FROM r_projekt;
GO

-- Prüfen 1: u_controller liest über r_controlling. Dort liegt ein GRANT, und es gibt kein DENY mehr.
EXECUTE AS USER = 'u_controller';
GO
SELECT * FROM testlauf;                       -- funktioniert
GO
REVERT;
GO

-- Prüfen 2: u_projektleiter ist nur in r_projekt. Die Rolle hat kein Recht mehr, ein anderes gibt es nicht.
EXECUTE AS USER = 'u_projektleiter';
GO
SELECT * FROM testlauf;                       -- Fehler 229: kein Recht
GO
REVERT;
GO

-- Aufräumen: Die Vertretung endet.
ALTER ROLE r_projekt DROP MEMBER u_controller;
GO
-- --8<-- [end:b3]

-- --8<-- [start:b4]
-- ===== Aufgabe 4: Neuer Mitarbeiter im Personalwesen mit denselben Rechten wie u_personal =====

-- Gegebenes Skript (korrekt): Login auf Serverebene anlegen ...
USE master;
GO
CREATE LOGIN l_personal2 WITH PASSWORD = 'Kurs#2026-Pers2';
GO

-- ... Benutzer in der Datenbank anlegen und der Rolle zuordnen.
-- Alle Rechte kommen von der Rolle r_personal, es wird nichts einzeln vergeben.
USE BestTec;
GO
CREATE USER u_personal2 FOR LOGIN l_personal2;
ALTER ROLE r_personal ADD MEMBER u_personal2;
GO

-- Prüfen: Der neue Benutzer hat genau die Rechte von r_personal.
EXECUTE AS USER = 'u_personal2';
GO
SELECT COUNT(*) AS anzahl_ma FROM ma;         -- funktioniert: 20
GO
UPDATE abt SET bezeichnung = 'Test' WHERE abtnr = 99;   -- Fehler 229: UPDATE auf abt hat r_personal nicht
GO
REVERT;
GO
-- --8<-- [end:b4]
