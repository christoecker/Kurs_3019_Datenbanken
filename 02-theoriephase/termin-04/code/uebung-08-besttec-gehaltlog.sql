-- BestTec: Erweiterung um die Protokolltabelle gehalt_log (Gehaltsänderungen nachvollziehen)
-- Voraussetzung: BestTec mit Testdaten, Tabelle testlauf (Block 07) und Rechtekonzept aus Block 07.
USE BestTec;
GO

-- Bewusst ohne Fremdschlüssel auf ma: Das Protokoll soll erhalten bleiben,
-- auch wenn ein Mitarbeiter später gelöscht wird.
CREATE TABLE gehalt_log (
    lognr      INT           IDENTITY(1,1) NOT NULL,
    manr       NUMERIC(4)    NOT NULL,
    gehalt_alt NUMERIC(9,2)  NOT NULL,
    gehalt_neu NUMERIC(9,2)  NOT NULL,
    zeitpunkt  DATETIME2(0)  NOT NULL CONSTRAINT df_gehalt_log_zeit     DEFAULT SYSDATETIME(),
    benutzer   VARCHAR(128)  NOT NULL CONSTRAINT df_gehalt_log_benutzer DEFAULT USER_NAME(),
    CONSTRAINT pk_gehalt_log PRIMARY KEY (lognr)
);
GO
