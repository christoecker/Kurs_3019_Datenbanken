-- BestTec: Testdaten (Datenbankzustand laut Lehrbrief, Anhang 9.2, S. 98)
USE BestTec;
GO

INSERT INTO abt VALUES (10, 'Zentrale',    'Gütersloh');
INSERT INTO abt VALUES (20, 'Engineering', 'Verl');
INSERT INTO abt VALUES (30, 'Automotive',  'Paderborn');
INSERT INTO abt VALUES (40, 'Robotik',     'Bielefeld');
INSERT INTO abt VALUES (50, 'Education',   'Münster');

-- Vorgesetzte stehen vor ihren Untergebenen (Fremdschlüssel auf ma selbst)
INSERT INTO ma VALUES (7656, 'Hansen',  'Geschäftsführer', NULL, 9800, NULL, 10);
INSERT INTO ma VALUES (7900, 'Karl',    'Manager',         7656, 7200, NULL, 20);
INSERT INTO ma VALUES (8801, 'Langer',  'Vertrieb',        7656, 4800, 1200, 10);
INSERT INTO ma VALUES (7329, 'Frohn',   'Programmierer',   7900, 2900, NULL, 20);
INSERT INTO ma VALUES (8722, 'Werther', 'Programmierer',   7900, 2700, NULL, 20);
INSERT INTO ma VALUES (7643, 'Kurt',    'Vertrieb',        8801, 3100, 900,  10);
INSERT INTO ma VALUES (7767, 'John',    'Controller',      7656, 4900, NULL, 10);
INSERT INTO ma VALUES (7783, 'Kron',    'Manager',         7656, 5200, NULL, 50);
INSERT INTO ma VALUES (8800, 'Beier',   'Trainer',         7783, 2700, NULL, 50);
INSERT INTO ma VALUES (7621, 'Klaas',   'Trainer',         7783, 3200, NULL, 50);
INSERT INTO ma VALUES (7768, 'Schulte', 'Vertrieb',        8801, 2900, 500,  10);
INSERT INTO ma VALUES (7745, 'Meier',   'Manager',         7656, 5500, NULL, 40);
INSERT INTO ma VALUES (8956, 'Dorn',    'Engineer',        7745, 3000, NULL, 40);
INSERT INTO ma VALUES (7112, 'Born',    'Manager',         7656, 4800, NULL, 30);
INSERT INTO ma VALUES (8969, 'Walter',  'Engineer',        7112, 2500, NULL, 30);
INSERT INTO ma VALUES (8322, 'Frei',    'Engineer',        7745, 2500, NULL, 40);
INSERT INTO ma VALUES (7769, 'Meyer',   'Engineer',        7900, 5200, NULL, 20);
INSERT INTO ma VALUES (8659, 'Sorge',   'Engineer',        7900, 5800, NULL, 20);
INSERT INTO ma VALUES (8247, 'Holle',   'Engineer',        7112, 2900, NULL, 30);
INSERT INTO ma VALUES (7739, 'Meier',   'Projektleiter',   7900, 3200, NULL, 20);

INSERT INTO prj VALUES (232, 20, 'M341', 'PeakControl');
INSERT INTO prj VALUES (244, 10, 'T56',  'AutoRob');
INSERT INTO prj VALUES (212, 20, 'A12',  'HydroControl');
INSERT INTO prj VALUES (256, 20, 'M341', 'AvisyTurb');
GO
