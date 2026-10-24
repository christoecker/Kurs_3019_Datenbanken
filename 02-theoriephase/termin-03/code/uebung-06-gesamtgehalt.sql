SELECT x.abtnr, x.bezeichnung,
       SUM(y.gehalt) + SUM(ISNULL(y.prov, 0)) AS ges_gehalt
FROM abt x, ma y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung;
