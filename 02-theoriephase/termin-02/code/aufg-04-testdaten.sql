INSERT INTO REAKTOR (reaktor_id, saeureresistent) VALUES
    ('R-02', 1),
    ('R-05', 0);

INSERT INTO REZEPT (rezept_id) VALUES
    ('LAK-100'),
    ('LAK-220');

INSERT INTO REZEPT_PARAMETER (rezept_id, parameter_name, wert) VALUES
    ('LAK-100', 'T_soll',   85),
    ('LAK-100', 't_ruehr', 120),
    ('LAK-100', 'n_ruehr', 300),
    ('LAK-220', 'T_soll',   70),
    ('LAK-220', 't_ruehr',  90),
    ('LAK-220', 'n_ruehr', 250);

INSERT INTO CHARGE (charge_nr, reaktor_id, rezept_id) VALUES
    (4711, 'R-02', 'LAK-100'),
    (4712, 'R-05', 'LAK-220');

INSERT INTO PROZESSWERT (charge_nr, zeitstempel, viskositaet, temperatur, fuellstand) VALUES
    (4711, '2026-10-12 08:00:00', 128, 62.4, 78),
    (4711, '2026-10-12 08:00:30', 131, 63.1, 78),
    (4711, '2026-10-12 08:01:00', 135, 64.0, 78),
    (4712, '2026-10-12 11:30:00',  96, 58.2, 65);
