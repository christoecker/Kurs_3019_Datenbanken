-- A1: Zwei Profile (Lehrbrief-Aufgabe 4)
SELECT name, abtnr, job, gehalt
FROM ma
WHERE (gehalt < 5000 AND job NOT IN ('Programmierer', 'Administrator'))
   OR job IN ('Controller', 'Trainer');

-- A2: Gehalt zwischen 2800 und 3000, höchstes zuerst, bei Gleichstand nach Name
SELECT name, gehalt
FROM ma
WHERE gehalt BETWEEN 2800 AND 3000
ORDER BY gehalt DESC, name;

-- A3: Namen mit M am Anfang, kein Manager
SELECT name, job, abtnr
FROM ma
WHERE name LIKE 'M%' AND job <> 'Manager';

-- A4: Jahresgehalt der Abteilung 30
SELECT name, gehalt * 12 AS jahresgehalt
FROM ma
WHERE abtnr = 30
ORDER BY jahresgehalt DESC;
