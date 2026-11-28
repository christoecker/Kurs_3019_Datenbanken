-- Abfragen und Datenänderungen (auf dem Stand der Testdaten aus 05-testdaten.sql)
USE Instandhaltung;
GO

-- Q1: Offene (nicht erledigte) Meldungen je Maschine, auch Maschinen ohne offene Meldung
-- Erwartung: Spritzguss 1 -> 3, Spritzguss 2 -> 1, Handlingroboter 3 -> 1, Kühlanlage 4 -> 0
SELECT ma.bezeichnung, COUNT(m.meldung_id) AS offene_meldungen
FROM maschine ma
LEFT JOIN stoermeldung m ON m.maschine_id = ma.maschine_id AND m.stand <> 'erledigt'
GROUP BY ma.bezeichnung
ORDER BY offene_meldungen DESC, ma.bezeichnung;
GO

-- Q2: Nicht abgeschlossene Aufträge je Techniker (mit Rolle)
-- Erwartung: Becker 1 (A1), Roth 2 (A1, A2), Neumann 1 (A3)
SELECT mi.name, t.fachgebiet, COUNT(*) AS aktive_auftraege
FROM zuordnung z
JOIN techniker t  ON t.mitarbeiter_id = z.techniker_id
JOIN mitarbeiter mi ON mi.mitarbeiter_id = t.mitarbeiter_id
JOIN auftrag a    ON a.auftrag_id = z.auftrag_id
WHERE a.stand NOT IN ('abgeschlossen', 'zusammengelegt')
GROUP BY mi.name, t.fachgebiet
ORDER BY aktive_auftraege DESC, mi.name;
GO

-- Q3: Meldungen ohne Auftrag, die noch auf Bearbeitung warten (älteste zuerst, dringendste zuerst)
-- Erwartung: M3 (Spritzguss 2), M5 (Spritzguss 1)
SELECT m.meldung_id, ma.bezeichnung, mi.name AS gemeldet_von, m.dringlichkeit, m.zeitpunkt
FROM stoermeldung m
JOIN maschine ma   ON ma.maschine_id = m.maschine_id
JOIN mitarbeiter mi ON mi.mitarbeiter_id = m.melder_id
WHERE m.auftrag_id IS NULL
ORDER BY m.dringlichkeit DESC, m.zeitpunkt;
GO

-- Q4: Meldungen mit mehr als einer Beschreibung (Verlauf einer Störung)
-- Erwartung: nur M1 mit 2 Beschreibungen
SELECT m.meldung_id, COUNT(*) AS anzahl_beschreibungen
FROM stoermeldung m
JOIN stoerungsbeschreibung b ON b.meldung_id = m.meldung_id
GROUP BY m.meldung_id
HAVING COUNT(*) > 1;
GO

-- Q5: Aufträge mit ihrer Art (Untertyp) und der Maschine
-- Erwartung: A1 Wartung, A2 Eilauftrag, A3 Wartung
SELECT a.auftrag_id,
       CASE a.art WHEN 'W' THEN 'Wartung' WHEN 'E' THEN 'Eilauftrag' ELSE 'Fremdauftrag' END AS auftragsart,
       ma.bezeichnung, a.stand
FROM auftrag a
JOIN maschine ma ON ma.maschine_id = a.maschine_id
ORDER BY a.auftrag_id;
GO

-- Q6: Zusammengelegte Aufträge mit ihrem Hauptauftrag (rekursive Beziehung, Selbstverknüpfung)
-- Erwartung auf den Testdaten: keine Zeile (erst nach dem Zusammenlegen)
SELECT neben.auftrag_id AS zusammengelegter_auftrag, neben.zusammengelegt_in AS hauptauftrag
FROM wartungsauftrag neben
JOIN wartungsauftrag haupt ON haupt.auftrag_id = neben.zusammengelegt_in;
GO

-- Q7: Eilaufträge mit Fehlerbeschreibung (Untertyp-Tabelle mit Obertyp verknüpfen)
SELECT a.auftrag_id, ma.bezeichnung, e.fehlerbeschreibung, e.melderhinweis
FROM eilauftrag e
JOIN auftrag a  ON a.auftrag_id = e.auftrag_id
JOIN maschine ma ON ma.maschine_id = a.maschine_id;
GO

-- Datenänderung D1: Maschine nach Reparatur wieder in Betrieb setzen (Leitung)
UPDATE maschine SET zustand = 'in Betrieb' WHERE bezeichnung = N'Handlingroboter 3';
GO
-- Datenänderung D2: Fachgebiet eines Technikers ändern (Leitung)
UPDATE techniker SET fachgebiet = 'Elektrik' WHERE mitarbeiter_id = 5;
GO
-- (Rückgängig machen, damit die Testdaten wie in 05-testdaten.sql bleiben)
UPDATE maschine SET zustand = 'gestoert' WHERE bezeichnung = N'Handlingroboter 3';
UPDATE techniker SET fachgebiet = 'Steuerung/SPS' WHERE mitarbeiter_id = 5;
GO

-- Optional (Leitung): Wie oft wurde je Maschine gemeldet? (störanfälligste zuerst)
SELECT ma.bezeichnung, COUNT(*) AS meldungen
FROM stoermeldung m
JOIN maschine ma ON ma.maschine_id = m.maschine_id
GROUP BY ma.bezeichnung
ORDER BY meldungen DESC;
GO

-- Optional (Leitung): Durchschnittliche Bearbeitungsdauer abgeschlossener Aufträge in Stunden je Maschine
SELECT ma.bezeichnung, AVG(DATEDIFF(MINUTE, a.angelegt_am, a.abgeschlossen_am) / 60.0) AS dauer_h
FROM auftrag a
JOIN maschine ma ON ma.maschine_id = a.maschine_id
WHERE a.stand = 'abgeschlossen'
GROUP BY ma.bezeichnung;
GO
