-- --8<-- [start:a1]
-- A1: Zwei Profile (Lehrbrief-Aufgabe 4)
SELECT name, abtnr, job, gehalt
FROM ma
WHERE (gehalt < 5000 AND job NOT IN ('Programmierer', 'Administrator'))
   OR job IN ('Controller', 'Trainer');
-- --8<-- [end:a1]

-- --8<-- [start:a2]
-- A2: Gehalt zwischen 2800 und 3000, höchstes zuerst, bei Gleichstand nach Name
SELECT name, gehalt
FROM ma
WHERE gehalt BETWEEN 2800 AND 3000
ORDER BY gehalt DESC, name;
-- --8<-- [end:a2]

-- --8<-- [start:a3]
-- A3: Namen mit M am Anfang, kein Manager
SELECT name, job, abtnr
FROM ma
WHERE name LIKE 'M%' AND job <> 'Manager';
-- --8<-- [end:a3]

-- --8<-- [start:a4]
-- A4: Jahresgehalt der Abteilung 30
SELECT name, gehalt * 12 AS jahresgehalt
FROM ma
WHERE abtnr = 30
ORDER BY jahresgehalt DESC;
-- --8<-- [end:a4]
