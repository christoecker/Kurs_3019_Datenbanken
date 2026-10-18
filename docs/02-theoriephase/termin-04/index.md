---
typ: theoriephase-termin-uebersicht
termin: 4
datum: "2026-11-17"
thema_termin: "Zugriffsrechte, Prozeduren und Trigger"
workload_minuten: 90
lernziele:
  - "Ihr könnt anhand von Lehrbuch Kapitel 11 erklären, was eine View ist, und beschreiben, wofür man Zugriffsrechte für Datenbanknutzer vergibt."
  - "Ihr könnt anhand von Lehrbuch Kapitel 12 beschreiben, was gespeicherte Prozeduren und Trigger sind und worin sie sich unterscheiden."
bearbeitungsstatus: entworfen
publish_date: 2026-11-03
---

# Termin 4 (17.11.2026) — Zugriffsrechte, Prozeduren und Trigger

Bisher habt ihr Daten angelegt, abgefragt und geändert. Heute geht es um
die Frage, wer das darf und was die Datenbank selbst tun kann. Im ersten
Block, [Zugriffsrechte und Benutzerverwaltung](block-07.md), entwerft
und prüft ihr ein Rechtekonzept. Im zweiten Block, [Prozeduren und
Trigger](block-08.md), lest ihr Programme, die in der Datenbank liegen,
und entscheidet, wann sie sinnvoll sind.

> Zeitbedarf zur Vorbereitung: ca. 90 Minuten.

## Vorbereitung

### Worum geht es?

Für diesen Termin ist das Lehrbuch von Kleuker die Grundlage, denn der
Lehrbrief behandelt diese Themen nicht. Lest vorab die unten genannten
Teile der Kapitel 11 und 12. Ihr müsst nichts selbst anwenden oder
auswendig können — es genügt, wenn ihr die Begriffe und Ideen einmal
gesehen habt, denn die Übungen setzen genau dort an.

Das Lehrbuch arbeitet mit einem anderen Datenbanksystem (PL/SQL). Die
Konzepte sind dieselben, die Befehle weichen aber von SQL Server ab. Das
ist kein Problem: Wir arbeiten im Kurs mit SQL Server, und die
Unterschiede sind auf der Seite [SQL Server und Lehrbuch/Lehrbrief:
Abweichungen](../../info/sql-server-vs-lehrbrief.md) zusammengestellt.
Konzentriert euch beim Lesen auf das **Was** und **Warum**, nicht auf
die genaue Schreibweise.

### Zu bearbeiten: Lehrbuch Kapitel 11 und 12

**Pflicht — Kapitel 11 „Rechte und Views“ (S. 233–241):**

- **11.1 Views (S. 234–237):** Wie man Abfrageergebnisse dauerhaft wie
  Tabellen nutzbar macht.
- **11.2 Rechte für die Datenbank-Administration (S. 238–239):** Wie
  Rechte und Rollen vergeben werden und wie man mit Views Daten vor
  bestimmten Nutzern verbirgt.
- **11.3 Rechte für die Projekt-Administration (S. 240–241):** Wie
  Nutzer und Rechte für die Arbeit in einem Projekt eingerichtet
  werden.

Die Aufgaben in 11.4 (S. 242) solltet ihr noch nicht bearbeiten.

**Pflicht — Kapitel 12 „Stored Procedures und Trigger“ (S. 243–280):**

- **12.1 Einführung in PL/SQL (S. 245–258):** Wie man in der Datenbank
  Programme (Prozeduren) ablegt: Parameter, Variablen und Abläufe.
- **12.3 Trigger (S. 268–276):** Was Trigger sind, wann sie ausgelöst
  werden und was sie bewirken.

**Empfohlen:** In Abschnitt 12.2 (S. 259–267) geht es um Cursor. Sie
sind für unsere Übungen nicht nötig. Die Aufgaben in 12.4 (S. 277–280)
solltet ihr noch nicht bearbeiten.

### Alles verstanden?

Prüft euer Verständnis mit diesen drei Fragen:

**1. Was ist eine View, und wofür kann man sie einsetzen?**
(Abschnitt 11.1)

??? note "Musterlösung anzeigen"
    Eine View ist eine gespeicherte Abfrage, die sich wie eine Tabelle
    verwenden lässt. Sie zeigt nur einen Ausschnitt der Daten (bestimmte
    Spalten oder Zeilen). Man setzt sie ein, um Nutzern nur die Daten zu
    zeigen, die sie brauchen, und um komplizierte Abfragen zu
    vereinfachen.

**2. Was ist ein Trigger, und wie unterscheidet er sich von einer
Prozedur?** (Abschnitte 12.1 und 12.3)

??? note "Musterlösung anzeigen"
    Ein Trigger ist ein Programm, das die Datenbank automatisch
    ausführt, wenn sich Daten ändern (z. B. bei einem `UPDATE`). Eine
    Prozedur läuft dagegen nur, wenn jemand sie ausdrücklich aufruft.

**3. Warum vergibt man Rechte nicht an einzelne Personen, sondern an
Gruppen oder Rollen?** (Abschnitte 11.2 und 11.3)

??? note "Musterlösung anzeigen"
    Rechte an Rollen zu binden ist übersichtlicher und weniger
    fehleranfällig: Kommt jemand hinzu oder wechselt die Aufgabe,
    ändert man nur die Zugehörigkeit zur Rolle statt viele einzelne
    Rechte.

### Zur Auffrischung

**Für Block 07 (Zugriffsrechte und Benutzerverwaltung)** — aus der
Praxisphase und Termin 3:

- Die externe Ebene der Drei-Ebenen-Architektur zeigt jeder
  Nutzergruppe nur einen Ausschnitt der Daten; in SQL Server sind das
  die Sichten (Praxisphase Woche 1).
- Was ein `UPDATE` oder `DELETE` ohne `WHERE` anrichtet (Termin 3,
  Datenänderung).

**Für Block 08 (Prozeduren und Trigger)** — aus Termin 2 und der
vorherigen Einheit:

- Constraints (`CHECK`, `UNIQUE`, Fremdschlüssel) als Regeln, die die
  Datenbank selbst durchsetzt (Termin 2).
- Rollen und Rechte aus Block 07, denn der Prüfstand bekommt dort nur
  noch das Recht, eine Prozedur aufzurufen.
