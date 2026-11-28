-- Vorab prüfen, welche Zeilen betroffen wären
SELECT manr, name, job, gehalt
FROM ma
WHERE abtnr = 20 AND job = 'Programmierer';

UPDATE ma
SET gehalt = gehalt * 1.05 -- (1)!
WHERE abtnr = 20 AND job = 'Programmierer'; -- (2)!
