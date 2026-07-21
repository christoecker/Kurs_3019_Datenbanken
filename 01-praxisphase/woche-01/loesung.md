---
typ: praxisphase-loesung
woche: 1
gehoert_zu: selbstkontrolle.md
---

# Lösung zur Selbstkontrolle Woche 1

## Zu Frage 1

Ein **Informationssystem** ist ein Softwaresystem zur Erfassung,
Verarbeitung, Speicherung, Auswertung und Anzeige von Informationen — z. B.
eine Warenwirtschafts- oder Kundenverwaltungssoftware mit
Benutzeroberfläche. Eine **Datenbank** ist demgegenüber (konzeptionell)
eine Sammlung logisch zusammenhängender Daten, die einen Ausschnitt der
realen Welt beschreiben und von einer Gruppe von Nutzern für einen
bestimmten Zweck verwendet werden. Ein **Datenbanksystem** ist die
technische Realisierung dieser Datenbank: Es besteht aus der **Datenbasis**
(den eigentlich gespeicherten Daten) und dem **Datenbankmanagementsystem
(DBMS)** — der Software, die den kontrollierten Zugriff auf diese Daten
ermöglicht.

Kurz gesagt: "Datenbank" ist eher der fachliche/konzeptionelle Begriff,
"Datenbanksystem" der technische — beide Begriffe werden im Alltag aber
oft synonym verwendet. Ein Informationssystem *nutzt* ein Datenbanksystem,
um seine Daten dauerhaft zu speichern; ohne Datenbanken sind
Informationssysteme praktisch nicht denkbar.

## Zu Frage 2

Der Lehrbrief nennt u. a. folgende Nachteile eines Dateiansatzes (jede
korrekt benannte und kurz erklärte Auswahl von mindestens vier reicht):

- **Redundanz**: Daten werden getrennt und mehrfach gespeichert.
- **Inkonsistenz**: Folge der Redundanz — Änderungen werden nicht überall
  synchron nachgezogen, wodurch widersprüchliche Datenstände entstehen.
- **Fehlende integrierte Auswertbarkeit**: Unterschiedliche Datenstrukturen
  in verschiedenen Dateien machen eine übergreifende Auswertung nahezu
  unmöglich.
- **Probleme im Mehrbenutzerbetrieb**: Dateisysteme bieten kaum
  Mechanismen, um gleichzeitigen Zugriff mehrerer Nutzer zu koordinieren
  (Gefahr von Datenverlust/-verfälschung).
- **Geringer Schutz vor Datenverlust**: Nur periodische Sicherungen
  möglich, Daten seit der letzten Sicherung sind bei einem Ausfall
  unwiederbringlich verloren.
- **Schwacher Datenschutz**: Nur sehr eingeschränkte Vergabe von
  Zugriffsrechten möglich.
- **Hoher Aufwand für effiziente Speicherung**: Individuelle,
  performante Speicherstrukturen zu entwickeln ist teuer und erfordert
  Spezialwissen.

## Zu Frage 3

Die drei Ebenen sind:

1. **Externe Ebene** (mehrere externe Schemata/Sichten) — je eine Sicht
   pro Anwendergruppe oder Informationssystem.
2. **Logische Ebene** (ein konzeptuelles Schema) — legt fest, welche
   Daten überhaupt in der Datenbank gespeichert werden.
3. **Interne Ebene** (ein internes Schema) — legt fest, wie die Daten
   physisch auf dem Speichermedium abgelegt werden.

Zweck der Trennung ist die **Datenunabhängigkeit** bzw. Komplexitäts-
reduktion (im Lehrbrief als "Separation of Concerns" bezeichnet): Jede
Ebene adressiert nur ihr eigenes Teilproblem. So können z. B. einzelne
Anwendungen nur die für sie relevanten Daten sehen (externe Sicht,
reduziert Komplexität und schränkt Zugriff ein), und die physische
Speicherung kann geändert werden, ohne dass sich dadurch etwas an der
logischen Struktur oder den Anwendungen ändern muss.

## Zu Frage 4

1. **Anforderungsanalyse** → Ergebnis: informell dokumentierte
   Datenbankanforderungen (Text, Tabellen, Formulare).
2. **Konzeptueller Datenbankentwurf** → Ergebnis: konzeptuelles
   Datenbankschema (i. d. R. als ER-Modell/ER-Diagramm).
3. **Logischer Datenbankentwurf** → Ergebnis: logisches Datenbankschema
   (i. d. R. als Relationenmodell).
4. **Datendefinition** → Ergebnis: konkrete Datenstrukturen, umgesetzt in
   einer Datenbanksprache (SQL), direkt in der Datenbank anlegbar.

(Optional, nicht Teil des Kurses: im Anschluss folgt in der Praxis noch
der physische Datenbankentwurf, der Speicherstrukturen und Zugriffspfade
festlegt — das ist Aufgabe des Datenbankadministrators und wird im
Lehrbrief nur der Vollständigkeit halber erwähnt.)

## Zu Frage 5

Der Lehrbrief nennt für SQL u. a.: an die englische Umgangssprache
angelehnt, mengenorientiert (statt satzorientiert), deskriptiv (statt
prozedural), mathematisch wohldefiniert, standardisiert, und aus mehreren
orthogonalen Teilsprachen aufgebaut. Zwei davon korrekt benannt und kurz
erklärt reichen für die Selbstkontrolle.
