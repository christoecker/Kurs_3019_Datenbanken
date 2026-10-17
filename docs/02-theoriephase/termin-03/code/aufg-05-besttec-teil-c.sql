-- C1: Niemand verdient mehr als der direkte Vorgesetzte -> leeres Ergebnis
SELECT x.name, x.gehalt, y.name AS chef, y.gehalt AS chefgehalt
FROM ma x, ma y
WHERE x.vorgnr = y.manr AND x.gehalt > y.gehalt;

-- Gegenprobe: ohne die Gehaltsbedingung erscheinen alle 19 Mitarbeiter mit Vorgesetztem
SELECT x.name, x.gehalt, y.name AS chef, y.gehalt AS chefgehalt
FROM ma x, ma y
WHERE x.vorgnr = y.manr;

-- C2: Verbund ohne Verknüpfungsbedingung -> Engineering mit allen vier Projekten
SELECT a.bezeichnung, p.titel
FROM abt a, prj p
WHERE a.abtnr = 20;

-- Gegenprobe: mit Verknüpfungsbedingung nur die drei Projekte von Engineering
SELECT a.bezeichnung, p.titel
FROM abt a, prj p
WHERE a.abtnr = p.abtnr AND a.abtnr = 20;
