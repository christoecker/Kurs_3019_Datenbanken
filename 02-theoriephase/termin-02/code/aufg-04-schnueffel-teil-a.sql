CREATE DATABASE Schnueffel;
GO
USE Schnueffel;
GO

CREATE TABLE REAKTOR (
    reaktor_id       VARCHAR(10)  NOT NULL PRIMARY KEY,
    saeureresistent  BIT          NOT NULL
);

CREATE TABLE REZEPT (
    rezept_id  VARCHAR(20)  NOT NULL PRIMARY KEY
);

CREATE TABLE REZEPT_PARAMETER (
    rezept_id       VARCHAR(20)   NOT NULL,
    parameter_name  VARCHAR(30)   NOT NULL,
    wert            DECIMAL(8,2)  NOT NULL,
    PRIMARY KEY (rezept_id, parameter_name),
    FOREIGN KEY (rezept_id) REFERENCES REZEPT(rezept_id)
);

CREATE TABLE CHARGE (
    charge_nr   INT          NOT NULL PRIMARY KEY,
    reaktor_id  VARCHAR(10)  NOT NULL,
    rezept_id   VARCHAR(20)  NOT NULL,
    FOREIGN KEY (reaktor_id) REFERENCES REAKTOR(reaktor_id),
    FOREIGN KEY (rezept_id)  REFERENCES REZEPT(rezept_id)
);

CREATE TABLE PROZESSWERT (
    charge_nr    INT           NOT NULL,
    zeitstempel  DATETIME2(0)  NOT NULL,
    viskositaet  DECIMAL(6,1)  NOT NULL,
    temperatur   DECIMAL(5,1)  NOT NULL,
    fuellstand   DECIMAL(5,1)  NOT NULL
        CHECK (fuellstand BETWEEN 0 AND 100),
    PRIMARY KEY (charge_nr, zeitstempel),
    FOREIGN KEY (charge_nr) REFERENCES CHARGE(charge_nr)
);
