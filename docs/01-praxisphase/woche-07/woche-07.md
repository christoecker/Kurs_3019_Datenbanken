---
typ: praxisphase-woche
woche: 7
thema: "Normalisierung (funktionale Abhängigkeit, 1.-3. Normalform)"
workload_minuten: 90
lernziele:
  - "kann den Begriff der funktionalen Abhängigkeit erklären und für zwei gegebene Attribute einer Relation beurteilen, ob eine funktionale Abhängigkeit besteht"
  - "kann erklären, was Redundanz ist und warum sie zu Inkonsistenzen führen kann"
  - "kann eine Relation auf Verletzung der zweiten Normalform prüfen und sie bei Bedarf durch Auslagerung des betroffenen Attributs in zwei Relationen zerlegen"
  - "kann eine Relation auf Verletzung der dritten Normalform prüfen und sie bei Bedarf durch Auslagerung des betroffenen Attributs in zwei Relationen zerlegen"
quelle_lehrbrief: "Kap. 5.6"
quelle_lehrbuch: "keine"
fallstudie: "eigenes MEA-Szenario (Wartungseinsätze, Fortsetzung Maschinenpark/Wartung aus Woche 2 und 5) - siehe 04-fallstudien/README.md"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-08-31
---

# Woche 7: Normalisierung

> Zeitbedarf: ca. 1,5 Stunden.

## Worum geht es?

Die letzten drei Wochen ging es darum, ein ER-Schema *korrekt* in ein
Relationenschema zu überführen. Die entstehenden Relationen sind damit
zwar formal richtig — aber nicht zwangsläufig auch *gut entworfen*.
Diese Woche lernst du, wie man ein bereits transformiertes Schema auf
Qualität prüft und bei Bedarf verbessert: die **Normalisierung**.

Dabei geht es um ein zentrales Problem: **Redundanz**, also die
mehrfache Speicherung derselben Information innerhalb einer Relation.
Redundanz ist gefährlich, weil sie **Inkonsistenzen** ermöglicht — wird
bei einer Änderung eine der mehrfach gespeicherten Kopien vergessen,
widersprechen sich die Daten. Mit der **ersten, zweiten und dritten
Normalform** bekommst du drei konkrete, prüfbare Kriterien an die Hand,
mit denen du genau solche Redundanzen aufspüren und beseitigen kannst.

## Das solltest du danach können

- Du kannst erklären, was eine funktionale Abhängigkeit zwischen zwei
  Attributen ist, und sie an einem Beispiel zeigen.
- Du kannst erklären, was Redundanz ist und an einem Beispiel zeigen,
  wie daraus eine Inkonsistenz entstehen kann.
- Du kannst eine Relation mit zusammengesetztem Schlüssel darauf
  prüfen, ob ein Nichtschlüsselattribut nur von einem Teil des
  Schlüssels abhängt (2NF-Verletzung), und sie bei Bedarf in zwei
  Relationen zerlegen.
- Du kannst eine Relation darauf prüfen, ob ein Nichtschlüsselattribut
  nur indirekt — über ein anderes Nichtschlüsselattribut — vom
  Schlüssel abhängt (3NF-Verletzung), und sie bei Bedarf in zwei
  Relationen zerlegen.

## Erarbeitung

Lies im Lehrbrief (`Lehrbrief_relationaleDatenbanken.pdf`) die folgenden
Abschnitte der Reihe nach. Mach dir wie in den letzten Wochen Notizen in
eigenen Worten — die brauchst du für die Aufgabe unten.

**Schritt 1:** Abschnitt 5.6, Einleitung (S. 49-50): Redundanz und
funktionale Abhängigkeit, gezeigt am Beispiel der Relation
`PROJEKT-TEAM`. Das Beispiel lohnt sich, aufmerksam zu lesen — die
Aufgabe unten arbeitet mit einer ganz ähnlich aufgebauten eigenen
Relation.

**Schritt 2:** Abschnitt 5.6.1 "Erste Normalform" (S. 50): kurz, da alle
Relationen, die du mit den Regeln aus Woche 4-6 gebildet hast, die
erste Normalform automatisch erfüllen.

**Schritt 3:** Abschnitt 5.6.2 "Zweite Normalform" (S. 51): Regel und
Zerlegung von `PROJEKT-TEAM`.

**Schritt 4:** Abschnitt 5.6.3 "Dritte Normalform" (S. 52): Regel und
weitere Zerlegung.

