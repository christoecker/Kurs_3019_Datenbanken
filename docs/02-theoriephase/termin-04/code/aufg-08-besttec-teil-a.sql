-- Teil A: Wirkung des gegebenen Triggers tr_ma_gehalt_v2 vorhersagen
-- Ausgangszustand: BestTec mit Testdaten, Tabelle gehalt_log (uebung-08-besttec-gehaltlog.sql)

-- --8<-- [start:a-trigger]
USE BestTec;
GO
-- Den Trigger aus der Übung entfernen, damit nicht zwei Trigger gleichzeitig protokollieren
DROP TRIGGER IF EXISTS tr_ma_gehalt;
GO

CREATE TRIGGER tr_ma_gehalt_v2
ON ma
AFTER UPDATE
AS
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    SELECT i.manr, d.gehalt, i.gehalt
    FROM inserted i, deleted d
    WHERE i.manr = d.manr;
END;
GO
-- --8<-- [end:a-trigger]

-- --8<-- [start:a1]
-- A.1: Nur die Tätigkeit ändern -> 1 Logzeile (obwohl sich das Gehalt nicht geändert hat)
TRUNCATE TABLE gehalt_log;
UPDATE ma SET job = 'Entwickler' WHERE manr = 7329;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 1 Zeile: Frohn, 2900 -> 2900
GO
-- --8<-- [end:a1]

-- --8<-- [start:a2]
-- A.2: Gehälter der Abteilung 20 um 2 % erhöhen -> 6 Logzeilen
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.02 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 6 Zeilen
GO
-- --8<-- [end:a2]

-- --8<-- [start:a3]
-- A.3: Provision der Vertriebsmitarbeiter ändern -> 3 Logzeilen (Gehalt unverändert)
TRUNCATE TABLE gehalt_log;
UPDATE ma SET prov = 100 WHERE job = 'Vertrieb';
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 3 Zeilen: Kurt, Schulte, Langer
GO
-- --8<-- [end:a3]

-- --8<-- [start:a4]
-- A.4: Einen Mitarbeiter löschen -> 0 Logzeilen (der Trigger gilt nur für UPDATE)
TRUNCATE TABLE gehalt_log;
DELETE FROM ma WHERE manr = 8800;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 0 Zeilen
GO
-- --8<-- [end:a4]

-- --8<-- [start:a5]
-- A.5: Verbesserter Trigger. Nur Gehaltsänderungen werden protokolliert.
DROP TRIGGER IF EXISTS tr_ma_gehalt_v2;
GO
CREATE TRIGGER tr_ma_gehalt_v3
ON ma
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(gehalt)                  -- die Spalte gehalt kommt in SET vor ...
        INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
        SELECT i.manr, d.gehalt, i.gehalt
        FROM inserted i, deleted d
        WHERE i.manr = d.manr
          AND i.gehalt <> d.gehalt;    -- ... und der Wert hat sich wirklich geändert
END;
GO
-- --8<-- [end:a5]
