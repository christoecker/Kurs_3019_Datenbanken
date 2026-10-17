-- Schreibweise des Lehrbriefs: Verknüpfungsbedingung im WHERE-Teil
SELECT x.abtnr, x.bezeichnung, y.titel, y.kdnr
FROM abt x, prj y
WHERE x.abtnr = y.abtnr
ORDER BY x.abtnr;

-- Gleiche Abfrage mit INNER JOIN (diese Schreibweise liefert auch KI meist)
SELECT x.abtnr, x.bezeichnung, y.titel, y.kdnr
FROM abt x
INNER JOIN prj y ON x.abtnr = y.abtnr
ORDER BY x.abtnr;
