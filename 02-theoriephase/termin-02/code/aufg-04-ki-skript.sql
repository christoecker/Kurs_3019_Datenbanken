CREATE TABLE KENNZAHL (
    kennzahl        VARCHAR(30)  NOT NULL PRIMARY KEY,
    einheit         VARCHAR(10)  NOT NULL,
    pruefverfahren  VARCHAR(50)  NOT NULL
);

CREATE TABLE QUALITAETSERGEBNIS (
    charge_nr   INT          NOT NULL PRIMARY KEY,
    kennzahl    VARCHAR(30)  NOT NULL,
    wert        FLOAT        NOT NULL,
    pruefdatum  VARCHAR(20)  NOT NULL,
    FOREIGN KEY (charge_nr) REFERENCES CHARGE(charge_nr)
);

CREATE TABLE EREIGNIS (
    ereignis_id  INT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    charge_nr    INT                NOT NULL,
    zeitpunkt    DATE               NOT NULL,
    ereignistyp  VARCHAR(50)        NOT NULL,
    kommentar    VARCHAR(500)       NOT NULL,
    bediener     VARCHAR(50)        NOT NULL,
    FOREIGN KEY (charge_nr) REFERENCES CHARGE(charge_nr)
);
