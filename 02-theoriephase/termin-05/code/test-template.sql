-- Test-Template für das Mini-Projekt (Termin 5)
-- ---------------------------------------------------------------------------
-- So geht ihr vor:
--   1. Den Kopf (Teil 0) einmal in einem Abfragefenster ausführen. Er legt
--      die temporäre Ergebnistabelle #ergebnis an (gilt nur in diesem Fenster).
--   2. Jeden Test einzeln markieren und ausführen (F5), oder die ganze Datei.
--   3. Am Ende die Zusammenfassung ausführen.
--   4. Kopiert einen Beispieltest je Testart und passt an: Datenbank,
--      Tabellen, Spalten, Prozeduren, Benutzer und die erwartete Fehlernummer.
--      Stellen mit "ANPASSEN" müssen geändert werden.
--
-- Grundmuster jedes Tests:
--   Vorbereiten -> Aktion -> Erwartung prüfen -> Rollback -> Ergebnis merken
-- Durch das ROLLBACK am Ende bleiben die Daten nach jedem Test unverändert.
-- ---------------------------------------------------------------------------

-- Teil 0: Kopf --------------------------------------------------------------
USE MeineDatenbank;                -- ANPASSEN: Name eurer Datenbank
GO
SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;          -- nötig, falls ihr gefilterte Indizes nutzt
IF @@TRANCOUNT > 0 ROLLBACK;
IF OBJECT_ID('tempdb..#ergebnis') IS NOT NULL DROP TABLE #ergebnis;
CREATE TABLE #ergebnis (test VARCHAR(10), beschreibung NVARCHAR(120), ok BIT, info NVARCHAR(300));
GO


-- Beispiel 1: Fehlerfall -----------------------------------------------------
-- Testart 1 bis 3, 5, 7, 11 (Constraint, Beziehung, Prozedur oder Trigger lehnen etwas ab).
-- Erwartung: Die Anweisung scheitert mit einer bestimmten Fehlernummer.
--   2627 / 2601 = Eindeutigkeit, 547 = CHECK oder Fremdschlüssel,
--   50000 und größer = eigene Fehlernummern aus THROW.
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    -- Aktion, die scheitern soll
    INSERT INTO TABELLE (SPALTE1, SPALTE2) VALUES (N'Wert1', N'Wert2');   -- ANPASSEN
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;          -- ANPASSEN: erwartete Fehlernummer
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T01', N'Kurze Beschreibung, was geprüft wird', @ok, @info);  -- ANPASSEN
GO


-- Beispiel 2: Erfolgsfall mit Prozedur ----------------------------------------
-- Testart 4, 6, 12 (etwas funktioniert, und der Zustand in den Tabellen stimmt).
-- Erwartung prüfen heißt: Daten nachsehen, nicht nur "kein Fehler".
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @neue_id INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXEC PROZEDUR @parameter1 = 1, @parameter2 = N'Text', @id = @neue_id OUTPUT;   -- ANPASSEN

    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM TABELLE WHERE ID_SPALTE = @neue_id AND STAND = 'neu')  -- ANPASSEN
                   THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Neue Zeile mit Nr. ', @neue_id);
END TRY
BEGIN CATCH
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T02', N'Kurze Beschreibung, was geprüft wird', @ok, @info);  -- ANPASSEN
GO


-- Beispiel 3: Recht verweigert ------------------------------------------------
-- Testart 8 bis 10 (ein Benutzer darf etwas oder darf es nicht).
-- Die Anweisung läuft als der Benutzer. Wichtig: Nach einem Fehler erst
-- ROLLBACK, dann REVERT, sonst bleibt ihr in der Rolle des Benutzers.
-- Erwartung bei verweigertem Recht: Fehler 229 (Objekt) oder 230 (Spalte).
-- (Benutzer ohne Login anlegen: CREATE USER u_test WITHOUT LOGIN;)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'BENUTZER';                                         -- ANPASSEN
    DELETE FROM TABELLE WHERE ID_SPALTE = 1;                              -- ANPASSEN
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;                                        -- zuerst zurückrollen
    IF USER_NAME() <> 'dbo' REVERT;                                       -- dann Benutzerwechsel beenden
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 THEN 1 ELSE 0 END;           -- ANPASSEN
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T03', N'Kurze Beschreibung, was geprüft wird', @ok, @info);  -- ANPASSEN
GO


-- Weitere Tests: Beispiel 1 bis 3 kopieren, anpassen, Nummer erhöhen. ---------


-- Zusammenfassung -------------------------------------------------------------
SELECT test, beschreibung, CASE ok WHEN 1 THEN 'PASS' ELSE 'FAIL' END AS ergebnis, info
FROM #ergebnis ORDER BY test;
SELECT SUM(CASE WHEN ok = 1 THEN 1 ELSE 0 END) AS bestanden,
       SUM(CASE WHEN ok = 0 THEN 1 ELSE 0 END) AS fehlgeschlagen
FROM #ergebnis;
GO
