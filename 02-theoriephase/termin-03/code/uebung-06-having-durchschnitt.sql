-- Gegeben: filtert Mitarbeiter, nicht Abteilungen
SELECT abtnr, AVG(gehalt) AS durchschnitt
FROM ma
WHERE gehalt > 4000
GROUP BY abtnr;

-- Richtig: erst gruppieren, dann die Gruppen auswählen
SELECT abtnr, AVG(gehalt) AS durchschnitt
FROM ma
GROUP BY abtnr
HAVING AVG(gehalt) > 4000;
