-- Welcher Fremdschlüssel ist verletzt?
-- Zuerst ausschalten: Mit ON würde SQLite das fehlerhafte INSERT sofort ablehnen,
-- und es gäbe nichts zu finden.
PRAGMA foreign_keys = OFF; -- (3)!
INSERT INTO ma VALUES (9001, 'Neu', 'Tester', NULL, 3000, NULL, 99);

PRAGMA foreign_key_check; -- (1)!
-- ma|21|abt|1

PRAGMA foreign_key_list(ma); -- (2)!
-- 0|0|ma|vorgnr|manr|NO ACTION|NO ACTION|NONE
-- 1|0|abt|abtnr|abtnr|NO ACTION|NO ACTION|NONE

DELETE FROM ma WHERE manr = 9001;
