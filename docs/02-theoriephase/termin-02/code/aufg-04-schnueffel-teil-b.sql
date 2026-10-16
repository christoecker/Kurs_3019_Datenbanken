CREATE TABLE KENNZAHL (
    kennzahl        VARCHAR(30)  NOT NULL PRIMARY KEY,
    einheit         VARCHAR(10)  NOT NULL,
    pruefverfahren  VARCHAR(50)  NOT NULL
);

CREATE TABLE QUALITAETSERGEBNIS (
    charge_nr   INT           NOT NULL,
    kennzahl    VARCHAR(30)   NOT NULL,
    wert        DECIMAL(8,2)  NOT NULL,
    pruefdatum  DATE          NOT NULL,
    PRIMARY KEY (charge_nr, kennzahl),
    FOREIGN KEY (charge_nr) REFERENCES CHARGE(charge_nr),
    FOREIGN KEY (kennzahl)  REFERENCES KENNZAHL(kennzahl)
);

CREATE TABLE EREIGNIS (
    ereignis_id  INT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    charge_nr    INT                NOT NULL,
    zeitpunkt    DATETIME2(0)       NOT NULL,
    ereignistyp  VARCHAR(50)        NOT NULL,
    kommentar    VARCHAR(500)       NULL,
    bediener     VARCHAR(50)        NOT NULL,
    FOREIGN KEY (charge_nr) REFERENCES CHARGE(charge_nr)
);
