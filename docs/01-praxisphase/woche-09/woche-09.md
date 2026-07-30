---
typ: praxisphase-woche
woche: 9
thema: "Transfer: eigenes Mini-Modell komplett selbst durchführen (ER-Modell -> Relationenmodell -> Normalisierung)"
workload_minuten: 120
lernziele:
  - "kann für eine neue, unbekannte Anwendungsbeschreibung eigenständig ein vollständiges ER-Modell mit mehreren Entity-Typen und Beziehungstypen erstellen (Entity-Typen, Attribute, Schlüssel, abhängiger Entity-Typ, Kardinalitäten)"
  - "kann ein selbst erstelltes ER-Modell mit mehreren Entity-Typen eigenständig nach den gelernten Regeln (u. a. Regel 3 und Regel 5) in ein vollständiges Relationenmodell überführen"
  - "kann eine selbst gebildete Relation eigenständig auf Verletzung einer Normalform prüfen und bei Bedarf zerlegen"
  - "kann konzeptuellen Entwurf, logischen Entwurf und Normalisierung an einem eigenen kleinen Beispiel durchgängig selbst durchführen, ohne dabei schrittweise angeleitet zu werden"
quelle_lehrbrief: "keine (Transfer/Anwendung von Kap. 3.4, 4, 5.1-5.3 und 5.6)"
quelle_lehrbuch: "keine"
fallstudie: "eigenes MEA-Szenario (Prüfmittelverwaltung/Kalibrierung) - siehe 04-fallstudien/README.md"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
publish_date: 2026-09-14
---

# Woche 9: Transfer — einen kleinen Datenbankentwurf komplett selbst durchführen

> Zeitbedarf: ca. 1,5-2 Stunden.

## Worum geht es?

Diese Woche gibt es **keinen neuen Stoff und keine neuen Regeln** —
stattdessen wendest du alles an, was du in den Wochen 1-7 gelernt hast,
an einem einzigen, in sich geschlossenen Beispiel: von der ersten
Modellierungsidee bis zur fertig normalisierten Relation, komplett in
eigener Verantwortung. Anders als in den Vorwochen bekommst du diesmal
**keine Relationen oder ER-Diagramme vorgegeben** — du beginnst bei
einer reinen Textbeschreibung und arbeitest dich selbst durch alle drei
Phasen:

1. **Konzeptueller Entwurf** — die Anwendungswelt als ER-Diagramm
   modellieren (Woche 2-3).
2. **Logischer Entwurf** — das ER-Diagramm nach den gelernten Regeln in
   ein Relationenmodell überführen (Woche 4-6).
3. **Normalisierung** — die entstandene Relation auf Redundanz prüfen
   und bei Bedarf zerlegen (Woche 7).

Das ist bewusst der Übergang von "ich kann eine bereits vorbereitete
Teilaufgabe lösen" zu "ich kann ein kleines Problem von Anfang bis Ende
selbst durchdringen" — genau die Fähigkeit, die in der Theoriephase
und später in der Praxis gebraucht wird.

## Das solltest du danach können

- Du kannst zu einer neuen Anwendungsbeschreibung eigenständig die
  passenden Entity-Typen, Attribute, Schlüssel und die Beziehungstypen
  inkl. Kardinalitäten bestimmen — auch wenn mehrere Entity-Typen und
  ein abhängiger Entity-Typ darunter sind.
- Du kannst dein eigenes ER-Modell ohne fremde Vorgaben in ein
  vollständiges Relationenmodell überführen.
- Du kannst eine so entstandene Relation eigenständig auf Redundanz
  und Normalform-Verletzungen untersuchen und sie bei Bedarf zerlegen.

## Aufgabe

Ein Fertigungsbetrieb lässt seine **Prüfmittel** (z. B. Messschieber,
Drehmomentschlüssel, Bügelmessschrauben) regelmäßig kalibrieren, damit
ihre Messwerte weiterhin als vertrauenswürdig gelten:

