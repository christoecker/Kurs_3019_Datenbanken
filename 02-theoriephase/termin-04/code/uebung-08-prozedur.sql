USE BestTec;
GO

-- Prozedur: einen Testlauf des Prüfstands melden
CREATE PROCEDURE p_testlauf_melden -- (1)!
    @prjnr    NUMERIC(3),
    @ergebnis VARCHAR(10)
AS
BEGIN
    SET NOCOUNT ON; -- (2)!

    -- Prüfung: Gibt es das Projekt überhaupt?
    IF NOT EXISTS (SELECT 1 FROM prj WHERE prjnr = @prjnr) -- (3)!
        THROW 50001, 'Unbekanntes Projekt.', 1; -- (4)!

    -- Nur wenn die Prüfung bestanden ist, wird der Testlauf eingetragen.
    INSERT INTO testlauf (prjnr, ergebnis) -- (5)!
    VALUES (@prjnr, @ergebnis);
END;
GO
