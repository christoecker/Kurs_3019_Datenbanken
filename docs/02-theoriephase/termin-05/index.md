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
sortiert sie nach den folgenden Bereichen. Die Bereiche zeigen auch, was
ihr nach dem Gespräch beantworten können müsst.

**Das müsst ihr nach dem Gespräch beantworten können.** Zu jedem Bereich
steht ein Beispiel dafür, welche Information ihr braucht:

- **Beteiligte:** Wer arbeitet mit dem System, welche Gruppen von Nutzern
  gibt es, ist eine Gruppe ein Teil einer anderen, und was muss man über
  sie festhalten? Was davon ist eindeutig?<br>
  *Beispiel:* Welche Angaben braucht ihr zu einem Mitarbeiter, und was ist
  bei einem Techniker anders?
- **Funktionsweise:** Wie läuft ein Vorgang von Anfang bis Ende ab, wer
  löst wann welchen Schritt aus, welche Zustände gibt es, und welche
  Wechsel zwischen ihnen sind erlaubt?<br>
  *Beispiel:* Was passiert mit einer Störungsmeldung, nachdem sie angelegt
  wurde, und wer entscheidet, wie es weitergeht?
- **Daten:** Welche Dinge muss das System festhalten, welche Merkmale
  haben sie, wie hängen sie zusammen (und wie viele gehören jeweils
  zusammen), und gibt es Arten eines Dings oder Dinge, die nur zusammen mit
  einem anderen existieren?<br>
  *Beispiel:* Betrifft eine Störungsmeldung immer genau eine Maschine,
  und kann zu einer Maschine mehr als eine Meldung vorliegen? Was
  unterscheidet einen Wartungsauftrag von einem Eilauftrag?
- **Regeln:** Was muss immer gelten, was darf nie passieren, und was soll
  das System von selbst erledigen?<br>
  *Beispiel:* Was soll automatisch passieren, wenn ein Auftrag erledigt
  ist, und was darf gar nicht erst passieren?
- **Rechte:** Wer darf was sehen, anlegen, ändern und löschen, und welche
  Angaben dürfen nur bestimmte Gruppen sehen?<br>
  *Beispiel:* Darf jeder Mitarbeiter einen Auftrag anlegen, wer darf eine
  Meldung löschen, und welche Angaben sieht nicht jeder?
- **Auswertungen:** Welche Übersichten braucht wer regelmäßig auf einen
  Blick?<br>
  *Beispiel:* Was will die Leitung morgens als Erstes sehen?
- **Priorität:** Was ist notwendig, was wäre schön, und was ist
  ausdrücklich erst für später gedacht?<br>
  *Beispiel:* Ist es notwendig, dass ein Auftrag auch ohne vorherige
  Meldung angelegt werden kann, oder wäre das nur schön?

**Nicht alles sagt Frau Vogel von sich aus.** Sie ist keine
Datenbank-Fachfrau und kennt zum Beispiel nicht die technischen Begriffe
für Regeln oder Rechte. Manches müsst ihr deshalb durch Nachfragen
herausbekommen, und manches entscheidet ihr selbst. Haltet solche
Entscheidungen fest; am Termin hilft dabei eine Tabelle zum Mitschreiben.

**Tipps:** Formuliert eure Fragen in Alltagssprache, denn Frau Vogel
versteht keine Fachbegriffe. Da die Zeit knapp ist, markiert die
wichtigsten Fragen und verteilt vorab die Rollen (Fragen stellen,
mitschreiben, Zeit im Blick behalten). Bringt eure Liste zum Termin mit.
Eine Abgabe ist nicht nötig.

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
