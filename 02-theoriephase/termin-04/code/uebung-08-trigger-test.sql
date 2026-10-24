USE BestTec;
GO

-- 1. Gehalt eines einzelnen Mitarbeiters ändern (Frohn: 2900 -> 3000)
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = 3000 WHERE manr = 7329;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 1 Zeile
GO

-- 2. Gehälter der Abteilung 20 um 5 % erhöhen: ein UPDATE, sechs betroffene Zeilen
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 6 Zeilen: der Trigger lief einmal, aber für alle sechs
GO

-- 3. Nur die Tätigkeit ändern: Die Spalte gehalt kommt in SET nicht vor
TRUNCATE TABLE gehalt_log;
UPDATE ma SET job = 'Entwickler' WHERE manr = 7329;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 0 Zeilen
GO

-- 4. Gehalt wird "geändert", behält aber seinen Wert
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 0 Zeilen: UPDATE(gehalt) ist wahr, aber gehalt_alt = gehalt_neu
GO

-- 5. UPDATE ohne passende Zeile: Es gibt keine Abteilung 99
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = 0 WHERE abtnr = 99;                  -- 0 Zeilen betroffen
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;        -- 0 Zeilen: Der Trigger lief, aber inserted war leer
GO
