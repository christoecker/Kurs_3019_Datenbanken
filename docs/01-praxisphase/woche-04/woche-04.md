---
typ: praxisphase-woche
woche: 4
thema: "Vom ER-Modell zum Relationenmodell: Grundlagen, Schlüssel und Transformationsregeln"
workload_minuten: 90
lernziele:
  - "kann die Grundbegriffe Relation, Datensatz, Attribut, Wertebereich und Relationenschema erklären und sie den entsprechenden Begriffen des ER-Modells zuordnen"
  - "kann aus mehreren Schlüsselkandidaten einer Relation begründet einen Primärschlüssel auswählen und die übrigen als Unique Key kennzeichnen"
  - "kann erklären, was ein Fremdschlüssel ist, ihn in einem Relationenschema korrekt notieren (auch bei einer Referenz auf die eigene Relation) und die Entity-/Schlüsselintegrität von der Fremdschlüsselintegrität abgrenzen"
  - "kann einen einzelnen Entity-Typ nach der Grundregel der Transformation in ein Relationenschema überführen, inkl. Kennzeichnung von Primärschlüssel, Unique Key und optionalen (NULL-fähigen) Attributen"
quelle_lehrbrief: "Kap. 4"
quelle_lehrbuch: "keine"
fallstudie: "eigenes MEA-Szenario (Rohstoffe/Lieferanten, angelehnt an mea-produktionsauftraege) - siehe 04-fallstudien/README.md"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-08-10
---

# Woche 4: Vom ER-Modell zum Relationenmodell: Grundlagen, Schlüssel und Transformationsregeln

> Zeitbedarf: ca. 1,5 Stunden.

## Worum geht es?

Die letzten beiden Wochen drehten sich ausschließlich um den
**konzeptuellen Datenbankentwurf** — das ER-Modell. Das ER-Modell ist
absichtlich technikfern gehalten: Es eignet sich hervorragend, um mit
Anwendern über eine Anwendungswelt zu diskutieren, aber es fehlt ihm
eine Sprachkomponente, mit der man tatsächlich Daten abfragen oder
ändern könnte. Deshalb hat sich zur *Implementierung* von Datenbanken
ein anderes Modell durchgesetzt: das **Relationenmodell**, ergänzt um
die Datenbanksprache SQL.

Diese Woche beginnt damit der **logische Datenbankentwurf**: die
Überführung eines ER-Schemas in ein Relationenschema. Diese Woche
lernst du zunächst die Grundbegriffe und das Schlüsselkonzept des
Relationenmodells kennen und wendest die einfachste Transformationsregel
an — die Überführung *eines einzelnen* Entity-Typs in eine Relation.
Wie ganze *Beziehungstypen* (1:N, N:M, 1:1, rekursive Beziehungen)
systematisch transformiert werden, ist Thema der nächsten Woche — diese
Woche lernst du aber schon das Werkzeug kennen, mit dem das gemacht
wird: den **Fremdschlüssel**.

## Das solltest du danach können

- Du kannst erklären, was im Relationenmodell eine Relation, ein
  Datensatz, ein Attribut, ein Wertebereich und ein Relationenschema
  sind — und weißt, welchem ER-Modell-Begriff sie jeweils entsprechen.
- Du kannst erklären, warum eine Relation mehrere Schlüsselkandidaten
  haben kann, aber für die Implementierung genau einer als
  Primärschlüssel ausgewählt werden muss, und die übrigen als Unique
  Key gekennzeichnet werden.
- Du kannst ein optionales (NULL-fähiges) Attribut von einem
  verpflichtenden Attribut unterscheiden und weißt, warum ein
  Primärschlüssel niemals optional sein darf.
- Du kannst erklären, was ein Fremdschlüssel ist, ihn in einem
  Relationenschema korrekt notieren und begründen, warum ein
  selbstreferenzierender Fremdschlüssel zwingend anders heißen muss als
  der Schlüssel, auf den er verweist.

## Erarbeitung

Lies im Lehrbrief (`Lehrbrief_relationaleDatenbanken.pdf`) die folgenden
Abschnitte der Reihe nach. Mach dir wie in den letzten Wochen Notizen in
eigenen Worten — die brauchst du für die Aufgabe unten.

**Schritt 1:** Kapitel 4, Einleitung sowie Abschnitt 4.1 "Grundlagen"
(S. 35-36): Relation, Datensatz, Attribut, Wertebereich,
Relationenschema sowie optionale Attribute und der NULL-Wert.

