---
typ: theoriephase-block
termin: 2
block_id: "03"
datum: "2026-10-27"
kurztitel: "Normalisierung anwenden"
thema: "Normalisierung anwenden + Praxisfall: bewusster Verzicht auf Normalform"
lernziele:
  - "Ihr könnt eine gegebene Relation systematisch auf Verletzungen der ersten, zweiten und dritten Normalform prüfen und sie bei Bedarf in mehrere Relationen zerlegen."
  - "Ihr könnt begründen, wann eine bewusst nicht vollständig normalisierte bzw. redundante Datenhaltung eine gerechtfertigte Entwurfsentscheidung ist, statt ein Fehler."
  - "Ihr könnt widersprüchliche Anforderungen in einer Spezifikation erkennen, euch begründet für eine Umsetzung entscheiden und belegen, warum eine Anforderung nicht (vollständig) umgesetzt wurde."
  - "Ihr könnt die Auswirkung einer nachträglichen Anforderungsänderung auf ein bestehendes Schema einschätzen, bevor ihr sie umsetzt, und KI gezielt zur Umsetzung einsetzen und deren Vorschläge prüfen."
musterloesungen_sichtbar: true
nachtrag_sichtbar: false
fallstudie: "Übung: Kompressor-Zustandsüberwachung; betreutes Selbststudium: Lackproduktion Schnüffel GmbH (beides eigene MEA-Szenarien)"
ki_einsatz: stufe_2_pair_programmer
bearbeitungsstatus: entworfen
publish_date: 2026-10-19
---

<!-- ABLAUF-HINWEIS FÜR DIE LEHRPERSON (wird nicht gerendert):
     Teil C des betreuten Selbststudiums ("Nachtrag der Schnüffel GmbH")
     ist bewusst ausgeblendet - die Anforderungsänderung soll während der
     Veranstaltung überraschend kommen und nicht vorab lesbar sein.
     Gesteuert wird das über das Frontmatter-Feld "nachtrag_sichtbar"
     (siehe hooks/solution_toggle.py); der komplette Teil C inklusive
     seiner Musterlösung steht zwischen NACHTRAG-START und NACHTRAG-ENDE
     und landet bei "false" gar nicht erst im gebauten HTML.

     Geplantes Vorgehen während der Veranstaltung:
     1. Vorher prüfen: musterloesungen_sichtbar: false UND
        nachtrag_sichtbar: false. Diese Fassung bekommen die
        Studierenden zu Beginn.
     2. Studierende bearbeiten Teil A und Teil B (zusammen ca. 25 Min.).
     3. Sobald die ersten Gruppen eine vollständige erste Version des
        Schemas haben: nachtrag_sichtbar auf true setzen, committen,
        pushen. Der GitHub-Actions-Lauf baut die Seite neu, danach ist
        Teil C auf der Kurswebseite sichtbar. Sonst nichts ändern -
        musterloesungen_sichtbar bleibt auf false.
     4. Erst NACH der Besprechung aller Teile: musterloesungen_sichtbar
        auf true setzen (eigener, späterer Commit).
-->

# Normalisierung anwenden (27.10.2026)

## Normalisierung anwenden { .modus-uebung }

### Worum geht es?

Ihr habt in der Praxisphase (Woche 7) bereits gelernt, wie man eine
Relation auf Redundanz prüft und sie mithilfe der ersten, zweiten und
dritten Normalform verbessert. Heute wendet ihr das auf ein komplett
neues, eigenständiges Szenario an: die Zustandsüberwachung eines
Kompressors. Dabei zerlegt ihr nicht nur eine, sondern gleich zwei
unterschiedlich strukturierte Relationen — und lernt am Ende auch die
Kehrseite kennen: Wann es eine bewusste, gute Entscheidung ist, eine
Relation *nicht* vollständig zu normalisieren.

!!! abstract "Lernziele"
    - Ihr könnt eine Relation mit zusammengesetztem Schlüssel
      systematisch auf 1NF-, 2NF- und 3NF-Verletzungen prüfen und bei
      Bedarf zerlegen.
    - Ihr könnt erklären, warum bewusst gespeicherte, aus anderen
      Daten ableitbare Werte kein klassischer Normalform-Verstoß sind,
      sondern eine eigene, ebenfalls bewusst zu treffende
      Entwurfsentscheidung.

### Kurzer Rückblick <span class="zeitangabe">ca. 6 Min.</span> { data-toc-label="Kurzer Rückblick" }

