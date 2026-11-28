-- Testdaten (Stand v2): 6 Beschäftigte (3 Techniker), 4 Maschinen, 5 Meldungen, 3 Aufträge
-- Direkte INSERTs als Besitzer (dbo); die Prozeduren werden in 07-tests.sql geprüft.
USE Instandhaltung;
GO
SET QUOTED_IDENTIFIER ON;
GO

INSERT INTO mitarbeiter (name, personalnr, db_benutzer) VALUES
    (N'Anna Kaya',     '100001', 'u_mitarbeiter'), -- 1  Beschäftigte
    (N'Jonas Lenz',    '100002', NULL),            -- 2  Beschäftigter (ohne Benutzer)
    (N'Tom Becker',    '200001', 'u_techniker1'),  -- 3  Techniker Elektrik
    (N'Ines Roth',     '200002', 'u_techniker2'),  -- 4  Techniker Mechanik
    (N'Paul Neumann',  '200003', NULL),            -- 5  Techniker Steuerung/SPS
    (N'Sabine Vogel',  '900001', 'u_leitung');     -- 6  Leitung

INSERT INTO techniker (mitarbeiter_id, fachgebiet) VALUES
    (3, 'Elektrik'), (4, 'Mechanik'), (5, 'Steuerung/SPS');

INSERT INTO maschine (bezeichnung, halle, wichtigkeit, zustand) VALUES
    (N'Spritzguss 1',      1, 1, 'in Betrieb'),  -- 1
    (N'Spritzguss 2',      1, 2, 'in Betrieb'),  -- 2
    (N'Handlingroboter 3', 2, 2, 'gestoert'),    -- 3
    (N'Kühlanlage 4',      3, 3, 'in Betrieb');  -- 4

-- Aufträge: A1 Wartung Spritzguss 1, A2 Eilauftrag Spritzguss 2, A3 Wartung Handlingroboter 3
INSERT INTO auftrag (art, maschine_id, stand) VALUES ('W', 1, 'in Arbeit'); -- 1
INSERT INTO wartungsauftrag (auftrag_id, geplanter_termin) VALUES (1, DATEADD(DAY, 2, SYSDATETIME()));
INSERT INTO auftrag (art, maschine_id, stand) VALUES ('E', 2, 'offen');     -- 2
INSERT INTO eilauftrag (auftrag_id, fehlerbeschreibung, melderhinweis)
VALUES (2, N'Hydraulikdruck bricht ein, Maschine steht', N'Anruf von Schichtführer Weber');
INSERT INTO auftrag (art, maschine_id, stand) VALUES ('W', 3, 'offen');     -- 3
INSERT INTO wartungsauftrag (auftrag_id, geplanter_termin) VALUES (3, DATEADD(DAY, 5, SYSDATETIME()));

INSERT INTO zuordnung (auftrag_id, techniker_id, rolle, stunden) VALUES
    (1, 3, 'verantwortlich',  2.5),
    (1, 4, 'unterstuetzend',  1.0),
    (2, 4, 'verantwortlich',  0),
    (3, 5, 'verantwortlich',  0);

-- Meldungen: M1, M2 -> A1; M3 neu (Spritzguss 2); M4 -> A3; M5 neu (Spritzguss 1)
INSERT INTO stoermeldung (maschine_id, melder_id, dringlichkeit, stand, auftrag_id) VALUES
    (1, 1, 3, 'in Bearbeitung', 1),     -- M1
    (1, 2, 2, 'in Bearbeitung', 1),     -- M2
    (2, 1, 2, 'neu',            NULL),  -- M3
    (3, 5, 1, 'in Bearbeitung', 3),     -- M4
    (1, 1, 2, 'neu',            NULL);  -- M5

INSERT INTO stoerungsbeschreibung (meldung_id, nr, text, verfasser_id) VALUES
    (1, 1, N'Maschine fährt nicht an, Fehlermeldung am Display', 1),
    (1, 2, N'Tritt jetzt häufiger auf, zusätzlich laute Geräusche', 2),
    (2, 1, N'Werkzeugtemperatur schwankt stark', 2),
    (3, 1, N'Schließeinheit hakt gelegentlich', 1),
    (4, 1, N'Greifer verliert Teile', 5),
    (5, 1, N'Ölgeruch an der Einspritzeinheit', 1);
GO
