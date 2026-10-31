CREATE TABLE MESSUNG (
    zeitstempel       DATETIME2(0)  NOT NULL PRIMARY KEY, -- (1)!
    druck_eingang     DECIMAL(6,2)  NOT NULL, -- (2)!
    druck_ausgang     DECIMAL(6,2)  NOT NULL,
    volumenstrom      DECIMAL(8,2)  NOT NULL,
    temperatur        DECIMAL(5,2)  NOT NULL,
    luftfeuchtigkeit  DECIMAL(5,2)  NOT NULL
);