1.  Wozu dient Normalisierung grundsätzlich?

    <!-- MUSTERLOESUNG-START -->
    ??? question "Antwort anzeigen"
        Normalisierung prüft ein bereits transformiertes
        Relationenschema auf Qualität und deckt Redundanz auf, die zu
        Inkonsistenzen führen kann. Mit der ersten, zweiten und dritten
        Normalform bekommt man konkrete, prüfbare Kriterien an die
        Hand, um solche Redundanzen zu erkennen und durch Zerlegung in
        mehrere Relationen zu beseitigen.
    <!-- MUSTERLOESUNG-ENDE -->

2.  Was verlangt die erste Normalform von einer Relation?

    <!-- MUSTERLOESUNG-START -->
    ??? question "Antwort anzeigen"
        Dass jedes Attribut einen atomaren, nicht weiter zerlegbaren
        Wertebereich hat — eine einzelne Zelle darf also nicht mehrere
        Werte gleichzeitig enthalten (z. B. kein Tupel, keine Liste).
    <!-- MUSTERLOESUNG-ENDE -->

3.  Was versteht man unter einer funktionalen Abhängigkeit zwischen zwei Attributen?

    <!-- MUSTERLOESUNG-START -->
    ??? question "Antwort anzeigen"
        Der Wert des einen Attributs legt den Wert des anderen
        eindeutig fest — zwei Datensätze mit demselben Wert im ersten
        Attribut müssen dann auch im zweiten Attribut übereinstimmen.
    <!-- MUSTERLOESUNG-ENDE -->

4.  Wann verletzt eine Relation die zweite Normalform?

    <!-- MUSTERLOESUNG-START -->
    ??? question "Antwort anzeigen"
        Wenn ein Nichtschlüsselattribut nur von einem *Teil* eines
        zusammengesetzten Schlüssels abhängt, nicht vom vollständigen
        Schlüssel.
    <!-- MUSTERLOESUNG-ENDE -->

5.  Wann verletzt eine Relation die dritte Normalform — und wie unterscheidet sich das von einer 2NF-Verletzung?

    <!-- MUSTERLOESUNG-START -->
    ??? question "Antwort anzeigen"
        Wenn ein Nichtschlüsselattribut nur indirekt (transitiv) über
        ein *anderes* Nichtschlüsselattribut vom Schlüssel abhängt. Im
        Unterschied zur 2NF geht es hier nicht um das Verhältnis
        zwischen einem Attribut und dem Schlüssel, sondern um das
        Verhältnis zwischen zwei Nichtschlüsselattributen
        untereinander.
    <!-- MUSTERLOESUNG-ENDE -->

---

### Das Szenario: Kompressor-Zustandsüberwachung <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Das Szenario: Kompressor-Zustandsüberwachung" }

> Pustefix & Co. ist ein Hersteller von Kompressoren, der sein Topmodell nun "intelligent"
> machen möchte: Jeder Kompressor soll auf Basis seiner eigenen Prozessdaten
> eine Einschätzung seines Zustands liefern — das kann beispielsweise wichtig für die
> vorausschauende Instandhaltung sein. Die Datenhaltung läuft dabei
> vollständig auf einem **am Kompressor angeschlossenen Industrie-PC**. Erfasst werden minütlich fünf Messgrößen:
> Eingangs- und Ausgangsdruck, Volumenstrom, Temperatur und
> Luftfeuchtigkeit — diese Messreihen dienen zur langfristigen Rekonstruktion der Fahrweise und zur Analyse des "Gesundheitszustands" der Maschine..
>
> Einmal täglich läuft ein Analyse-Lauf: Er identifiziert lokale
> Maxima/Minima der Druckdifferenz, verarbeitet bislang unverarbeitete
> Extremwerte und markiert sie danach als verarbeitet. Innerhalb
> *eines* Laufs kommen dabei mehrere **Auswertealgorithmen** zum
> Einsatz: Jeder ist eindeutig identifizierbar und charakterisiert
> durch das verwendete **Verfahren** (aktuell "DIN" oder
> "PFIX", künftig ggf. weitere), die konkrete **Version** dieses
> Verfahrens sowie deren Freigabedatum und Status. Verfahren und
> Version zusammen legen einen Algorithmus eindeutig fest — die
> Versionsnummer allein nicht, da DIN und PFIX unabhängig
> voneinander versioniert werden und rein zufällig dieselbe
> Versionsnummer tragen könnten. Jeder dieser Algorithmen liefert
> innerhalb des Laufs einen eigenen Schädigungswert (0–100 %).
>
> Unabhängig von der jeweiligen Version sind außerdem für jedes
> Verfahren feste **Melde- und Alarm-Grenzwerte** hinterlegt, anhand
> derer ein berechneter Schädigungswert eingeordnet wird — diese
> Grenzwerte ändern sich nicht mit jeder neuen Version, sondern gelten
> für das Verfahren als Ganzes.