**Schritt 2:** Abschnitt 4.2 "Schlüssel" (S. 36-37): Schlüsselkandidat,
Primärschlüssel (PK), Unique Key (UK), Entity-/Schlüsselintegrität sowie
die Abgrenzung von Schlüsselattributen und Nichtschlüsselattributen.

**Schritt 3:** Abschnitt 4.3 "Fremdschlüssel" (S. 37-39): das
Fremdschlüssel-Konzept (FK), seine Notation, die Regeln im Umgang mit
Fremdschlüsseln sowie die Fremdschlüsselintegrität.

Lies **nicht** weiter in Kapitel 5 ("Logischer Datenbankentwurf") — die
systematische Transformation ganzer Beziehungstypen ist Thema der
nächsten Woche.

## Aufgabe

Ein Betrieb aus dem MEA-Umfeld verwaltet die Rohstoffe, die er für seine
Fertigungsaufträge benötigt, sowie seine Lieferanten:

> Zu jedem **Rohstoff** werden eine intern vergebene, eindeutige
> Rohstoffnummer sowie ein vom Hersteller vergebener, ebenfalls
> eindeutiger Artikelcode gespeichert. Außerdem werden eine Bezeichnung
> und ein Mindestbestand gespeichert. Der Lagerort eines Rohstoffs wird
> erst eingetragen, sobald er tatsächlich einem Lagerplatz zugewiesen
> wurde — bis dahin ist er unbekannt. Jeder Rohstoff wird außerdem genau
> einem **Lieferanten** zugeordnet. Für manche Rohstoffe ist zusätzlich
> ein alternativer Rohstoff als Ersatz hinterlegt, falls der
> Hauptlieferant kurzfristig nicht liefern kann — für die meisten
> Rohstoffe gibt es aber keinen solchen Ersatz.
>
> Für **Lieferanten** werden eine eindeutige Lieferantennummer, ein
> Name und ein Sitz (Ort) gespeichert; diese drei Angaben liegen für
> jeden Lieferanten immer vollständig vor.

**Teil A — Schlüssel**

1. Bestimme die Attribute des Entity-Typs `ROHSTOFF` und markiere beide
   Schlüsselkandidaten (im ER-Modell macht man an dieser Stelle noch
   keinen Unterschied zwischen ihnen).
2. Überführe `ROHSTOFF` nach der Grundregel der Transformation in ein
   Relationenschema. Entscheide dich für einen der beiden
   Schlüsselkandidaten als Primärschlüssel, kennzeichne den anderen als
   Unique Key, und begründe deine Wahl. Kennzeichne außerdem, welches
   Attribut optional (NULL-fähig) ist.

**Teil B — Fremdschlüssel**

Die Relation `LIEFERANT` ist bereits fertig transformiert:

| Schlüssel | Attribut | Wertebereich | optional (NULL-fähig)? |
|---|---|---|---|
| PK | lieferantennr | int | nein |
| – | name | string | nein |
| – | ort | string | nein |

3. Erweitere dein Relationenschema `ROHSTOFF` aus Teil A um ein
   passendes Fremdschlüssel-Attribut, das jeden Rohstoff seinem
   Lieferanten zuordnet. Kennzeichne es als `FK1` und gib an, ob es
   optional sein darf.
4. Erweitere `ROHSTOFF` um ein zweites Fremdschlüssel-Attribut
   `ersatz_rohstoffnr`, das — falls vorhanden — auf den Ersatzrohstoff
   verweist. Kennzeichne es als `FK2` und gib an, ob es optional ist.
5. Erkläre in ein bis zwei Sätzen, warum `ersatz_rohstoffnr` nicht
   einfach `rohstoffnr` heißen darf, obwohl ein Fremdschlüssel
   grundsätzlich denselben Namen wie der referenzierte Schlüssel tragen
   darf.

