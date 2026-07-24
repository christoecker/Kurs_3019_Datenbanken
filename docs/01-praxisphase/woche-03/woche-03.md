---
typ: praxisphase-woche
woche: 3
thema: "ER-Modell-Erweiterungen: Abhängige Entity-Typen und Spezialisierung"
workload_minuten: 90
lernziele:
  - "kann erklären, was einen Entity-Typ zu einem abhängigen (schwachen) Entity-Typ macht, und ihn von einem gewöhnlichen Entity-Typ abgrenzen"
  - "kann einen abhängigen Entity-Typ inkl. identifizierender Beziehung korrekt notieren und die dabei zwingende Kardinalität aus Sicht des abhängigen Entity-Typs benennen"
  - "kann die Begriffe Spezialisierung und Generalisierung erklären und ihren Zusammenhang beschreiben"
  - "kann eine Spezialisierung mit Supertyp und mehreren Subtypen korrekt im ER-Diagramm notieren und die mengentheoretische Bedeutung der Subtyp-Beziehung erklären"
quelle_lehrbrief: "Kap. 3.4"
quelle_lehrbuch: "keine"
fallstudie: "eigene MEA-Szenarien (Produktionsaufträge, Maschinenpark) - siehe 04-fallstudien/README.md; Pflichtlektüre bleibt FH-Info"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-08-03
---

# Woche 3: ER-Modell-Erweiterungen: Abhängige Entity-Typen und Spezialisierung

> Zeitbedarf: ca. 1,5 Stunden.

## Worum geht es?

Letzte Woche hast du die drei Grundkonzepte des ER-Modells kennengelernt:
Entity-Typ, Beziehungstyp und Attribut, dazu Kardinalitäten in zwei
Notationen. Damit lässt sich schon sehr viel modellieren — aber nicht
alles. Diese Woche ergänzt du dein Werkzeugkasten um zwei Spezialfälle,
die in der Praxis ständig vorkommen:

1. Was macht man mit Objekten, die gar keinen eigenen Schlüssel haben
   und ohne ein "übergeordnetes" Objekt gar nicht existieren können
   (**abhängige Entity-Typen**)?
2. Was macht man, wenn ein Entity-Typ eigentlich nur ein Spezialfall
   eines anderen ist, der zusätzliche Eigenschaften mitbringt
   (**Spezialisierung**)?

## Das solltest du danach können

- Du kannst erklären, wann ein Entity-Typ als "abhängig" (manche Bücher
  sagen auch "schwach") gilt, und ein eigenes Beispiel dafür nennen.
- Du kannst einen abhängigen Entity-Typ korrekt notieren (doppelte
  Umrandung, unterstrichene identifizierende Beziehung) und weißt, warum
  die Kardinalität aus Sicht des abhängigen Entity-Typs immer genau 1
  sein muss.
- Du kannst erklären, was eine Spezialisierung ist, was ein Subtyp vom
  Supertyp "erbt", und wie sich Spezialisierung und Generalisierung
  zueinander verhalten.
- Du kannst eine Spezialisierung mit mehreren Subtypen zu einem
  gemeinsamen Supertyp im ER-Diagramm notieren.

## Erarbeitung

Lies im Lehrbrief (`Lehrbrief_relationaleDatenbanken.pdf`) die folgenden
Abschnitte. Mach dir wie in den letzten Wochen Notizen in eigenen
Worten — die brauchst du für die Aufgabe unten.

**Schritt 1:** Abschnitt 3.4, Einleitung "Erweiterungen des ER-Modells"
(S. 31).

!!! warning "Pflichtlektüre im Anhang"
    Auch hier weist der Lehrbrief explizit darauf hin, dass für die
    beiden folgenden Abschnitte (3.4.1 und 3.4.2) das Lesen von **Teil 2
    der FH-Info-Fallstudie im Anhang** vorausgesetzt wird. Nur falls du dich nicht mehr an das Fallbeispiel erinnerst: Lies diesen
    Teil noch einmal, bevor du weitermachst.

