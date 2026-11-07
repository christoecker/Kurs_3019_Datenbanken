-- ============================================================
-- Übung: SQL-Abfragen mit BestTec (nur die Aufgaben)
-- Vorab ausführen: uebung-05-besttec-datenbank.sql und
--                  uebung-05-besttec-testdaten.sql
-- ============================================================
USE BestTec;
GO


-- ============================================================
-- Spalten auswählen: Projektion
-- ============================================================

-- Eine einfache Liste
-- Die Personalabteilung möchte eine Liste mit Name, Tätigkeit und Grundgehalt
-- aller Mitarbeiter - ohne Vorgesetzten, Provision und Abteilung.
-- Welche Angaben braucht die Datenbank, um das zu liefern?




-- Rechnen und umbenennen
-- Die Geschäftsführung fragt nach dem Jahresgehalt jedes Mitarbeiters
-- (zwölf Monatsgehälter). In der Tabelle gibt es dafür keine Spalte.
-- Muss man die Tabelle erweitern?




-- Doppelte Werte entfernen
-- Welche Tätigkeiten kommen im Unternehmen überhaupt vor?
-- Was passiert, wenn man einfach nur die Spalte job abfragt?




-- ============================================================
-- Zeilen auswählen: Selektion
-- ============================================================

-- Vergleiche und Listen
-- Wer in den Abteilungen 10 oder 20 verdient mehr als 4000 EUR?
-- Ausgegeben werden sollen Name, Gehalt und Abteilungsnummer.
-- Womit sagt ihr der Datenbank, welche Zeilen ins Ergebnis gehören?




-- Muster in Texten
-- Welche Mitarbeiter der Abteilungen 20, 30 oder 40 haben einen Namen mit
-- genau vier Buchstaben, dessen zweiter Buchstabe ein "o" ist?
-- Wie beschreibt man ein solches Muster in SQL?




-- ============================================================
-- Bedingungen kombinieren
-- ============================================================

-- Gesucht sind die Mitarbeiter der Abteilungen 10 oder 20, die Manager sind
-- ODER mehr als 5000 EUR verdienen.
-- Formuliert die Bedingung zuerst so, wie ihr den Satz sprecht, und sagt vorher:
-- Wie viele Zeilen erwartet ihr? Vergleicht dann mit dem tatsächlichen Ergebnis.




-- ============================================================
-- Sortieren
-- ============================================================

-- Die Geschäftsführung möchte eine Gehaltsliste: das höchste Gehalt zuerst,
-- bei gleichem Gehalt alphabetisch nach Name.
-- Woran erkennt die Datenbank, in welcher Reihenfolge sie die Zeilen liefern soll?




-- ============================================================
-- Mehrere Tabellen: der Verbund
-- ============================================================

-- Was passiert ohne Verknüpfung?
-- Gesucht ist für jedes Projekt die Bezeichnung der verantwortlichen Abteilung.
-- Die Tabelle prj kennt nur die Abteilungsnummer - die Bezeichnung steht in abt.
-- Schreibt einmal beide Tabellen in den FROM-Teil, ohne weitere Bedingung.
-- Wie viele Zeilen erwartet ihr?




-- Zeilen über den Fremdschlüssel verknüpfen
-- Welche Bedingung sortiert die unsinnigen Kombinationen aus?
-- Gesucht ist eine Liste mit Abteilungsnummer, Bezeichnung, Projekttitel und
-- Kundennummer, geordnet nach Abteilungsnummer.




-- Eine Tabelle mit sich selbst verknüpfen
-- Wer sind die Untergebenen von Kron, und wie weit liegt ihr Gehalt unter seinem?
-- Gesucht sind Name, Tätigkeit, Gehalt und die Gehaltsdifferenz.
-- Vorgesetzter und Untergebener stehen beide in der Tabelle ma - wie löst man das?




