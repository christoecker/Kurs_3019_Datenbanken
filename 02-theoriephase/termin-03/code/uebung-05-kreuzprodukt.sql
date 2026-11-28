-- Ohne Verknüpfungsbedingung: jede Abteilung mit jedem Projekt (5 * 4 = 20 Zeilen)
SELECT abt.bezeichnung, prj.titel
FROM abt, prj;
