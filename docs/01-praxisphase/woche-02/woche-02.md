---
typ: praxisphase-woche
woche: 2
thema: "Konzeptueller Datenbankentwurf: Grundkonzepte des ER-Modells (Entity-Typen, Attribute, Beziehungstypen, Kardinalitäten)"
workload_minuten: 100
lernziele:
  - "kann die drei Grundkonzepte des ER-Modells (Entity, Relationship, Attribut) in eigenen Worten erklären und an einem Beispiel zeigen"
  - "kann Entity-Typen mit ihren Attributen und Schlüsselattributen sowohl in der klassischen ER-Notation als auch in der UML-Notation darstellen"
  - "kann Beziehungstypen inkl. Beziehungsattributen, rekursiven Beziehungen und Rollennamen modellieren und von Entity-Typen abgrenzen"
  - "kann Kardinalitäten in Chen-Notation und in UML-Notation angeben, ihre Bedeutung erläutern und den Unterschied zwischen beiden Notationen benennen"
quelle_lehrbrief: "Kap. 3.1-3.3"
quelle_lehrbuch: "keine"
fallstudie: "FH-Info (Lehrbrief-Fallstudie)"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-07-27
---

# Woche 2: Konzeptueller Datenbankentwurf: Grundkonzepte des ER-Modells

> Zeitbedarf: ca. 2 Stunden.

## Worum geht es?

Letzte Woche ging es darum, *warum* es Datenbanken gibt und *wie* ein
Datenbanksystem grob aufgebaut ist — inklusive der vier Phasen des
Datenbankentwurfs. Diese Woche steigst du in die zweite dieser Phasen ein:
den **konzeptuellen Datenbankentwurf**. Dafür lernst du das wichtigste
Handwerkszeug kennen, das dabei zum Einsatz kommt — das
**Entity-Relationship-Modell (ER-Modell)** — und seine drei
Grundbausteine: Entity-Typen, Beziehungstypen und Attribute. Außerdem
lernst du, wie man mit Kardinalitäten festlegt, in welchem
zahlenmäßigen Verhältnis Objekte zueinander stehen dürfen.

Der Lehrbrief nutzt für dieses Kapitel durchgängig eine eigene
Fallstudie — **FH-Info**, ein fiktives Informationssystem zur Verwaltung
von Studiengängen, Modulen, Studierenden und Dozenten an einer
Hochschule. Diese Anwendungswelt dürfte dir sehr vertraut vorkommen.

## Das solltest du danach können

- Du kannst die Begriffe Entity, Entity-Typ, Relationship, Beziehungstyp
  und Attribut definieren und in einem gegebenen Beispiel den passenden
  Begriffen zuordnen.
- Du kannst zu einer kurzen Beschreibung einer Anwendungswelt passende
  Entity-Typen mit Attributen bestimmen und dabei Schlüsselattribute
  erkennen.
- Du kannst einen Beziehungstyp zwischen zwei Entity-Typen benennen,
  bei Bedarf mit Beziehungsattribut versehen und — bei rekursiven
  Beziehungen — mit Rollennamen versehen.
- Du kannst zu einem Beziehungstyp passende Kardinalitäten sowohl in
  Chen-Notation als auch in UML-Notation angeben und begründen, warum
  diese Kardinalität und keine andere zutrifft.

## Erarbeitung

Lies im Lehrbrief (`Lehrbrief_relationaleDatenbanken.pdf`) die folgenden
Abschnitte der Reihe nach. Mach dir wie letzte Woche beim Lesen
Notizen in eigenen Worten — die brauchst du für die Aufgabe unten.

**Schritt 1:** Kapitel 3, Einleitung "Konzeptueller Datenbankentwurf"
(S. 20) — warum sich für den konzeptuellen Entwurf ein grafischer,
technikferner Formalismus (das ER-Modell) durchgesetzt hat.

**Schritt 2:** Abschnitt 3.1, "Die Fallstudie FH-Info" (S. 21-22).

!!! warning "Pflichtlektüre im Anhang"
    Der Lehrbrief weist explizit darauf hin, dass für die folgenden
    Abschnitte das Lesen von **Teil 1 der FH-Info-Fallstudie im
    Anhang** des Lehrbriefs vorausgesetzt wird. Lies diesen Teil jetzt,
    bevor du weitermachst — sonst ergeben die Beispiele in 3.2 und 3.3
    wenig Sinn.

**Schritt 3:** Abschnitt 3.2, "Basiskonzepte des ER-Modells" (S. 22-28):

- 3.2.1 "Entity-Typen" (S. 23)
- 3.2.2 "Werte und Attribute", inkl. der Unterabschnitte zu Schlüsseln
  und Schlüsselattributen (S. 24-25)
- 3.2.3 "Beziehungstypen", inkl. der Unterabschnitte zu
  Beziehungsattributen, rekursiven Beziehungen und Rollennamen
  (S. 26-28)

**Schritt 4:** Abschnitt 3.3, "Kardinalitäten" (S. 28-30):

