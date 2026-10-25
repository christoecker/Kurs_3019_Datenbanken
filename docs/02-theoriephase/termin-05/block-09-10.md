---
typ: theoriephase-block
termin: 5
block_id: "09-10"
datum: "2026-11-24"
kurztitel: "Mini-Projekt: Ticketsystem Instandhaltung"
thema: "Mini-Projekt: Von einem unscharfen Auftrag zur Datenbankanwendung (Anforderungen klären, Entwurf, Implementierung mit Rechten, Prozeduren und Triggern, eigene Tests) - mit KI-Unterstützung"
lernziele:
  - "Ihr könnt durch gezielte Fragen die Anforderungen eines Auftraggebers klären und zwischen Notwendigem, Wünschenswertem und bloßen Zukunftsideen unterscheiden."
  - "Ihr könnt aus den Anforderungen ein Datenbankmodell herleiten und eure Entwurfsentscheidungen begründen."
  - "Ihr könnt das Modell in SQL Server umsetzen: Tabellen, Constraints, Rechte, Prozeduren, Trigger und Abfragen."
  - "Ihr könnt eigene Testfälle schreiben, die die Regeln der Datenbank prüfen."
  - "Ihr könnt ein Datenbankmodell weiterentwickeln und die Auswirkungen auf Skripte, Rechte und Tests benennen."
  - "Ihr könnt KI-Ergebnisse gegen die Anforderung prüfen und dokumentieren, was ihr übernommen, korrigiert oder verworfen habt."
musterloesungen_sichtbar: false
nachtrag_sichtbar: false
fallstudie: "Brandt Kunststofftechnik: Ticketsystem für die Instandhaltung (eigenes MEA-Szenario)"
ki_einsatz: stufe_3_pflicht_reflexion
bearbeitungsstatus: entworfen
publish_date: 2026-11-24
---

# Mini-Projekt: Ticketsystem Instandhaltung (24.11.2026)

## Mini-Projekt { .modus-miniprojekt }

### Worum geht es?

Heute baut ihr eine Datenbank für einen echten Auftrag, wie er in einem
Betrieb vorkommen könnte. Den Auftrag kennt ihr schon von der
[Übersichtsseite](index.md): Frau Vogel will ein Ticketsystem für die
Instandhaltung. Alles Weitere müsst ihr selbst herausfinden: Ihr stellt
Fragen, entscheidet, was gebaut werden soll, entwerft das Modell und setzt
es in SQL Server um, mit Rechten, Constraints, Prozeduren, Triggern,
Abfragen und eigenen Tests. Alles, was ihr in den Terminen 1 bis 4
gelernt habt, kommt vor. Dabei arbeitet ihr mit voller KI-Unterstützung;
wie das gemeint ist, steht im Abschnitt „Arbeiten mit KI“.

Es gibt nicht die eine richtige Lösung. Wichtiger als ein
vollständiges System ist, dass ihr eure Entscheidungen begründen könnt,
denn genau darüber sprechen wir am Ende.

!!! abstract "Lernziele"
    - Ihr könnt durch gezielte Fragen die Anforderungen eines
      Auftraggebers klären und zwischen Notwendigem, Wünschenswertem und
      bloßen Zukunftsideen unterscheiden.
    - Ihr könnt aus den Anforderungen ein Datenbankmodell herleiten und
      eure Entwurfsentscheidungen begründen.
    - Ihr könnt das Modell in SQL Server umsetzen: Tabellen,
      Constraints, Rechte, Prozeduren, Trigger und Abfragen.
    - Ihr könnt eigene Testfälle schreiben, die die Regeln der
      Datenbank prüfen.
    - Ihr könnt ein Datenbankmodell weiterentwickeln und die
      Auswirkungen auf Skripte, Rechte und Tests benennen.
    - Ihr könnt KI-Ergebnisse gegen die Anforderung prüfen und
      dokumentieren, was ihr übernommen, korrigiert oder verworfen habt.

---

### Ablauf und Spielregeln <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Ablauf und Spielregeln" }

Ihr arbeitet in **Gruppen mit höchstens drei Personen**, die ihr vor dem
Termin selbst gebildet habt. Jede Gruppe bekommt zu Beginn eine
**Gruppennummer**; sie braucht ihr für die Abgabe.

Der folgende Plan gibt euch eine Übersicht über den ungefähren Ablauf des Projekts:

