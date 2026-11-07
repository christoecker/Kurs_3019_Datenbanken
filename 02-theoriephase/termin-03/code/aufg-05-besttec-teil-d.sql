-- Anforderung: Name und Abteilungsbezeichnung aller Mitarbeiter, die in Verl oder
-- Paderborn arbeiten und kein Engineer sind.

-- a) korrekt (5 Zeilen: Karl, Frohn, Werther, Meier, Born)
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz IN ('Verl', 'Paderborn')
  AND m.job <> 'Engineer';

-- b) Verknüpfungsbedingung fehlt
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE a.sitz IN ('Verl', 'Paderborn')
  AND m.job <> 'Engineer';

-- c) AND/OR ohne Klammern
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz = 'Verl' OR a.sitz = 'Paderborn'
  AND m.job <> 'Engineer';

-- d) Falscher Vergleich: = statt <>
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz IN ('Verl', 'Paderborn')
  AND m.job = 'Engineer';

-- e) AND statt OR zwischen den Sitzen
SELECT m.name, a.bezeichnung
FROM ma m, abt a
WHERE m.abtnr = a.abtnr
  AND a.sitz = 'Verl' AND a.sitz = 'Paderborn'
  AND m.job <> 'Engineer';