??? note "Musterlösung anzeigen"
    **1. Entity-Typ `ROHSTOFF` (ER-Modell, vor der Transformation)**

    ```mermaid
    %%{init: {'themeVariables': {'fontSize': '0.6rem'}}}%%
    graph LR
    ROHSTOFF["<div style='text-align:left; font-size: 0.6rem;'><b>ROHSTOFF</b><hr/>rohstoffnr : int (Schlüssel)<br/>artikelcode : string (Schlüssel)<br/>bezeichnung : string<br/>lagerort : string<br/>mindestbestand : int</div>"]
    ```

    Sowohl `rohstoffnr` als auch `artikelcode` identifizieren einen
    Rohstoff eindeutig — im ER-Modell sind das zunächst zwei
    gleichwertige Schlüsselkandidaten. Erst bei der Transformation ins
    Relationenmodell muss entschieden werden, welcher davon Primärschlüssel
    wird.

    **2. Relationenschema `ROHSTOFF` (Teil A)**

    | Schlüssel | Attribut | Wertebereich | optional (NULL-fähig)? |
    |---|---|---|---|
    | PK | rohstoffnr | int | nein |
    | UK | artikelcode | string | nein |
    | – | bezeichnung | string | nein |
    | – | lagerort | string | ja |
    | – | mindestbestand | int | nein |

    Begründung für die Wahl von `rohstoffnr` als Primärschlüssel statt
    `artikelcode`: Der Primärschlüssel sollte möglichst stabil sein, da
    andere Relationen ihn später über Fremdschlüssel referenzieren.
    `rohstoffnr` wird intern vom Betrieb selbst vergeben und ändert sich
    nie. `artikelcode` stammt dagegen vom Hersteller — wechselt der
    Betrieb den Lieferanten für einen Rohstoff oder ändert der
    Hersteller sein Kodierschema, könnte sich der Artikelcode ändern.
    Deshalb bleibt `artikelcode` zwar Schlüsselkandidat (als Unique Key
    weiterhin vor doppelten Werten geschützt), wird aber nicht
    Primärschlüssel. `lagerort` ist das einzige optionale Attribut, da
    er laut Aufgabenstellung anfangs unbekannt sein kann.

    **3.-4. Relationenschema `ROHSTOFF` inkl. Fremdschlüssel (Teil B)**

    | Schlüssel | Attribut | Wertebereich | optional (NULL-fähig)? |
    |---|---|---|---|
    | PK | rohstoffnr | int | nein |
    | UK | artikelcode | string | nein |
    | – | bezeichnung | string | nein |
    | – | lagerort | string | ja |
    | – | mindestbestand | int | nein |
    | FK1 | lieferantennr | int | nein |
    | FK2 | ersatz_rohstoffnr | int | ja |

    `FK1` (`lieferantennr`) referenziert den Primärschlüssel von
    `LIEFERANT` und ist nicht optional, da laut Aufgabenstellung *jeder*
    Rohstoff genau einem Lieferanten zugeordnet ist. `FK2`
    (`ersatz_rohstoffnr`) referenziert den Primärschlüssel derselben
    Relation `ROHSTOFF` (`rohstoffnr`) und ist optional, da die meisten
    Rohstoffe laut Aufgabenstellung keinen Ersatz haben — für sie steht
    dort der NULL-Wert.

    **5. Warum `ersatz_rohstoffnr` nicht `rohstoffnr` heißen darf**

    Ein Fremdschlüssel referenziert hier einen Datensatz *derselben*
    Relation `ROHSTOFF` — genau in diesem Sonderfall müssen sich
    Fremdschlüssel- und referenzierter Schlüsselname zwingend
    unterscheiden. Würde man das Attribut ebenfalls `rohstoffnr` nennen,
    gäbe es im Relationenschema von `ROHSTOFF` zweimal ein Attribut mit
    demselben Namen — dann wäre nicht mehr erkennbar, welches davon der
    eigene Primärschlüssel des Datensatzes ist und welches der Verweis
    auf einen *anderen* Datensatz.

## Selbstkontrolle

### Frage 1

<quiz>
Ergänze die Lücken mit den passenden Fachbegriffen des Relationenmodells: 

Im Relationenmodell wird eine Tabelle als [[Relation]] bezeichnet, eine einzelne Zeile dieser Tabelle als [[Datensatz]], und die Struktur-Beschreibung mit Namen und Attributliste als [[Relationenschema]]; die Menge der für ein Attribut zulässigen Werte heißt [[Wertebereich]].

---
Kapitel 4.1 im Lehrbrief (S. 35-36) führt alle vier Begriffe direkt hintereinander ein.
</quiz>

### Frage 2

Erkläre in eigenen Worten den Unterschied zwischen
Entity-/Schlüsselintegrität und Fremdschlüsselintegrität. Nutze dazu die
Relationen `ROHSTOFF` und `LIEFERANT` aus der Aufgabe als Beispiel.

