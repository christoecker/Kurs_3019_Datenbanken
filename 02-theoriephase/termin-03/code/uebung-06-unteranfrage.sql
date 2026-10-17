-- Die Unteranfrage allein: höchstes Gehalt in der Abteilung mit Sitz in Münster
SELECT MAX(m.gehalt)
FROM ma m, abt a
WHERE m.abtnr = a.abtnr AND a.sitz = 'Münster';

-- Die äußere Abfrage vergleicht mit diesem Wert
SELECT x.manr, x.name, x.gehalt, y.sitz
FROM ma x, abt y
WHERE x.abtnr = y.abtnr
  AND x.gehalt > (SELECT MAX(m.gehalt)
                  FROM ma m, abt a
                  WHERE m.abtnr = a.abtnr AND a.sitz = 'Münster');
