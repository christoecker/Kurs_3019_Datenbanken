USE BestTec;
GO

-- 1. Gültiger Aufruf: Projekt 232 existiert, das Ergebnis ist erlaubt
EXEC p_testlauf_melden @prjnr = 232, @ergebnis = 'bestanden';
GO

-- 2. Unbekanntes Projekt: Fehler 50001 aus der Prozedur, es wird nichts eingetragen
EXEC p_testlauf_melden @prjnr = 999, @ergebnis = 'bestanden';
GO

-- 3. Unerlaubtes Ergebnis: Die Prozedur prüft das nicht selbst, aber der CHECK-Constraint
--    der Tabelle lehnt ab (Fehler 547)
EXEC p_testlauf_melden @prjnr = 232, @ergebnis = 'unklar';
GO

-- Kontrolle: Nur der erste Aufruf hat eine neue Zeile erzeugt
SELECT TOP 3 testnr, prjnr, zeitpunkt, ergebnis
FROM testlauf
ORDER BY testnr DESC;
GO
