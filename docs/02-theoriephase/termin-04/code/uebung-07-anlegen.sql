-- Schritt 1: Logins anlegen (Serverebene). Die Passwörter gelten nur für diese Übung.
USE master;
GO
CREATE LOGIN l_personal      WITH PASSWORD = 'Kurs#2026-Pers';
CREATE LOGIN l_projektleiter WITH PASSWORD = 'Kurs#2026-Proj';
CREATE LOGIN l_controller    WITH PASSWORD = 'Kurs#2026-Ctrl';
CREATE LOGIN l_pruefstand    WITH PASSWORD = 'Kurs#2026-SPS1';
GO

-- Schritt 2: Datenbank-Benutzer anlegen (jeder Benutzer gehört zu einem Login)
USE BestTec;
GO
CREATE USER u_personal      FOR LOGIN l_personal;
CREATE USER u_projektleiter FOR LOGIN l_projektleiter;
CREATE USER u_controller    FOR LOGIN l_controller;
CREATE USER u_pruefstand    FOR LOGIN l_pruefstand;
GO

-- Schritt 3: Rollen anlegen und die Benutzer zuordnen
CREATE ROLE r_personal;
CREATE ROLE r_projekt;
CREATE ROLE r_controlling;
CREATE ROLE r_pruefstand;
GO
ALTER ROLE r_personal    ADD MEMBER u_personal;
ALTER ROLE r_projekt     ADD MEMBER u_projektleiter;
ALTER ROLE r_controlling ADD MEMBER u_controller;
ALTER ROLE r_pruefstand  ADD MEMBER u_pruefstand;
GO
