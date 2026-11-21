SELECT name, gehalt, abtnr
FROM ma
WHERE abtnr IN (10, 20) -- (1)!
  AND gehalt > 4000; -- (2)!