- 3.3.1 "Chen-Notation" (S. 28-29)
- 3.3.2 "UML-Notation" (S. 30)

Lies **nicht** weiter in Abschnitt 3.4 ("Erweiterungen des ER-Modells")
— abhängige Entity-Typen und Spezialisierung sind Thema der nächsten
Woche.

## Aufgabe

Diesmal geht es nicht um FH-Info, sondern um eine Anwendungswelt aus
deinem eigenen Umfeld — dem Maschinenpark eines Betriebs:

> Ein Betrieb verwaltet seinen Maschinenpark. Zu jeder **Maschine**
> werden eine eindeutige Maschinennummer, eine Bezeichnung und der
> aktuelle Standort gespeichert. Zu jedem **Wartungsauftrag** werden
> eine eindeutige Auftragsnummer, das Datum der Durchführung und eine
> kurze Beschreibung der durchgeführten Arbeiten gespeichert. Jeder
> Wartungsauftrag bezieht sich auf genau eine Maschine; eine Maschine
> kann im Laufe ihrer Nutzungsdauer Gegenstand mehrerer
> Wartungsaufträge sein.

Bearbeite dazu folgende Teilaufgaben schriftlich (Text reicht, ein
Diagramm mit Stift und Papier ist optional):

1. Bestimme die beiden Entity-Typen dieser Anwendungswelt mit ihren
   jeweiligen Attributen. Markiere das Schlüsselattribut jedes
   Entity-Typs.
2. Stelle beide Entity-Typen in der UML-Notation dar (Kasten mit Name
   oben, Attributen darunter, Schlüsselattribut hervorgehoben).
3. Bestimme den Beziehungstyp zwischen beiden Entity-Typen, gib ihm
   einen sprechenden Namen und gib die passenden Kardinalitäten sowohl
   in Chen-Notation (1/N/M) als auch in UML-Notation (z. B. `1..1`,
   `0..*`) an. Begründe in ein bis zwei Sätzen, warum genau diese
   Kardinalität und keine andere zutrifft.

??? tip "Musterlösung anzeigen"
    **1. Entity-Typen und Attribute**

    - **MASCHINE**: `maschinennr` (Schlüssel), `bezeichnung`, `standort`
    - **WARTUNGSAUFTRAG**: `auftragsnr` (Schlüssel), `datum`,
      `beschreibung`

    Beide Schlüssel sind jeweils Einzelattribute, da es laut
    Aufgabenstellung "eine eindeutige Maschinennummer" bzw. "eine
    eindeutige Auftragsnummer" gibt — anders als z. B. beim Entity-Typ
    STUDIENGANG in FH-Info, wo erst die Kombination zweier Attribute
    eindeutig ist.

    **2. UML-Notation**

    ```
    MASCHINE                     WARTUNGSAUFTRAG
    --------------------------   --------------------------
    maschinennr : int  (Schl.)   auftragsnr  : int  (Schl.)
    bezeichnung : string         datum       : date
    standort    : string         beschreibung: string
    ```

    **3. Beziehungstyp und Kardinalitäten**

    Ein sprechender Name für den Beziehungstyp ist z. B. `betrifft`.

    - **Chen-Notation**: `MASCHINE (1) -- betrifft -- (N) WARTUNGSAUFTRAG`
    - **UML-Notation**: `MASCHINE (1..1) -- betrifft -- (0..*) WARTUNGSAUFTRAG`

    Begründung: Jeder Wartungsauftrag bezieht sich laut Aufgabenstellung
    auf **genau eine** Maschine (Obergrenze **und** Untergrenze = 1 aus
    Sicht des Wartungsauftrags). Eine Maschine dagegen kann Gegenstand
    **mehrerer** Wartungsaufträge sein, muss es aber nicht zwingend (eine
    fabrikneue Maschine hat z. B. noch keinen Wartungsauftrag) — daher
    aus Sicht der Maschine die Untergrenze 0 und die Obergrenze N bzw.
    `*`. Die Chen-Notation kann diese Untergrenze von 0 nicht ausdrücken,
    da sie grundsätzlich nur Obergrenzen kennt.

## Selbstkontrolle

### Frage 1

<quiz>
Ergänze die Lücken mit den passenden Fachbegriffen aus dem ER-Modell:

Ein konkretes reales oder fiktives Objekt der Anwendungswelt, über das etwas gespeichert werden soll, heißt [[Entity]]. Die Menge aller gleichartigen Objekte dieser Art wird im ER-Diagramm durch einen [[Entity-Typ]] repräsentiert und als Rechteck dargestellt. Eine konkrete Beziehung zwischen zwei Objekten der Anwendungswelt wird als [[Relationship]] bezeichnet; die Menge aller gleichartigen Beziehungen dieser Art wird als [[Beziehungstyp]] modelliert und im ER-Diagramm als Raute dargestellt.

---
Wenn dir ein Begriff nicht mehr geläufig ist: Kapitel 3.2 im Lehrbrief
(S. 22) führt alle vier Begriffe direkt hintereinander ein.
</quiz>

