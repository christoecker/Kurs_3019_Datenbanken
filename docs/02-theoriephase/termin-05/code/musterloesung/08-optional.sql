-- Optionaler Teil: Fremdaufträge (nur Leitung), Beschreibung ergänzen
-- Die Tabelle fremdauftrag liegt schon in 01-schema.sql.
USE Instandhaltung;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Fremdauftrag anlegen (nur Leitung). Ein intern zuständiger Techniker betreut die Fremdfirma.
CREATE PROCEDURE dbo.p_fremdauftrag_anlegen
    @maschine_id  INT,
    @fremdfirma   NVARCHAR(100),
    @betreuer_id  INT,            -- Techniker, der die Fremdfirma intern betreut
    @meldungen    VARCHAR(200) = NULL,
    @auftrag_id   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    IF LEN(LTRIM(RTRIM(ISNULL(@fremdfirma, N'')))) = 0
        THROW 50010, 'Ein Fremdauftrag braucht den Namen der Fremdfirma.', 1;

    DECLARE @ids TABLE (id INT PRIMARY KEY);
    IF @meldungen IS NOT NULL
    BEGIN
        INSERT INTO @ids
        SELECT DISTINCT TRY_CAST(LTRIM(RTRIM(value)) AS INT)
        FROM STRING_SPLIT(@meldungen, ',')
        WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) IS NOT NULL;
        IF EXISTS (SELECT 1 FROM dbo.stoermeldung
                   WHERE meldung_id IN (SELECT id FROM @ids)
                     AND (auftrag_id IS NOT NULL OR stand = 'erledigt' OR maschine_id <> @maschine_id))
            THROW 50012, 'Mindestens eine Meldung ist unzulässig (hat Auftrag, erledigt oder andere Maschine).', 1;
    END;

    BEGIN TRANSACTION;
    INSERT INTO dbo.auftrag (art, maschine_id) VALUES ('F', @maschine_id);
    SET @auftrag_id = SCOPE_IDENTITY();
    INSERT INTO dbo.fremdauftrag (auftrag_id, fremdfirma) VALUES (@auftrag_id, @fremdfirma);
    INSERT INTO dbo.zuordnung (auftrag_id, techniker_id, rolle) VALUES (@auftrag_id, @betreuer_id, 'verantwortlich');
    UPDATE dbo.stoermeldung SET auftrag_id = @auftrag_id, stand = 'in Bearbeitung'
    WHERE meldung_id IN (SELECT id FROM @ids);
    COMMIT;
END;
GO

-- Beschreibung zu einer bestehenden Meldung ergänzen; die nächste laufende Nummer wird selbst vergeben
CREATE PROCEDURE dbo.p_beschreibung_ergaenzen
    @meldung_id INT,
    @text       NVARCHAR(500)
AS
BEGIN
    SET NOCOUNT ON;
    SET XACT_ABORT ON;

    DECLARE @ich INT = dbo.f_aktueller_mitarbeiter();
    IF @ich IS NULL
        THROW 50001, 'Der Benutzer ist keinem Beschäftigten zugeordnet.', 1;
    IF NOT EXISTS (SELECT 1 FROM dbo.stoermeldung WHERE meldung_id = @meldung_id AND stand <> 'erledigt')
        THROW 50011, 'Die Meldung existiert nicht oder ist schon erledigt.', 1;

    BEGIN TRANSACTION;
    DECLARE @nr SMALLINT;
    -- UPDLOCK/HOLDLOCK: zwei gleichzeitige Ergänzungen dürfen nicht dieselbe Nummer erhalten
    SELECT @nr = ISNULL(MAX(nr), 0) + 1
    FROM dbo.stoerungsbeschreibung WITH (UPDLOCK, HOLDLOCK)
    WHERE meldung_id = @meldung_id;

    INSERT INTO dbo.stoerungsbeschreibung (meldung_id, nr, text, verfasser_id)
    VALUES (@meldung_id, @nr, @text, @ich);
    COMMIT;
END;
GO

GRANT EXECUTE ON p_fremdauftrag_anlegen   TO r_leitung;
GRANT EXECUTE ON p_beschreibung_ergaenzen TO r_mitarbeiter;
GO
