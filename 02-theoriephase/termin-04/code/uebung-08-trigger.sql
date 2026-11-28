USE BestTec;
GO

-- Trigger: Jede Änderung des Gehalts in ma wird in gehalt_log protokolliert.
CREATE TRIGGER tr_ma_gehalt
ON ma
AFTER UPDATE -- (1)!
AS
BEGIN
    SET NOCOUNT ON; -- (2)!

    IF UPDATE(gehalt) -- (3)!
        INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
        SELECT i.manr, d.gehalt, i.gehalt -- (4)!
        FROM inserted i, deleted d
        WHERE i.manr = d.manr -- (5)!
          AND i.gehalt <> d.gehalt; -- (6)!
END;
GO
