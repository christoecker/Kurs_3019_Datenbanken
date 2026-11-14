SELECT COUNT(*)    AS anzahl,
       SUM(gehalt) AS gehaltssumme,
       AVG(gehalt) AS durchschnitt,
       MIN(gehalt) AS niedrigstes,
       MAX(gehalt) AS hoechstes
FROM ma;
