-- Teil A: neue Rolle r_vertrieb mit eigener Sicht
-- Ausgangszustand: Rechtekonzept am Ende der Übung (uebung-07-besttec-rechte-gesamt.sql)

-- --8<-- [start:a-login]
-- Login auf Serverebene
USE master;
GO
CREATE LOGIN l_vertrieb WITH PASSWORD = 'Kurs#2026-Vert';
GO
-- --8<-- [end:a-login]

-- --8<-- [start:a-sicht]
-- Eigene Sicht: nur Vertriebsmitarbeiter, mit Provision, ohne Grundgehalt
USE BestTec;
GO
CREATE VIEW v_ma_vertrieb AS
SELECT manr, name, job, prov
FROM ma
WHERE job = 'Vertrieb';
GO
-- --8<-- [end:a-sicht]

-- --8<-- [start:a-rolle]
-- Benutzer, Rolle, Mitgliedschaft und Recht (nur auf die Sicht, an die Rolle)
CREATE USER u_vertrieb FOR LOGIN l_vertrieb;
CREATE ROLE r_vertrieb;
ALTER ROLE r_vertrieb ADD MEMBER u_vertrieb;
GRANT SELECT ON v_ma_vertrieb TO r_vertrieb;
GO
-- --8<-- [end:a-rolle]

-- --8<-- [start:a-pruefen]
-- Prüfen mit EXECUTE AS
EXECUTE AS USER = 'u_vertrieb';
GO
SELECT * FROM v_ma_vertrieb;            -- funktioniert: 3 Zeilen (Langer, Kurt, Schulte)
GO
SELECT gehalt FROM ma;                  -- Fehler 229
GO
SELECT * FROM v_ma_projekt;             -- Fehler 229: keine Rechte auf die Sicht der Projektleiter
GO
REVERT;
GO

-- Gegenprobe: Die Projektleiter sehen die Provision weiterhin nicht
EXECUTE AS USER = 'u_projektleiter';
GO
SELECT name, prov FROM v_ma_projekt;    -- Fehler 207: Spalte prov gibt es in dieser Sicht nicht
GO
SELECT * FROM v_ma_vertrieb;            -- Fehler 229
GO
REVERT;
GO
-- --8<-- [end:a-pruefen]
