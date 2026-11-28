-- Gegeben: Gehaltserhöhung um 5 % für die Abteilung 20 ...
UPDATE ma
SET gehalt = gehalt * 1.05;

-- Richtig: Die Bedingung schränkt auf Abteilung 20 ein
UPDATE ma
SET gehalt = gehalt * 1.05
WHERE abtnr = 20;
