-- Teil C: Vier gegebene Trigger auf ma prüfen
-- Test für alle: Gehälter der Abteilung 20 (6 Mitarbeiter) um 5 % erhöhen
-- Erwartung für die Anforderung "jede Gehaltsänderung protokollieren": 6 Logzeilen
-- Ausgangszustand: BestTec mit Testdaten, Tabelle gehalt_log (uebung-08-besttec-gehaltlog.sql)

-- --8<-- [start:c-vorbereitung]
USE BestTec;
GO
-- Alle Trigger aus der Übung und aus Teil A entfernen, damit nur der jeweils geprüfte Trigger läuft
DROP TRIGGER IF EXISTS tr_ma_gehalt;
DROP TRIGGER IF EXISTS tr_ma_gehalt_v2;
DROP TRIGGER IF EXISTS tr_ma_gehalt_v3;
GO
-- --8<-- [end:c-vorbereitung]

-- --8<-- [start:c1]
-- C.1: Der Trigger geht von genau einer Zeile aus
CREATE TRIGGER tr_ma_gehalt_c1
ON ma
AFTER UPDATE
AS
BEGIN
    DECLARE @manr NUMERIC(4), @alt NUMERIC(9,2), @neu NUMERIC(9,2);
    SELECT @manr = manr, @neu = gehalt FROM inserted;      -- liest bei mehreren Zeilen nur eine davon
    SELECT @alt = gehalt FROM deleted;
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    VALUES (@manr, @alt, @neu);
END;
GO
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- nur 1 Zeile statt 6; welche, ist nicht festgelegt
GO
DROP TRIGGER tr_ma_gehalt_c1;
GO
-- Korrektur: INSERT ... SELECT über inserted und deleted, ohne Variablen
-- --8<-- [end:c1]

-- --8<-- [start:c2]
-- C.2: Syntax eines anderen Datenbanksystems (BEFORE, FOR EACH ROW, OLD/NEW)
-- Dieses Statement scheitert schon beim Anlegen mit einem Syntaxfehler und wird deshalb nicht ausgeführt:
--   CREATE TRIGGER tr_ma_gehalt_c2
--   BEFORE UPDATE ON ma
--   FOR EACH ROW
--   BEGIN
--       INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
--       VALUES (OLD.manr, OLD.gehalt, NEW.gehalt);
--   END;
-- Korrektur: AFTER UPDATE, einmal pro Anweisung, und inserted/deleted statt OLD/NEW:
CREATE TRIGGER tr_ma_gehalt_c2
ON ma
AFTER UPDATE
AS
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    SELECT i.manr, d.gehalt, i.gehalt
    FROM inserted i, deleted d
    WHERE i.manr = d.manr
      AND i.gehalt <> d.gehalt;
END;
GO
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 6 Zeilen
GO
DROP TRIGGER tr_ma_gehalt_c2;
GO
-- --8<-- [end:c2]

-- --8<-- [start:c3]
-- C.3: Die Verknüpfung zwischen inserted und deleted fehlt (Kreuzprodukt)
CREATE TRIGGER tr_ma_gehalt_c3
ON ma
AFTER UPDATE
AS
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    SELECT i.manr, d.gehalt, i.gehalt
    FROM inserted i, deleted d;                            -- WHERE i.manr = d.manr fehlt
END;
GO
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 36 Zeilen (6 x 6), davon 30 falsche Paare
GO
DROP TRIGGER tr_ma_gehalt_c3;
GO
-- Korrektur: WHERE i.manr = d.manr
-- --8<-- [end:c3]

-- --8<-- [start:c4]
-- C.4: Dieser Trigger ist korrekt
CREATE TRIGGER tr_ma_gehalt_c4
ON ma
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(gehalt)
        INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
        SELECT i.manr, d.gehalt, i.gehalt
        FROM inserted i, deleted d
        WHERE i.manr = d.manr
          AND i.gehalt <> d.gehalt;
END;
GO
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 6 Zeilen
GO
DROP TRIGGER tr_ma_gehalt_c4;
GO
-- --8<-- [end:c4]
