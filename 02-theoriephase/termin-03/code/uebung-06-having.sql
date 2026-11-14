SELECT job, COUNT(*) AS anzahl
FROM ma
GROUP BY job
HAVING COUNT(*) > 3; -- (1)!
