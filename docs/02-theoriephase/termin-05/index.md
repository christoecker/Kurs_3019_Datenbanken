---
typ: theoriephase-termin-uebersicht
termin: 5
datum: "2026-11-24"
thema_termin: "Mini-Projekt: Ticketsystem Instandhaltung"
workload_minuten: 60
lernziele:
  - "Ihr könnt die Inhalte der Termine 1 bis 4 (Modellierung, Relationenmodell, Normalisierung, SQL, Rechte, Prozeduren und Trigger) in einem zusammenhängenden Projekt anwenden."
bearbeitungsstatus: entworfen
publish_date: 2026-11-17
---

# Termin 5 (24.11.2026) — Mini-Projekt

Heute gibt es keine Einzelübungen. Ihr arbeitet den ganzen Termin in
Gruppen an einem **Datenbank-Projekt**: Eine Auftraggeberin bestellt eine
Datenbank, und ihr entwickelt sie in SQL Server, von den Anforderungen
über das Modell bis zur fertigen Datenbank mit Tabellen, Constraints,
Rechten, Prozeduren, Triggern und Abfragen. Dazu schreibt ihr eigene
Tests. Alles steht auf einer Seite:
[Mini-Projekt: Ticketsystem Instandhaltung](block-09-10.md).

> Zeitbedarf zur Vorbereitung: ca. 60 Minuten.

## Vorbereitung

### Worum geht es?

Um den Auftrag geht es in dieser E-Mail. Sie ist heute bei euch
eingegangen:

!!! email ""
    <div class="email-kopf"><b>Von:</b> Sabine Vogel (Betriebsleitung), Brandt Kunststofftechnik GmbH<br><b>An:</b> Projektteam Datenbank<br><b>Datum:</b> 17.11.2026<br><b>Betreff:</b> Ticketsystem für unsere Instandhaltung</div>

    Guten Tag,

    die Brandt Kunststofftechnik GmbH fertigt in drei Hallen und drei
    Schichten Spritzgussteile. Rund 120 Beschäftigte und etwa 45 Maschinen
    sorgen dafür, dass die Aufträge unserer Kunden pünktlich rausgehen.

    Bei uns ist in den letzten Jahren einiges gewachsen — leider auch das
    Durcheinander in der Instandhaltung. Wenn in der Halle etwas kaputtgeht,
    rufen die Leute bisher einfach irgendeinen Techniker an. Hinterher
    weiß niemand mehr genau, wer was gemeldet hat, wer sich darum gekümmert
    hat und ob es überhaupt erledigt ist. Das führt zu Ärger zwischen den
    Schichten und der Instandhaltung.

    Ich stelle mir das so vor: Wenn an einer Maschine etwas nicht in Ordnung
    ist, wird dazu eine Störungsmeldung erfasst, in der das technische Problem
    beschrieben wird. In der Instandhaltung sollen diese Meldungen erfasst
    werden, und daraus werden Wartungsaufträge erstellt. Unsere Techniker
    arbeiten diese Aufträge ab und beheben so die Störungen.

    Das System muss aber flexibel genug sein für Eilaufträge: Wenn eine Störung
    so dringend ist, dass die Produktion ausfallen könnte, wird sie dem
    Techniker oft nur mündlich mitgeteilt und steht deshalb nicht im System.
    Auch dann soll er sofort einen Auftrag anlegen können.

    Wer dabei was machen darf, was automatisch passieren soll und was nie
    vorkommen darf, klären wir im Gespräch. Bauen Sie uns dafür bitte die
    Datenhaltung. Eine Bedienoberfläche brauchen wir noch nicht, das kommt
    später.

    Leider bin ich bis zum 20.11. auf einer Messe und ab dem 23.11. auf
    Dienstreise, sodass wir vorher nicht sprechen können. Am 24.11. können
    wir die Details aber gerne in einem kurzen Chat klären. Den Link dazu
    schicke ich Ihnen an dem Tag per E-Mail.

    Freundliche Grüße  
    Sabine Vogel

