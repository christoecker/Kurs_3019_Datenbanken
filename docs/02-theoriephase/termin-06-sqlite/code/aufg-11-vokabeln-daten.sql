-- Vokabeltrainer: Lektionen und Vokabeln (Technik-Englisch)
-- Voraussetzung: Tabellen lektion und vokabel (Aufgabe 11, Teil A)
INSERT INTO lektion (lektion_id, titel) VALUES (1, 'Mechanik');
INSERT INTO lektion (lektion_id, titel) VALUES (2, 'Elektrik');
INSERT INTO lektion (lektion_id, titel) VALUES (3, 'Steuerung');
INSERT INTO lektion (lektion_id, titel) VALUES (4, 'Pneumatik');

INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (1, 'shaft',        'Welle');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (1, 'bearing',      'Lager');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (1, 'gear',         'Zahnrad');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (1, 'screw',        'Schraube');

INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (2, 'voltage',      'Spannung');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (2, 'current',      'Strom');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (2, 'fuse',         'Sicherung');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (2, 'wire',         'Leitung');

INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (3, 'limit switch', 'Endschalter');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (3, 'actuator',     'Aktor');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (3, 'setpoint',     'Sollwert');
INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (3, 'it''s broken', 'es ist kaputt');
-- Lektion 4 (Pneumatik) hat bewusst noch keine Vokabeln.
