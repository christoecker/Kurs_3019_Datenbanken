-- A1: Anzahl unterstellter Mitarbeiter je Führungskraft (Lehrbrief-Aufgabe 11)
SELECT y.manr, y.name, COUNT(x.manr) AS anzahl
FROM ma x, ma y
WHERE x.vorgnr = y.manr
GROUP BY y.manr, y.name;

-- A2: Sonderprämie der Abteilung 10 (Lehrbrief-Aufgabe 15)
-- NULL wird erst in der Provision ersetzt: ohne Provision 50 EUR je Zeichen
SELECT name, job, LEN(name) * ISNULL(0.1 * prov, 50) AS s_praemie
FROM ma
WHERE abtnr = 10;

-- A3: Abteilungen mit mehr Mitarbeitern als Abteilung 10 (Lehrbrief-Aufgabe 19)
SELECT abtnr, COUNT(*) AS anzahl_ma
FROM ma
GROUP BY abtnr
HAVING COUNT(*) > (SELECT COUNT(*) FROM ma WHERE abtnr = 10);
