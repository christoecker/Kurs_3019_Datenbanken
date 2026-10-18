USE BestTec;
GO

-- Gehalt und Provision für die Projektleiter sperren
DENY SELECT ON ma (gehalt, prov) TO r_projekt;
GO

EXECUTE AS USER = 'u_projektleiter';
GO
SELECT name, gehalt FROM ma;                              -- Fehler 230: gehalt gesperrt
GO
SELECT * FROM ma;                                         -- Fehler 230: schon ein Stern genügt
GO
SELECT manr, name, job, vorgnr, abtnr FROM ma;            -- funktioniert: 20 Zeilen
GO
REVERT;
GO