---

### Normalisierung anwenden <span class="zeitangabe">ca. 22 Min.</span> { data-toc-label="Normalisierung anwenden" }

#### Erste Normalform: Messwerte atomar speichern

Ein erster Entwurf für die minütliche Messwerterfassung sieht so aus:

**:octicons-table-16: Relation `MESSUNG`** (erste Version)

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | zeitstempel | datetime | nein |
| – | druckwerte | Tupel (Eingangsdruck, Ausgangsdruck) | nein |
| – | volumenstrom | decimal | nein |
| – | temperatur | decimal | nein |
| – | luftfeuchtigkeit | decimal | nein |

Prüft: Hat jedes Attribut einen atomaren Wertebereich?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    `druckwerte` fasst zwei eigentlich unabhängige Messgrößen (Eingangs-
    und Ausgangsdruck) in einem einzigen Attribut zusammen — das verletzt
    die 1NF, die von jedem Attribut einen atomaren, nicht weiter
    zerlegbaren Wertebereich verlangt. Die Zerlegung ist denkbar einfach:
    Aus dem einen Tupel-Attribut werden zwei eigenständige Attribute.

    **:octicons-table-16: Relation `MESSUNG`** (1NF-konform)

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | zeitstempel | datetime | nein |
    | – | druck_eingang | decimal | nein |
    | – | druck_ausgang | decimal | nein |
    | – | volumenstrom | decimal | nein |
    | – | temperatur | decimal | nein |
    | – | luftfeuchtigkeit | decimal | nein |
<!-- MUSTERLOESUNG-ENDE -->

#### Zweite Normalform: Schädigungsauswertung prüfen

Für die täglichen Auswertungsergebnisse existiert folgender erster
Entwurf. Da innerhalb eines Laufs mehrere Algorithmen ausgewertet
werden, braucht die Relation einen zusammengesetzten Schlüssel aus
Lauf und Algorithmus:

**:octicons-table-16: Relation `SCHAEDIGUNG_NAIV`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | analyse_lauf_id | int | nein |
| PK | algorithmus_id | int | nein |
| – | schädigungswert | int (0–100) | nein |
| – | zeitstempel | datetime | nein |
| – | verfahren | string | nein |
| – | version | string | nein |
| – | release_datum | date | nein |
| – | status | string (alpha/beta/stable) | nein |
| – | grenzwert_meldung | int (0–100) | nein |
| – | grenzwert_alarm | int (0–100) | nein |

Prüft: Hängt jedes Nichtschlüsselattribut wirklich vom *vollständigen*
Schlüssel (`analyse_lauf_id` + `algorithmus_id`) ab, oder nur von einem
Teil davon?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    `schädigungswert` hängt vom vollen Schlüssel ab — er ist das Ergebnis
    genau dieses Algorithmus innerhalb genau dieses Laufs. Die übrigen
    Attribute verletzen die 2NF jeweils auf einer anderen Seite des
    Schlüssels: `zeitstempel` hängt nur von `analyse_lauf_id` ab (ein Lauf
    hat genau einen Abschlusszeitpunkt, unabhängig davon, wie viele
    Algorithmen darin ausgewertet werden). `verfahren`, `version`,
    `release_datum`, `status`, `grenzwert_meldung` und `grenzwert_alarm`
    dagegen hängen nur von `algorithmus_id` ab: Ein Algorithmus wie
    "DIN, Version 1.01" bleibt derselbe, unabhängig davon, in welchem
    Lauf er gerade ausgewertet wird. `SCHAEDIGUNG_NAIV` verletzt die 2NF
    also gleich auf beiden Seiten des Schlüssels.

    Zerlegung — jede Gruppe wird zusammen mit dem Schlüsselteil, von dem
    sie abhängt, in eine eigene Relation ausgelagert:

    **:octicons-table-16: Relation `ANALYSE_LAUF`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | analyse_lauf_id | int | nein |
    | – | zeitstempel | datetime | nein (UNIQUE) |

    **:octicons-table-16: Relation `SCHAEDIGUNG`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | analyse_lauf_id | int | nein |
    | PK, FK | algorithmus_id | int | nein |
    | – | schädigungswert | int (0–100) | nein |

    **:octicons-table-16: Relation `ALGORITHMUS`** (vorläufig, vor 3NF-Prüfung)

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | algorithmus_id | int | nein |
    | – | verfahren | string | nein |
    | – | version | string | nein |
    | – | release_datum | date | nein |
    | – | status | string | nein |
    | – | grenzwert_meldung | int (0–100) | nein |
    | – | grenzwert_alarm | int (0–100) | nein |

    Wie im Szenario beschrieben, sind `verfahren` und `version`
    gemeinsam UNIQUE — `algorithmus_id` ist trotzdem der gewählte
    Primärschlüssel, weil `version` allein (wie in der Übung zu PK vs.
    Unique Key aus Woche 4) nicht eindeutig ist: Zwei unterschiedliche
    Verfahren könnten zufällig dieselbe Versionsnummer tragen.