Lies **nicht** weiter in Abschnitt 5.7 ("Projektaufgabe") — das ist
eine größere Übungsaufgabe aus dem Lehrbrief und nicht
Teil dieses Arbeitsauftrags.

## Aufgabe

Ein Betrieb hält für jeden Mitarbeiter-Einsatz an einem Wartungsauftrag
(du kennst `WARTUNGSAUFTRAG` bereits aus Woche 2 und 5) einen Datensatz
in folgender Relation fest:

**Relation `EINSATZ`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | personalnr | int | nein |
| PK | auftragsnr | int | nein |
| – | maschinennr | int | nein |
| – | standort | string | nein |
| – | stunden | int | nein |

`maschinennr` und `standort` betreffen dabei die Maschine, auf die sich
der jeweilige Wartungsauftrag bezieht; `stunden` ist die Anzahl der
Stunden, die genau dieser Mitarbeiter an genau diesem Auftrag
gearbeitet hat.

1. Prüfe `EINSATZ` auf Verletzung der zweiten Normalform: Hängt jedes
  Nichtschlüsselattribut wirklich vom *gesamten* Schlüssel
  (`personalnr`, `auftragsnr`) ab, oder nur von einem Teil davon?
  Begründe. Zerlege `EINSATZ` bei Bedarf in zwei Relationen, die die
  2NF erfüllen.
2. Prüfe anschließend die neu entstandene Relation, die die
  Auftragsdaten enthält, auf Verletzung der dritten Normalform und begründe deine Analyse. 
  Zerlege sie bei Bedarf weiter in zwei Relationen, die die
  3NF erfüllen.

??? note "Musterlösung anzeigen"
    **Schritt 1: Prüfung auf 2. Normalform**

    `maschinennr` und `standort` hängen beide nur von `auftragsnr` ab
    (jeder Wartungsauftrag bezieht sich immer auf dieselbe Maschine,
    unabhängig davon, welcher Mitarbeiter beteiligt ist) — das ist eine
    Abhängigkeit von nur einem *Teil* des zusammengesetzten Schlüssels.
    `stunden` dagegen hängt tatsächlich von der *vollständigen*
    Kombination aus `personalnr` und `auftragsnr` ab (wie viele Stunden
    genau dieser Mitarbeiter an genau diesem Auftrag gearbeitet hat,
    ist für jede Personalnr/Auftragsnr-Kombination ein eigener Wert).

    `EINSATZ` verletzt damit die 2NF. Zerlegung — die von `auftragsnr`
    abhängigen Nichtschlüsselattribute werden zusammen mit `auftragsnr`
    in eine neue Relation ausgelagert:

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | auftragsnr | int | nein |
    | – | maschinennr | int | nein |
    | – | standort | string | nein |

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | personalnr | int | nein |
    | PK | auftragsnr | int | nein |
    | – | stunden | int | nein |

    **Schritt 2: Prüfung der neuen Auftragsrelation auf 3. Normalform**

    In der neuen Relation (Schlüssel `auftragsnr`) hängt `standort`
    nicht direkt vom Schlüssel ab, sondern nur *indirekt*: Der Standort
    ist eine Eigenschaft der Maschine, nicht des Auftrags — `standort`
    hängt also eigentlich vom Nichtschlüsselattribut `maschinennr` ab,
    und `maschinennr` wiederum vom Schlüssel `auftragsnr`. Das ist eine
    transitive Abhängigkeit, die 3NF ist verletzt.

    Zerlegung — das transitiv abhängige Attribut wird zusammen mit dem
    Attribut, von dem es abhängt, in eine neue Relation ausgelagert:

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | auftragsnr | int | nein |
    | FK | maschinennr | int | nein |

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | maschinennr | int | nein |
    | – | standort | string | nein |

    Damit steht der Standort einer Maschine nur noch einmal in der
    Relation `MASCHINE` — unabhängig davon, wie viele Wartungsaufträge
    und wie viele beteiligte Mitarbeiter es für diese Maschine gibt.

## Selbstkontrolle

### Frage 1

<quiz>
Ergänze die Lücken mit den passenden Fachbegriffen: 

Wird ein und dieselbe Information mehrfach in einer Relation gespeichert, spricht man von [[Redundanz]]; besteht zwischen zwei Attributen der Zusammenhang, dass der Wert des einen Attributs den Wert des anderen eindeutig festlegt, nennt man das eine [[funktionale]] Abhängigkeit. Eine Relation verletzt die zweite Normalform, wenn ein Nichtschlüsselattribut nur von einem [[Teil]] eines zusammengesetzten Schlüssels abhängig ist, und die dritte Normalform, wenn ein Nichtschlüsselattribut [[transitiv]] über ein anderes Nichtschlüsselattribut vom Schlüssel abhängig ist; die schrittweise Beseitigung solcher Abhängigkeiten durch Zerlegung in mehrere Relationen wird als [[Normalisierung]] bezeichnet.

