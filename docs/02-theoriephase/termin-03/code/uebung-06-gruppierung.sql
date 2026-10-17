SELECT abtnr, COUNT(*) AS anzahl
FROM ma
GROUP BY abtnr;

-- Mit der Abteilungsbezeichnung: Verbund mit abt, beide Spalten stehen in GROUP BY
SELECT a.abtnr, a.bezeichnung, COUNT(*) AS anzahl
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
GROUP BY a.abtnr, a.bezeichnung;
