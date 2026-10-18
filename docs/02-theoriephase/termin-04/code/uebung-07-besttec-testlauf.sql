-- BestTec: Erweiterung um die Tabelle testlauf (Prüfstand meldet Testergebnisse zu Projekten)
-- Voraussetzung: BestTec ist mit den Skripten aus Termin 3 angelegt und mit Testdaten gefüllt.
USE BestTec;
GO

CREATE TABLE testlauf (
    testnr    INT          IDENTITY(1,1) NOT NULL,
    prjnr     NUMERIC(3)   NOT NULL,
    zeitpunkt DATETIME2(0) NOT NULL CONSTRAINT df_testlauf_zeit DEFAULT SYSDATETIME(),
    ergebnis  VARCHAR(10)  NOT NULL,
    CONSTRAINT pk_testlauf PRIMARY KEY (testnr),
    CONSTRAINT fk_testlauf_prj FOREIGN KEY (prjnr) REFERENCES prj (prjnr),
    CONSTRAINT ck_testlauf_ergebnis CHECK (ergebnis IN ('bestanden', 'fehlerhaft'))
);
GO

INSERT INTO testlauf (prjnr, zeitpunkt, ergebnis) VALUES (232, '2026-11-10 08:15:00', 'bestanden');
INSERT INTO testlauf (prjnr, zeitpunkt, ergebnis) VALUES (232, '2026-11-10 09:40:00', 'fehlerhaft');
INSERT INTO testlauf (prjnr, zeitpunkt, ergebnis) VALUES (244, '2026-11-11 13:05:00', 'bestanden');
GO
