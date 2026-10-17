CREATE TABLE VERFAHREN (
    verfahren          VARCHAR(20)  NOT NULL PRIMARY KEY,
    grenzwert_meldung  INT          NOT NULL,
    grenzwert_alarm    INT          NOT NULL
);

CREATE TABLE ALGORITHMUS (
    algorithmus_id  INT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    verfahren       VARCHAR(20)        NOT NULL,
    ver             VARCHAR(10)        NOT NULL,
    release_datum   DATE               NOT NULL,
    release_status  VARCHAR(10)        NOT NULL,
    FOREIGN KEY (verfahren) REFERENCES VERFAHREN(verfahren)
);
