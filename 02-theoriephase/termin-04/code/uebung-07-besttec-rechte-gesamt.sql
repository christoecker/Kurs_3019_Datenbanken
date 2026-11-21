-- BestTec: Rechtekonzept am Ende der Übung (Endzustand)
-- Voraussetzung: BestTec mit Testdaten und die Tabelle testlauf (uebung-07-besttec-testlauf.sql).
-- Bei Wiederholung zuerst uebung-07-aufraeumen.sql ausführen.

-- Logins (Serverebene); die Passwörter gelten nur für die Übung
USE master;
GO
CREATE LOGIN l_personal      WITH PASSWORD = 'Kurs#2026-Pers';
CREATE LOGIN l_projektleiter WITH PASSWORD = 'Kurs#2026-Proj';
CREATE LOGIN l_controller    WITH PASSWORD = 'Kurs#2026-Ctrl';
CREATE LOGIN l_pruefstand    WITH PASSWORD = 'Kurs#2026-SPS1';
GO

-- Benutzer und Rollen (Datenbankebene)
USE BestTec;
GO
CREATE USER u_personal      FOR LOGIN l_personal;
CREATE USER u_projektleiter FOR LOGIN l_projektleiter;
CREATE USER u_controller    FOR LOGIN l_controller;
CREATE USER u_pruefstand    FOR LOGIN l_pruefstand;

CREATE ROLE r_personal;
CREATE ROLE r_projekt;
CREATE ROLE r_controlling;
CREATE ROLE r_pruefstand;

ALTER ROLE r_personal    ADD MEMBER u_personal;
ALTER ROLE r_projekt     ADD MEMBER u_projektleiter;
ALTER ROLE r_controlling ADD MEMBER u_controller;
ALTER ROLE r_pruefstand  ADD MEMBER u_pruefstand;
GO

-- Sicht für die Projektleiter: Mitarbeiter ohne Gehalt und Provision
CREATE VIEW v_ma_projekt AS
SELECT manr, name, job, vorgnr, abtnr
FROM ma;
GO

-- Rechte (immer an Rollen, nie an einzelne Benutzer)
GRANT SELECT, INSERT, UPDATE, DELETE ON ma TO r_personal;
GRANT SELECT ON abt TO r_personal;

GRANT SELECT, INSERT, UPDATE, DELETE ON prj TO r_projekt;
GRANT SELECT ON abt          TO r_projekt;
GRANT SELECT ON v_ma_projekt TO r_projekt;
GRANT SELECT ON testlauf     TO r_projekt;

GRANT SELECT ON abt      TO r_controlling;
GRANT SELECT ON ma       TO r_controlling;
GRANT SELECT ON prj      TO r_controlling;
GRANT SELECT ON testlauf TO r_controlling;

GRANT INSERT ON testlauf TO r_pruefstand;
GRANT SELECT ON prj (prjnr, titel) TO r_pruefstand;
GO
