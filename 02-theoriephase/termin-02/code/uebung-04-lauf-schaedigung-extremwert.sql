CREATE TABLE ANALYSE_LAUF (
    analyse_lauf_id  INT IDENTITY(1,1)  NOT NULL PRIMARY KEY,
    zeitstempel      DATETIME2(0)       NOT NULL
);

CREATE TABLE SCHAEDIGUNG (
    analyse_lauf_id   INT  NOT NULL,
    algorithmus_id    INT  NOT NULL,
    schaedigungswert  INT  NOT NULL,
    PRIMARY KEY (analyse_lauf_id, algorithmus_id),
    FOREIGN KEY (analyse_lauf_id) REFERENCES ANALYSE_LAUF(analyse_lauf_id),
    FOREIGN KEY (algorithmus_id)  REFERENCES ALGORITHMUS(algorithmus_id)
);

CREATE TABLE EXTREMWERT (
    zeitstempel  DATETIME2(0)  NOT NULL PRIMARY KEY,
    typ          VARCHAR(7)    NOT NULL,
    wert         DECIMAL(6,2)  NOT NULL,
    verarbeitet  BIT           NOT NULL
);
