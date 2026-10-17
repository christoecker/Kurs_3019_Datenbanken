-- Schreibweise des Lehrbriefs: Verknüpfungsbedingung im WHERE-Teil
SELECT x.name, x.job, x.gehalt, y.gehalt - x.gehalt AS delta
FROM ma x, ma y
WHERE y.name = 'Kron' AND x.vorgnr = y.manr;

-- Gleiche Abfrage mit INNER JOIN
SELECT x.name, x.job, x.gehalt, y.gehalt - x.gehalt AS delta
FROM ma x
INNER JOIN ma y ON x.vorgnr = y.manr
WHERE y.name = 'Kron';
