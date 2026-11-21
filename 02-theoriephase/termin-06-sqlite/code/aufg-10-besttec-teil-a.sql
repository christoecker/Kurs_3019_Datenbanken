-- Teil A: Von der KI "übersetztes" SQL-Server-Skript prüfen und für SQLite korrigieren
-- Ausgangszustand: BestTec in SQLite (uebung-11-besttec-schema.sql und -testdaten.sql),
-- Tabelle gehalt_log (uebung-11-gehaltlog.sql)

-- --8<-- [start:a2]
CREATE TABLE testlauf (
    testnr    INTEGER PRIMARY KEY AUTOINCREMENT,
    prjnr     NUMERIC(3)   NOT NULL,
    ergebnis  VARCHAR(20)  NOT NULL,
    zeitpunkt TEXT         NOT NULL DEFAULT CURRENT_TIMESTAMP, -- (1)!
    CONSTRAINT fk_testlauf_prj FOREIGN KEY (prjnr) REFERENCES prj (prjnr),
    CONSTRAINT ck_testlauf_ergebnis CHECK (ergebnis IN ('bestanden', 'fehlerhaft'))
);
-- --8<-- [end:a2]

-- --8<-- [start:a3]
INSERT INTO testlauf (prjnr, ergebnis) VALUES (232, 'bestanden');
SELECT testnr, prjnr, ergebnis, zeitpunkt FROM testlauf;
-- 1  232  bestanden  2026-12-01 08:12:45   (UTC)
-- --8<-- [end:a3]

-- --8<-- [start:a4]
CREATE TRIGGER tr_ma_gehalt_ki
AFTER UPDATE OF gehalt ON ma -- (1)!
FOR EACH ROW
WHEN NEW.gehalt <> OLD.gehalt
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    VALUES (OLD.manr, OLD.gehalt, NEW.gehalt); -- (2)!
END;
-- --8<-- [end:a4]

-- --8<-- [start:a5]
SELECT name || ', ' || job AS info
FROM ma
WHERE abtnr = 20;
-- --8<-- [end:a5]

-- --8<-- [start:a6]
DELETE FROM prj WHERE prjnr = 232; -- (1)!

PRAGMA foreign_key_check; -- (2)!
-- testlauf|1|prj|0
-- --8<-- [end:a6]
