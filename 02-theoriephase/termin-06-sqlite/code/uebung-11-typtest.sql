-- Typtest: Was passiert, wenn Werte nicht zur deklarierten Spaltenart passen?
CREATE TABLE typtest (
    zahl NUMERIC(4),
    text VARCHAR(5)
);

INSERT INTO typtest VALUES (1500, 'ok');
INSERT INTO typtest VALUES ('viel', 'dieser Text ist viel laenger als fuenf Zeichen');
INSERT INTO typtest VALUES ('12', 'x');

SELECT zahl, typeof(zahl) AS typ, text FROM typtest;
-- zahl  typ       text
-- 1500  integer   ok
-- viel  text      dieser Text ist viel laenger als fuenf Zeichen
-- 12    integer   x

-- Der Text 'viel' gilt als größer als jede Zahl:
SELECT zahl FROM typtest WHERE zahl > 1000;
-- 1500
-- viel

-- Abhilfe: STRICT-Tabelle (seit SQLite 3.37). Hier wird der Typ erzwungen.
CREATE TABLE typtest_strict (
    zahl INTEGER,
    text TEXT
) STRICT;

INSERT INTO typtest_strict VALUES ('viel', 'x');
-- Fehler: cannot store TEXT value in INTEGER column typtest_strict.zahl
