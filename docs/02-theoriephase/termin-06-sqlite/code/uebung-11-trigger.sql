-- Trigger: Jede Änderung des Gehalts in ma wird in gehalt_log protokolliert (SQLite).
CREATE TRIGGER tr_ma_gehalt
AFTER UPDATE OF gehalt ON ma -- (1)!
FOR EACH ROW -- (2)!
WHEN NEW.gehalt <> OLD.gehalt -- (3)!
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    VALUES (OLD.manr, OLD.gehalt, NEW.gehalt); -- (4)!
END;
