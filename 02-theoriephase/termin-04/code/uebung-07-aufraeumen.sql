-- Aufräumen: entfernt alle Benutzer, Rollen, Sichten und Logins aus Termin 4,
-- damit die Übung (oder die Aufgabe) von vorn beginnen kann.
-- Logins gehören zum Server und bleiben sonst auch nach dem Neuanlegen von BestTec erhalten.
USE master;
GO

IF DB_ID('BestTec') IS NOT NULL
BEGIN
    EXEC BestTec.sys.sp_executesql N'
        DROP VIEW IF EXISTS v_ma_vertrieb;
        DROP VIEW IF EXISTS v_ma_projekt;
        DROP USER IF EXISTS u_personal;
        DROP USER IF EXISTS u_projektleiter;
        DROP USER IF EXISTS u_controller;
        DROP USER IF EXISTS u_pruefstand;
        DROP USER IF EXISTS u_vertrieb;
        DROP USER IF EXISTS u_personal2;
        DROP ROLE IF EXISTS r_personal;
        DROP ROLE IF EXISTS r_projekt;
        DROP ROLE IF EXISTS r_controlling;
        DROP ROLE IF EXISTS r_pruefstand;
        DROP ROLE IF EXISTS r_vertrieb;';
END
GO

IF SUSER_ID('l_personal')      IS NOT NULL DROP LOGIN l_personal;
IF SUSER_ID('l_projektleiter') IS NOT NULL DROP LOGIN l_projektleiter;
IF SUSER_ID('l_controller')    IS NOT NULL DROP LOGIN l_controller;
IF SUSER_ID('l_pruefstand')    IS NOT NULL DROP LOGIN l_pruefstand;
IF SUSER_ID('l_vertrieb')      IS NOT NULL DROP LOGIN l_vertrieb;
IF SUSER_ID('l_personal2')     IS NOT NULL DROP LOGIN l_personal2;
GO
