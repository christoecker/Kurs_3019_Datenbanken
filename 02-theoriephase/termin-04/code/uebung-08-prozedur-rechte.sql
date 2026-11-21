USE BestTec;
GO

-- Der Prüfstand darf Testläufe nicht mehr direkt eintragen, sondern nur noch über die Prozedur.
REVOKE INSERT ON testlauf FROM r_pruefstand;
GRANT EXECUTE ON p_testlauf_melden TO r_pruefstand;
GO

EXECUTE AS USER = 'u_pruefstand';
GO
-- Direkter Zugriff auf die Tabelle: Fehler 229, INSERT-Recht fehlt
INSERT INTO testlauf (prjnr, ergebnis) VALUES (232, 'bestanden');
GO
-- Aufruf der Prozedur: funktioniert, obwohl der Prüfstand kein Recht auf testlauf hat
EXEC p_testlauf_melden @prjnr = 232, @ergebnis = 'bestanden';
GO
-- Auch die Prüfung in der Prozedur wirkt: unbekanntes Projekt wird abgelehnt (Fehler 50001)
EXEC p_testlauf_melden @prjnr = 999, @ergebnis = 'bestanden';
GO
-- Lesen darf der Prüfstand die Testläufe weiterhin nicht (Fehler 229)
SELECT * FROM testlauf;
GO
REVERT;
GO
