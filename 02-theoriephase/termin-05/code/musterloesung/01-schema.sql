-- Musterlösung Mini-Projekt Termin 5: Ticketsystem Instandhaltung (Stand nach Änderung v2)
-- Ausführen: einzeln in der Reihenfolge 01 bis 05 und 08 (in SSMS oder mit sqlcmd); danach Tests: 07 und 09; Abfragen: 06.
-- Legt die Datenbank NEU an (eine vorhandene Datenbank gleichen Namens wird gelöscht!).

USE master;
GO
IF DB_ID('Instandhaltung') IS NOT NULL
BEGIN
    ALTER DATABASE Instandhaltung SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE Instandhaltung;
END;
GO
CREATE DATABASE Instandhaltung;
GO
USE Instandhaltung;
GO
SET QUOTED_IDENTIFIER ON; -- nötig für den gefilterten Index weiter unten
GO

-- ---------------------------------------------------------------------------
-- Beschäftigte und Techniker (Spezialisierung, Tabelle je Typ, gemeinsamer Schlüssel)
-- ---------------------------------------------------------------------------
CREATE TABLE mitarbeiter (
    mitarbeiter_id INT          IDENTITY(1,1) NOT NULL,
    name           NVARCHAR(100) NOT NULL,
    personalnr     CHAR(6)      NOT NULL,
    db_benutzer    SYSNAME      NULL, -- Zuordnung Datenbankbenutzer -> Beschäftigter (für Prozeduren)
    CONSTRAINT pk_mitarbeiter PRIMARY KEY (mitarbeiter_id),
    CONSTRAINT uq_mitarbeiter_personalnr UNIQUE (personalnr),
    CONSTRAINT ck_mitarbeiter_personalnr CHECK (personalnr NOT LIKE '%[^0-9]%')
);
-- Mehrere Beschäftigte ohne Benutzer (NULL) sind erlaubt, vergebene Namen müssen aber eindeutig sein:
-- ein UNIQUE-Constraint würde nur EIN NULL erlauben, deshalb gefilterter Index.
CREATE UNIQUE INDEX ux_mitarbeiter_benutzer ON mitarbeiter (db_benutzer) WHERE db_benutzer IS NOT NULL;
GO

CREATE TABLE techniker (
    mitarbeiter_id INT         NOT NULL,
    fachgebiet     VARCHAR(30) NOT NULL,
    CONSTRAINT pk_techniker PRIMARY KEY (mitarbeiter_id),
    CONSTRAINT fk_techniker_mitarbeiter FOREIGN KEY (mitarbeiter_id) REFERENCES mitarbeiter (mitarbeiter_id),
    CONSTRAINT ck_techniker_fachgebiet CHECK (fachgebiet IN ('Mechanik', 'Elektrik', 'Steuerung/SPS', 'Hydraulik/Pneumatik'))
);
GO

-- ---------------------------------------------------------------------------
-- Maschinen
-- ---------------------------------------------------------------------------
CREATE TABLE maschine (
    maschine_id INT           IDENTITY(1,1) NOT NULL,
    bezeichnung NVARCHAR(100) NOT NULL,
    halle       TINYINT       NOT NULL,
    wichtigkeit TINYINT       NOT NULL, -- 1 = Produktion steht ohne sie, 3 = kann ausfallen
    zustand     VARCHAR(20)   NOT NULL CONSTRAINT df_maschine_zustand DEFAULT 'in Betrieb',
    CONSTRAINT pk_maschine PRIMARY KEY (maschine_id),
    CONSTRAINT uq_maschine_bezeichnung UNIQUE (bezeichnung),
    CONSTRAINT ck_maschine_halle CHECK (halle BETWEEN 1 AND 3),
    CONSTRAINT ck_maschine_wichtigkeit CHECK (wichtigkeit BETWEEN 1 AND 3),
    CONSTRAINT ck_maschine_zustand CHECK (zustand IN ('in Betrieb', 'gestoert', 'in Wartung', 'ausser Betrieb'))
);
GO

