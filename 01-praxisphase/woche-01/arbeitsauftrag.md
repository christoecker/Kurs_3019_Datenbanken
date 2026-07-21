---
typ: praxisphase-arbeitsauftrag
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
status: entworfen
---

# Woche 1: Warum Datenbanken? Grundarchitektur eines DBMS

> Zeitbedarf: ca. 1,5 Stunden. Bearbeite diese Einheit vollständig im
> Selbststudium — es gibt in dieser Phase keine Präsenzveranstaltung dazu.

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

1. Kapitel 1, "Datenbanken und Informationssysteme" (S. 8). Kurzer
   Überblick: Wie hängen Informationssysteme und Datenbanken zusammen?
2. Kapitel 2, Einleitung (S. 9–11). Achte besonders auf die Liste der
   Nachteile eines **Dateiansatzes** — das ist die Kernbegründung, warum
   es Datenbanksysteme überhaupt gibt.
3. Abschnitt 2.1, "Drei-Ebenen-Schema-Architektur" (S. 12–13).
4. Abschnitt 2.2, "Aufgaben eines Datenbanksystems" (S. 13–14). Die neun
   Anforderungen müssen nicht auswendig gelernt werden, aber du solltest
   grob wiedergeben können, welche Problembereiche sie abdecken.
5. Abschnitt 2.3, "Phasen des Datenbankentwurfs" (S. 14–18) — besonders
   die Abbildung auf S. 16. Diese Abbildung ist wichtig: Sie zeigt genau
   den Weg, den du in den kommenden Wochen selbst gehen wirst (Woche 2–3:
   konzeptueller Entwurf/ER-Modell, Woche 4–6: logischer Entwurf/
   Relationenmodell, Woche 9–11: Datendefinition mit SQL).
6. Abschnitt 2.4, "Die Datenbanksprache SQL" (S. 18–19) — hier reicht ein
   erster Eindruck. Die Details zu SQL folgen erst ab Woche 9, wenn du
   selbst am SQL Server arbeitest.

Diese Woche findet **ohne KI-Unterstützung** statt (Stufe 0) — es geht
darum, dass du dir die Grundbegriffe selbst erarbeitest, bevor du sie
später mit KI-Werkzeugen einsetzt.

## Aufgabe

Stell dir folgende Situation in deinem Ausbildungsbetrieb vor:

> Ein Kollege schlägt vor, alle Maschinendaten (Wartungshistorie,
> verbaute Ersatzteile, Standorte) weiterhin in einer wachsenden
> Excel-Tabelle zu pflegen, die auf einem Netzlaufwerk liegt und von
> mehreren Personen bearbeitet wird — "das hat doch bisher auch immer
> funktioniert".

Schreib eine kurze schriftliche Stellungnahme (ca. 150–250 Wörter), in
der du:

1. mindestens drei konkrete Probleme benennst, die bei diesem Vorgehen
   mit wachsender Datenmenge und mehreren gleichzeitigen Nutzern
   auftreten (nutze die Begriffe aus dem Lehrbrief, z. B. Redundanz,
   Inkonsistenz, Mehrbenutzerbetrieb),
2. in eigenen Worten erklärst, welche Vorteile ein Datenbanksystem hier
   bieten würde,
3. kurz skizzierst, in welchen Phasen der Entwurf einer solchen Datenbank
   ablaufen würde, wenn man es "richtig" machen wollte.

Speichere deine Stellungnahme als Text (z. B. in einer eigenen Notiz) —
sie wird nicht eingereicht, dient aber als Grundlage, um dein Verständnis
in der Selbstkontrolle zu prüfen.

## Selbstkontrolle

Siehe `selbstkontrolle.md` im selben Ordner — bearbeite diese erst,
NACHDEM du die Aufgabe oben abgeschlossen hast.
