-- Abfragen aus Termin 3 in SQLite

-- --8<-- [start:a]
SELECT name, gehalt
FROM ma
WHERE abtnr = 20
ORDER BY gehalt DESC;
-- --8<-- [end:a]

-- --8<-- [start:b]
SELECT name, gehalt
FROM ma
ORDER BY gehalt DESC
LIMIT 3; -- (1)!
-- --8<-- [end:b]

-- --8<-- [start:c]
SELECT name || ' (' || job || ')' AS beschreibung -- (1)!
FROM ma;
-- --8<-- [end:c]

-- --8<-- [start:d]
SELECT a.bezeichnung, COUNT(*) AS anzahl
FROM abt a
JOIN ma m ON a.abtnr = m.abtnr
GROUP BY a.bezeichnung;
-- --8<-- [end:d]

-- --8<-- [start:datum]
SELECT date('now') AS heute, -- (1)!
       datetime('now') AS jetzt_utc, -- (2)!
       datetime('now', 'localtime') AS jetzt_lokal, -- (3)!
       date('now', '+7 days') AS in_einer_woche; -- (4)!
-- heute       jetzt_utc            jetzt_lokal          in_einer_woche
-- 2026-12-01  2026-12-01 07:15:00  2026-12-01 08:15:00  2026-12-08
-- --8<-- [end:datum]
