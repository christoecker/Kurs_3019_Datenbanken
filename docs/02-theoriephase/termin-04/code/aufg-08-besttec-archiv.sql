-- BestTec: Erweiterung um die Archivtabelle prj_archiv (für Teil B der Aufgabe)
USE BestTec;
GO

CREATE TABLE prj_archiv (
    lfdnr         INT          IDENTITY(1,1) NOT NULL,
    prjnr         NUMERIC(3)   NOT NULL,
    abtnr         NUMERIC(2)   NOT NULL,
    kdnr          VARCHAR(4)   NOT NULL,
    titel         VARCHAR(20)  NOT NULL,
    geloescht_am  DATETIME2(0) NOT NULL CONSTRAINT df_prj_archiv_zeit     DEFAULT SYSDATETIME(),
    geloescht_von VARCHAR(128) NOT NULL CONSTRAINT df_prj_archiv_benutzer DEFAULT USER_NAME(),
    CONSTRAINT pk_prj_archiv PRIMARY KEY (lfdnr)
);
GO