Mehr wisst ihr vorab nicht, und mehr müsst ihr auch nicht wissen. Alles
Weitere klärt ihr am Termin selbst.

### So läuft der Termin ab

1. **Gespräch mit Frau Vogel:** ein Chat von höchstens 20 Minuten, in dem
   ihr durch Fragen die Anforderungen herausfindet.
2. **Entwerfen und Umsetzen:** Modell, Tabellen, Rechte, Prozeduren,
   Trigger, Abfragen und eigene Tests.
3. **Zwischentermin:** Mitten im Projekt meldet sich Frau Vogel noch
   einmal (höchstens 15 Minuten).
4. **Weiterarbeiten, Testen, Dokumentieren.**
5. **Erfahrungsaustausch:** Wir besprechen, *warum* ihr euch so
   entschieden habt.

!!! tip "KI-Unterstützung ist ausdrücklich erlaubt und erwünscht"
    Das Mini-Projekt ist dafür gedacht, mit KI zu entwickeln. Ohne KI
    wäre der zeitliche Rahmen nicht zu schaffen. Nutzt sie, wo ihr wollt.
    Entscheidend ist, dass ihr jeden Schritt versteht und prüft. Wie das
    gemeint ist, steht am Termin auf der Projektseite.

### Bis zum Termin

- **Gruppe bilden:** höchstens drei Personen. Die Gruppennummer bekommt
  ihr am Termin.
- **Werkzeuge prüfen:** SQL Server 2025 Express läuft, ihr könnt euch mit
  SSMS verbinden und in einer Testdatenbank eine Tabelle anlegen. drawDB
  öffnet im Browser (Datenbanktyp MSSQL), und euer KI-Zugang funktioniert.
- **Fragen an Frau Vogel vorbereiten** (Aufgabe, siehe unten).

### Aufgabe: Das Gespräch mit Frau Vogel vorbereiten

Ihr bekommt am Termin nur 20 Minuten, um mit Frau Vogel im Chat die
Anforderungen zu klären. In der Praxis bereitet man sich auf ein solches
Gespräch gezielt vor, und genau das ist eure Aufgabe, am besten
gemeinsam in der Gruppe.

Lest die E-Mail oben und überlegt: **Was müsstet ihr wissen, um dafür eine
Datenbank zu bauen?** Schreibt eure Fragen auf (etwa 10 bis 15) und
sortiert sie nach diesen Bereichen:

- **Beteiligte:** Wer arbeitet mit dem System?
- **Funktionsweise:** Wie soll das System künftig funktionieren?
- **Daten:** Was muss gespeichert werden?
- **Regeln:** Was ist erlaubt, was verboten, was muss immer gelten?
- **Rechte:** Wer darf was sehen und ändern?
- **Auswertungen:** Was soll man jederzeit auf einen Blick sehen können?
- **Priorität:** Was ist notwendig, was wäre schön, was später?

**Tipps:** Frau Vogel ist keine Datenbank-Fachfrau und versteht keine
Fachbegriffe. Formuliert eure Fragen deshalb in Alltagssprache.

### Zur Auffrischung

Im Projekt kommt alles ab Termin 1 zur Anwendung. Schaut bei Bedarf in
diese Einheiten:

- **Termin 1:** ER-Modellierung und Transformation ins Relationenmodell
  ([ER-Modell aufstellen](../termin-01/block-01.md),
  [Transformation](../termin-01/block-02.md)).
- **Termin 2:** Normalisierung, Tabellen und Constraints in SQL Server
  ([Normalisierung](../termin-02/block-03.md),
  [Relationenschema anlegen](../termin-02/block-04.md)).
- **Termin 3:** Abfragen und Datenänderungen
  ([SQL-Abfragen](../termin-03/block-05.md),
  [Eigene Abfragen](../termin-03/block-06.md)).
- **Termin 4:** Rechte, Prozeduren und Trigger
  ([Zugriffsrechte](../termin-04/block-07.md),
  [Prozeduren und Trigger](../termin-04/block-08.md)).
