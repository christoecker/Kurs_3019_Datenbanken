-- Prozeduren und Hilfsfunktion (Pflichtteil, Stand v2)
-- Fehlernummern (THROW):
--   50001 Benutzer ist keinem Beschäftigten zugeordnet     50002 Beschäftigter ist kein Techniker
--   50010 Text leer                                        50011 Meldung nicht gefunden
--   50012 Meldung hat schon einen Auftrag oder ist erledigt 50020 Meldungen betreffen verschiedene Maschinen
--   50021 Zusammenlegen: verschiedene Maschinen            50022 Zusammenlegen: kein Wartungsauftrag
--   50023 Zusammenlegen: Hauptauftrag/Kette unzulässig     50024 Auftrag schon abgeschlossen/zusammengelegt
--   50030 Termin liegt in der Vergangenheit                50031 keine Zuordnung zu diesem Auftrag
--   50040 Abschluss ohne Stunden des Verantwortlichen      50041 Statuswechsel nicht erlaubt
USE Instandhaltung;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Welcher Beschäftigte gehört zum aufrufenden Datenbankbenutzer?
CREATE FUNCTION dbo.f_aktueller_mitarbeiter() RETURNS INT
AS
BEGIN
    RETURN (SELECT mitarbeiter_id FROM dbo.mitarbeiter WHERE db_benutzer = USER_NAME());
END;
GO

-- Meldung samt Erstbeschreibung anlegen (alle Beschäftigten)
CREATE PROCEDURE dbo.p_meldung_anlegen
    @maschine_id   INT,
    @dringlichkeit TINYINT,
    @text          NVARCHAR(500),
    @meldung_id    INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON; -- jeder Fehler nimmt die ganze Transaktion zurück

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL
        THROW 50001, 'Der Benutzer ist keinem Beschäftigten zugeordnet.', 1;
    IF LEN(LTRIM(RTRIM(ISNULL(@text, N'')))) = 0
        THROW 50010, 'Eine Meldung braucht eine Beschreibung.', 1;

    BEGIN TRANSACTION;
    INSERT INTO dbo.stoermeldung (maschine_id, melder_id, dringlichkeit)
    VALUES (@maschine_id, @ich, @dringlichkeit);
    SET @meldung_id = SCOPE_IDENTITY();

    INSERT INTO dbo.stoerungsbeschreibung (meldung_id, nr, text, verfasser_id)
    VALUES (@meldung_id, 1, @text, @ich);
    COMMIT;
END;
GO

-- Wartungsauftrag aus einer oder mehreren Meldungen derselben Maschine anlegen (Techniker)
-- @meldungen: Liste der Meldungsnummern, z. B. '3,5'
CREATE PROCEDURE dbo.p_wartungsauftrag_anlegen
    @meldungen        VARCHAR(200),
    @geplanter_termin DATETIME2(0),
    @auftrag_id       INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL
        THROW 50001, 'Der Benutzer ist keinem Beschäftigten zugeordnet.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.techniker WHERE mitarbeiter_id = @ich)
        THROW 50002, 'Nur Techniker dürfen Aufträge anlegen.', 1;
    IF @geplanter_termin < SYSDATETIME()
        THROW 50030, 'Der geplante Termin darf nicht in der Vergangenheit liegen.', 1;

    DECLARE @ids TABLE (id INT PRIMARY KEY);
    INSERT INTO @ids
    SELECT DISTINCT TRY_CAST(LTRIM(RTRIM(value)) AS INT)
    FROM STRING_SPLIT(@meldungen, ',')
    WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) IS NOT NULL;

    IF (SELECT COUNT(*) FROM @ids) = 0
        THROW 50011, 'Ein Wartungsauftrag braucht mindestens eine Meldung.', 1;
    IF (SELECT COUNT(*) FROM dbo.stoermeldung WHERE meldung_id IN (SELECT id FROM @ids)) <> (SELECT COUNT(*) FROM @ids)
        THROW 50011, 'Mindestens eine Meldung existiert nicht.', 1;
    IF EXISTS (SELECT 1 FROM dbo.stoermeldung
               WHERE meldung_id IN (SELECT id FROM @ids) AND (auftrag_id IS NOT NULL OR stand = 'erledigt'))
        THROW 50012, 'Mindestens eine Meldung gehört schon zu einem Auftrag oder ist erledigt.', 1;

    DECLARE @maschine INT;
    IF (SELECT COUNT(DISTINCT maschine_id) FROM dbo.stoermeldung WHERE meldung_id IN (SELECT id FROM @ids)) <> 1
        THROW 50020, 'Die Meldungen betreffen verschiedene Maschinen.', 1;
    SELECT @maschine = MIN(maschine_id) FROM dbo.stoermeldung WHERE meldung_id IN (SELECT id FROM @ids);

    BEGIN TRANSACTION;
    INSERT INTO dbo.auftrag (art, maschine_id) VALUES ('W', @maschine);
    SET @auftrag_id = SCOPE_IDENTITY();
    INSERT INTO dbo.wartungsauftrag (auftrag_id, geplanter_termin) VALUES (@auftrag_id, @geplanter_termin);
    INSERT INTO dbo.zuordnung (auftrag_id, techniker_id, rolle) VALUES (@auftrag_id, @ich, 'verantwortlich');

    UPDATE dbo.stoermeldung
    SET auftrag_id = @auftrag_id, stand = 'in Bearbeitung'
    WHERE meldung_id IN (SELECT id FROM @ids);
    COMMIT;
