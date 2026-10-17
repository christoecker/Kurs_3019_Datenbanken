-- Ohne Klammern: AND bindet stärker als OR
SELECT name, abtnr, gehalt, job
FROM ma
WHERE abtnr IN (10, 20) AND job = 'Manager' OR gehalt > 5000;

-- Mit Klammern: wie in der Fragestellung gemeint
SELECT name, abtnr, gehalt, job
FROM ma
WHERE abtnr IN (10, 20) AND (job = 'Manager' OR gehalt > 5000);