<!-- MUSTERLOESUNG-ENDE -->

#### Dritte Normalform: Grenzwerte prüfen

Prüft die neu entstandene Relation `ALGORITHMUS`: Hängen
`grenzwert_meldung` und `grenzwert_alarm` wirklich direkt von
`algorithmus_id` ab, oder nur indirekt über ein anderes
Nichtschlüsselattribut?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    `grenzwert_meldung` und `grenzwert_alarm` beschreiben nicht den
    einzelnen Algorithmus, sondern das verwendete `verfahren` — sie
    hängen also nur transitiv über `verfahren` vom Schlüssel ab:
    Mehrere Versionen desselben Verfahrens (z. B. DIN Version 1.00 und
    DIN Version 1.01) hätten identische Grenzwerte, weil die Grenzwerte
    laut Szenario unabhängig von der Version für das gesamte Verfahren
    gelten. `ALGORITHMUS` verletzt damit die 3NF.

    Zerlegung — das transitiv abhängige Attribut-Paar wird zusammen mit
    `verfahren` in eine neue Relation ausgelagert:

    **:octicons-table-16: Relation `ALGORITHMUS`** (vollständig)

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | algorithmus_id | int | nein |
    | – | version | string | nein |
    | – | release_datum | date | nein |
    | – | status | string | nein |
    | FK | verfahren | string | nein |

    (weiterhin gilt: `verfahren` + `version` gemeinsam UNIQUE)

    **:octicons-table-16: Relation `VERFAHREN`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | verfahren | string | nein |
    | – | grenzwert_meldung | int (0–100) | nein |
    | – | grenzwert_alarm | int (0–100) | nein |
<!-- MUSTERLOESUNG-ENDE -->

---

### Gesamtergebnis <span class="zeitangabe">ca. 4 Min.</span> { data-toc-label="Gesamtergebnis" }

Neben den fünf Relationen aus der Normalisierung gehört noch eine
weitere zum Kompressor-Datenmodell: `EXTREMWERT`, die die täglich
identifizierten lokalen Maxima/Minima der Druckdifferenz festhält.

**:octicons-table-16: Relation `EXTREMWERT`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | zeitstempel | datetime | nein |
| – | typ | string (Maximum/Minimum) | nein |
| – | wert | decimal | nein |
| – | verarbeitet | boolean | nein |

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    Damit besteht das vollständige, normalisierte Kompressor-Datenmodell
    aus sechs Relationen: `MESSUNG`, `EXTREMWERT`, `ANALYSE_LAUF`,
    `SCHAEDIGUNG`, `ALGORITHMUS` und `VERFAHREN`. Jede Redundanz, die
    sich über eine funktionale Abhängigkeit zwischen Attributen
    begründen ließ, ist damit beseitigt.
<!-- MUSTERLOESUNG-ENDE -->

---

### Praxisfall: bewusster Verzicht auf Normalform <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Praxisfall: bewusster Verzicht auf Normalform" }

Schaut euch `EXTREMWERT.wert` noch einmal genauer an: Dieser Wert ist
nichts anderes als `druck_ausgang − druck_eingang` an genau diesem
Zeitstempel — er lässt sich also vollständig aus `MESSUNG` berechnen.
Trotzdem wird er zusätzlich in `EXTREMWERT` gespeichert.

Diskutiert: Ist das ein Normalform-Verstoß? Ist es sinnvoll die Druckdifferenz an ausgewählten Zeitpunkten zu speichern?

