-- Erster Versuch: die Summe ist NULL, sobald die Provision NULL ist
SELECT manr, name, gehalt, prov, gehalt + prov AS gesamt
FROM ma
WHERE abtnr = 10;

-- NULL in der Provision durch 0 ersetzen, dann addieren
SELECT manr, name, gehalt, prov, gehalt + ISNULL(prov, 0) AS gesamt
FROM ma
WHERE abtnr = 10;