-- ---------------------------------------------------------------------------
-- Aufträge (Spezialisierung total + disjunkt, Tabelle je Untertyp)
-- Die Spalte art plus der zusammengesetzte Fremdschlüssel erzwingt deklarativ,
-- dass jeder Auftrag in genau EINER Untertyp-Tabelle steht.
-- ---------------------------------------------------------------------------
CREATE TABLE auftrag (
    auftrag_id       INT          IDENTITY(1,1) NOT NULL,
    art              CHAR(1)      NOT NULL, -- W = Wartung, E = Eil, F = Fremd
    maschine_id      INT          NOT NULL, -- bewusst auch hier (Eilauftrag kann ohne Meldung bestehen)
    angelegt_am      DATETIME2(0) NOT NULL CONSTRAINT df_auftrag_angelegt DEFAULT SYSDATETIME(),
    abgeschlossen_am DATETIME2(0) NULL,
    stand            VARCHAR(20)  NOT NULL CONSTRAINT df_auftrag_stand DEFAULT 'offen',
    CONSTRAINT pk_auftrag PRIMARY KEY (auftrag_id),
    CONSTRAINT uq_auftrag_art UNIQUE (auftrag_id, art), -- Ziel des zusammengesetzten Fremdschlüssels
    CONSTRAINT fk_auftrag_maschine FOREIGN KEY (maschine_id) REFERENCES maschine (maschine_id),
    CONSTRAINT ck_auftrag_art CHECK (art IN ('W', 'E', 'F')),
    CONSTRAINT ck_auftrag_stand CHECK (stand IN ('offen', 'in Arbeit', 'abgeschlossen', 'zusammengelegt')),
    CONSTRAINT ck_auftrag_abschluss_nach_anlegen CHECK (abgeschlossen_am IS NULL OR abgeschlossen_am >= angelegt_am),
    CONSTRAINT ck_auftrag_abschluss_stand CHECK ((stand = 'abgeschlossen' AND abgeschlossen_am IS NOT NULL)
                                                   OR (stand <> 'abgeschlossen' AND abgeschlossen_am IS NULL))
);
GO

CREATE TABLE wartungsauftrag (
    auftrag_id       INT          NOT NULL,
    art              CHAR(1)      NOT NULL CONSTRAINT df_wartung_art DEFAULT 'W',
    geplanter_termin DATETIME2(0) NOT NULL,
    zusammengelegt_in INT         NULL, -- rekursive Beziehung: Hauptauftrag
    CONSTRAINT pk_wartungsauftrag PRIMARY KEY (auftrag_id),
    CONSTRAINT fk_wartung_auftrag FOREIGN KEY (auftrag_id, art) REFERENCES auftrag (auftrag_id, art),
    CONSTRAINT ck_wartung_art CHECK (art = 'W'),
    CONSTRAINT fk_wartung_haupt FOREIGN KEY (zusammengelegt_in) REFERENCES wartungsauftrag (auftrag_id),
    CONSTRAINT ck_wartung_nicht_selbst CHECK (zusammengelegt_in IS NULL OR zusammengelegt_in <> auftrag_id)
);
GO

CREATE TABLE eilauftrag (
    auftrag_id         INT           NOT NULL,
    art                CHAR(1)       NOT NULL CONSTRAINT df_eil_art DEFAULT 'E',
    fehlerbeschreibung NVARCHAR(500) NOT NULL,
    melderhinweis      NVARCHAR(200) NULL,
    CONSTRAINT pk_eilauftrag PRIMARY KEY (auftrag_id),
    CONSTRAINT fk_eil_auftrag FOREIGN KEY (auftrag_id, art) REFERENCES auftrag (auftrag_id, art),
    CONSTRAINT ck_eil_art CHECK (art = 'E'),
    CONSTRAINT ck_eil_text CHECK (LEN(LTRIM(RTRIM(fehlerbeschreibung))) > 0)
);
GO

-- Optional (Fremdaufträge nur durch die Leitung)
CREATE TABLE fremdauftrag (
    auftrag_id INT           NOT NULL,
    art        CHAR(1)       NOT NULL CONSTRAINT df_fremd_art DEFAULT 'F',
    fremdfirma NVARCHAR(100) NOT NULL, -- heute Freitext; später ggf. Fremdschlüssel auf eine Firmentabelle
    CONSTRAINT pk_fremdauftrag PRIMARY KEY (auftrag_id),
    CONSTRAINT fk_fremd_auftrag FOREIGN KEY (auftrag_id, art) REFERENCES auftrag (auftrag_id, art),
    CONSTRAINT ck_fremd_art CHECK (art = 'F'),
    CONSTRAINT ck_fremd_name CHECK (LEN(LTRIM(RTRIM(fremdfirma))) > 0)
);
GO