<!-- MUSTERLOESUNG-START -->
!!! quote musterloesung-hervorgehoben "Lösung"
    Formal ist das **keine** 2NF- oder 3NF-Verletzung: Beide Normalformen
    prüfen funktionale Abhängigkeiten zwischen Attributen *derselben*
    Relation über deren Schlüssel — `wert` hängt korrekt vom vollen
    Schlüssel `zeitstempel` ab. Die Redundanz liegt stattdessen *zwischen*
    zwei Relationen und entsteht dadurch, dass ein Wert algorithmisch aus
    anderen, bereits gespeicherten Daten berechenbar wäre. Das ist eine
    eigene, verwandte Art von Redundanz — **abgeleitete Daten** —, die 1NF
    bis 3NF gar nicht erfassen.

    Der Grund für die bewusste Speicherung ist pragmatisch: Die
    Identifikation lokaler Extrema erfordert einen Scan über die
    gesamte, potenziell monatelange Messreihe. Das bei jedem Durchlauf
    neu zu berechnen wäre teuer — deshalb wird das Ergebnis einmalig
    materialisiert, und das `verarbeitet`-Flag verhindert, dass derselbe
    Extremwert ein zweites Mal in den Algorithmus eingeht. Eine bewusste,
    gut begründete Entwurfsentscheidung also — kein handwerklicher Fehler
    wie die vorherigen 1NF-/2NF-/3NF-Verletzungen.
<!-- MUSTERLOESUNG-ENDE -->

---

## Normalisierung anwenden { .modus-selbststudium }

### Worum geht es?

