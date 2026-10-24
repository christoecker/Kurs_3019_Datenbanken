-- Gegeben: NULL lässt sich nicht mit = vergleichen
SELECT COUNT(*) AS ohne_provision
FROM ma
WHERE prov = NULL;

-- Richtig: IS NULL
SELECT COUNT(*) AS ohne_provision
FROM ma
WHERE prov IS NULL;