**Schritt 2:** Abschnitt 3.4.1, "Abhängige Entity-Typen" (S. 31).

**Schritt 3:** Abschnitt 3.4.2, "Spezialisierung" (S. 32-33).

Lies **nicht** weiter in Abschnitt 3.5 ("Projektaufgaben") — diese größeren Übungsaufgaben aus dem Lehrbrief sind nicht Teil
dieses Arbeitsauftrags.

## Aufgabe

Zwei kleine, voneinander unabhängige Szenarien aus deinem MEA-Umfeld.

**Teil A — Abhängiger Entity-Typ**

> Ein Fertigungsbetrieb verwaltet Fertigungsaufträge. Jeder
> Fertigungsauftrag hat eine eindeutige Auftragsnummer und einen
> Starttermin. Jeder Fertigungsauftrag besteht aus mindestens einer
> Auftragsposition. Jede Auftragsposition hat eine Positionsnummer, die
> nur *innerhalb ihres Auftrags* eindeutig ist (Auftrag 4711 hat
> Positionen 1, 2, 3 — Auftrag 4712 fängt bei seinen Positionen wieder
> bei 1 an), eine Produktnummer sowie eine Menge. Eine Auftragsposition kann nicht ohne
> ihren Fertigungsauftrag existieren.

1. Begründe, warum `AUFTRAGSPOSITION` ein abhängiger Entity-Typ ist.
2. Modelliere `FERTIGUNGSAUFTRAG` und `AUFTRAGSPOSITION` inkl. Attributen,
   identifizierender Beziehung und Kardinalitäten (eine der beiden
   Notationen reicht). Kennzeichne, was zur eindeutigen Identifikation
   einer Auftragsposition beiträgt.

??? tip "Musterlösung anzeigen"

    `AUFTRAGSPOSITION` ist ein abhängiger Entity-Typ, weil (1) eine
    Auftragsposition ohne ihren Fertigungsauftrag nicht existieren kann
    (Existenzabhängigkeit) und (2) die Positionsnummer allein nicht
    eindeutig ist — erst die Kombination aus Positionsnummer *und* dem
    zugehörigen Fertigungsauftrag identifiziert eine Auftragsposition
    eindeutig.

    ```mermaid
    %%{init: {'flowchart': {'padding': 5}, 'themeVariables': {'fontSize': '0.6rem'}}}%%
    graph LR
    FERTIGUNGSAUFTRAG["<div style='text-align:left; font-size: 0.6rem;'><b>FERTIGUNGSAUFTRAG</b><hr/>auftragsnr : int (PK)<br/>starttermin : date</div>"]
    AUFTRAGSPOSITION["<div style='text-align:left; font-size: 0.6rem; border: 3px double rgb(82, 108, 254); background: rgba(82, 108, 254, 0.1); padding: 8px;'><b>AUFTRAGSPOSITION</b><hr/><u>positionsnr</u> : int (lokal)<br/>produktnr : int<br/>menge : int</div>"]
    style AUFTRAGSPOSITION fill:transparent,stroke:none
    umfasst{{"<u>umfasst</u>"}}
    FERTIGUNGSAUFTRAG -- "1" --- umfasst
    umfasst -- "N" --- AUFTRAGSPOSITION
    ```

    (Die doppelte Umrandung von `AUFTRAGSPOSITION` sowie die
    unterstrichene identifizierende Beziehung `umfasst` und das
    unterstrichene lokale Attribut `positionsnr` kennzeichnen den
    abhängigen Entity-Typ gemäß Chen-Notation. Der Standard-Rahmen des
    Knotens ist dafür bewusst transparent geschaltet, damit nur die
    eigene doppelte Umrandung sichtbar ist.)

    Identifizierende Beziehung `umfasst`:

    - Aus Sicht `AUFTRAGSPOSITION`: **1..1** (jede Position gehört zu
      genau einem Auftrag — das ist bei abhängigen Entity-Typen immer
      so).
    - Aus Sicht `FERTIGUNGSAUFTRAG`: **1..\*** (ein Auftrag hat laut
      Aufgabenstellung mindestens eine Position, kann aber mehrere
      haben).

    Zur Identifikation einer Auftragsposition tragen sowohl ihre lokale
    Positionsnummer als auch die identifizierende Beziehung zu ihrem
    Fertigungsauftrag bei — beides zusammen wird im Diagramm
    unterstrichen.

