-- Teil B: Sensor-Messreihe in SQLite

-- --8<-- [start:b1]
PRAGMA foreign_keys = ON; -- (1)!

CREATE TABLE sensor (
    sensor_id   INTEGER PRIMARY KEY, -- (2)!
    bezeichnung TEXT NOT NULL,
    einheit     TEXT NOT NULL
) STRICT; -- (3)!

CREATE TABLE messwert (
    messwert_id INTEGER PRIMARY KEY,
    sensor_id   INTEGER NOT NULL REFERENCES sensor (sensor_id), -- (4)!
    zeitpunkt   TEXT    NOT NULL, -- (5)!
    wert        REAL    NOT NULL
) STRICT;
-- --8<-- [end:b1]

-- --8<-- [start:b3a]
SELECT s.bezeichnung,
       COUNT(*)    AS anzahl,
       AVG(m.wert) AS mittelwert,
       MIN(m.wert) AS minimum,
       MAX(m.wert) AS maximum
FROM sensor s
JOIN messwert m ON s.sensor_id = m.sensor_id
GROUP BY s.bezeichnung;
-- --8<-- [end:b3a]

-- --8<-- [start:b3b]
SELECT zeitpunkt, wert
FROM messwert
WHERE sensor_id = 1
ORDER BY zeitpunkt DESC
LIMIT 2; -- (1)!
-- --8<-- [end:b3b]

-- --8<-- [start:b3c]
SELECT zeitpunkt, wert
FROM messwert
WHERE sensor_id = 2
  AND date(zeitpunkt) = '2026-12-01'; -- (1)!
-- --8<-- [end:b3c]

-- --8<-- [start:b4]
INSERT INTO messwert (sensor_id, zeitpunkt, wert)
VALUES (9, '2026-12-02 08:10:00', 12.0);
-- Runtime error: FOREIGN KEY constraint failed (19)
-- --8<-- [end:b4]
