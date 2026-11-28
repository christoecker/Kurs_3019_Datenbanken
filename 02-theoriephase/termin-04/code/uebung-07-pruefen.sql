USE BestTec;
GO

-- Controller: lesen ja, ändern nein
EXECUTE AS USER = 'u_controller';
GO
SELECT name, gehalt FROM ma WHERE abtnr = 10;       -- funktioniert: 5 Zeilen
GO
UPDATE ma SET gehalt = gehalt * 1.1 WHERE abtnr = 10;   -- Fehler 229: UPDATE-Recht verweigert
GO
REVERT;
GO

-- Prüfstand (SPS): eintragen ja, lesen nein
EXECUTE AS USER = 'u_pruefstand';
GO
INSERT INTO testlauf (prjnr, ergebnis) VALUES (212, 'bestanden');   -- funktioniert
GO
SELECT * FROM testlauf;                             -- Fehler 229: SELECT-Recht verweigert
GO
SELECT prjnr, titel FROM prj;                       -- funktioniert: 4 Zeilen
GO
SELECT prjnr, kdnr FROM prj;                        -- Fehler 230: Spalte kdnr nicht freigegeben
GO
REVERT;
GO

-- Projektleiter: Was sieht er in der Tabelle ma?
EXECUTE AS USER = 'u_projektleiter';
GO
SELECT name, job, gehalt, prov FROM ma;             -- funktioniert, aber das ist zu viel!
GO
REVERT;
GO
