-- Teil B: Trigger auf prj, der gelöschte Projekte in prj_archiv sichert
-- Ausgangszustand: BestTec mit Testdaten, testlauf, prj_archiv (aufg-08-besttec-archiv.sql)

-- --8<-- [start:b1]
-- B.1: Beispiel für einen guten Prompt (sinngemäß):
--   Schema:      CREATE TABLE prj (...) und CREATE TABLE prj_archiv (...) einfügen
--   Dialekt:     Microsoft SQL Server (T-SQL)
--   Anforderung: Wenn Projekte aus prj gelöscht werden, soll jede gelöschte Zeile mit allen
--                Spalten in prj_archiv gesichert werden. Das gilt auch, wenn mehrere Projekte
--                mit einem einzigen DELETE gelöscht werden. Gewünscht: ein AFTER-DELETE-Trigger.
-- --8<-- [end:b1]

-- --8<-- [start:b2]
USE BestTec;
GO
-- B.2: Referenzlösung des Triggers
CREATE TRIGGER tr_prj_loeschen
ON prj
AFTER DELETE                -- feuert nach jedem DELETE auf prj, einmal pro Anweisung
AS
BEGIN
    SET NOCOUNT ON;
    -- Bei DELETE steht der alte Zustand der gelöschten Zeilen in der Pseudotabelle deleted
    -- (inserted ist leer). Es werden alle gelöschten Zeilen auf einmal gesichert.
    INSERT INTO prj_archiv (prjnr, abtnr, kdnr, titel)
    SELECT prjnr, abtnr, kdnr, titel
    FROM deleted;
END;
GO

-- Test mit zwei Zeilen in einem DELETE: beide Projekte müssen archiviert werden
DELETE FROM prj WHERE prjnr IN (212, 256);
GO
SELECT prjnr, titel, geloescht_von FROM prj_archiv;         -- 2 Zeilen: 212 und 256
GO
-- --8<-- [end:b2]

-- --8<-- [start:b3]
-- B.3: Löschversuch für ein Projekt, zu dem es Testläufe gibt
DELETE FROM prj WHERE prjnr = 232;                          -- Fehler 547 (Fremdschlüssel fk_testlauf_prj)
GO
SELECT COUNT(*) AS archivzeilen FROM prj_archiv;            -- weiterhin 2: Der DELETE wurde abgelehnt, der Trigger lief nicht
GO
-- --8<-- [end:b3]

-- --8<-- [start:b4]
-- B.4: Trigger verwalten
INSERT INTO prj (prjnr, abtnr, kdnr, titel) VALUES (500, 10, 'T56', 'Testprojekt');
INSERT INTO prj (prjnr, abtnr, kdnr, titel) VALUES (501, 10, 'T56', 'Testprojekt 2');
GO

DISABLE TRIGGER tr_prj_loeschen ON prj;
GO
DELETE FROM prj WHERE prjnr = 500;                          -- wird NICHT archiviert
GO
SELECT COUNT(*) AS archivzeilen FROM prj_archiv;            -- 2

ENABLE TRIGGER tr_prj_loeschen ON prj;
GO
DELETE FROM prj WHERE prjnr = 501;                          -- wird archiviert
GO
SELECT COUNT(*) AS archivzeilen FROM prj_archiv;            -- 3

-- Status aller Trigger auf prj: is_disabled = 0 bedeutet aktiv
SELECT name, is_disabled FROM sys.triggers WHERE parent_id = OBJECT_ID('prj');
GO
-- --8<-- [end:b4]