| Zeit (Min.) | Phase |
|---|---|
| 0–10 | Start: Gruppe sortieren, Chat-Link von Frau Vogel |
| 10–30 | Gespräch mit der Auftraggeberin (höchstens 20 Min.) |
| 30–ca. 90 | Entwerfen und Umsetzen |
| ca. 90–105 | Zwischentermin mit der Auftraggeberin (höchstens 15 Min.) |
| 105–165 | Weiterarbeiten, Testen, Dokumentieren |
| 165–180 | Erfahrungsaustausch |

Die Zeiten sind Richtwerte. Den Zwischentermin kündigt die
Auftraggeberin per E-Mail an.

**Abgabe:** Eure Ergebnisse könnt ihr freiwillig in ILIAS hochladen und
bekommt dann eine Rückmeldung. Die Einzelheiten stehen später auf dieser
Seite.

---

### Der Chat <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Der Chat" }

Den Auftrag kennt ihr von der Übersichtsseite. Heute am Termin schickt
Frau Vogel euch den Link zum Chat:

!!! email ""
    <div class="email-kopf"><b>Von:</b> Sabine Vogel (Betriebsleitung), Brandt Kunststofftechnik GmbH<br><b>An:</b> Projektteam Datenbank<br><b>Datum:</b> 24.11.2026<br><b>Betreff:</b> Chat zum Ticketsystem</div>

    Guten Tag,

    wie angekündigt können wir heute die Details zum Ticketsystem klären.
    Hier ist der Link zum Chat: [BrandtChat](https://auftraggeber-bot.christoecker.workers.dev/).

    Ich habe leider nur wenig Zeit, bitte stellen Sie Ihre Fragen deshalb
    gezielt.

    Freundliche Grüße<br>
    Sabine Vogel

Die Gesprächsregeln stehen auf der Startseite des Chats. Ihr müsst sie
lesen und bestätigen, bevor ihr den Zugangscode eingeben könnt.

---

### Phase 1: Anforderungen klären <span class="zeitangabe">ca. 20 Min.</span> { data-toc-label="Phase 1: Anforderungen klären" }

**Ziel:** Nach diesen 20 Minuten solltet ihr alles wissen, um ein Modell zu
entwerfen und die Regeln umzusetzen. Frau Vogel erzählt nur, was ihr
fragt, und manches sagt sie nicht von selbst. Nutzt die Zeit gezielt.

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
Entscheidungen in der Spalte „Noch offen?“ eurer Tabelle fest.

**Mitschreiben:** Eine einfache Tabelle hilft, später den Überblick zu
behalten:

| Thema | Aussage von Frau Vogel | Notwendig / schön / später | Noch offen? |
|---|---|---|---|
| … | … | … | … |

!!! tip "Nicht alles gehört zum Projekt"
    Auftraggeber erzählen oft mehr, als sie bestellen: Wünsche für die
    Zukunft, Nebensächliches, Ideen. Eure Aufgabe ist zu entscheiden, was
    davon jetzt gebaut werden muss, was ihr bei der Gestaltung nur nicht
    verbauen dürft und was ihr ignoriert. Haltet das in eurer Tabelle fest.

---

### Arbeiten mit KI: Der Weg ist das Ziel

!!! warning "Dieses Projekt ist für die Arbeit mit KI gedacht, aber anders, als man denkt"
    Ihr dürft und sollt mit voller KI-Unterstützung entwickeln. Gelernt
    wird dabei aber nicht, indem die KI das ganze System auf einmal baut,
    sondern indem **die Anwendung Schritt für Schritt wächst und ihr jeden
    Schritt versteht und prüft**. Der Weg ist das Ziel: Am Ende zählt
    weniger, wie viel fertig ist, als dass ihr erklären könnt, was
    warum in eurer Datenbank steht.

**So geht ihr vor, für jeden Baustein neu:**

1. **Einen kleinen Baustein festlegen**, zum Beispiel eine Tabelle, ein
   Recht, eine Prozedur oder einen Trigger. Nicht mehr.
2. **Mit KI erzeugen.** Gebt der KI konkrete Anforderungen aus euren
   Notizen und den bisherigen Stand eurer Datenbank, nicht „Bau das ganze
   System“.
3. **Den Code lesen und verstehen.** Könnt ihr jede Zeile erklären? Was
   passiert bei Randfällen? Passt es zum Dialekt von SQL Server?
4. **Testen.** Schreibt zum neuen Baustein einen Test (die KI darf helfen,
   aber ihr bestimmt, *was* geprüft wird) und lasst alle bisherigen Tests
   noch einmal laufen. So merkt ihr, ob etwas Altes kaputtgegangen ist.
5. **Entscheiden und festhalten:** übernommen, korrigiert oder verworfen?
   Notiert es kurz im Entscheidungsdokument, am besten sofort.
6. **Erst dann der nächste Baustein.**

**Worauf ihr besonders achten solltet:** KI-Ergebnisse sehen oft gut aus,
sind aber nicht immer richtig. Typisch sind Syntax aus einem anderen
Datenbanksystem statt T-SQL, Trigger, die nur eine Zeile pro Änderung
annehmen, zu weit vergebene Rechte, fehlende Randfälle und Regeln, die
nicht zu eurer Anforderung passen. Gerade deshalb prüft ihr nach jedem
Baustein, auf Code-Ebene und mit Tests.

**Was nicht funktioniert:** Wenn ihr der KI alles auf einmal gebt und das
Ergebnis erst am Ende prüft, habt ihr viel Code, den ihr nicht erklären
könnt, und viele Fehler, die ihr nicht mehr findet. Im Erfahrungsaustausch
müsst ihr eure Entscheidungen begründen, und das gelingt nur, wenn ihr den
Weg dorthin kennt.

---

### Phase 2: Entwerfen und Umsetzen <span class="zeitangabe">ca. 60 Min.</span> { data-toc-label="Phase 2: Entwerfen und Umsetzen" }

Jetzt wird gebaut, Baustein für Baustein, wie oben beschrieben. Eine
bewährte Reihenfolge, die ihr nicht streng einhalten müsst:

| Baustein | Was ihr nach dem Baustein prüft |
|---|---|
| **1. Modell in drawDB (MSSQL):** Welche Dinge gibt es, wie hängen sie zusammen, wo ist eine Spezialisierung sinnvoll? Exportiert das Modell als JSON (*Datei → Exportieren als → JSON*), denn drawDB speichert nur im Browser. | Lässt sich jede Regel aus dem Gespräch abbilden? Habt ihr nichts erfunden, was nicht gewünscht war? |
| **2. Tabellen und Constraints:** Schlüssel, Fremdschlüssel, `CHECK`, `UNIQUE`, Standardwerte. Alles, was die Datenbank selbst durchsetzen kann, gehört hierher. | Code: Stimmen Schlüssel, Datentypen und Constraints? Tests: Eindeutigkeit, Wertebereich, Beziehung. |
| **3. Testdaten:** wenige, aber aussagekräftige Datensätze. | Decken sie die Fälle ab, die ihr testen wollt? |
| **4. Rechte:** Rollen, Benutzer, Rechte; Sichten für das, was nur ein Teil der Nutzer sehen darf. | Code: Ist nichts breiter vergeben als nötig? Tests: erlaubt, verweigert, gesperrte Daten. |
| **5. Prozeduren:** für Abläufe, die mehr tun als eine Zeile einzufügen. | Code: Randfälle, Fehlerbehandlung. Tests: Erfolgs- und Fehlerfall. |
| **6. Trigger:** für Regeln, die immer gelten müssen. Begründet jeweils, warum ihr Prozedur, Trigger oder Constraint gewählt habt. | Code: Funktioniert er auch bei mehreren Zeilen? Tests: Wirkung und Schutz. |
| **7. Abfragen:** die Übersichten, die Frau Vogel braucht. | Stimmt das Ergebnis mit dem überein, was ihr vorher ausgerechnet habt? |

**Pflicht und Kür:** Frau Vogel macht deutlich, was notwendig ist und
was „nur“ schön wäre. Setzt zuerst das Notwendige um. Wenn ihr Zeit habt,
nehmt etwas aus der zweiten Kategorie dazu.

#### Eigene Tests schreiben

Die Vorlage [test-template.sql](code/test-template.sql) enthält das
Grundmuster: Jeder Test bereitet etwas vor, führt eine Aktion aus,
prüft das Ergebnis, rollt alles zurück und meldet `PASS` oder `FAIL`.
Passt die Beispiele an eure Bezeichner an und ergänzt eigene Tests. Der
Mindestumfang: **jede der folgenden Testarten mindestens einmal**, also
mindestens zwölf Tests.

| Nr. | Testart | Was ist zu zeigen? |
|---|---|---|
| 1 | Eindeutigkeit | Ein doppelter Wert, der einmalig sein muss, wird abgelehnt. Prüft die Fehlernummer. |
| 2 | Wertebereich (`CHECK`) | Ein unzulässiger Wert wird abgelehnt. |
| 3 | Beziehung (Fremdschlüssel) | Ein Verweis auf etwas, das es nicht gibt, wird abgelehnt. |
| 4 | Prozedur, Erfolgsfall | Ein Aufruf mit gültigen Werten führt zum erwarteten Zustand in den Tabellen, nicht nur zu „kein Fehler“. |
| 5 | Prozedur, Fehlerfall | Ein Aufruf mit ungültigen Werten wird abgelehnt, und nichts hat sich geändert. |
| 6 | Trigger, Wirkung | Eine Aktion löst den Trigger aus, und die Folge ist in den Daten sichtbar. |
| 7 | Trigger, Schutz | Eine Änderung, die eine Regel verletzt, wird abgelehnt. |
| 8 | Recht erlaubt | Ein Benutzer einer Rolle kann tun, was seine Rolle darf. |
| 9 | Recht verweigert | Ein Benutzer kann nicht, was seine Rolle nicht darf (Fehler 229 oder 230). |
| 10 | Gesperrte Daten | Eine Spalte oder Tabelle ist gesperrt, die zugehörige Sicht oder Prozedur funktioniert. |
| 11 | Löschen | Beim Löschen verschwinden abhängige Daten oder bleiben erhalten, wie vereinbart. |
| 12 | Abfrage | Das Ergebnis einer Abfrage stimmt mit dem überein, was ihr vorher aus den Testdaten ausgerechnet habt. |

<!-- NACHTRAG-START -->
---

### Zwischentermin mit der Auftraggeberin <span class="zeitangabe">ca. 15 Min.</span> { data-toc-label="Zwischentermin mit der Auftraggeberin" }

Frau Vogel hat sich gerade bei euch mit einer zweiten E-Mail gemeldet und bittet um einen Zwischentermin:

!!! email ""
    <div class="email-kopf"><b>Von:</b> Sabine Vogel (Betriebsleitung), Brandt Kunststofftechnik GmbH<br><b>An:</b> Projektteam Datenbank<br><b>Datum:</b> 24.11.2026<br><b>Betreff:</b> Kleine Änderung — bitte kurz melden</div>

    Guten Tag,

    ich habe mit meinen Technikern gesprochen. Bei großen Störungen
    arbeiten oft mehrere von ihnen an einer Sache, und das soll sich im
    System widerspiegeln. Außerdem möchte ich wissen, wer verantwortlich
    war und wer wie viele Stunden investiert hat.

    Das ist bestimmt nicht schwer umzusetzen. Wenn Sie kurz Zeit haben,
    klären wir die Einzelheiten noch einmal im Chat:
    [BrandtChat](https://auftraggeber-bot.christoecker.workers.dev/).

    Freundliche Grüße  
    Sabine Vogel

Für das zweite Gespräch habt ihr maximal 15 Minuten Zeit.

**So nutzt ihr die 15 Minuten:**

- Klärt, was genau sich ändert: Was gilt neu, was ändert sich nicht?
- Klärt, wer was sehen und ändern darf, und ob die Regeln für Rechte,
  Abschluss und Löschen betroffen sind.
- Haltet die Antworten wieder in eurer Tabelle fest.

Danach geht ihr systematisch vor:

1. Welche Teile des **Modells** sind betroffen? Exportiert das neue
   Modell separat.
2. Welche **Tabellen, Prozeduren, Trigger und Rechte** müssen angepasst
   werden? Eine Datenübernahme ist nicht nötig. Ihr dürft die Datenbank neu
   aufbauen und die Skripte erneut ausführen.
3. Welche **Tests** müssen angepasst werden, welche kommen neu hinzu?
4. Haltet im Entscheidungsdokument fest, was ihr geändert habt und
   warum.

**Zusätzliche Testfälle nach dem Zwischentermin:**

| Nr. | Testart | Was ist zu zeigen? |
|---|---|---|
| A | Wertebereich | Negative Stunden und eine ungültige Rolle werden abgelehnt. |
| B | Regel | Pro Auftrag gibt es höchstens einen Verantwortlichen: Ein zweiter wird abgelehnt. |
| C | Regel | Ein Auftrag lässt sich nicht abschließen, solange für den Verantwortlichen keine Stunden eingetragen sind. |
| D | Recht | Mitarbeiter sehen, wer einem Auftrag zugeordnet ist, aber weder Rolle noch Stunden. |
| E | Recht | Ein Techniker kann Stunden nur für sich selbst eintragen. |

---

### Phase 3: Weiterarbeiten, Testen, Dokumentieren <span class="zeitangabe">ca. 60 Min.</span> { data-toc-label="Phase 3: Weiterarbeiten, Testen, Dokumentieren" }

Setzt um, was sich aus dem Zwischentermin ergibt, und bringt alles auf
einen sauberen Stand:

- Alle Skripte laufen auf einer **leeren Instanz** in dieser Reihenfolge
  durch: Schema, Rechte, Prozeduren und Trigger, Testdaten, Tests.
- Alle Tests laufen durch (`PASS`) oder ihr wisst, warum nicht.
- Das **Entscheidungsdokument** ist vollständig (Vorlage:
  [entscheidungen-template.txt](code/entscheidungen-template.txt)).
- Das Modell liegt als drawDB-Export vor.

Wer fertig ist, kann den Optionalteil umsetzen, einen eigenen Test
absichtlich scheitern lassen (um zu sehen, ob er wirklich etwas prüft)
oder sein Entscheidungsdokument für den Erfahrungsaustausch schärfen.

---

### Erfahrungsaustausch <span class="zeitangabe">ca. 15 Min.</span> { data-toc-label="Erfahrungsaustausch" }

Zum Schluss sprechen wir nicht darüber, *wie* ihr eine bestimmte Tabelle
angelegt habt, sondern *warum* ihr euch so entschieden habt. Einige
Gruppen stellen ihre Sicht vor, die anderen vergleichen. Bereitet
Antworten auf diese Fragen vor:

- Welche Architektur habt ihr gewählt, und welche Alternativen habt ihr
  verworfen?
- Welche Regel habt ihr als Constraint, welche als Prozedur, welche als
  Trigger umgesetzt, und warum?
- Was hätte Frau Vogels System später in einer **Anwendung** zu
  erledigen, statt in der Datenbank?
- Was habt ihr aus dem Gespräch mit Frau Vogel herausgefiltert, und wie
  seid ihr mit ihren Zukunftsideen umgegangen?
- Was habt ihr von der KI übernommen, korrigiert oder verworfen, und
  woran habt ihr Fehler erkannt? Wie habt ihr die Anwendung Baustein für
  Baustein geprüft?
- Was würdet ihr beim nächsten Mal anders machen?

---

### Freiwillige Abgabe

Ihr könnt eure Ergebnisse freiwillig in ILIAS hochladen. Ihr bekommt dann
eine persönliche Rückmeldung zu eurem Projekt. Die Rückmeldung zeigt,
was nach vier Terminen schon gut gelingt und wo ihr noch üben könnt.

Ladet **eine ZIP-Datei** `gruppe-NN.zip` hoch (NN = eure Gruppennummer
mit zwei Ziffern, zum Beispiel `gruppe-07.zip`). Die Frist steht im
ILIAS-Objekt. Die ZIP-Datei enthält diese Dateien:

| Datei | Inhalt |
|---|---|
| `gruppe-NN_entscheidungen.txt` | Entscheidungsdokument (Vorlage oben) |
| `gruppe-NN_modell_zwischenstand.ddb` | drawDB-Export vom Zwischenstand |
| `gruppe-NN_modell_final.ddb` | drawDB-Export vom Endstand |
| `gruppe-NN_schema.sql` | Datenbank, Tabellen, Constraints, Sichten |
| `gruppe-NN_rechte.sql` | Benutzer, Rollen, Rechte |
| `gruppe-NN_logik.sql` | Prozeduren und Trigger |
| `gruppe-NN_testdaten.sql` | Testdaten |
| `gruppe-NN_abfragen.sql` | Abfragen und Datenänderungen |
| `gruppe-NN_tests.sql` | eure Tests |

Die SQL-Dateien zeigen den **Endstand**. Alle sollten auf einer leeren
Instanz in der Reihenfolge Schema → Rechte → Logik → Testdaten → Tests
ohne Fehler laufen. Ehrliche Dokumentation hilft euch mehr als ein
perfekter Eindruck: Wenn etwas nicht klappt, schreibt es ins
Entscheidungsdokument.

<!-- MUSTERLOESUNG-START -->
---

### Musterlösung

Die Musterlösung folgt nach dem Termin an dieser Stelle.
<!-- MUSTERLOESUNG-ENDE -->
<!-- NACHTRAG-ENDE -->
