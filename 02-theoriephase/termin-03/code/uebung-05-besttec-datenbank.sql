-- BestTec: Datenbank und Tabellen anlegen (Fallstudie aus dem Lehrbrief, Anhang 9.2)
-- Hinweis: Das Skript löscht eine bereits vorhandene Datenbank BestTec und legt sie neu an.
USE master;
GO
IF DB_ID('BestTec') IS NOT NULL
BEGIN
    ALTER DATABASE BestTec SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE BestTec;
END
GO
CREATE DATABASE BestTec;
GO
USE BestTec;
GO

CREATE TABLE abt (
    abtnr       NUMERIC(2)  NOT NULL,
    bezeichnung VARCHAR(20) NOT NULL,
    sitz        VARCHAR(20) NOT NULL,
    CONSTRAINT pk_abt PRIMARY KEY (abtnr),
    CONSTRAINT uk_bez UNIQUE (bezeichnung)
);

CREATE TABLE ma (
    manr    NUMERIC(4)   NOT NULL,
    name    VARCHAR(20)  NOT NULL,
    job     VARCHAR(20)  NOT NULL,
    vorgnr  NUMERIC(4),
    gehalt  NUMERIC(9,2) NOT NULL,
    prov    NUMERIC(9,2),
    abtnr   NUMERIC(2)   NOT NULL,
    CONSTRAINT pk_ma PRIMARY KEY (manr),
    CONSTRAINT fk_ma_abt FOREIGN KEY (abtnr) REFERENCES abt (abtnr),
    CONSTRAINT fk_vorg FOREIGN KEY (vorgnr) REFERENCES ma (manr)
);

CREATE TABLE prj (
    prjnr  NUMERIC(3)  NOT NULL,
    abtnr  NUMERIC(2)  NOT NULL,
    kdnr   VARCHAR(4)  NOT NULL,
    titel  VARCHAR(20) NOT NULL,
    CONSTRAINT pk_prj PRIMARY KEY (prjnr),
    CONSTRAINT fk_prj_abt FOREIGN KEY (abtnr) REFERENCES abt (abtnr)
);
GO
