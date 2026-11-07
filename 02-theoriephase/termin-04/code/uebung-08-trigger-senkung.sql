USE BestTec;
GO

-- Zweiter Trigger: Gehaltssenkungen sind nicht erlaubt.
CREATE TRIGGER tr_ma_gehalt_senkung
ON ma
AFTER UPDATE
AS
BEGIN
    IF EXISTS (SELECT 1 -- (1)!
               FROM inserted i, deleted d
               WHERE i.manr = d.manr
                 AND i.gehalt < d.gehalt)
        THROW 50002, 'Gehaltssenkungen sind nicht erlaubt.', 1; -- (2)!
END;
GO

-- Test: Alle sechs Gehälter der Abteilung 20 sollen um 100 sinken
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt - 100 WHERE abtnr = 20;       -- Fehler 50002
GO
SELECT name, gehalt FROM ma WHERE abtnr = 20;               -- unverändert: auch nicht die Zeilen, die "gepasst" hätten
SELECT COUNT(*) AS logzeilen FROM gehalt_log;               -- 0: auch das Protokoll von tr_ma_gehalt wurde zurückgenommen
GO

-- Trigger verwalten: Status ansehen, abschalten, wieder einschalten, löschen
SELECT name, is_disabled FROM sys.triggers WHERE parent_id = OBJECT_ID('ma');
GO

DISABLE TRIGGER tr_ma_gehalt_senkung ON ma;                 -- ausschalten
GO
UPDATE ma SET gehalt = gehalt - 100 WHERE abtnr = 20;       -- funktioniert jetzt (und wird protokolliert)
GO
SELECT COUNT(*) AS logzeilen FROM gehalt_log;               -- 6
GO

ENABLE TRIGGER tr_ma_gehalt_senkung ON ma;                  -- wieder einschalten
GO

DROP TRIGGER tr_ma_gehalt_senkung;                          -- entfernen
GO
