-- Teil A: Datenbank für den Vokabeltrainer

-- --8<-- [start:a1]
PRAGMA foreign_keys = ON;

CREATE TABLE lektion (
    lektion_id INTEGER PRIMARY KEY, -- (1)!
    titel      TEXT NOT NULL UNIQUE
) STRICT; -- (2)!

CREATE TABLE vokabel (
    vokabel_id       INTEGER PRIMARY KEY,
    lektion_id       INTEGER NOT NULL REFERENCES lektion (lektion_id), -- (3)!
    englisch         TEXT    NOT NULL,
    deutsch          TEXT    NOT NULL,
    richtig          INTEGER NOT NULL DEFAULT 0,
    falsch           INTEGER NOT NULL DEFAULT 0,
    zuletzt_geprueft TEXT -- (4)!
) STRICT;
-- --8<-- [end:a1]

-- --8<-- [start:a3]
SELECT l.titel, v.englisch, v.deutsch
FROM vokabel v
JOIN lektion l ON v.lektion_id = l.lektion_id
ORDER BY l.lektion_id, v.englisch;
-- --8<-- [end:a3]

-- --8<-- [start:a4]
SELECT l.titel, COUNT(v.vokabel_id) AS anzahl -- (1)!
FROM lektion l
LEFT JOIN vokabel v ON v.lektion_id = l.lektion_id
GROUP BY l.lektion_id, l.titel
ORDER BY l.lektion_id;
-- --8<-- [end:a4]
