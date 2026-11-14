-- Die Datenbank lehnt ab: Mitarbeiter verweisen noch auf Abteilung 40
DELETE FROM abt
WHERE abtnr = 40;

-- Weg frei machen: erst die Mitarbeiter einer anderen Abteilung zuweisen ...
UPDATE ma
SET abtnr = 20
WHERE abtnr = 40;

-- ... dann lässt sich die leere Abteilung löschen
DELETE FROM abt
WHERE abtnr = 40;