END;
GO

-- Eilauftrag anlegen (jeder Techniker, auch ohne Meldung, z. B. telefonisch gemeldet)
CREATE PROCEDURE dbo.p_eilauftrag_anlegen
    @maschine_id        INT,
    @fehlerbeschreibung NVARCHAR(500),
    @melderhinweis      NVARCHAR(200) = NULL,
    @meldungen          VARCHAR(200)  = NULL, -- optional: schon vorhandene Meldungen derselben Maschine
    @auftrag_id         INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL
        THROW 50001, 'Der Benutzer ist keinem Beschäftigten zugeordnet.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.techniker WHERE mitarbeiter_id = @ich)
        THROW 50002, 'Nur Techniker dürfen Aufträge anlegen.', 1;
    IF LEN(LTRIM(RTRIM(ISNULL(@fehlerbeschreibung, N'')))) = 0
        THROW 50010, 'Ein Eilauftrag braucht eine Fehlerbeschreibung.', 1;

    DECLARE @ids TABLE (id INT PRIMARY KEY);
    IF @meldungen IS NOT NULL
    BEGIN
        INSERT INTO @ids
        SELECT DISTINCT TRY_CAST(LTRIM(RTRIM(value)) AS INT)
        FROM STRING_SPLIT(@meldungen, ',')
        WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) IS NOT NULL;

        IF (SELECT COUNT(*) FROM dbo.stoermeldung WHERE meldung_id IN (SELECT id FROM @ids)) <> (SELECT COUNT(*) FROM @ids)
            THROW 50011, 'Mindestens eine Meldung existiert nicht.', 1;
        IF EXISTS (SELECT 1 FROM dbo.stoermeldung
                   WHERE meldung_id IN (SELECT id FROM @ids) AND (auftrag_id IS NOT NULL OR stand = 'erledigt'))
            THROW 50012, 'Mindestens eine Meldung gehört schon zu einem Auftrag oder ist erledigt.', 1;
        IF EXISTS (SELECT 1 FROM dbo.stoermeldung WHERE meldung_id IN (SELECT id FROM @ids) AND maschine_id <> @maschine_id)
            THROW 50020, 'Mindestens eine Meldung betrifft eine andere Maschine.', 1;
    END;

    BEGIN TRANSACTION;
    INSERT INTO dbo.auftrag (art, maschine_id) VALUES ('E', @maschine_id);
    SET @auftrag_id = SCOPE_IDENTITY();
    INSERT INTO dbo.eilauftrag (auftrag_id, fehlerbeschreibung, melderhinweis)
    VALUES (@auftrag_id, @fehlerbeschreibung, @melderhinweis);
    INSERT INTO dbo.zuordnung (auftrag_id, techniker_id, rolle) VALUES (@auftrag_id, @ich, 'verantwortlich');

    UPDATE dbo.stoermeldung
    SET auftrag_id = @auftrag_id, stand = 'in Bearbeitung'
    WHERE meldung_id IN (SELECT id FROM @ids);
    COMMIT;
END;
GO