---
Abschnitt 5.6 im Lehrbrief (S. 49-52) führt alle fünf Begriffe der Reihe nach ein.
</quiz>

### Frage 2

Erkläre am Beispiel der Relation `EINSATZ` aus der Aufgabe (oder einem
eigenen Beispiel), warum die Verletzung der zweiten Normalform zu
Redundanz und potentiellen Inkonsistenzen führen kann.

??? question "Antwort anzeigen"
    In `EINSATZ` würden `maschinennr` und `standort` für jeden
    Mitarbeiter, der am selben Auftrag arbeitet, erneut gespeichert —
    arbeiten z. B. drei Mitarbeiter an Auftrag 500, steht
    "maschinennr = 12, standort = Halle 3" dreimal in der Tabelle.
    Ändert sich der Standort dieser Maschine, müssten alle drei Zeilen
    konsistent aktualisiert werden — wird eine davon vergessen, stehen
    für denselben Auftrag widersprüchliche Standortangaben in der
    Tabelle. Nach der Zerlegung steht diese Information nur noch einmal
    in der Auftragsrelation, unabhängig davon, wie viele Mitarbeiter
    beteiligt sind.

### Frage 3

<quiz>
Welche Aussagen zu Normalformen sind korrekt? (Mehrfachauswahl möglich)

- [ ] Redundanz ist grundsätzlich unproblematisch, solange die Relation die erste Normalform erfüllt.
  > Falsch: Redundanz kann unabhängig von der ersten Normalform zu Inkonsistenzen führen — genau das beseitigen erst die zweite und dritte Normalform.
- [x] Die erste Normalform verlangt, dass alle Attribute atomare Wertebereiche haben.
- [x] Die zweite Normalform ist nur bei Relationen mit einem zusammengesetzten Schlüssel überhaupt verletzbar.
- [ ] Die dritte Normalform verlangt, dass kein Nichtschlüsselattribut nur von einem Teil eines zusammengesetzten Schlüssels abhängt.
  > Falsch: Das beschreibt die zweite Normalform. Die dritte Normalform betrifft dagegen Abhängigkeiten zwischen zwei Nichtschlüsselattributen (transitive Abhängigkeit).
</quiz>

### Frage 4

<quiz>
Eine Relation `BESTELLPOSITION` hat den zusammengesetzten Schlüssel (`bestellnr`, `positionsnr`). Das Nichtschlüsselattribut `artikelbezeichnung` ist ausschließlich von `artikelnr` abhängig, einem weiteren Nichtschlüsselattribut derselben Relation:

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | bestellnr | int | nein |
| PK | positionsnr | int | nein |
| – | artikelnr | int | nein |
| – | artikelbezeichnung | string | nein |
| – | menge | int | nein |

Welche Normalform verletzt `BESTELLPOSITION` dadurch?

- [ ] Die erste Normalform, da `artikelbezeichnung` keinen atomaren Wertebereich hat.
- [ ] Die zweite Normalform, da `artikelbezeichnung` nur von einem Teil des Schlüssels abhängt.
- [x] Die dritte Normalform, da `artikelbezeichnung` transitiv über das Nichtschlüsselattribut `artikelnr` vom Schlüssel abhängt.
</quiz>

### Frage 5

Erkläre den Unterschied zwischen einer Verletzung der 2NF und einer
Verletzung der 3NF in eigenen Worten: Worauf genau bezieht sich die
jeweilige Abhängigkeit?

??? question "Antwort anzeigen"
    Bei einer 2NF-Verletzung hängt ein Nichtschlüsselattribut nur von
    einem *Teil* eines zusammengesetzten Schlüssels ab, nicht vom
    vollständigen Schlüssel — die Abhängigkeit betrifft hier also das
    Verhältnis zwischen einem Nichtschlüsselattribut und dem Schlüssel
    selbst. Bei einer 3NF-Verletzung hängt ein Nichtschlüsselattribut
    dagegen von einem *anderen Nichtschlüsselattribut* ab, nicht direkt
    vom Schlüssel — die Abhängigkeit betrifft hier also das Verhältnis
    zwischen zwei Nichtschlüsselattributen untereinander, nicht
    zwischen einem Attribut und dem Schlüssel.