-- ---------------------------------------------------------------------------
-- Zuordnung Techniker <-> Auftrag (Änderung v2): M:N mit den Beziehungsattributen rolle und stunden
-- ---------------------------------------------------------------------------
CREATE TABLE zuordnung (
    auftrag_id  INT          NOT NULL,
    techniker_id INT         NOT NULL,
    rolle       VARCHAR(20)  NOT NULL CONSTRAINT df_zuordnung_rolle DEFAULT 'unterstuetzend',
    stunden     DECIMAL(5,1) NOT NULL CONSTRAINT df_zuordnung_stunden DEFAULT 0,
    CONSTRAINT pk_zuordnung PRIMARY KEY (auftrag_id, techniker_id),
    CONSTRAINT fk_zuordnung_auftrag FOREIGN KEY (auftrag_id) REFERENCES auftrag (auftrag_id),
    CONSTRAINT fk_zuordnung_techniker FOREIGN KEY (techniker_id) REFERENCES techniker (mitarbeiter_id),
    CONSTRAINT ck_zuordnung_rolle CHECK (rolle IN ('verantwortlich', 'unterstuetzend')),
    CONSTRAINT ck_zuordnung_stunden CHECK (stunden >= 0)
);
-- Höchstens ein Verantwortlicher je Auftrag (gefilterter eindeutiger Index)
CREATE UNIQUE INDEX ux_zuordnung_verantwortlich ON zuordnung (auftrag_id) WHERE rolle = 'verantwortlich';
GO

-- ---------------------------------------------------------------------------
-- Störmeldungen und ihre Beschreibungen (abhängiger Entity-Typ)
-- ---------------------------------------------------------------------------
CREATE TABLE stoermeldung (
    meldung_id    INT          IDENTITY(1,1) NOT NULL,
    maschine_id   INT          NOT NULL,
    melder_id     INT          NOT NULL, -- heute immer ein Beschäftigter
    zeitpunkt     DATETIME2(0) NOT NULL CONSTRAINT df_meldung_zeit DEFAULT SYSDATETIME(),
    dringlichkeit TINYINT      NOT NULL, -- 1 = kann warten, 2 = normal, 3 = dringend
    stand         VARCHAR(20)  NOT NULL CONSTRAINT df_meldung_stand DEFAULT 'neu',
    auftrag_id    INT          NULL, -- Meldung gehört zu keinem oder genau einem Auftrag
    CONSTRAINT pk_stoermeldung PRIMARY KEY (meldung_id),
    CONSTRAINT fk_meldung_maschine FOREIGN KEY (maschine_id) REFERENCES maschine (maschine_id),
    CONSTRAINT fk_meldung_melder FOREIGN KEY (melder_id) REFERENCES mitarbeiter (mitarbeiter_id),
    CONSTRAINT fk_meldung_auftrag FOREIGN KEY (auftrag_id) REFERENCES auftrag (auftrag_id),
    CONSTRAINT ck_meldung_dringlichkeit CHECK (dringlichkeit BETWEEN 1 AND 3),
    CONSTRAINT ck_meldung_stand CHECK (stand IN ('neu', 'in Bearbeitung', 'erledigt'))
);
GO

CREATE TABLE stoerungsbeschreibung (
    meldung_id  INT           NOT NULL,
    nr          SMALLINT      NOT NULL, -- laufende Nummer je Meldung (1, 2, 3, ...)
    zeitpunkt   DATETIME2(0)  NOT NULL CONSTRAINT df_beschr_zeit DEFAULT SYSDATETIME(),
    text        NVARCHAR(500) NOT NULL,
    verfasser_id INT          NOT NULL,
    CONSTRAINT pk_stoerungsbeschreibung PRIMARY KEY (meldung_id, nr), -- zusammengesetzt: abhängig von der Meldung
    CONSTRAINT fk_beschr_meldung FOREIGN KEY (meldung_id) REFERENCES stoermeldung (meldung_id) ON DELETE CASCADE,
    CONSTRAINT fk_beschr_verfasser FOREIGN KEY (verfasser_id) REFERENCES mitarbeiter (mitarbeiter_id),
    CONSTRAINT ck_beschr_nr CHECK (nr >= 1),
    CONSTRAINT ck_beschr_text CHECK (LEN(LTRIM(RTRIM(text))) > 0)
);
GO