> Jedes Prüfmittel gehört zu genau einer Prüfmittelart (z. B.
> "Messschieber", "Drehmomentschlüssel"); eine Prüfmittelart kann
> mehrere Prüfmittel umfassen. Zu jeder Prüfmittelart werden eine
> eindeutige Artnummer, eine Artbezeichnung sowie das für diese Art
> vorgeschriebene Kalibrierintervall in Monaten gespeichert. Zu jedem
> einzelnen Prüfmittel werden außerdem eine eindeutige
> Prüfmittelnummer, eine Bezeichnung und ein Messbereich (z. B.
> "0-150 mm") gespeichert.
>
> Jedes Prüfmittel wird im Laufe seiner Nutzungsdauer üblicherweise
> mehrfach kalibriert. Zu jeder einzelnen Kalibrierung eines
> Prüfmittels werden eine fortlaufende Kalibriernummer (die nur
> *innerhalb* des jeweiligen Prüfmittels eindeutig ist — Prüfmittel 100
> hat z. B. die Kalibrierungen 1, 2, 3 ..., Prüfmittel 101 fängt bei
> seinen eigenen Kalibrierungen wieder bei 1 an), das Kalibrierdatum
> und das Ergebnis ("bestanden" oder "nicht bestanden") festgehalten.
> Außerdem wird zu jeder Kalibrierung vermerkt, von welchem
> Kalibrierlabor sie durchgeführt wurde: dessen Nummer, Name und
> Adresse. Eine einzelne Kalibrierung bezieht sich immer auf genau ein
> Prüfmittel und kann ohne dieses Prüfmittel nicht existieren.

**Teil A — Konzeptueller Entwurf (ER-Modell)**

Modelliere diese Anwendungswelt als ER-Diagramm: Bestimme die
Entity-Typen mit ihren Attributen und Schlüsseln (einer davon ist ein
abhängiger Entity-Typ), sowie die Beziehungstypen zwischen ihnen
inklusive Kardinalitäten. Verwende dieselbe Notation wie in den
Musterlösungen der bisherigen Wochen. Zur Bearbeitung reicht ein Stift und Papier, ein
Diagramm-Tool ist nicht nötig.

!!! note "Hinweis zum Kalibrierlabor"
    Die Angaben zum Unternehmen, das die Kalibrierung durchgeführt hat
    (Nummer, Name, Adresse), sollen dabei als Attribute *des
    Entity-Typs* `KALIBRIERUNG` modelliert werden — nicht als eigener
    Entity-Typ.

??? note "Musterlösung anzeigen"
    `KALIBRIERUNG` ist ein abhängiger Entity-Typ: Die Kalibriernummer
    ist nur innerhalb eines Prüfmittels eindeutig, und ohne das
    zugehörige Prüfmittel kann eine Kalibrierung nicht existieren.
    `PRÜFMITTELART` und `PRÜFMITTEL` sind dagegen über eine gewöhnliche
    1:N-Beziehung `gehört_zu` verbunden.

    ```mermaid
    %%{init: {'flowchart': {'padding': 5}, 'themeVariables': {'fontSize': '0.6rem'}}}%%
    graph LR
    PRUEFMITTELART["<div style='text-align:left; font-size: 0.6rem;'><b>PRÜFMITTELART</b><hr/>artnr : int (PK)<br/>artbezeichnung : string<br/>kalibrierintervall_monate : int</div>"]
    PRUEFMITTEL["<div style='text-align:left; font-size: 0.6rem;'><b>PRÜFMITTEL</b><hr/>prüfmittelnr : int (PK)<br/>bezeichnung : string<br/>messbereich : string</div>"]
    KALIBRIERUNG["<div style='text-align:left; font-size: 0.6rem; border: 3px double rgb(82, 108, 254); background: rgba(82, 108, 254, 0.1); padding: 8px;'><b>KALIBRIERUNG</b><hr/><u>kalibriernr</u> : int (lokal)<br/>datum : date<br/>ergebnis : string<br/>labornr : int<br/>laborname : string<br/>laboradresse : string</div>"]
    style KALIBRIERUNG fill:transparent,stroke:none
    gehoertzu{{gehört_zu}}
    hat{{"<u>hat</u>"}}
    PRUEFMITTELART -- "1" --- gehoertzu
    gehoertzu -- "N" --- PRUEFMITTEL
    PRUEFMITTEL -- "1" --- hat
    hat -- "N" --- KALIBRIERUNG
    ```

    (Doppelte Umrandung von `KALIBRIERUNG` sowie die unterstrichene
    identifizierende Beziehung `hat` und das unterstrichene lokale
    Attribut `kalibriernr` kennzeichnen den abhängigen Entity-Typ. Die
    Kalibrierlabor-Angaben stecken bewusst als gewöhnliche Attribute in
    `KALIBRIERUNG` — dazu mehr in Teil C.)

