-- Schreibweise des Lehrbriefs: Verknüpfungsbedingung im WHERE-Teil
SELECT x.name, x.job, x.gehalt, y.gehalt - x.gehalt AS delta
FROM ma x, ma y -- (1)!
WHERE y.name = 'Kron' AND x.vorgnr = y.manr; -- (2)!

-- Gleiche Abfrage mit INNER JOIN
SELECT x.name, x.job, x.gehalt, y.gehalt - x.gehalt AS delta
FROM ma x
INNER JOIN ma y ON x.vorgnr = y.manr -- (3)!
WHERE y.name = 'Kron';
