---
typ: praxisphase-woche
woche: 1
thema: "Warum Datenbanken? Grundarchitektur eines DBMS"
workload_minuten: 90
lernziele:
  - "kann die Begriffe Informationssystem, Datenbank und Datenbanksystem definieren und voneinander abgrenzen"
  - "kann erklären, warum ein einfacher dateibasierter Ansatz für die Massendatenspeicherung ungeeignet ist"
  - "kann die Drei-Ebenen-Schema-Architektur (externe, logische, interne Ebene) erklären und ihren Zweck benennen"
  - "kann die vier Phasen des Datenbankentwurfs benennen und den jeweiligen Ergebnissen (Schemata) zuordnen"
quelle_lehrbrief: "Kap. 1-2"
quelle_lehrbuch: "keine"
fallstudie: "keine"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-07-20
---

# Woche 1: Warum Datenbanken? Grundarchitektur eines DBMS

> Zeitbedarf: ca. 1,5 Stunden.

## Worum geht es?

Das ist die erste Einheit der Praxisphase. Bevor es in den nächsten Wochen
um konkrete Modellierungstechniken (ER-Modell, Relationenmodell,
Normalisierung) geht, brauchst du ein Grundverständnis dafür, *warum* es
Datenbanken überhaupt gibt und *wie* ein Datenbanksystem grob aufgebaut
ist. Diese Woche legt außerdem mit den "Phasen des Datenbankentwurfs" die
Landkarte für den gesamten weiteren Kurs: Jede der nächsten Wochen
entspricht genau einer Station auf dieser Landkarte.

## Das solltest du danach können

- Du kannst erklären, was eine Datenbank von einem "einfachen Haufen
  Dateien" unterscheidet.
- Du kannst mindestens vier konkrete Probleme benennen, die entstehen,
  wenn man versucht, Massendaten nur mit normalen Dateien zu verwalten.
- Du kannst die drei Ebenen der Drei-Ebenen-Schema-Architektur benennen
  und in eigenen Worten sagen, wofür diese Trennung gut ist.
- Du kannst die vier Phasen des Datenbankentwurfs in der richtigen
  Reihenfolge aufzählen und weißt, welches Ergebnis (Schema) am Ende
  jeder Phase steht.

## Erarbeitung

Lies im Lehrbrief (`Lehrbrief_relationaleDatenbanken.pdf`) die folgenden
Abschnitte der Reihe nach. Mach dir beim Lesen in eigenen Worten Notizen —
die brauchst du gleich für die Aufgabe unten.

1. Kapitel 1, "Datenbanken und Informationssysteme" (S. 8).
2. Kapitel 2, Einleitung (S. 9–11) — Nachteile eines **Dateiansatzes**.
3. Abschnitt 2.1, "Drei-Ebenen-Schema-Architektur" (S. 12–13).
4. Abschnitt 2.2, "Aufgaben eines Datenbanksystems" (S. 13–14).
5. Abschnitt 2.3, "Phasen des Datenbankentwurfs" (S. 14–18), besonders
   die Abbildung auf S. 16.
6. Abschnitt 2.4, "Die Datenbanksprache SQL" (S. 18–19) — nur ein erster
   Eindruck, Details folgen ab Woche 9.

## Aufgabe

Stell dir folgende Situation in deinem Praxisbetrieb vor:

> Ein Kollege schlägt vor, alle Maschinendaten (Wartungshistorie,
> verbaute Ersatzteile, Standorte) weiterhin in einer wachsenden
> Excel-Tabelle zu pflegen, die auf einem Netzlaufwerk liegt und von
> mehreren Personen bearbeitet wird — "das hat doch bisher auch immer
> funktioniert".

Schreib eine kurze schriftliche Stellungnahme (ca. 150–250 Wörter), in
der du:

1. mindestens drei konkrete Probleme benennst, die bei diesem Vorgehen
   mit wachsender Datenmenge und mehreren gleichzeitigen Nutzern
   auftreten (nutze Begriffe wie Redundanz, Inkonsistenz,
   Mehrbenutzerbetrieb),
2. in eigenen Worten erklärst, welche Vorteile ein Datenbanksystem hier
   bieten würde,
3. kurz skizzierst, in welchen Phasen der Entwurf einer solchen Datenbank
   ablaufen würde, wenn man es "richtig" machen wollte.

??? tip "Musterlösung anzeigen"
    Eine mögliche Stellungnahme:

    Die Excel-Lösung wirkt kurzfristig praktikabel, bringt aber mit
    wachsender Nutzung mehrere strukturelle Probleme mit sich. Erstens
    entsteht **Redundanz**: Wartungsdaten, Ersatzteilinformationen und
    Standortangaben werden vermutlich in mehreren Tabellenblättern oder
    sogar mehreren Dateien parallel gepflegt, weil Excel keine
    Mechanismen bietet, um verknüpfte Informationen zentral an einer
    Stelle zu halten. Zweitens folgt daraus fast zwangsläufig
    **Inkonsistenz**: Wird z. B. ein Standort in einem Tabellenblatt
    aktualisiert, aber in einem anderen vergessen, entstehen
    widersprüchliche Datenstände, ohne dass dies technisch auffällt.
    Drittens ist der **Mehrbenutzerbetrieb** kaum kontrolliert möglich:
    Bearbeiten zwei Personen gleichzeitig dieselbe Datei auf dem
    Netzlaufwerk, drohen Datenverlust oder sich gegenseitig
    überschreibende Änderungen, ohne dass es einen Mechanismus gibt,
    der das verhindert oder auch nur sichtbar macht.

    Ein Datenbanksystem würde diese Probleme durch zentrale, einmalige
    Datenhaltung (statt redundanter Kopien), kontrollierten
    gleichzeitigen Zugriff mehrerer Nutzer sowie definierte
    Konsistenzregeln lösen. Der "richtige" Weg dorthin würde über die
    vier Phasen des Datenbankentwurfs führen: zunächst eine
    **Anforderungsanalyse** (was genau muss gespeichert werden, wer
    braucht welchen Zugriff?), darauf aufbauend ein **konzeptueller
    Entwurf** als ER-Modell (welche Objekte/Beziehungen gibt es
    fachlich?), anschließend die Überführung in ein **logisches Schema**
    (Relationenmodell) und schließlich die **Datendefinition**, also die
    konkrete Umsetzung dieses Schemas in einer Datenbank mittels SQL.

