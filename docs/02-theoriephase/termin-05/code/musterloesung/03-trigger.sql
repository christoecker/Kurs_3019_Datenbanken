-- Trigger (Pflichtteil, Stand v2)
USE Instandhaltung;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- 1) Eine Meldung muss dieselbe Maschine betreffen wie ihr Auftrag (unabhängig davon, wer sie ändert)
CREATE TRIGGER tr_meldung_maschine
ON stoermeldung
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF EXISTS (SELECT 1
               FROM inserted i
               JOIN auftrag a ON a.auftrag_id = i.auftrag_id
               WHERE a.maschine_id <> i.maschine_id)
        THROW 50020, 'Meldung und Auftrag betreffen verschiedene Maschinen.', 1;
END;
GO

-- 2) Zusammenlegen: gleiche Maschine, Hauptauftrag nicht selbst zusammengelegt, keine Ketten
CREATE TRIGGER tr_wartung_zusammenlegen
ON wartungsauftrag
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(zusammengelegt_in) RETURN;

    -- gleiche Maschine
    IF EXISTS (SELECT 1
               FROM inserted i
               JOIN auftrag a_neu  ON a_neu.auftrag_id  = i.auftrag_id
               JOIN auftrag a_haupt ON a_haupt.auftrag_id = i.zusammengelegt_in
               WHERE a_neu.maschine_id <> a_haupt.maschine_id)
        THROW 50021, 'Zusammenlegen ist nur für Aufträge derselben Maschine erlaubt.', 1;

    -- Hauptauftrag darf nicht selbst zusammengelegt oder abgeschlossen sein
    IF EXISTS (SELECT 1
               FROM inserted i
               JOIN wartungsauftrag h ON h.auftrag_id = i.zusammengelegt_in
               JOIN auftrag ah        ON ah.auftrag_id = h.auftrag_id
               WHERE h.zusammengelegt_in IS NOT NULL OR ah.stand = 'abgeschlossen')
        THROW 50023, 'Der Hauptauftrag ist selbst zusammengelegt oder abgeschlossen.', 1;

    -- ein Auftrag, in den schon andere zusammengelegt wurden, kann nicht selbst zusammengelegt werden
    IF EXISTS (SELECT 1
               FROM inserted i
               JOIN wartungsauftrag k ON k.zusammengelegt_in = i.auftrag_id
               WHERE i.zusammengelegt_in IS NOT NULL)
        THROW 50023, 'In diesen Auftrag wurden schon andere zusammengelegt (keine Ketten).', 1;

    -- bereits abgeschlossene Aufträge werden nicht zusammengelegt
    IF EXISTS (SELECT 1
               FROM inserted i
               JOIN auftrag a ON a.auftrag_id = i.auftrag_id
               WHERE i.zusammengelegt_in IS NOT NULL AND a.stand = 'abgeschlossen')
        THROW 50024, 'Ein abgeschlossener Auftrag kann nicht zusammengelegt werden.', 1;
END;
GO

-- 3) Auftragsstand: erlaubte Wechsel, Abschluss nur mit Stunden des Verantwortlichen,
--    Abschluss-Kaskade auf Meldungen und zusammengelegte Aufträge
CREATE TRIGGER tr_auftrag_stand
ON auftrag
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF NOT UPDATE(stand) RETURN;

    -- erlaubt: offen -> in Arbeit, in Arbeit -> abgeschlossen, offen/in Arbeit -> zusammengelegt,
    --          zusammengelegt -> abgeschlossen (nur durch die Kaskade unten)
    IF EXISTS (SELECT 1
               FROM inserted i JOIN deleted d ON d.auftrag_id = i.auftrag_id
               WHERE i.stand <> d.stand
                 AND NOT ( (d.stand = 'offen'     AND i.stand IN ('in Arbeit', 'zusammengelegt'))
                        OR (d.stand = 'in Arbeit' AND i.stand IN ('abgeschlossen', 'zusammengelegt'))
                        OR (d.stand = 'zusammengelegt' AND i.stand = 'abgeschlossen') ))
        THROW 50041, 'Dieser Wechsel des Auftragsstands ist nicht erlaubt.', 1;

    -- Abschluss: der Verantwortliche muss Stunden eingetragen haben (gilt nicht für zusammengelegte Aufträge)
    IF EXISTS (SELECT 1
               FROM inserted i JOIN deleted d ON d.auftrag_id = i.auftrag_id
               WHERE i.stand = 'abgeschlossen' AND d.stand = 'in Arbeit'
                 AND NOT EXISTS (SELECT 1 FROM zuordnung z
                                 WHERE z.auftrag_id = i.auftrag_id AND z.rolle = 'verantwortlich' AND z.stunden > 0))
        THROW 50040, 'Abschluss nicht möglich: Für den Verantwortlichen sind keine Stunden eingetragen.', 1;

    -- Kaskade 1: zusammengelegte Aufträge werden mit abgeschlossen (gleiches Abschlussdatum)
    UPDATE a
    SET a.stand = 'abgeschlossen', a.abgeschlossen_am = i.abgeschlossen_am
    FROM auftrag a
    JOIN wartungsauftrag w ON w.auftrag_id = a.auftrag_id
    JOIN inserted i        ON i.auftrag_id = w.zusammengelegt_in
    JOIN deleted d         ON d.auftrag_id = i.auftrag_id
    WHERE i.stand = 'abgeschlossen' AND d.stand <> 'abgeschlossen' AND a.stand = 'zusammengelegt';

    -- Kaskade 2: Meldungen des Auftrags und der zusammengelegten Aufträge werden erledigt
    UPDATE m
    SET m.stand = 'erledigt'
    FROM stoermeldung m
    WHERE m.stand <> 'erledigt'
      AND ( m.auftrag_id IN (SELECT i.auftrag_id
                             FROM inserted i JOIN deleted d ON d.auftrag_id = i.auftrag_id
                             WHERE i.stand = 'abgeschlossen' AND d.stand <> 'abgeschlossen')
         OR m.auftrag_id IN (SELECT w.auftrag_id
                             FROM wartungsauftrag w
                             JOIN inserted i ON i.auftrag_id = w.zusammengelegt_in
                             JOIN deleted d  ON d.auftrag_id = i.auftrag_id
                             WHERE i.stand = 'abgeschlossen' AND d.stand <> 'abgeschlossen') );
END;
GO