-- Wartungsaufträge zu einem Hauptauftrag zusammenlegen (Techniker)
-- Die fachlichen Regeln (gleiche Maschine, keine Ketten, nicht abgeschlossen) prüft der Trigger tr_wartung_zusammenlegen.
CREATE PROCEDURE dbo.p_auftraege_zusammenlegen
    @hauptauftrag_id INT,
    @andere          VARCHAR(200) -- Liste der Auftragsnummern, die im Hauptauftrag aufgehen
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL
        THROW 50001, 'Der Benutzer ist keinem Beschäftigten zugeordnet.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.techniker WHERE mitarbeiter_id = @ich)
        THROW 50002, 'Nur Techniker dürfen Aufträge zusammenlegen.', 1;

    DECLARE @ids TABLE (id INT PRIMARY KEY);
    INSERT INTO @ids
    SELECT DISTINCT TRY_CAST(LTRIM(RTRIM(value)) AS INT)
    FROM STRING_SPLIT(@andere, ',')
    WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) IS NOT NULL;

    -- Eilaufträge und Fremdaufträge sind keine Wartungsaufträge und können nicht zusammengelegt werden
    IF EXISTS (SELECT 1 FROM @ids WHERE id NOT IN (SELECT auftrag_id FROM dbo.wartungsauftrag))
       OR @hauptauftrag_id NOT IN (SELECT auftrag_id FROM dbo.wartungsauftrag)
        THROW 50022, 'Nur Wartungsaufträge können zusammengelegt werden.', 1;

    BEGIN TRANSACTION;
    UPDATE dbo.wartungsauftrag SET zusammengelegt_in = @hauptauftrag_id WHERE auftrag_id IN (SELECT id FROM @ids);
    UPDATE dbo.auftrag SET stand = 'zusammengelegt' WHERE auftrag_id IN (SELECT id FROM @ids);
    COMMIT;
END;
GO

-- Weiteren Techniker einem Auftrag zuordnen (Techniker)
CREATE PROCEDURE dbo.p_zuordnung_hinzufuegen
    @auftrag_id   INT,
    @techniker_id INT,
    @rolle        VARCHAR(20) = 'unterstuetzend'
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.techniker WHERE mitarbeiter_id = @ich)
        THROW 50002, 'Nur Techniker dürfen Techniker zuordnen.', 1;
    IF EXISTS (SELECT 1 FROM dbo.auftrag WHERE auftrag_id = @auftrag_id AND stand IN ('abgeschlossen', 'zusammengelegt'))
        THROW 50024, 'Der Auftrag ist abgeschlossen oder zusammengelegt.', 1;

    INSERT INTO dbo.zuordnung (auftrag_id, techniker_id, rolle) VALUES (@auftrag_id, @techniker_id, @rolle);
END;
GO

-- Stunden eintragen: jeder Techniker nur für sich selbst
CREATE PROCEDURE dbo.p_stunden_eintragen
    @auftrag_id INT,
    @stunden    DECIMAL(5,1)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF NOT EXISTS (SELECT 1 FROM dbo.zuordnung WHERE auftrag_id = @auftrag_id AND techniker_id = @ich)
        THROW 50031, 'Sie sind diesem Auftrag nicht zugeordnet.', 1;
    IF EXISTS (SELECT 1 FROM dbo.auftrag WHERE auftrag_id = @auftrag_id AND stand IN ('abgeschlossen', 'zusammengelegt'))
        THROW 50024, 'Der Auftrag ist abgeschlossen oder zusammengelegt.', 1;

    UPDATE dbo.zuordnung SET stunden = @stunden WHERE auftrag_id = @auftrag_id AND techniker_id = @ich;
END;
GO

-- Auftrag in Arbeit nehmen
CREATE PROCEDURE dbo.p_auftrag_in_arbeit
    @auftrag_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.techniker WHERE mitarbeiter_id = @ich)
        THROW 50002, 'Nur Techniker dürfen Aufträge bearbeiten.', 1;

    UPDATE dbo.auftrag SET stand = 'in Arbeit' WHERE auftrag_id = @auftrag_id; -- Regeln prüft tr_auftrag_stand
END;
GO

-- Auftrag abschließen (Regeln und Folgen: tr_auftrag_stand)
CREATE PROCEDURE dbo.p_auftrag_abschliessen
    @auftrag_id INT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL OR NOT EXISTS (SELECT 1 FROM dbo.techniker WHERE mitarbeiter_id = @ich)
        THROW 50002, 'Nur Techniker dürfen Aufträge abschließen.', 1;

    UPDATE dbo.auftrag SET stand = 'abgeschlossen', abgeschlossen_am = SYSDATETIME() WHERE auftrag_id = @auftrag_id;
END;
GO
