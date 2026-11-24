-- Tests für den optionalen Teil (Fremdaufträge, Beschreibung ergänzen)
-- Voraussetzung: 01 bis 05 und 08 ausgeführt. Muster wie in 07-tests.sql.
USE Instandhaltung;
GO
SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON;
IF @@TRANCOUNT > 0 ROLLBACK;
IF OBJECT_ID('tempdb..#ergebnis') IS NOT NULL DROP TABLE #ergebnis;
CREATE TABLE #ergebnis (test VARCHAR(10), beschreibung NVARCHAR(120), ok BIT, info NVARCHAR(300));
GO

-- O01: Techniker dürfen keine Fremdaufträge anlegen (Fehler 229)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_fremdauftrag_anlegen @maschine_id = 1, @fremdfirma = N'Wiesel GmbH', @betreuer_id = 3, @auftrag_id = @aid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('O01', N'Fremdauftrag nur durch die Leitung', @ok, @info);
GO

-- O02: Die Leitung legt einen Fremdauftrag an (Typ F, Fremdfirma, intern zuständiger Betreuer)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_leitung';
    EXEC p_fremdauftrag_anlegen @maschine_id = 1, @fremdfirma = N'Wiesel GmbH', @betreuer_id = 3, @auftrag_id = @aid OUTPUT;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM auftrag a JOIN fremdauftrag f ON f.auftrag_id = a.auftrag_id
                                 WHERE a.auftrag_id = @aid AND a.art = 'F' AND f.fremdfirma = N'Wiesel GmbH')
                    AND EXISTS (SELECT 1 FROM zuordnung WHERE auftrag_id = @aid AND techniker_id = 3 AND rolle = 'verantwortlich')
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('O02', N'Leitung legt Fremdauftrag an', @ok, @info);
GO

-- O03: Fremdauftrag ohne Firmenname wird abgelehnt (Fehler 50010)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_leitung';
    EXEC p_fremdauftrag_anlegen @maschine_id = 1, @fremdfirma = N' ', @betreuer_id = 3, @auftrag_id = @aid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50010 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('O03', N'Fremdauftrag braucht Firmennamen', @ok, @info);
GO

-- O04: Beschreibung ergänzen vergibt die nächste Nummer, vorhandene Beschreibungen bleiben unverändert
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    EXEC p_beschreibung_ergaenzen @meldung_id = 1, @text = N'Seit heute früh auch Rauchentwicklung';
    EXEC p_beschreibung_ergaenzen @meldung_id = 1, @text = N'Maschine wurde abgeschaltet';
    REVERT;
    SET @ok = CASE WHEN (SELECT COUNT(*) FROM stoerungsbeschreibung WHERE meldung_id = 1) = 4
                    AND (SELECT MAX(nr) FROM stoerungsbeschreibung WHERE meldung_id = 1) = 4
                    AND (SELECT text FROM stoerungsbeschreibung WHERE meldung_id = 1 AND nr = 1)
                        = N'Maschine fährt nicht an, Fehlermeldung am Display'
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK;
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('O04', N'Beschreibung ergänzen: Nummernvergabe', @ok, @info);
GO

SELECT test, beschreibung, CASE ok WHEN 1 THEN 'PASS' ELSE 'FAIL' END AS ergebnis, info FROM #ergebnis ORDER BY test;
GO