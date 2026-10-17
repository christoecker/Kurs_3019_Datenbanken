-- D1: neues Projekt anlegen
INSERT INTO prj (prjnr, abtnr, kdnr, titel)
VALUES (471, 30, 'A12', 'WindControl');

-- D2 (gegeben, falsch): trifft auch die Engineers anderer Abteilungen
-- Vorab prüfen: mit OR sind es 10 Zeilen statt der 6 Mitarbeiter der Abteilung 20
SELECT manr, name, abtnr, job FROM ma WHERE abtnr = 20 OR job = 'Engineer';

-- D2 (korrigiert)
SELECT manr, name, abtnr, job FROM ma WHERE abtnr = 20;   -- 6 Zeilen

UPDATE ma
SET gehalt = gehalt * 1.03
WHERE abtnr = 20;

-- D3: Mitarbeiter 7739 wechselt in die Abteilung 30, Vorgesetzter wird Born (7112)
SELECT manr, name, abtnr, vorgnr FROM ma WHERE manr = 7739;   -- vorab: 1 Zeile

UPDATE ma
SET abtnr = 30, vorgnr = 7112
WHERE manr = 7739;

-- D4: Abteilung 40 löschen? Die Datenbank lehnt ab, solange Mitarbeiter darauf verweisen.
-- Zulässige Reihenfolge: erst die Untergebenen (Dorn, Frei), dann der Vorgesetzte Meier, zuletzt die Abteilung.
DELETE FROM ma WHERE manr IN (8956, 8322);
DELETE FROM ma WHERE manr = 7745;
DELETE FROM abt WHERE abtnr = 40;
