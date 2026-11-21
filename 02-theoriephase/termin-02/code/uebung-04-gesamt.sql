CREATE DATABASE Kompressor;
GO
USE Kompressor;
GO

CREATE TABLE MESSUNG (
    zeitstempel       DATETIME2(0)  NOT NULL,
    druck_eingang     DECIMAL(6,2)  NOT NULL,
    druck_ausgang     DECIMAL(6,2)  NOT NULL,
    volumenstrom      DECIMAL(8,2)  NOT NULL,
    temperatur        DECIMAL(5,2)  NOT NULL,
    luftfeuchtigkeit  DECIMAL(5,2)  NOT NULL,
    CONSTRAINT PK_MESSUNG PRIMARY KEY (zeitstempel)
);

CREATE TABLE VERFAHREN (
    verfahren          VARCHAR(20)  NOT NULL,
    grenzwert_meldung  INT          NOT NULL,
    grenzwert_alarm    INT          NOT NULL,
    CONSTRAINT PK_VERFAHREN PRIMARY KEY (verfahren),
    CONSTRAINT CK_VERFAHREN_GRENZWERTE
        CHECK (grenzwert_meldung BETWEEN 0 AND 100
           AND grenzwert_alarm   BETWEEN 0 AND 100)
);

CREATE TABLE ALGORITHMUS (
    algorithmus_id  INT IDENTITY(1,1)  NOT NULL,
    verfahren       VARCHAR(20)        NOT NULL,
    ver             VARCHAR(10)        NOT NULL,
    release_datum   DATE               NOT NULL,
    release_status  VARCHAR(10)        NOT NULL,
    CONSTRAINT PK_ALGORITHMUS PRIMARY KEY (algorithmus_id),
    CONSTRAINT FK_ALGORITHMUS_VERFAHREN
        FOREIGN KEY (verfahren) REFERENCES VERFAHREN(verfahren),
    CONSTRAINT UQ_ALGORITHMUS_VERFAHREN_VER UNIQUE (verfahren, ver),
    CONSTRAINT CK_ALGORITHMUS_RELEASE_STATUS
        CHECK (release_status IN ('alpha', 'beta', 'stable'))
);

CREATE TABLE ANALYSE_LAUF (
    analyse_lauf_id  INT IDENTITY(1,1)  NOT NULL,
    zeitstempel      DATETIME2(0)       NOT NULL,
    CONSTRAINT PK_ANALYSE_LAUF PRIMARY KEY (analyse_lauf_id),
    CONSTRAINT UQ_ANALYSE_LAUF_ZEITSTEMPEL UNIQUE (zeitstempel)
);

CREATE TABLE SCHAEDIGUNG (
    analyse_lauf_id   INT  NOT NULL,
    algorithmus_id    INT  NOT NULL,
    schaedigungswert  INT  NOT NULL,
    CONSTRAINT PK_SCHAEDIGUNG PRIMARY KEY (analyse_lauf_id, algorithmus_id),
    CONSTRAINT FK_SCHAEDIGUNG_LAUF
        FOREIGN KEY (analyse_lauf_id) REFERENCES ANALYSE_LAUF(analyse_lauf_id),
    CONSTRAINT FK_SCHAEDIGUNG_ALGORITHMUS
        FOREIGN KEY (algorithmus_id) REFERENCES ALGORITHMUS(algorithmus_id),
    CONSTRAINT CK_SCHAEDIGUNG_WERT
        CHECK (schaedigungswert BETWEEN 0 AND 100)
);

CREATE TABLE EXTREMWERT (
    zeitstempel  DATETIME2(0)  NOT NULL,
    typ          VARCHAR(7)    NOT NULL,
    wert         DECIMAL(6,2)  NOT NULL,
    verarbeitet  BIT           NOT NULL
        CONSTRAINT DF_EXTREMWERT_VERARBEITET DEFAULT 0,
    CONSTRAINT PK_EXTREMWERT PRIMARY KEY (zeitstempel),
    CONSTRAINT CK_EXTREMWERT_TYP CHECK (typ IN ('Maximum', 'Minimum'))
);
