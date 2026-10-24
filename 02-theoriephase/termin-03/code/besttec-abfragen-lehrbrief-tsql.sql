-- BestTec: Lehrbrief Kap. 7.10, Aufgaben 1-19 als T-SQL-Referenz
-- (Aufgaben 1-8 in Block 05, 9-19 in Block 06)
USE BestTec;
GO

-- 1. Mitarbeiter der Abt. 10 und 20 mit Grundgehalt > 4000
SELECT name, gehalt, abtnr
FROM ma
WHERE abtnr IN (10, 20) AND gehalt > 4000;

-- 2. Abt. 20, 30 oder 40, Name mit 4 Buchstaben und 'o' an zweiter Stelle
SELECT name, abtnr
FROM ma
WHERE abtnr IN (20, 30, 40) AND name LIKE '_o__';

-- 3. Abt. 10 oder 20; Manager oder Grundgehalt > 5000
SELECT name, abtnr, gehalt
FROM ma
WHERE abtnr IN (10, 20) AND (job = 'Manager' OR gehalt > 5000);

-- 4. Gehalt < 5000 und Job weder Programmierer noch Administrator, oder Job Controller/Trainer
SELECT name, abtnr, job, gehalt
FROM ma
WHERE (gehalt < 5000 AND job NOT IN ('Programmierer', 'Administrator'))
   OR job IN ('Controller', 'Trainer');

-- 5. Projekte der Abteilungen
SELECT x.abtnr, x.bezeichnung, y.titel, y.kdnr
FROM abt x, prj y
WHERE x.abtnr = y.abtnr
ORDER BY x.abtnr;

-- 6. Untergebene von Kron mit Job, Gehalt und Gehaltsdifferenz
SELECT x.name, x.job, x.gehalt, y.gehalt - x.gehalt AS delta
FROM ma x, ma y
WHERE y.name = 'Kron' AND x.vorgnr = y.manr;

-- 7. Projekte in der Abteilung von Mitarbeiter 7739
SELECT x.abtnr, x.bezeichnung, y.titel, y.kdnr
FROM abt x, prj y, ma z
WHERE z.manr = 7739 AND x.abtnr = z.abtnr AND x.abtnr = y.abtnr;

-- 8. Projekte von Abteilungen mit Engineers oder Programmierern
SELECT DISTINCT x.abtnr, x.bezeichnung, y.titel, y.kdnr
FROM abt x, prj y, ma z
WHERE z.job IN ('Engineer', 'Programmierer') AND x.abtnr = z.abtnr AND x.abtnr = y.abtnr;

-- 9. Anzahl der Mitarbeiter mit Vorgesetztenfunktion
SELECT COUNT(DISTINCT vorgnr) AS anzahl
FROM ma;

-- 10. Anzahl Projekte je Abteilung (nur Abteilungen mit Projekt)
SELECT x.abtnr, x.bezeichnung, COUNT(y.prjnr) AS anzahl
FROM abt x, prj y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung;

-- 11. Anzahl unterstellter Mitarbeiter je Führungskraft
SELECT y.manr, y.name, COUNT(x.manr) AS anzahl
FROM ma x, ma y
WHERE x.vorgnr = y.manr
GROUP BY y.manr, y.name;

-- 12. Tätigkeiten mit mehr als 3 Mitarbeitern (in T-SQL kein Alias in HAVING)
SELECT job, COUNT(*) AS anzahl
FROM ma
GROUP BY job
HAVING COUNT(*) > 3;

-- 13. Abteilungen mit einem oder keinem Projekt
-- Der Verbund allein blendet Abteilungen ohne Projekt aus (nur Abt. 10 käme heraus).
-- Lösung mit Unteranfrage, ohne Outer Join:
SELECT x.abtnr, x.bezeichnung
FROM abt x
WHERE (SELECT COUNT(*) FROM prj y WHERE y.abtnr = x.abtnr) <= 1;

-- 14. Warum liefert die Anfrage für Hansen und John den Wert 0?
-- prov + gehalt ist NULL, sobald prov NULL ist -> ISNULL liefert dann 0
SELECT manr, name, gehalt, prov, ISNULL(prov + gehalt, 0) AS gesamt
FROM ma
WHERE abtnr = 10;
-- Richtig: NULL erst in der Provision ersetzen
SELECT manr, name, gehalt, prov, ISNULL(prov, 0) + gehalt AS gesamt
FROM ma
WHERE abtnr = 10;

-- 15. Sonderprämie: 10 % der Provision je Namenszeichen, ohne Provision 50 EUR je Zeichen
SELECT name, job, LEN(name) * ISNULL(0.1 * prov, 50) AS s_praemie
FROM ma
WHERE abtnr = 10;

-- 16. Gesamtgehalt je Abteilung inklusive Provision
SELECT x.abtnr, x.bezeichnung, SUM(y.gehalt) + SUM(ISNULL(y.prov, 0)) AS ges_gehalt
FROM abt x, ma y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung;

-- 17. Mitarbeiter, die mehr verdienen als das höchste Grundgehalt der Abteilung in Münster
SELECT x.manr, x.name, x.gehalt, y.sitz
FROM ma x, abt y
WHERE x.abtnr = y.abtnr
  AND x.gehalt > (SELECT MAX(m.gehalt)
                  FROM ma m, abt a
                  WHERE m.abtnr = a.abtnr AND a.sitz = 'Münster');

-- 18. Mitarbeiter ohne Untergebene
-- Hier ist NOT IN unproblematisch, weil die Unteranfrage mit WHERE vorgnr IS NOT NULL keine NULL liefert
SELECT manr, name, abtnr
FROM ma
WHERE manr NOT IN (SELECT vorgnr FROM ma WHERE vorgnr IS NOT NULL)
ORDER BY abtnr;

-- 19. Anzahl Mitarbeiter je Abteilung, nur Abteilungen mit mehr Mitarbeitern als Abt. 10
SELECT abtnr, COUNT(*) AS anzahl_ma
FROM ma
GROUP BY abtnr
HAVING COUNT(*) > (SELECT COUNT(*) FROM ma WHERE abtnr = 10);
GO
