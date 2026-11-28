-- Tests (Pflichtteil, Stand v2). Voraussetzung: 01 bis 05 ausgeführt, Basisdaten unverändert.
-- Jeder Test läuft in einer eigenen Transaktion, die am Ende zurückgerollt wird (die Daten bleiben unverändert).
-- Ergebnis: Tabelle #ergebnis am Ende (PASS/FAIL), Spalte info nennt bei FAIL den tatsächlichen Fehler.
-- Muster je Test:  Vorbereiten -> Aktion (ggf. als Benutzer) -> Erwartung prüfen -> Rollback -> Ergebnis merken.
USE Instandhaltung;
GO
SET NOCOUNT ON;
SET QUOTED_IDENTIFIER ON; -- sqlcmd schaltet das standardmäßig ab (Option -I schaltet es ein); die Indizes brauchen es
IF @@TRANCOUNT > 0 ROLLBACK;
IF OBJECT_ID('tempdb..#ergebnis') IS NOT NULL DROP TABLE #ergebnis;
CREATE TABLE #ergebnis (test VARCHAR(10), beschreibung NVARCHAR(120), ok BIT, info NVARCHAR(300));
GO

-- ===================== Constraints =====================

-- T01: doppelte Personalnummer wird abgelehnt (Fehler 2627)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO mitarbeiter (name, personalnr) VALUES (N'Doppelgänger', '100001');
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 2627 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T01', N'Personalnummer eindeutig', @ok, @info);
GO

