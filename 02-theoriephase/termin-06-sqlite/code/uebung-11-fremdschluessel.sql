-- Fremdschlüssel in SQLite: standardmäßig aus, pro Verbindung einzuschalten
PRAGMA foreign_keys; -- (1)!
-- 0

-- Abteilung 99 gibt es nicht, trotzdem klappt das INSERT:
INSERT INTO ma VALUES (9001, 'Neu', 'Tester', NULL, 3000, NULL, 99);
DELETE FROM ma WHERE manr = 9001;

PRAGMA foreign_keys = ON; -- (2)!
PRAGMA foreign_keys;
-- 1

INSERT INTO ma VALUES (9001, 'Neu', 'Tester', NULL, 3000, NULL, 99);
-- Runtime error: FOREIGN KEY constraint failed (19)

DELETE FROM abt WHERE abtnr = 10;
-- Runtime error: FOREIGN KEY constraint failed (19)
