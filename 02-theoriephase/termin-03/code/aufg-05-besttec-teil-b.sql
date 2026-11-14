-- --8<-- [start:b1]
-- B1: Projekte in der Abteilung von Mitarbeiter 7739 (Lehrbrief-Aufgabe 7)
SELECT a.abtnr, a.bezeichnung, p.titel, p.kdnr
FROM ma m, abt a, prj p
WHERE m.manr = 7739 AND m.abtnr = a.abtnr AND a.abtnr = p.abtnr;
-- --8<-- [end:b1]

-- --8<-- [start:b2]
-- B2: Projekte von Abteilungen mit Engineers oder Programmierern (Lehrbrief-Aufgabe 8)
-- DISTINCT verhindert, dass ein Projekt pro passendem Mitarbeiter erscheint
SELECT DISTINCT a.abtnr, a.bezeichnung, p.titel, p.kdnr
FROM ma m, abt a, prj p
WHERE m.job IN ('Engineer', 'Programmierer')
  AND m.abtnr = a.abtnr AND a.abtnr = p.abtnr;
-- --8<-- [end:b2]

-- --8<-- [start:b3]
-- B3: Mitarbeiter in Verl oder Münster mit Abteilung und Sitz
SELECT m.name, a.bezeichnung, a.sitz
FROM ma m, abt a
WHERE m.abtnr = a.abtnr AND a.sitz IN ('Verl', 'Münster')
ORDER BY a.sitz, m.name;
-- --8<-- [end:b3]

-- --8<-- [start:b4]
-- B4: Mitarbeiter von Abteilungen mit einem Projekt für Kunde M341
SELECT DISTINCT m.name, m.job
FROM ma m, abt a, prj p
WHERE m.abtnr = a.abtnr AND a.abtnr = p.abtnr AND p.kdnr = 'M341'
ORDER BY m.name;
-- --8<-- [end:b4]