-- T02: ungültiges Fachgebiet wird abgelehnt (Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO mitarbeiter (name, personalnr) VALUES (N'Neu', '300001');
    INSERT INTO techniker (mitarbeiter_id, fachgebiet) VALUES (SCOPE_IDENTITY(), 'Kochen');
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T02', N'Fachgebiet nur aus der Liste', @ok, @info);
GO

-- T03: ungültige Dringlichkeit wird abgelehnt (Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO stoermeldung (maschine_id, melder_id, dringlichkeit) VALUES (1, 1, 5);
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T03', N'Dringlichkeit nur 1 bis 3', @ok, @info);
GO

-- T04: Abschlussdatum vor dem Anlegedatum wird abgelehnt (Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE auftrag SET stand = 'abgeschlossen', abgeschlossen_am = DATEADD(DAY, -1, angelegt_am) WHERE auftrag_id = 1;
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T04', N'Abschluss nicht vor Anlegen', @ok, @info);
GO

-- T05: Stunden unter 0 werden abgelehnt (Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE zuordnung SET stunden = -1 WHERE auftrag_id = 1 AND techniker_id = 3;
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T05', N'Stunden nicht negativ', @ok, @info);
GO

-- T06: ungültige Rolle in der Zuordnung wird abgelehnt (Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO zuordnung (auftrag_id, techniker_id, rolle) VALUES (1, 5, 'chef');
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T06', N'Rolle nur verantwortlich/unterstuetzend', @ok, @info);
GO

-- T07: höchstens ein Verantwortlicher je Auftrag (Fehler 2601)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO zuordnung (auftrag_id, techniker_id, rolle) VALUES (1, 5, 'verantwortlich');
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 2601 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T07', N'Genau ein Verantwortlicher je Auftrag', @ok, @info);
GO

-- T08: Ein Eilauftrag kann nicht zusätzlich Wartungsauftrag sein (disjunkte Spezialisierung, Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    INSERT INTO wartungsauftrag (auftrag_id, geplanter_termin) VALUES (2, DATEADD(DAY, 1, SYSDATETIME()));
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T08', N'Auftrag in genau einem Untertyp', @ok, @info);
GO

-- T09: Ein Auftrag kann nicht in sich selbst zusammengelegt werden (Fehler 547)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE wartungsauftrag SET zusammengelegt_in = 1 WHERE auftrag_id = 1;
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 547 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T09', N'Nicht in sich selbst zusammenlegen', @ok, @info);
GO

-- ===================== Prozeduren =====================

-- T10: Meldung anlegen: Stand "neu", Zeitpunkt gesetzt, genau eine Beschreibung mit Nr. 1, Melder korrekt
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @mid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    EXEC p_meldung_anlegen @maschine_id = 4, @dringlichkeit = 2, @text = N'Kühlwasser tropft', @meldung_id = @mid OUTPUT;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM stoermeldung WHERE meldung_id = @mid AND stand = 'neu'
                                  AND zeitpunkt IS NOT NULL AND melder_id = 1 AND auftrag_id IS NULL)
                    AND (SELECT COUNT(*) FROM stoerungsbeschreibung WHERE meldung_id = @mid AND nr = 1) = 1
                   THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Meldung ', @mid);
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T10', N'Meldung mit Erstbeschreibung anlegen', @ok, @info);
GO

-- T11: Meldung ohne Text wird abgelehnt (Fehler 50010)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @mid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    EXEC p_meldung_anlegen @maschine_id = 4, @dringlichkeit = 2, @text = N'   ', @meldung_id = @mid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50010 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T11', N'Meldung ohne Text abgelehnt', @ok, @info);
GO

-- T12: Wartungsauftrag aus Meldung M3: Auftrag vom Typ W, Ersteller verantwortlich, Meldung "in Bearbeitung"
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_wartungsauftrag_anlegen @meldungen = '3', @geplanter_termin = '2099-01-01', @auftrag_id = @aid OUTPUT;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM auftrag a JOIN wartungsauftrag w ON w.auftrag_id = a.auftrag_id
                                 WHERE a.auftrag_id = @aid AND a.art = 'W' AND a.maschine_id = 2 AND a.stand = 'offen')
                    AND EXISTS (SELECT 1 FROM zuordnung WHERE auftrag_id = @aid AND techniker_id = 3
                                  AND rolle = 'verantwortlich' AND stunden = 0)
                    AND EXISTS (SELECT 1 FROM stoermeldung WHERE meldung_id = 3 AND auftrag_id = @aid AND stand = 'in Bearbeitung')
                   THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Auftrag ', @aid);
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T12', N'Wartungsauftrag aus Meldung anlegen', @ok, @info);
GO

-- T13: Meldungen verschiedener Maschinen in einem Wartungsauftrag werden abgelehnt (Fehler 50020)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_wartungsauftrag_anlegen @meldungen = '3,5', @geplanter_termin = '2099-01-01', @auftrag_id = @aid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50020 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T13', N'Meldungen derselben Maschine erforderlich', @ok, @info);
GO

-- T14: Wartungsauftrag ohne Meldung wird abgelehnt (Fehler 50011)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_wartungsauftrag_anlegen @meldungen = '', @geplanter_termin = '2099-01-01', @auftrag_id = @aid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50011 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T14', N'Wartungsauftrag braucht mindestens eine Meldung', @ok, @info);
GO

-- T15: Eilauftrag ohne Meldung, mit Fehlerbeschreibung
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker2';
    EXEC p_eilauftrag_anlegen @maschine_id = 4, @fehlerbeschreibung = N'Kühlkreislauf ausgefallen',
                              @melderhinweis = N'Anruf Halle 3', @auftrag_id = @aid OUTPUT;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM auftrag a JOIN eilauftrag e ON e.auftrag_id = a.auftrag_id
                                 WHERE a.auftrag_id = @aid AND a.art = 'E' AND a.maschine_id = 4)
                    AND EXISTS (SELECT 1 FROM zuordnung WHERE auftrag_id = @aid AND techniker_id = 4 AND rolle = 'verantwortlich')
                   THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Auftrag ', @aid);
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T15', N'Eilauftrag ohne Meldung anlegen', @ok, @info);
GO

-- T16: Eilauftrag ohne Fehlerbeschreibung wird abgelehnt (Fehler 50010)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker2';
    EXEC p_eilauftrag_anlegen @maschine_id = 4, @fehlerbeschreibung = N' ', @auftrag_id = @aid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50010 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T16', N'Eilauftrag braucht Fehlerbeschreibung', @ok, @info);
GO

-- ===================== Trigger =====================

-- T17: Abschluss setzt alle Meldungen des Auftrags auf "erledigt" (A1 mit M1, M2)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_auftrag_abschliessen @auftrag_id = 1;
    REVERT;
    SET @ok = CASE WHEN (SELECT COUNT(*) FROM stoermeldung WHERE auftrag_id = 1 AND stand = 'erledigt') = 2
                    AND EXISTS (SELECT 1 FROM auftrag WHERE auftrag_id = 1 AND stand = 'abgeschlossen' AND abgeschlossen_am IS NOT NULL)
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T17', N'Abschluss setzt Meldungen auf erledigt', @ok, @info);
GO

-- T18: Abschluss ohne Stunden des Verantwortlichen wird abgelehnt (Fehler 50040; A2, Roth hat 0 Stunden)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker2';
    EXEC p_auftrag_in_arbeit @auftrag_id = 2;
    EXEC p_auftrag_abschliessen @auftrag_id = 2;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50040 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T18', N'Abschluss nur mit Stunden des Verantwortlichen', @ok, @info);
GO

-- T19: Stand darf nicht zurückgehen (in Arbeit -> offen, Fehler 50041)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE auftrag SET stand = 'offen' WHERE auftrag_id = 1;
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 50041 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T19', N'Keine Rückschritte im Auftragsstand', @ok, @info);
GO

-- T20: Meldung und Auftrag müssen dieselbe Maschine betreffen, auch bei direkter Änderung (Fehler 50020)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    UPDATE stoermeldung SET auftrag_id = 1 WHERE meldung_id = 3; -- M3 betrifft Spritzguss 2, A1 Spritzguss 1
END TRY
BEGIN CATCH
    SET @ok = CASE WHEN ERROR_NUMBER() = 50020 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T20', N'Meldung und Auftrag: gleiche Maschine', @ok, @info);
GO

-- T21: Zusammenlegen zweier Wartungsaufträge derselben Maschine (A1 und neuer Auftrag aus M5)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @neu INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_wartungsauftrag_anlegen @meldungen = '5', @geplanter_termin = '2099-01-01', @auftrag_id = @neu OUTPUT;
    DECLARE @liste VARCHAR(20) = CAST(@neu AS VARCHAR(20));
    EXEC p_auftraege_zusammenlegen @hauptauftrag_id = 1, @andere = @liste;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM wartungsauftrag WHERE auftrag_id = @neu AND zusammengelegt_in = 1)
                    AND EXISTS (SELECT 1 FROM auftrag WHERE auftrag_id = @neu AND stand = 'zusammengelegt')
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T21', N'Zusammenlegen derselben Maschine', @ok, @info);
GO

-- T22: Zusammenlegen verschiedener Maschinen wird abgelehnt (A3 betrifft Handlingroboter 3, Fehler 50021)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_auftraege_zusammenlegen @hauptauftrag_id = 1, @andere = '3';
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50021 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T22', N'Zusammenlegen nur gleiche Maschine', @ok, @info);
GO

-- T23: Ein Eilauftrag kann nicht zusammengelegt werden (Fehler 50022)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @e INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker2';
    EXEC p_eilauftrag_anlegen @maschine_id = 1, @fehlerbeschreibung = N'Notstopp ausgelöst', @auftrag_id = @e OUTPUT;
    DECLARE @liste VARCHAR(20) = CAST(@e AS VARCHAR(20));
    EXEC p_auftraege_zusammenlegen @hauptauftrag_id = 1, @andere = @liste;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50022 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T23', N'Eilauftrag nicht zusammenlegbar', @ok, @info);
GO

-- T24: Abschluss des Hauptauftrags schließt zusammengelegte Aufträge und deren Meldungen mit ab
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @neu INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_wartungsauftrag_anlegen @meldungen = '5', @geplanter_termin = '2099-01-01', @auftrag_id = @neu OUTPUT;
    DECLARE @liste VARCHAR(20) = CAST(@neu AS VARCHAR(20));
    EXEC p_auftraege_zusammenlegen @hauptauftrag_id = 1, @andere = @liste;
    EXEC p_auftrag_abschliessen @auftrag_id = 1;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM auftrag k JOIN auftrag h ON h.auftrag_id = 1
                                 WHERE k.auftrag_id = @neu AND k.stand = 'abgeschlossen' AND k.abgeschlossen_am = h.abgeschlossen_am)
                    AND EXISTS (SELECT 1 FROM stoermeldung WHERE meldung_id = 5 AND stand = 'erledigt')
                    AND (SELECT COUNT(*) FROM stoermeldung WHERE meldung_id IN (1, 2) AND stand = 'erledigt') = 2
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T24', N'Abschluss des Hauptauftrags schließt Zusammengelegte mit', @ok, @info);
GO

-- ===================== Zuordnung und Stunden (v2) =====================

-- T25: Ein Techniker trägt Stunden für sich selbst ein, die der anderen bleiben unverändert
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker2';
    EXEC p_stunden_eintragen @auftrag_id = 1, @stunden = 4.0;
    REVERT;
    SET @ok = CASE WHEN (SELECT stunden FROM zuordnung WHERE auftrag_id = 1 AND techniker_id = 4) = 4.0
                    AND (SELECT stunden FROM zuordnung WHERE auftrag_id = 1 AND techniker_id = 3) = 2.5
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T25', N'Stunden nur für sich selbst eintragen', @ok, @info);
GO

-- T26: Stunden für einen Auftrag, dem man nicht zugeordnet ist, werden abgelehnt (Fehler 50031)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_stunden_eintragen @auftrag_id = 3, @stunden = 1.0; -- A3 gehört Neumann
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 50031 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T26', N'Keine Stunden für fremde Aufträge', @ok, @info);
GO

-- T27: Weiteren Techniker zuordnen
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    EXEC p_zuordnung_hinzufuegen @auftrag_id = 1, @techniker_id = 5;
    REVERT;
    SET @ok = CASE WHEN EXISTS (SELECT 1 FROM zuordnung WHERE auftrag_id = 1 AND techniker_id = 5
                                  AND rolle = 'unterstuetzend' AND stunden = 0) THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T27', N'Weiteren Techniker zuordnen', @ok, @info);
GO

-- ===================== Rechte =====================

-- T28: Mitarbeiter dürfen nicht direkt in Tabellen schreiben (Fehler 229)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    INSERT INTO stoermeldung (maschine_id, melder_id, dringlichkeit) VALUES (1, 1, 2);
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T28', N'Mitarbeiter: kein direktes INSERT', @ok, @info);
GO

-- T29: Mitarbeiter dürfen keine Aufträge anlegen (kein EXECUTE-Recht, Fehler 229)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @aid INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    EXEC p_eilauftrag_anlegen @maschine_id = 1, @fehlerbeschreibung = N'Test', @auftrag_id = @aid OUTPUT;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T29', N'Mitarbeiter: keine Aufträge anlegen', @ok, @info);
GO

-- T30: Techniker dürfen nicht direkt in die Auftragstabelle schreiben (Fehler 229)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    UPDATE auftrag SET stand = 'offen' WHERE auftrag_id = 3;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T30', N'Techniker: kein direktes UPDATE', @ok, @info);
GO

-- T31: Personalnummern sind für Mitarbeiter nicht lesbar (Fehler 229), Namen über die Sicht aber schon
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @n INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    SELECT @n = COUNT(*) FROM v_mitarbeiter;
    SELECT personalnr FROM mitarbeiter;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 AND @n = 6 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Sicht liefert ', @n, N' Zeilen; Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T31', N'Personalnummer nur für die Leitung', @ok, @info);
GO

-- T32: Die Leitung sieht die Personalnummern
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @n INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_leitung';
    SELECT @n = COUNT(personalnr) FROM mitarbeiter;
    REVERT;
    SET @ok = CASE WHEN @n = 6 THEN 1 ELSE 0 END;
    SET @info = CONCAT(@n, N' Personalnummern gelesen');
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T32', N'Leitung liest Personalnummern', @ok, @info);
GO

-- T33: Stunden und Rolle sind für Mitarbeiter gesperrt (Fehler 229), die Zuordnung ohne Stunden ist sichtbar
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde', @n INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    SELECT @n = COUNT(*) FROM v_zuordnung;
    SELECT stunden FROM zuordnung;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 AND @n = 4 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Sicht liefert ', @n, N' Zeilen; Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T33', N'Stunden nur für Leitung und Techniker selbst', @ok, @info);
GO

-- T34: Techniker sehen über ihre Sicht nur die eigenen Zuordnungen mit Stunden
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'', @alle INT, @fremde INT;
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_techniker1';
    SELECT @alle = COUNT(*), @fremde = SUM(CASE WHEN techniker_id <> 3 THEN 1 ELSE 0 END) FROM v_zuordnung_eigene;
    REVERT;
    SET @ok = CASE WHEN @alle = 1 AND ISNULL(@fremde, 0) = 0 THEN 1 ELSE 0 END;
    SET @info = CONCAT(@alle, N' Zeile(n), davon fremd: ', ISNULL(@fremde, 0));
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T34', N'Techniker sehen nur eigene Stunden', @ok, @info);
GO

-- T35: Meldung löschen: nur Leitung, Beschreibungen verschwinden mit (ON DELETE CASCADE)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_leitung';
    DELETE FROM stoermeldung WHERE meldung_id = 1;
    REVERT;
    SET @ok = CASE WHEN NOT EXISTS (SELECT 1 FROM stoermeldung WHERE meldung_id = 1)
                    AND NOT EXISTS (SELECT 1 FROM stoerungsbeschreibung WHERE meldung_id = 1)
                   THEN 1 ELSE 0 END;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T35', N'Leitung löscht Meldung samt Beschreibungen', @ok, @info);
GO

-- T36: Mitarbeiter dürfen keine Meldung löschen (Fehler 229)
DECLARE @ok BIT = 0, @info NVARCHAR(300) = N'Kein Fehler, obwohl einer erwartet wurde';
BEGIN TRANSACTION;
BEGIN TRY
    EXECUTE AS USER = 'u_mitarbeiter';
    DELETE FROM stoermeldung WHERE meldung_id = 1;
    REVERT;
END TRY
BEGIN CATCH
    IF XACT_STATE() <> 0 ROLLBACK; -- erst zurückrollen: in einer abgebrochenen Transaktion scheitert REVERT
    IF USER_NAME() <> 'dbo' REVERT;
    SET @ok = CASE WHEN ERROR_NUMBER() = 229 THEN 1 ELSE 0 END;
    SET @info = CONCAT(N'Fehler ', ERROR_NUMBER(), N': ', ERROR_MESSAGE());
END CATCH;
IF @@TRANCOUNT > 0 ROLLBACK;
INSERT INTO #ergebnis VALUES ('T36', N'Mitarbeiter: kein DELETE auf Meldungen', @ok, @info);
GO

-- ===================== Ergebnis =====================
SELECT test, beschreibung, CASE ok WHEN 1 THEN 'PASS' ELSE 'FAIL' END AS ergebnis, info FROM #ergebnis ORDER BY test;
SELECT SUM(CASE WHEN ok = 1 THEN 1 ELSE 0 END) AS bestanden, SUM(CASE WHEN ok = 0 THEN 1 ELSE 0 END) AS fehlgeschlagen FROM #ergebnis;
GO