**Teil B — Spezialisierung**

> Derselbe Betrieb verwaltet außerdem seinen Maschinenpark. Jede
> Maschine hat eine Maschinennummer und eine Bezeichnung. Ein Teil der
> Maschinen sind CNC-Maschinen, für die zusätzlich der Steuerungstyp
> (z. B. "Siemens 840D") gespeichert wird. Ein anderer Teil sind
> Montagestationen, für die zusätzlich die Anzahl der Arbeitsplätze
> gespeichert wird. (Es gibt auch Maschinen, die weder CNC-Maschine noch
> Montagestation sind.)

1. Modelliere diese Anwendungswelt als Spezialisierung: Supertyp,
   Subtypen, jeweilige Attribute.
2. Erkläre in ein bis zwei Sätzen, was es *mengentheoretisch* bedeutet,
   dass `CNC_MASCHINE` ein Subtyp von `MASCHINE` ist.

??? tip "Musterlösung anzeigen"

    ```mermaid
    %%{init: {'themeVariables': {'fontSize': '0.6rem'}}}%%
    graph TD
    MASCHINE["<div style='text-align:left; font-size: 0.6rem;'><b>MASCHINE</b><hr/>maschinennr : int (PK)<br/>bezeichnung : string</div>"]
    spez((△))
    style spez fill:transparent,stroke:none
    CNC_MASCHINE["<div style='text-align:left; font-size: 0.6rem;'><b>CNC_MASCHINE</b><hr/>steuerungstyp : string</div>"]
    MONTAGESTATION["<div style='text-align:left; font-size: 0.6rem;'><b>MONTAGESTATION</b><hr/>anzahl_arbeitsplaetze : int</div>"]
    MASCHINE --- spez
    spez --- CNC_MASCHINE
    spez --- MONTAGESTATION
    ```

    (Der Knoten `spez` steht für das Spezialisierungsdreieck aus dem
    Lehrbrief — Mermaid kennt keine native Dreieck-Form für Knoten,
    daher das Dreieck-Zeichen △ als Text in einem Knoten, dessen
    eigener Rahmen/Füllung transparent geschaltet ist, damit nur das
    Zeichen selbst sichtbar bleibt.)

    Dass `CNC_MASCHINE` ein Subtyp von `MASCHINE` ist, bedeutet
    mengentheoretisch: Jedes Objekt vom Typ `CNC_MASCHINE` ist automatisch
    auch ein Objekt vom Typ `MASCHINE` und besitzt zusätzlich zu
    `maschinennr` und `bezeichnung` das eigene Attribut `steuerungstyp`.
    Umgekehrt gilt das nicht — nicht jede Maschine ist automatisch eine
    CNC-Maschine (es gibt ja auch Montagestationen und sonstige
    Maschinen).

## Selbstkontrolle

### Frage 1

<quiz>
Ergänze die Lücken mit den passenden Fachbegriffen: Ein Entity-Typ, dessen Objekte nur über die Beziehung zu einem anderen Entity-Typ eindeutig identifiziert werden können, heißt [[abhängiger]] Entity-Typ (auch [[schwacher]] Entity-Typ genannt). Die identifizierende Beziehung wird im ER-Diagramm durch [[Unterstreichen]] markiert, der abhängige Entity-Typ selbst durch eine [[doppelte]] Umrandung dargestellt.

