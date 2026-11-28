-- Rollen, Benutzer, Sichten und Rechte (Stand v2)
-- Rechte ausschließlich über Datenbankrollen: r_mitarbeiter, r_techniker, r_leitung.
-- Für den Test werden Benutzer OHNE Login angelegt (nur zum Testen per EXECUTE AS);
-- im Betrieb wäre es CREATE LOGIN ... + CREATE USER ... FOR LOGIN ....
USE Instandhaltung;
GO
SET QUOTED_IDENTIFIER ON;
GO

-- Sichten: Namen für alle, Personalnummer und Stunden bleiben gesperrt
CREATE VIEW v_mitarbeiter AS
SELECT mitarbeiter_id, name FROM mitarbeiter; -- ohne personalnr und db_benutzer
GO

-- Wer ist einem Auftrag zugeordnet? (ohne Rolle und Stunden)
CREATE VIEW v_zuordnung AS
SELECT auftrag_id, techniker_id FROM zuordnung;
GO

-- Eigene Zuordnungen mit Rolle und Stunden: nur die Zeilen des aufrufenden Technikers
CREATE VIEW v_zuordnung_eigene AS
SELECT auftrag_id, techniker_id, rolle, stunden
FROM zuordnung
WHERE techniker_id = dbo.f_aktueller_mitarbeiter();
GO

-- Rollen
CREATE ROLE r_mitarbeiter;
CREATE ROLE r_techniker;
CREATE ROLE r_leitung;
GO
-- Techniker und Leitung sind auch Beschäftigte und dürfen alles, was Mitarbeiter dürfen.
-- Achtung: Es gibt bewusst kein DENY auf r_mitarbeiter, sonst würden Techniker und Leitung es erben.
ALTER ROLE r_mitarbeiter ADD MEMBER r_techniker;
ALTER ROLE r_mitarbeiter ADD MEMBER r_leitung;
GO

-- Mitarbeiter: lesen (Transparenz), melden über Prozedur, sonst nichts
GRANT SELECT ON maschine               TO r_mitarbeiter;
GRANT SELECT ON stoermeldung           TO r_mitarbeiter;
GRANT SELECT ON stoerungsbeschreibung  TO r_mitarbeiter;
GRANT SELECT ON auftrag                TO r_mitarbeiter;
GRANT SELECT ON wartungsauftrag        TO r_mitarbeiter;
GRANT SELECT ON eilauftrag             TO r_mitarbeiter;
GRANT SELECT ON fremdauftrag           TO r_mitarbeiter;
GRANT SELECT ON techniker              TO r_mitarbeiter;
GRANT SELECT ON v_mitarbeiter          TO r_mitarbeiter;
GRANT SELECT ON v_zuordnung            TO r_mitarbeiter;
GRANT EXECUTE ON p_meldung_anlegen     TO r_mitarbeiter;
GO

-- Techniker: Aufträge anlegen und bearbeiten, ausschließlich über Prozeduren
GRANT SELECT ON v_zuordnung_eigene            TO r_techniker;
GRANT EXECUTE ON p_wartungsauftrag_anlegen    TO r_techniker;
GRANT EXECUTE ON p_eilauftrag_anlegen         TO r_techniker;
GRANT EXECUTE ON p_auftraege_zusammenlegen    TO r_techniker;
GRANT EXECUTE ON p_zuordnung_hinzufuegen      TO r_techniker;
GRANT EXECUTE ON p_stunden_eintragen          TO r_techniker;
GRANT EXECUTE ON p_auftrag_in_arbeit          TO r_techniker;
GRANT EXECUTE ON p_auftrag_abschliessen       TO r_techniker;
GO

-- Leitung: alles lesen, Stammdaten verwalten, Meldungen löschen
GRANT SELECT ON mitarbeiter       TO r_leitung;
GRANT SELECT ON zuordnung         TO r_leitung;
GRANT INSERT, UPDATE, DELETE ON mitarbeiter TO r_leitung;
GRANT INSERT, UPDATE, DELETE ON techniker   TO r_leitung;
GRANT INSERT, UPDATE, DELETE ON maschine    TO r_leitung;
GRANT DELETE ON stoermeldung      TO r_leitung; -- Beschreibungen werden per ON DELETE CASCADE mitgelöscht
GO

-- Testbenutzer (ohne Login) und Rollenzuordnung
CREATE USER u_mitarbeiter WITHOUT LOGIN;
CREATE USER u_techniker1  WITHOUT LOGIN;
CREATE USER u_techniker2  WITHOUT LOGIN;
CREATE USER u_leitung     WITHOUT LOGIN;
GO
ALTER ROLE r_mitarbeiter ADD MEMBER u_mitarbeiter;
ALTER ROLE r_techniker   ADD MEMBER u_techniker1;
ALTER ROLE r_techniker   ADD MEMBER u_techniker2;
ALTER ROLE r_leitung     ADD MEMBER u_leitung;
GO
