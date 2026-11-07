-- ============================================================
-- Übung: Eigene Abfragen und Datenänderung (nur die Aufgaben)
-- Vorab ausführen (und nach Datenänderungen wiederholen):
--   uebung-05-besttec-datenbank.sql und uebung-05-besttec-testdaten.sql
-- Immer nur die markierte Anweisung ausführen (Markieren, dann F5).
-- ============================================================
USE BestTec;
GO


-- ============================================================
-- Daten zusammenfassen und gruppieren
-- ============================================================

-- Eine Kennzahl über alle Zeilen
-- Wie viele Mitarbeiter hat BestTec, wie hoch ist die Gehaltssumme, und was sind
-- das niedrigste und das höchste Gehalt?
-- Was erwartet ihr als Ergebnis: eine Zeile je Mitarbeiter oder etwas anderes?




-- Eine Kennzahl je Gruppe
-- Wie viele Mitarbeiter gibt es in jeder Abteilung? Die Datenbank soll die
-- Mitarbeiter also nach Abteilung in Gruppen einteilen und jede Gruppe zählen.
-- Zusatz: Wie sieht die Abfrage aus, wenn zusätzlich die Bezeichnung der
-- Abteilung erscheinen soll?




-- Ein gegebenes Statement lesen
-- Gesucht ist je Abteilung das Gesamtgehalt einschließlich Provision.
-- Welchen Wert erwartet ihr für die Abteilungen 10 und 20?
-- Erfüllt das Statement die Anforderung?
SELECT x.abtnr, x.bezeichnung,
       SUM(y.gehalt) + SUM(ISNULL(y.prov, 0)) AS ges_gehalt
FROM abt x, ma y
WHERE x.abtnr = y.abtnr
GROUP BY x.abtnr, x.bezeichnung;




-- ============================================================
-- Gruppen auswählen: HAVING
-- ============================================================

-- Zu welchen Tätigkeiten gibt es mehr als drei Mitarbeiter?
-- Hier wird nicht eine Zeile, sondern eine Gruppe ausgewählt.




-- Gesucht sind die Abteilungen, deren Durchschnittsgehalt über 4000 EUR liegt.
-- Welche Abteilungen und Werte liefert das Statement? Erfüllt es die Anforderung?
SELECT abtnr, AVG(gehalt) AS durchschnitt
FROM ma
WHERE gehalt > 4000
GROUP BY abtnr;




-- ============================================================
-- Der Umgang mit NULL
-- ============================================================

-- Wie hoch sind die Gesamtbezüge (Grundgehalt plus Provision) der Mitarbeiter
-- der Abteilung 10? Probiert zuerst die einfachste Formulierung und schaut euch
-- die Ergebnisse von Hansen und John an.




-- Wie viele Mitarbeiter erhalten keine Provision?
-- Welchen Wert liefert das Statement? Erfüllt es die Anforderung?
SELECT COUNT(*) AS ohne_provision
FROM ma
WHERE prov = NULL;




-- ============================================================
-- Unteranfragen lesen
-- ============================================================

-- Wer verdient mehr als das höchste Grundgehalt in der Abteilung mit Sitz in Münster?
-- Was liefert die Unteranfrage in den Klammern für sich allein?
-- Welche Mitarbeiter erwartet ihr im Gesamtergebnis?
SELECT x.manr, x.name, x.gehalt, y.sitz
FROM ma x, abt y
WHERE x.abtnr = y.abtnr
  AND x.gehalt > (SELECT MAX(m.gehalt)
                  FROM ma m, abt a
                  WHERE m.abtnr = a.abtnr AND a.sitz = 'Münster');




-- Gesucht sind alle Mitarbeiter ohne Untergebene.
-- Welche Zeilen liefert die Unteranfrage? Wie viele Mitarbeiter erwartet ihr im Ergebnis?
SELECT manr, name, abtnr
FROM ma
WHERE manr NOT IN (SELECT vorgnr FROM ma);




-- ============================================================
-- Daten ändern
-- ============================================================

-- Zeile einfügen
-- Die Abteilung 30 übernimmt ein neues Projekt: Nummer 471, Titel "WindControl",
-- Kunde "A12". Wie bekommt die Datenbank diesen Datensatz?




-- Zeilen ändern
-- Die Programmierer der Abteilung 20 bekommen 5 % mehr Gehalt.
-- Wie beschreibt man, welche Zeilen sich ändern und wie?




-- Die Gehälter der gesamten Abteilung 20 sollen um 5 % steigen.
-- Wie viele Zeilen werden vom Statement geändert? Erfüllt es die Anforderung?
-- Danach Datenbank mit den beiden Skripten zurücksetzen!
UPDATE ma
SET gehalt = gehalt * 1.05;




-- Zeilen löschen
-- Das Projekt 471 wird wieder gestrichen.




-- Was passiert, wenn man die Abteilung 40 (Robotik) mit DELETE löschen möchte,
-- obwohl dort noch Mitarbeiter arbeiten? Und was muss geschehen, damit es klappt?