---
Kapitel 3.4.1 im Lehrbrief (S. 31) führt alle vier Begriffe direkt hintereinander ein.
</quiz>

### Frage 2

<quiz>
Welche Aussage zur Kardinalität der identifizierenden Beziehung eines abhängigen Entity-Typs ist korrekt?

- [ ] Aus Sicht des abhängigen Entity-Typs sind beliebige Kardinalitäten möglich.
- [ ] Aus Sicht des identifizierenden (starken) Entity-Typs müssen Ober- und Untergrenze immer 1 sein.
- [x] Aus Sicht des abhängigen Entity-Typs müssen Ober- und Untergrenze immer 1 sein.
</quiz>

### Frage 3

Nenne ein eigenes Beispiel (nicht aus dem Lehrbrief und nicht aus der
Aufgabe oben) für eine Spezialisierung aus deinem Praxisbetrieb
oder Alltag. Benenne den Supertyp, mindestens einen Subtyp und ein
zusätzliches Attribut, das nur der Subtyp hat.

??? question "Antwort anzeigen"
    Ein mögliches Beispiel: Supertyp `MITARBEITER` (Attribute z. B.
    `personalnr`, `name`). Subtyp `AUSZUBILDENDER` mit dem zusätzlichen
    Attribut `ausbildungsjahr`, das nur für Auszubildende Sinn ergibt,
    nicht aber für alle Mitarbeiter (z. B. nicht für langjährige
    Facharbeiter). Andere sinnvolle Beispiele sind ebenso denkbar, z. B.
    `KUNDE` mit Subtyp `GESCHÄFTSKUNDE` (zusätzlich: `umsatzsteuer_id`).

### Frage 4

Was ist der Unterschied zwischen Spezialisierung und Generalisierung?
Sind das zwei unterschiedliche Modellierungstechniken oder zwei
Blickrichtungen auf dasselbe Ergebnis?

??? question "Antwort anzeigen"
    Es ist dieselbe Struktur (ein Supertyp mit einem oder mehreren
    Subtypen, verbunden über das Spezialisierungsdreieck), nur mit
    unterschiedlichem gedanklichem Ausgangspunkt. **Spezialisierung**
    geht vom bereits bestehenden, allgemeineren Typ aus und leitet davon
    speziellere Subtypen ab (Top-down: "`MASCHINE` gibt es schon, ich
    brauche zusätzlich `CNC_MASCHINE`"). **Generalisierung** geht
    umgekehrt von mehreren speziellen Typen aus und bildet daraus einen
    gemeinsamen, allgemeineren Typ (Bottom-up: "`CNC_MASCHINE` und
    `MONTAGESTATION` haben beide `maschinennr` und `bezeichnung` — das fasse
    ich in einem gemeinsamen Supertyp `MASCHINE` zusammen"). Im
    ER-Diagramm sieht man am Ende nicht, welchen Weg man gegangen ist.

### Frage 5

<quiz>
Welche Aussagen zur mengentheoretischen Bedeutung einer Spezialisierung sind korrekt? (Mehrfachauswahl möglich)

- [x] Jedes Objekt eines Subtyps ist automatisch auch ein Objekt des Supertyps.
- [ ] Jedes Objekt eines Supertyps ist automatisch auch ein Objekt jedes Subtyps.
  > Falsch: Die Teilmengenbeziehung gilt nur vom Subtyp zum Supertyp, nicht umgekehrt.
- [x] Ein Subtyp besitzt alle Attribute und Beziehungen des Supertyps zusätzlich zu seinen eigenen.
- [ ] Zu einem Supertyp kann es höchstens einen Subtyp geben.
  > Falsch: Ein Supertyp kann mehrere Subtypen haben, z. B. `MASCHINE` mit den Subtypen `CNC_MASCHINE` und `MONTAGESTATION`.
</quiz>