**Teil B — Logischer Entwurf (Relationenmodell)**

Überführe dein ER-Modell aus Teil A vollständig in ein
Relationenmodell.

??? note "Musterlösung anzeigen"
    `PRUEFMITTELART` wird nach Regel 1 transformiert. Die 1:N-Beziehung
    `gehört_zu` wird nach Regel 3 abgebildet: Sie verschmilzt mit der
    Relation der N-Seite (`PRUEFMITTEL`), die dabei den Schlüssel
    `artnr` als Fremdschlüssel erhält. `KALIBRIERUNG` schließlich wird
    nach Regel 5 (abhängiger Entity-Typ) transformiert: Ihr
    Primärschlüssel setzt sich aus dem lokalen Attribut `kalibriernr`
    und dem Fremdschlüssel `prüfmittelnr` zum identifizierenden
    Entity-Typ zusammen.

    **Relation `PRUEFMITTELART`:**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | artnr | int | nein |
    | – | artbezeichnung | string | nein |
    | – | kalibrierintervall_monate | int | nein |

    **Relation `PRUEFMITTEL`:**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | prüfmittelnr | int | nein |
    | – | bezeichnung | string | nein |
    | – | messbereich | string | nein |
    | FK | artnr | int | nein |

    **Relation `KALIBRIERUNG`:**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | prüfmittelnr | int | nein |
    | PK | kalibriernr | int | nein |
    | – | datum | date | nein |
    | – | ergebnis | string | nein |
    | – | labornr | int | nein |
    | – | laborname | string | nein |
    | – | laboradresse | string | nein |

    `artnr` ist in `PRUEFMITTEL` nicht optional, da laut
    Aufgabenstellung jedes Prüfmittel zu genau einer Prüfmittelart
    gehört.

**Teil C — Normalisierung**

Prüfe die Relation `KALIBRIERUNG` aus deiner Lösung zu Teil B auf
Verletzung der dritten Normalform. Begründe deine Analyse. Zerlege die
Relation bei Bedarf, sodass beide entstehenden Relationen die 3NF
erfüllen.

??? note "Musterlösung anzeigen"
    `laborname` und `laboradresse` hängen nicht direkt vom
    (zusammengesetzten) Schlüssel (`prüfmittelnr`, `kalibriernr`) ab,
    sondern nur *indirekt*: Name und Adresse sind Eigenschaften des
    Kalibrierlabors, nicht der einzelnen Kalibrierung — sie hängen also
    eigentlich vom Nichtschlüsselattribut `labornr` ab, und `labornr`
    wiederum hängt vom vollständigen Schlüssel ab. Das ist eine
    transitive Abhängigkeit — `KALIBRIERUNG` verletzt damit die 3NF
    (dass hier zusätzlich mehrere Kalibrierungen desselben Labors
    dessen Name und Adresse jeweils erneut speichern würden, ist genau
    die Redundanz, die dadurch entsteht).

    Zerlegung — das transitiv abhängige Attribut wird zusammen mit dem
    Attribut, von dem es abhängt, in eine neue Relation ausgelagert:

    **Relation `KALIBRIERUNG`:**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK | prüfmittelnr | int | nein |
    | PK | kalibriernr | int | nein |
    | – | datum | date | nein |
    | – | ergebnis | string | nein |
    | FK | labornr | int | nein |

    **Relation `KALIBRIERLABOR`:**

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | labornr | int | nein |
    | – | laborname | string | nein |
    | – | laboradresse | string | nein |

    Damit stehen Name und Adresse eines Kalibrierlabors nur noch einmal
    in der neuen Relation `KALIBRIERLABOR` — unabhängig davon, wie viele Kalibrierungen
    dieses Labor insgesamt durchgeführt hat.
