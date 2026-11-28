-- Messreihe: Stammdaten der Sensoren und einige Messwerte
-- Voraussetzung: Tabellen sensor und messwert (Aufgabe 10, Teil B)
INSERT INTO sensor (sensor_id, bezeichnung, einheit) VALUES (1, 'Temperatur Ofen',   'Grad C');
INSERT INTO sensor (sensor_id, bezeichnung, einheit) VALUES (2, 'Druck Hydraulik',   'bar');
INSERT INTO sensor (sensor_id, bezeichnung, einheit) VALUES (3, 'Drehzahl Spindel',  '1/min');

INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (1, '2026-12-01 08:00:00',  181.5);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (1, '2026-12-01 08:10:00',  184.2);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (1, '2026-12-01 08:20:00',  190.8);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (1, '2026-12-02 08:00:00',  179.9);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (2, '2026-12-01 08:00:00',  148.0);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (2, '2026-12-01 08:10:00',  151.5);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (2, '2026-12-01 08:20:00',  149.7);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (2, '2026-12-02 08:00:00',  147.2);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (3, '2026-12-01 08:00:00', 1200.0);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (3, '2026-12-01 08:10:00', 1195.5);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (3, '2026-12-01 08:20:00', 1210.0);
INSERT INTO messwert (sensor_id, zeitpunkt, wert) VALUES (3, '2026-12-02 08:00:00', 1188.0);
