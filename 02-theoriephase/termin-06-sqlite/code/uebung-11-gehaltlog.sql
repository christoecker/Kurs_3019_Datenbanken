-- BestTec für SQLite: Protokolltabelle gehalt_log (Gehaltsänderungen nachvollziehen)
-- Bewusst ohne Fremdschlüssel auf ma: Das Protokoll soll erhalten bleiben,
-- auch wenn ein Mitarbeiter später gelöscht wird.
-- Eine Spalte "benutzer" fehlt, denn SQLite kennt keine Datenbankbenutzer.
CREATE TABLE gehalt_log (
    lognr      INTEGER       PRIMARY KEY AUTOINCREMENT,
    manr       NUMERIC(4)    NOT NULL,
    gehalt_alt NUMERIC(9,2)  NOT NULL,
    gehalt_neu NUMERIC(9,2)  NOT NULL,
    zeitpunkt  TEXT          NOT NULL DEFAULT CURRENT_TIMESTAMP
);