### Frage 2

<quiz>
Welche der folgenden Aussagen zu Kardinalitäten und ihren Notationen sind korrekt? (Mehrfachauswahl möglich)

- [x] In der Chen-Notation werden ausschließlich Obergrenzen angegeben, keine Untergrenzen.
- [x] Die UML-Notation kann sowohl Ober- als auch Untergrenzen ausdrücken.
- [ ] Bei einer 1:N-Beziehung dürfen Entities beider beteiligten Entity-Typen beliebig viele Partner haben.
  > Falsch: Bei 1:N ist eine Seite auf höchstens 1 begrenzt, sonst wäre es eine N:M-Beziehung.
- [ ] Ein Beziehungstyp kann eigene Schlüsselattribute besitzen, die unabhängig von den beteiligten Entity-Typen sind.
  > Falsch: Beziehungstypen verfügen nie über eigene Schlüsselattribute, da eine Beziehung eindeutig über die beteiligten Entity-Typen bestimmt ist.
</quiz>

### Frage 3

Aus der objektorientierten Programmierung kennst du die Begriffe *Klasse* und
*Objekt*. Entity-Typ und Entity aus dem ER-Modell lassen
sich zu diesen Begriffen in Analogie setzen. Erkläre in eigenen Worten,
welcher Begriff aus der OOP welchem Begriff aus dem ER-Modell
entspricht, und nenne mindestens einen Punkt, an dem diese Analogie an
ihre Grenzen stößt.

??? question "Antwort anzeigen"
    Ein **Entity-Typ** entspricht in etwa einer **Klasse**: Er legt —
    wie eine Klassendefinition — nur die Struktur fest (welche
    Attribute es gibt), ohne selbst ein konkretes Objekt zu sein. Ein
    **Entity** entspricht einem **Objekt** (einer Instanz dieser
    Klasse) mit konkreten Attributwerten — z. B. wäre der Entity-Typ
    `MASCHINE` vergleichbar mit einer Klasse `Maschine`, und eine
    bestimmte Werkzeugmaschine mit der Nummer `4711` in der Werkhalle
    wäre ein konkretes Objekt (eine Instanz) dieser Klasse.

    Die Analogie stößt aber an Grenzen: Eine Klasse in der OOP
    kapselt in der Regel **Daten und Verhalten** gemeinsam (Attribute
    *und* Methoden). Ein Entity-Typ im ER-Modell beschreibt dagegen
    ausschließlich **Struktur/Zustand** — Verhalten (Methoden,
    Geschäftslogik) ist im ER-Modell kein Konzept und wird an anderer
    Stelle (z. B. in der Anwendung oder später in Prozeduren)
    realisiert. Auch für Beziehungstypen gibt es in der klassischen
    OOP kein direktes Gegenstück auf derselben Abstraktionsebene — sie
    werden dort eher implizit über Referenzen/Zeiger zwischen Objekten
    abgebildet.

### Frage 4

Was versteht man unter einer *rekursiven Beziehung*? Nenne ein
Beispiel aus deinem Praxisbetrieb, bei dem ein **Rollenname**
sinnvoll wäre, und begründe kurz, warum.

??? question "Antwort anzeigen"
    Eine rekursive Beziehung ist ein Beziehungstyp, bei dem beide
    beteiligten "Seiten" derselbe Entity-Typ sind — die
    Beziehungsraute wird also zweifach mit demselben Entity-Typ-Kasten
    verbunden (im Lehrbrief-Beispiel: `folgt_nach` zwischen zwei
    Modulen desselben Entity-Typs MODUL).

    Ein mögliches Beispiel: Im Entity-Typ MASCHINE könnte es eine
    Beziehung `ist_ersatz_fuer` geben, wenn eine Maschine als
    Ersatz für eine andere, ausgefallene Maschine eingesetzt wird.
    Da beide beteiligten Rollen sonst nicht unterscheidbar wären
    (beides sind ja "Maschinen"), macht es hier Sinn, an den
    Verbindungslinien die Rollennamen `ersatzmaschine` und
    `ersetzte_maschine` zu notieren — das erhöht die Lesbarkeit des
    Diagramms deutlich.

### Frage 5

Im Lehrbrief wird für FH-Info die 1:1-Beziehung `ist_für` zwischen den
Entity-Typen `AKKREDITIERUNG` und `STUDIENGANG` als Beispiel genutzt.

<quiz>
Welche Aussage zur Beziehung `ist_für` zwischen `AKKREDITIERUNG` und `STUDIENGANG` ist korrekt?

- [ ] Ein Studiengang kann mehrere Akkreditierungen gleichzeitig besitzen.
- [x] Jeder Studiengang hat höchstens eine Akkreditierung, und jede Akkreditierung gehört zu höchstens einem Studiengang.
- [ ] Jede Akkreditierung muss zu mindestens zwei Studiengängen gehören.
</quiz>