## Selbstkontrolle

### Frage 1

Definiere in eigenen Worten die Begriffe "Informationssystem", "Datenbank"
und "Datenbanksystem". Worin genau unterscheiden sich "Datenbank" und
"Datenbanksystem"?

??? question "Antwort anzeigen"
    Ein **Informationssystem** ist ein Softwaresystem zur Erfassung,
    Verarbeitung, Speicherung, Auswertung und Anzeige von Informationen
    — z. B. eine Warenwirtschafts- oder Kundenverwaltungssoftware mit
    Benutzeroberfläche. Eine **Datenbank** ist demgegenüber
    (konzeptionell) eine Sammlung logisch zusammenhängender Daten, die
    einen Ausschnitt der realen Welt beschreiben und von einer Gruppe
    von Nutzern für einen bestimmten Zweck verwendet werden. Ein
    **Datenbanksystem** ist die technische Realisierung dieser
    Datenbank: Es besteht aus der **Datenbasis** (den eigentlich
    gespeicherten Daten) und dem **Datenbankmanagementsystem (DBMS)** —
    der Software, die den kontrollierten Zugriff auf diese Daten
    ermöglicht.

    Kurz gesagt: "Datenbank" ist eher der fachliche/konzeptionelle
    Begriff, "Datenbanksystem" der technische — beide Begriffe werden im
    Alltag aber oft synonym verwendet.

### Frage 2

Nenne mindestens vier der im Lehrbrief beschriebenen Nachteile, die
auftreten, wenn Massendaten mit einem reinen Dateiansatz statt mit einem
Datenbanksystem verwaltet werden.

??? question "Antwort anzeigen"
    - **Redundanz**: Daten werden getrennt und mehrfach gespeichert.
    - **Inkonsistenz**: Folge der Redundanz — Änderungen werden nicht
      überall synchron nachgezogen.
    - **Fehlende integrierte Auswertbarkeit**: Unterschiedliche
      Datenstrukturen in verschiedenen Dateien erschweren übergreifende
      Auswertungen.
    - **Probleme im Mehrbenutzerbetrieb**: kaum Mechanismen zur
      Koordination gleichzeitigen Zugriffs.
    - **Geringer Schutz vor Datenverlust**: nur periodische Sicherungen
      möglich.
    - **Schwacher Datenschutz**: nur eingeschränkte Rechtevergabe
      möglich.
    - **Hoher Aufwand für effiziente Speicherung**: individuelle,
      performante Speicherstrukturen sind teuer und erfordern
      Spezialwissen.

### Frage 3

Die Drei-Ebenen-Schema-Architektur unterscheidet drei Ebenen. Wie heißen
sie, und was ist der Zweck dieser Trennung?

??? question "Antwort anzeigen"
    1. **Externe Ebene** (mehrere externe Schemata/Sichten) — je eine
       Sicht pro Anwendergruppe oder Informationssystem.
    2. **Logische Ebene** (ein konzeptuelles Schema) — legt fest, welche
       Daten überhaupt gespeichert werden.
    3. **Interne Ebene** (ein internes Schema) — legt fest, wie die
       Daten physisch abgelegt werden.

    Zweck ist die **Datenunabhängigkeit** ("Separation of Concerns"):
    Jede Ebene adressiert nur ihr eigenes Teilproblem, sodass sich z. B.
    die physische Speicherung ändern lässt, ohne die logische Struktur
    oder Anwendungen anzupassen.

### Frage 4

Nenne die vier Phasen des Datenbankentwurfs in der richtigen Reihenfolge.
Ordne jeder Phase zu, welches Schema bzw. Ergebnis am Ende dieser Phase
steht.

??? question "Antwort anzeigen"
    1. **Anforderungsanalyse** → informell dokumentierte
       Datenbankanforderungen.
    2. **Konzeptueller Datenbankentwurf** → konzeptuelles Schema
       (i. d. R. ER-Modell).
    3. **Logischer Datenbankentwurf** → logisches Schema (i. d. R.
       Relationenmodell).
    4. **Datendefinition** → konkrete Datenstrukturen in einer
       Datenbanksprache (SQL).

### Frage 5

Nenne zwei Eigenschaften, die laut Lehrbrief die Datenbanksprache SQL
charakterisieren.

??? question "Antwort anzeigen"
    Z. B.: an die englische Umgangssprache angelehnt, mengenorientiert
    (statt satzorientiert), deskriptiv (statt prozedural), mathematisch
    wohldefiniert, standardisiert, aus mehreren orthogonalen
    Teilsprachen aufgebaut. Zwei davon reichen.