??? question "Antwort anzeigen"
    Die **Entity-/Schlüsselintegrität** betrifft eine einzelne Relation
    für sich genommen: Sie stellt sicher, dass keine zwei Datensätze
    einer Relation in den Werten ihres Primärschlüssels übereinstimmen —
    in `ROHSTOFF` darf es also nicht zweimal denselben Wert für
    `rohstoffnr` geben.

    Die **Fremdschlüsselintegrität** betrifft dagegen die Beziehung
    *zwischen zwei* Relationen: Sie stellt sicher, dass es zu jedem
    (nicht-NULL) Fremdschlüsselwert auch tatsächlich einen passenden
    Datensatz in der referenzierten Relation gibt — zu jedem Wert von
    `lieferantennr` in `ROHSTOFF` muss es einen Datensatz mit genau
    dieser `lieferantennr` in `LIEFERANT` geben. Ein Rohstoff kann also
    nicht einem Lieferanten zugeordnet werden, den es gar nicht gibt.

### Frage 3

<quiz>
Die folgenden vier Satzanfänge beschreiben Regeln im Umgang mit Fremdschlüsseln. Vervollständige jeden Satzanfang mit der passenden Fortsetzung:

1. Ein Fremdschlüssel kann bestehen aus
2. Am besten referenziert ein Fremdschlüssel
3. Ein Fremdschlüssel und der von ihm referenzierte Schlüssel müssen übereinstimmen in
4. Die Bezeichnung eines Fremdschlüsselattributs muss nicht identisch sein mit

Ordne jedem Satzanfang die passende Fortsetzung zu:

- [[3]] ihrem Wertebereich (Datentyp).
- [[1]] einem einzelnen Attribut oder aus mehreren Attributen.
- [[4]] der Bezeichnung des referenzierten Schlüsselattributs – aus praktischen Gründen ist eine gleiche Bezeichnung aber empfehlenswert.
- [[2]] den Primärschlüssel der referenzierten Relation – theoretisch wäre aber auch ein anderer Schlüsselkandidat möglich.

---
Alle vier Regeln stehen im Lehrbrief auf S. 39 im Kasten zu Fremdschlüsseln.
</quiz>

### Frage 4

Ein Fremdschlüssel darf grundsätzlich denselben Namen tragen wie der
Schlüssel, den er referenziert. Es gibt aber genau eine Situation, in
der das nicht erlaubt ist. Welche, und warum?

??? question "Antwort anzeigen"
    Die Ausnahme betrifft einen **selbstreferenzierenden Fremdschlüssel**
    — einen Fremdschlüssel, der auf einen Datensatz *derselben* Relation
    verweist (wie `ersatz_rohstoffnr` in `ROHSTOFF`, das wieder auf
    `rohstoffnr` in `ROHSTOFF` verweist). Hier muss der
    Fremdschlüsselname sich zwingend vom referenzierten Schlüsselnamen
    unterscheiden, weil sonst im selben Relationenschema zwei Attribute
    denselben Namen trügen — dann wäre nicht mehr unterscheidbar,
    welches der eigene Primärschlüssel des Datensatzes ist und welches
    der Verweis auf einen anderen Datensatz.

### Frage 5

<quiz>
Welche Aussagen zu Schlüsselkandidaten, Primärschlüssel und Unique Key sind korrekt? (Mehrfachauswahl möglich)

- [x] Eine Relation kann mehrere Schlüsselkandidaten besitzen, muss aber genau einen davon als Primärschlüssel auswählen.
- [ ] Ein Unique Key darf wie der Primärschlüssel keine optionalen Attribute enthalten.
  > Falsch: Genau das unterscheidet einen Unique Key vom Primärschlüssel — ein Unique Key darf optionale (NULL-fähige) Attribute enthalten, ein Primärschlüssel nicht.
- [x] Attribute, die Teil eines Schlüsselkandidaten sind, heißen Schlüsselattribute, alle anderen Nichtschlüsselattribute.
- [ ] Für eine Relation genügt es, irgendeinen Schlüsselkandidaten zu benennen, ohne einen davon als Primärschlüssel festzulegen.
  > Falsch: Für die Implementierung muss aus den Schlüsselkandidaten zwingend genau einer als Primärschlüssel ausgewählt werden.
</quiz>
