USE BestTec;
GO

-- Personal: Mitarbeiterdaten komplett verwalten, Abteilungen nachschlagen
GRANT SELECT, INSERT, UPDATE, DELETE ON ma TO r_personal; -- (1)!
GRANT SELECT ON abt TO r_personal;

-- Projektleiter (erste Fassung): Projekte verwalten, Rest lesen
GRANT SELECT, INSERT, UPDATE, DELETE ON prj TO r_projekt;
GRANT SELECT ON abt      TO r_projekt;
GRANT SELECT ON ma       TO r_projekt;
GRANT SELECT ON testlauf TO r_projekt;

-- Controlling: alles lesen, nichts ändern
GRANT SELECT ON abt      TO r_controlling;
GRANT SELECT ON ma       TO r_controlling;
GRANT SELECT ON prj      TO r_controlling;
GRANT SELECT ON testlauf TO r_controlling;

-- Prüfstand (SPS): Testläufe eintragen, Projekte nachschlagen (nur Nummer und Titel)
GRANT INSERT ON testlauf TO r_pruefstand;
GRANT SELECT ON prj (prjnr, titel) TO r_pruefstand; -- (2)!
GO
