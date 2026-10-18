USE BestTec;
GO

-- Die Sicht enthält nur die Spalten, die Projektleiter sehen dürfen
CREATE VIEW v_ma_projekt AS -- (1)!
SELECT manr, name, job, vorgnr, abtnr
FROM ma;
GO

-- Sperre (DENY) und Tabellenrecht zurücknehmen, stattdessen die Sicht freigeben
REVOKE SELECT ON ma (gehalt, prov) FROM r_projekt; -- (2)!
REVOKE SELECT ON ma FROM r_projekt;
GRANT SELECT ON v_ma_projekt TO r_projekt; -- (3)!
GO

EXECUTE AS USER = 'u_projektleiter';
GO
SELECT * FROM v_ma_projekt;                 -- funktioniert: 20 Zeilen ohne Gehalt und Provision
GO
SELECT name, gehalt FROM v_ma_projekt;      -- Fehler 207: Spalte gehalt gibt es in der Sicht nicht
GO
SELECT name, gehalt FROM ma;                -- Fehler 229: auf die Tabelle ma hat er kein Recht mehr
GO
REVERT;
GO
