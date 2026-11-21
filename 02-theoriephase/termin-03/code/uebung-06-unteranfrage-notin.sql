-- Gegeben: vorgnr enthält NULL (Hansen hat keinen Vorgesetzten)
SELECT manr, name, abtnr
FROM ma
WHERE manr NOT IN (SELECT vorgnr FROM ma);

-- Richtig: NULL aus der Unteranfrage herausfiltern
SELECT manr, name, abtnr
FROM ma
WHERE manr NOT IN (SELECT vorgnr FROM ma WHERE vorgnr IS NOT NULL)
ORDER BY abtnr;
