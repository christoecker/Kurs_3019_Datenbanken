-- B1: Falsch war, dass der Verbund Abteilungen ohne Projekt ausblendet (nur Abteilung 10 erschien).
-- Korrigiert: Die Projekte je Abteilung werden in einer Unteranfrage gezählt.
SELECT x.abtnr, x.bezeichnung
FROM abt x
WHERE (SELECT COUNT(*) FROM prj y WHERE y.abtnr = x.abtnr) <= 1;

-- B2: Falsch war, dass AVG die NULL-Werte übergeht (Mittel über nur 3 Mitarbeiter: 866,67).
-- Korrigiert: Eine fehlende Provision zählt als 0.
SELECT AVG(ISNULL(prov, 0)) AS durchschnitt_prov
FROM ma;

-- B3: Falsch war, dass der Verbund mit prj die Mitarbeiter vervielfacht (Engineering: 18 statt 6).
-- Korrigiert: Jeder Mitarbeiter wird nur einmal gezählt.
SELECT a.abtnr, a.bezeichnung, COUNT(DISTINCT m.manr) AS anzahl_ma
FROM abt a, ma m, prj p
WHERE a.abtnr = m.abtnr AND a.abtnr = p.abtnr
GROUP BY a.abtnr, a.bezeichnung;

-- B4: Das gegebene Statement war korrekt.
SELECT name
FROM ma
WHERE abtnr IN (SELECT abtnr FROM prj GROUP BY abtnr HAVING COUNT(*) >= 2);
