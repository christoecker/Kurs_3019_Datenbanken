-- Wie viele Zeilen stehen nach jeder Anweisung in gehalt_log?
-- Vor jeder Anweisung: DELETE FROM gehalt_log;

UPDATE ma SET gehalt = 3000 WHERE manr = 7329;                -- (a) 1 Zeile
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;        -- (b) 6 Zeilen
UPDATE ma SET job = 'Entwickler' WHERE manr = 7329;           -- (c) 0 Zeilen
UPDATE ma SET gehalt = gehalt WHERE abtnr = 20;               -- (d) 0 Zeilen
UPDATE ma SET gehalt = 0 WHERE abtnr = 99;                    -- (e) 0 Zeilen

SELECT manr, gehalt_alt, gehalt_neu, zeitpunkt FROM gehalt_log;
