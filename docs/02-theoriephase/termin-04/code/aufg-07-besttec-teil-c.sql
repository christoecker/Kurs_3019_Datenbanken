-- Teil C: Nachprüfen der Bewertungsaufgabe (Benutzer u_anna ohne Login, nur für diesen Test)
USE BestTec;
GO

CREATE USER u_anna WITHOUT LOGIN;
CREATE ROLE r_a;
CREATE ROLE r_b;
ALTER ROLE r_a ADD MEMBER u_anna;
ALTER ROLE r_b ADD MEMBER u_anna;
GO

GRANT SELECT ON abt TO r_a;
GRANT SELECT ON ma  TO r_a;
GRANT SELECT ON prj TO r_b;
DENY  SELECT ON ma (gehalt, prov) TO r_b;
GO

EXECUTE AS USER = 'u_anna';
GO
SELECT * FROM ma;                                   -- Fehler 230: gehalt gesperrt
GO
SELECT name, prov FROM ma;                          -- Fehler 230
GO
SELECT m.name, a.bezeichnung
FROM ma m, abt a WHERE m.abtnr = a.abtnr;           -- funktioniert: 20 Zeilen
GO
SELECT AVG(gehalt) FROM ma;                         -- Fehler 230
GO
INSERT INTO prj (prjnr, abtnr, kdnr, titel)
VALUES (999, 10, 'X1', 'Test');                     -- Fehler 229: INSERT-Recht fehlt
GO
SELECT titel FROM prj;                              -- funktioniert: 4 Zeilen
GO
REVERT;
GO

-- Aufräumen
DROP USER u_anna;
DROP ROLE r_a;
DROP ROLE r_b;
GO
