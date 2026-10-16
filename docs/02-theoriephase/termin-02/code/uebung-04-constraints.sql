-- UNIQUE: Verfahren + Version legen einen Algorithmus eindeutig fest
ALTER TABLE ALGORITHMUS
    ADD CONSTRAINT UQ_ALGORITHMUS_VERFAHREN_VERSION UNIQUE (verfahren, version);

-- UNIQUE: pro Zeitpunkt gibt es genau einen Analyse-Lauf
ALTER TABLE ANALYSE_LAUF
    ADD CONSTRAINT UQ_ANALYSE_LAUF_ZEITSTEMPEL UNIQUE (zeitstempel);

-- CHECK: Schädigungswerte und Grenzwerte sind Prozentangaben
ALTER TABLE SCHAEDIGUNG
    ADD CONSTRAINT CK_SCHAEDIGUNG_WERT
    CHECK (schaedigungswert BETWEEN 0 AND 100);

ALTER TABLE VERFAHREN
    ADD CONSTRAINT CK_VERFAHREN_GRENZWERTE
    CHECK (grenzwert_meldung BETWEEN 0 AND 100
       AND grenzwert_alarm   BETWEEN 0 AND 100);

-- CHECK: nur erlaubte Texte
ALTER TABLE ALGORITHMUS
    ADD CONSTRAINT CK_ALGORITHMUS_STATUS
    CHECK (status IN ('alpha', 'beta', 'stable'));

ALTER TABLE EXTREMWERT
    ADD CONSTRAINT CK_EXTREMWERT_TYP
    CHECK (typ IN ('Maximum', 'Minimum'));

-- DEFAULT: ein neuer Extremwert ist zunächst unverarbeitet
ALTER TABLE EXTREMWERT
    ADD CONSTRAINT DF_EXTREMWERT_VERARBEITET
    DEFAULT 0 FOR verarbeitet;