Ihr arbeitet jetzt eigenständig (einzeln oder zu zweit) an einer
gewachsenen Bestandsdatenbank aus einem echten Produktionsumfeld: Sie
ist historisch entstanden, sie funktioniert — und sie ist alles andere
als sauber entworfen. Zuerst bringt ihr sie in Ordnung, danach
erweitert ihr sie um neue Anforderungen des Kunden. Anders als bisher
geht ihr dabei **direkt ins Relationenmodell**, ohne den Umweg über ein
ER-Diagramm; euer Schema baut ihr in [drawDB](https://drawdb.app) auf.

!!! abstract "Lernziele"
    - Ihr könnt eine gewachsene, unnormalisierte Bestandstabelle
      eigenständig auf Verletzungen der ersten, zweiten und dritten
      Normalform prüfen und in ein sauberes Schema überführen.
    - Ihr könnt ein bestehendes Schema um neue Anforderungen erweitern,
      ohne dabei neue Redundanz einzubauen.
    - Ihr könnt erkennen, wenn zwei Anforderungen einander
      widersprechen, euch begründet für eine Umsetzung entscheiden und
      festhalten, welche Anforderung ihr dabei nicht vollständig
      umgesetzt habt und warum.

### Aufgabe 03: Prozessdatenbank der Schnüffel GmbH

??? info "Bezug zu Lehrinhalten"
    Normalformen und funktionale Abhängigkeiten: Praxisphase Woche 7
    sowie die Übung oben. <br>
    Schlüssel, Fremdschlüssel und
    Fremdschlüsselintegrität: Praxisphase Woche 4. <br>
    KI-Einsatz gem. [KI-Nutzungsrichtlinie](../../03-ki-erweiterungsaufgaben/ki-nutzungsrichtlinie.md):
    ab Teil B ausdrücklich erlaubt — Teil A bearbeitet ihr ohne KI.

#### Ausgangslage

> Die Schnüffel GmbH stellt Lacke zur Oberflächenveredelung her. Die
> Produktion läuft im Chargenbetrieb: Verschiedene Ausgangsstoffe
> werden in einem Reaktor nach einem vorgegebenen Rezept gemischt,
> verrührt und erhitzt. Alle relevanten Prozessparameter werden bereits
> heute alle 30 Sekunden erfasst und gespeichert.
>
> Der Betrieb hat beobachtet, dass die Produktqualität zwar immer
> innerhalb der Anforderungen liegt, dabei aber stark schwankt. Um die
> Prozessführung später gezielt optimieren zu können, sollen zusätzliche
> Daten erfasst und mit den Prozesswerten verknüpft werden.

Die vorhandene Erfassung steckt vollständig in einer einzigen Tabelle:

**:octicons-table-16: Relation `PROZESSWERT_ALT`**

| Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|
| PK | charge_nr | int | nein |
| PK | zeitstempel | datetime | nein |
| – | viskositaet | decimal | nein |
| – | temperatur | decimal | nein |
| – | fuellstand | decimal | nein |
| – | reaktor_id | string | nein |
| – | saeureresistent | boolean | nein |
| – | rezept_id | string | nein |
| – | rezept_parameter | string | nein |

Ein Ausschnitt aus den vorhandenen Daten (zwei Chargen):

| charge_nr | zeitstempel | viskositaet | temperatur | fuellstand | reaktor_id | saeureresistent | rezept_id | rezept_parameter |
|---|---|---|---|---|---|---|---|---|
| 4711 | 2026-10-12 08:00:00 | 128 | 62.4 | 78 | R-02 | ja | LAK-100 | T_soll=85;t_ruehr=120;n_ruehr=300 |
| 4711 | 2026-10-12 08:00:30 | 131 | 63.1 | 78 | R-02 | ja | LAK-100 | T_soll=85;t_ruehr=120;n_ruehr=300 |
| 4711 | 2026-10-12 08:01:00 | 135 | 64.0 | 78 | R-02 | ja | LAK-100 | T_soll=85;t_ruehr=120;n_ruehr=300 |
| 4712 | 2026-10-12 11:30:00 | 96 | 58.2 | 65 | R-05 | nein | LAK-220 | T_soll=70;t_ruehr=90;n_ruehr=250 |

---

#### Teil A — Bestand normalisieren

Plant für diesen Teil ca. 15 Minuten ein. Diesen Teil bearbeitet ihr
**ohne KI** — nach der Übung bekommt ihr das selbst hin.

1. Prüft `PROZESSWERT_ALT` der Reihe nach auf Verletzungen der ersten,
   zweiten und dritten Normalform. Schaut dabei nicht nur auf das
   Relationenschema, sondern auch auf die Beispieldaten.
2. Überführt die Tabelle in ein sauberes Schema und baut es in drawDB
   auf.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil A anzeigen"
    **Erste Normalform:** `rezept_parameter` enthält nicht einen Wert,
    sondern ein ganzes Bündel von Rezeptvorgaben (`T_soll`, `t_ruehr`,
    `n_ruehr` …) in einer einzigen Zelle — das sieht man erst an den
    Beispieldaten, nicht am Attributnamen. Der Wertebereich ist damit
    nicht atomar, die 1NF ist verletzt. Da verschiedene Rezepte
    unterschiedlich viele Vorgaben haben können, ist eine eigene
    Relation die tragfähigere Lösung als ein paar feste Einzelspalten.

    **Zweite Normalform:** `reaktor_id` und `rezept_id` hängen nur von
    `charge_nr` ab — eine Charge läuft in genau einem Reaktor nach genau
    einem Rezept, unabhängig vom einzelnen 30-Sekunden-Messpunkt. In den
    Beispieldaten sieht man das sofort: Für Charge 4711 stehen Reaktor
    und Rezept in jeder einzelnen Zeile erneut.

    **Dritte Normalform:** `saeureresistent` beschreibt nicht die
    Charge, sondern den Reaktor — es hängt nur indirekt über
    `reaktor_id` vom Schlüssel ab.

    **:octicons-table-16: Relation `PROZESSWERT`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | charge_nr | int | nein |
    | PK | zeitstempel | datetime | nein |
    | – | viskositaet | decimal | nein |
    | – | temperatur | decimal | nein |
    | – | fuellstand | decimal | nein |

    **:octicons-table-16: Relation `CHARGE`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | charge_nr | int | nein |
    | FK | reaktor_id | string | nein |
    | FK | rezept_id | string | nein |

    **:octicons-table-16: Relation `REAKTOR`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | reaktor_id | string | nein |
    | – | saeureresistent | boolean | nein |

    **:octicons-table-16: Relation `REZEPT`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | rezept_id | string | nein |

    **:octicons-table-16: Relation `REZEPT_PARAMETER`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | rezept_id | string | nein |
    | PK | parameter_name | string | nein |
    | – | wert | decimal | nein |

    `REZEPT` besteht hier nur aus seinem Schlüssel — das wirkt zunächst
    seltsam, ist aber sinnvoll: Ohne diese Relation gäbe es kein Ziel
    für den Fremdschlüssel `rezept_id` aus `CHARGE` (`rezept_id` allein
    ist in `REZEPT_PARAMETER` kein Schlüssel), und in der Praxis kämen
    dort später ohnehin weitere Attribute dazu.

    [🔗 Musterlösung Teil A in draw.io öffnen (als Kopie)](https://app.diagrams.net/?page-id=kcXyMHQK7twO6rdA3rPs#Uhttps%3A%2F%2Fchristoecker.github.io%2FKurs_3019_Datenbanken%2F02-theoriephase%2Ftermin-02%2Fcode%2Faufg-03-prozessdatenbank.drawio)
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil B — Erweiterung nach Kundenwunsch

Plant für diesen Teil ca. 10 Minuten ein. Ab hier dürft ihr KI als
Unterstützung nutzen — prüft aber jeden Vorschlag, ihr müsst ihn
erklären können.

Die Schnüffel GmbH hat dazu Folgendes zusammengestellt:

> **Ereignisdokumentation in der Leitwarte**
>
> Die Mitarbeiter in der Leitwarte sollen künftig besondere Ereignisse
> während einer Charge dokumentieren — etwa, dass eine Regelung von Hand
> übersteuert oder dass ein alternativer Einsatzstoff verwendet wurde.
> Erfasst werden sollen der Zeitpunkt, die Art des Ereignisses, ein
> Freitextkommentar und der Name des Bedieners. Jedes Ereignis soll
> später direkt neben dem zugehörigen Messwert angezeigt werden können;
> die Zuordnung erfolgt über den Prozessdatenpunkt, zu dem das Ereignis
> gehört.
>
> **Qualitätsdaten aus der Excel-Tabelle**
>
> Die Ergebnisse der Qualitätsanalyse werden bisher in einer
> Excel-Tabelle geführt und sollen nun mit den Prozessdaten verknüpft
> werden. Pro Charge werden mehrere Kennzahlen bestimmt (z. B.
> Glanzgrad, Deckvermögen, Trocknungszeit), jeweils mit gemessenem Wert,
> Einheit, Prüfverfahren und Prüfdatum.
>
> **Hinweis aus dem Betrieb**
>
> Während einer Störung bleibt in der Leitwarte keine Zeit für
> Eingaben. Ereignisse müssen deshalb auch nachträglich am Schichtende
> nachgetragen werden können — mit dem exakten Zeitpunkt (sekundengenau),
> zu dem sie tatsächlich aufgetreten sind.

1. Erweitert euer Schema aus Teil A um beide Anforderungen.
2. Prüft dabei, ob sich wirklich alle Angaben gleichzeitig umsetzen
   lassen. Falls nicht: Entscheidet euch begründet für eine Lösung und
   haltet in ein bis zwei Sätzen fest, welche Anforderung ihr nicht
   vollständig umsetzt und warum.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil B anzeigen"
    **Der Widerspruch:** Ereignisse sollen einerseits über den
    Prozessdatenpunkt zugeordnet werden (also per Fremdschlüssel auf
    einen vorhandenen Messpunkt verweisen), andererseits sekundengenau
    nachgetragen werden können. Beides zusammen geht nicht: Die
    Prozesswerte liegen nur im 30-Sekunden-Raster vor, ein Ereignis um
    08:00:17 Uhr hat dort keinen passenden Datensatz — der Fremdschlüssel
    hätte kein gültiges Ziel (Fremdschlüsselintegrität, Woche 4).

    Tragfähige Entscheidung: Das Ereignis bekommt einen **eigenen,
    exakten Zeitstempel** und wird über `charge_nr` der Charge
    zugeordnet, nicht über einen Fremdschlüssel auf `PROZESSWERT`. Die
    gewünschte Anzeige "neben dem Messwert" ist damit weiterhin möglich —
    sie wird bei der Auswertung über den Zeitbezug hergestellt (nächster
    oder umliegender Messpunkt), statt in der Tabellenstruktur
    festgeschrieben zu werden. Genau diese Abweichung von der
    ursprünglichen Anforderung gehört kurz begründet dokumentiert.

    **:octicons-table-16: Relation `EREIGNIS`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | ereignis_id | int | nein |
    | FK | charge_nr | int | nein |
    | – | zeitpunkt | datetime | nein |
    | – | ereignistyp | string | nein |
    | – | kommentar | string | ja |
    | – | bediener | string | nein |

    **Qualitätsdaten:** Hier steckt eine zweite, kleinere Falle —
    `einheit` und `pruefverfahren` gehören zur Kennzahl, nicht zur
    Charge. Stünden sie in derselben Relation wie der Messwert, wären
    sie für jede Charge erneut gespeichert (Verletzung der 2NF, weil sie
    nur von einem Teil des Schlüssels abhängen).

    **:octicons-table-16: Relation `QUALITAETSERGEBNIS`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | charge_nr | int | nein |
    | PK, FK | kennzahl | string | nein |
    | – | wert | decimal | nein |
    | – | pruefdatum | date | nein |

    **:octicons-table-16: Relation `KENNZAHL`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | kennzahl | string | nein |
    | – | einheit | string | nein |
    | – | pruefverfahren | string | nein |

    [🔗 Musterlösung Teil B in draw.io öffnen (als Kopie)](https://app.diagrams.net/?page-id=KmU5hiBMG3OvSqviw_yH#Uhttps%3A%2F%2Fchristoecker.github.io%2FKurs_3019_Datenbanken%2F02-theoriephase%2Ftermin-02%2Fcode%2Faufg-03-prozessdatenbank.drawio)
<!-- MUSTERLOESUNG-ENDE -->

<!-- NACHTRAG-START -->

---

#### Teil C — Nachtrag der Schnüffel GmbH

Plant für diesen Teil ca. 18 Minuten ein.

> Kurz nachdem eure erste Version steht, meldet sich der Kunde noch
> einmal:
>
> "Wir hatten gesagt, dass die Qualitätsschwankungen der Einsatzstoffe
> für uns außen vor bleiben. Das würden wir gerne revidieren: Zu jedem
> gelieferten Los eines Einsatzstoffs gibt es aus der
> Wareneingangskontrolle Analysewerte, zum Beispiel Feststoffgehalt,
> Dichte und Viskosität. Die würden wir jetzt doch gerne mit aufnehmen,
> damit wir sie später gegen die Prozess- und Qualitätsdaten auswerten
> können."

1. Schätzt **zuerst ohne KI** ein, was diese Ergänzung für euer Schema
   bedeutet, und haltet eure Einschätzung schriftlich fest: Welche
   Relationen kommen dazu? Genügt es, eine Tabelle anzuhängen? Ändert
   sich etwas an dem, was ihr in Teil B gebaut habt?
2. Setzt die Änderung **danach mit KI-Unterstützung** in eurem
   drawDB-Schema um.
3. Dokumentiert stichpunktartig: Was hat die KI vorgeschlagen? Was habt
   ihr unverändert übernommen? Was habt ihr angepasst oder verworfen,
   und warum?

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung Teil C anzeigen"
    **Es ist nicht "eine Tabelle mehr".** Analysewerte allein nützen
    nichts, solange nicht festgehalten ist, welches Liefer-Los in
    welcher Charge tatsächlich verarbeitet wurde — und genau diese
    Verknüpfung gibt es im bisherigen Schema überhaupt nicht. Eine
    Charge verbraucht mehrere Lose, ein Los wird über mehrere Chargen
    verbraucht: Es braucht also eine eigene Verknüpfungsrelation.

    **:octicons-table-16: Relation `EINSATZSTOFF`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | stoff_id | string | nein |
    | – | bezeichnung | string | nein |

    **:octicons-table-16: Relation `LIEFERLOS`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | los_id | string | nein |
    | FK | stoff_id | string | nein |
    | – | lieferant | string | nein |
    | – | wareneingang_datum | date | nein |

    **:octicons-table-16: Relation `WE_ANALYSEWERT`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | los_id | string | nein |
    | PK, FK | kennzahl | string | nein |
    | – | wert | decimal | nein |

    **:octicons-table-16: Relation `CHARGE_EINSATZ`**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | charge_nr | int | nein |
    | PK, FK | los_id | string | nein |
    | – | menge | decimal | nein |

    **Folge für Teil B:** Der Ereignistyp "alternativer Einsatzstoff
    verwendet" ist damit strukturell abgedeckt — welche Lose in einer
    Charge steckten, steht ab jetzt in `CHARGE_EINSATZ`. Bliebe die
    Information zusätzlich als Freitext-Ereignis bestehen, gäbe es zwei
    Quellen für dieselbe Tatsache, die auseinanderlaufen können. Also
    entweder diesen Ereignistyp streichen oder bewusst als reine
    Bedienernotiz behalten — und dann begründen, warum die Redundanz
    hier in Kauf genommen wird (vgl. Praxisfall aus der Übung).

    **Beispiel für die KI-Dokumentation:** Ein typischer Vorschlag ist,
    die Analysewerte direkt als Spalten an `LIEFERLOS` zu hängen
    (`feststoffgehalt`, `dichte`, `viskositaet`). Das ist bequem, aber
    unflexibel, sobald ein Stoff andere Kennwerte hat — hier wurde der
    Vorschlag verworfen und stattdessen `WE_ANALYSEWERT` mit
    zusammengesetztem Schlüssel gewählt. Häufig übersehen KI-Vorschläge
    außerdem die Verknüpfung `CHARGE_EINSATZ` komplett, weil sie in der
    Anforderung nicht ausdrücklich genannt ist.

    [🔗 Musterlösung Teil C in draw.io öffnen (als Kopie)](https://app.diagrams.net/?page-id=xPvhkduKNkkRyXKQXQVn#Uhttps%3A%2F%2Fchristoecker.github.io%2FKurs_3019_Datenbanken%2F02-theoriephase%2Ftermin-02%2Fcode%2Faufg-03-prozessdatenbank.drawio)

    ---

    Alle drei Teilaufgaben liegen als Tabellenblätter in **einer** Datei:

    [⬇ Gesamte .drawio-Datei mit allen Teilaufgaben herunterladen](code/aufg-03-prozessdatenbank.drawio)
<!-- MUSTERLOESUNG-ENDE -->

<!-- NACHTRAG-ENDE -->
