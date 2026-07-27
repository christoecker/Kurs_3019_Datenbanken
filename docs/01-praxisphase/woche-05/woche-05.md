---
typ: praxisphase-woche
woche: 5
thema: "Logischer Datenbankentwurf: Transformation von Entity- und Beziehungstypen in das Relationenmodell (1:N, N:M, 1:1, rekursive Beziehungen)"
workload_minuten: 120
lernziele:
  - "kann die Transformationsregeln für N:M-, 1:N- und 1:1-Beziehungstypen in eigenen Worten erklären und benennen, wie viele Relationen bei jeder Regel jeweils entstehen"
  - "kann einen gegebenen Beziehungstyp inkl. Beziehungsattributen und Kardinalitäten nach der passenden Regel in ein oder mehrere Relationenschemata überführen, inkl. korrekter Primär- und Fremdschlüssel"
  - "kann erklären, wie ein aus mehreren Attributen zusammengesetzter Schlüssel eines Entity-Typs bei Bedarf durch einen künstlichen Schlüssel (Surrogatschlüssel) ersetzt wird"
  - "kann die Besonderheit rekursiver Beziehungstypen bei der Transformation erklären, insbesondere warum dabei zwei Fremdschlüssel auf dieselbe Relation verweisen können und weshalb sie unterschiedliche Namen benötigen"
quelle_lehrbrief: "Kap. 5.1-5.2"
quelle_lehrbuch: "keine"
fallstudie: "eigene MEA-Szenarien (Maschinenpark/Wartung als Fortsetzung aus Woche 2, ergänzt um ein Mitarbeiter-Szenario) - siehe 04-fallstudien/README.md"
ki_einsatz: stufe_0_ohne
bearbeitungsstatus: entworfen
---
<!-- publish_date: 2026-08-17 -->

# Woche 5: Logischer Datenbankentwurf: Transformation von Entity- und Beziehungstypen in das Relationenmodell

> Zeitbedarf: ca. 2 Stunden.

## Worum geht es?

Letzte Woche hast du gelernt, wie ein *einzelner* Entity-Typ in ein
Relationenschema überführt wird, und das Werkzeug kennengelernt, mit
dem sich Beziehungen zwischen Relationen abbilden lassen: den
**Fremdschlüssel**. Diese Woche wird das systematisiert: Für jede Art
von Beziehungstyp — N:M, 1:N, 1:1 und rekursiv — gibt es eine eigene,
feste Transformationsregel, nach der du (fast) mechanisch vorgehen
kannst, ohne jedes Mal neu überlegen zu müssen. Genau das ist auch der
Sinn dieser Regeln: Die Schema-Transformation ist bewusst **kein
kreativer Prozess** mehr, sondern regelbasiertes Anwenden von Wissen,
das du dir diese Woche aneignest.

Außerdem lernst du eine Ergänzung zur Transformation einzelner
Entity-Typen aus Woche 4 kennen: Was passiert, wenn der Schlüssel eines
Entity-Typs aus mehreren Attributen besteht?

## Das solltest du danach können

- Du kannst erklären, warum bei einer N:M-Beziehung immer eine eigene,
  dritte Relation entsteht, bei einer 1:N- oder 1:1-Beziehung dagegen
  nicht.
- Du kannst zu einem gegebenen Beziehungstyp (inkl. Kardinalitäten und
  ggf. Beziehungsattributen) die passende Regel auswählen und korrekt
  anwenden — inkl. der Entscheidung, ob ein neu hinzugefügtes
  Fremdschlüsselattribut optional sein darf oder nicht.
- Du kannst erklären, wann ein künstlicher Schlüssel (Surrogatschlüssel)
  bei der Transformation eines Entity-Typs nötig wird und was mit dem
  ursprünglichen Schlüssel geschieht.
- Du kannst erklären, warum bei rekursiven Beziehungstypen ein
  Fremdschlüssel niemals denselben Namen tragen darf wie der Schlüssel,
  auf den er verweist.

## Erarbeitung

Lies im Lehrbrief (`Lehrbrief_relationaleDatenbanken.pdf`) die folgenden
Abschnitte der Reihe nach. Mach dir wie in den letzten Wochen Notizen in
eigenen Worten — die brauchst du für die Aufgabe unten.

**Schritt 1:** Kapitel 5, Einleitung sowie Abschnitt 5.1 "Transformation
von Entity-Typen" (S. 40-41): Regel 1 (Abbildung einfacher Entity-Typen)
— insbesondere, was passiert, wenn der Schlüssel eines Entity-Typs aus
mehreren Attributen zusammengesetzt ist (künstlicher Schlüssel /
Surrogatschlüssel).

**Schritt 2:** Abschnitt 5.2, Einleitung sowie 5.2.1 "N:M-Beziehungen"
(S. 41-43): Regel 2 (Abbildung von N:M-Beziehungstypen).

**Schritt 3:** Abschnitt 5.2.2 "1:N-Beziehungen" (S. 43-44): Regel 3
(Abbildung von 1:N-Beziehungstypen).

**Schritt 4:** Abschnitt 5.2.3 "1:1-Beziehungen" (S. 44): Regel 4
(Abbildung von 1:1-Beziehungstypen).

**Schritt 5:** Abschnitt 5.2.4 "Rekursive Beziehungen" (S. 44-45): wie
die Regeln 2-4 auf rekursive Beziehungstypen angewendet werden.

Lies **nicht** weiter in Abschnitt 5.3 ("Transformation der erweiterten
ER-Konzepte") — abhängige Entity-Typen und Spezialisierung werden erst
nächste Woche transformiert.

## Aufgabe

Zwei Relationen aus deinem MEA-Umfeld sind bereits nach der
Grundregel aus Woche 4 transformiert:

| Relation | Schlüssel | Attribut | Wertebereich | optional? |
|---|---|---|---|---|
| `MASCHINE` | PK | maschinennr | int | nein |
| `MASCHINE` | – | bezeichnung | string | nein |
| `MASCHINE` | – | standort | string | nein |
| `MITARBEITER` | PK | personalnr | int | nein |
| `MITARBEITER` | – | name | string | nein |

(`MASCHINE` kennst du bereits aus Woche 2 — dort hast du sie zusammen
mit `WARTUNGSAUFTRAG` modelliert.)

**Teil A — 1:N-Beziehung**

Aus Woche 2 kennst du bereits den Beziehungstyp `betrifft` zwischen
`MASCHINE` und `WARTUNGSAUFTRAG`: Jeder Wartungsauftrag bezieht sich auf
genau eine Maschine (verpflichtende Teilnahme), eine Maschine kann
dagegen auch ganz ohne Wartungsauftrag existieren (optionale
Teilnahme). `WARTUNGSAUFTRAG` ist bereits als Relation transformiert
(PK `auftragsnr`, dazu `datum` und `beschreibung`, beide nicht
optional).

1. Wende Regel 3 an: Erweitere `WARTUNGSAUFTRAG` um das passende
   Fremdschlüsselattribut.
2. Entscheide, ob dieses Attribut optional sein darf, und begründe
   deine Entscheidung mit den Kardinalitäten aus Woche 2.

??? tip "Musterlösung anzeigen"
    **Teil A — `WARTUNGSAUFTRAG` nach Regel 3**

    Regel 3 besagt: Die Beziehung und die Relation der N-Seite
    (`WARTUNGSAUFTRAG`) verschmelzen zu einer Relation; diese erhält den
    Schlüssel der 1-Seite (`MASCHINE`) als Fremdschlüsselattribut.

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | auftragsnr | int | nein |
    | – | datum | date | nein |
    | – | beschreibung | string | nein |
    | FK | maschinennr | int | **nein** |

    `maschinennr` darf **nicht** optional sein: Laut Woche 2 bezieht
    sich jeder Wartungsauftrag auf genau eine Maschine — die Teilnahme
    ist aus Sicht von `WARTUNGSAUFTRAG` verpflichtend (Untergrenze 1).
    Die umgekehrte Optionalität (eine Maschine muss keinen
    Wartungsauftrag haben) betrifft dagegen nur, *wie oft* eine
    bestimmte `maschinennr` in `WARTUNGSAUFTRAG` vorkommt (auch: gar
    nicht) — nicht, ob das Attribut selbst NULL sein darf.

**Teil B — N:M-Beziehung**

Zusätzlich verwaltet der Betrieb, welcher Mitarbeiter an welcher
Maschine eingewiesen wurde: Ein Mitarbeiter kann an mehreren Maschinen
eingewiesen sein, eine Maschine kann von mehreren Mitarbeitern bedient
werden (Beziehungstyp `bedient`, N:M). Zu jeder Einweisung wird
zusätzlich das Datum der Einweisung gespeichert (Beziehungsattribut
`eingewiesen_am`).

3. Wende Regel 2 an: Bilde die neue Relation, die aus `bedient`
   entsteht (wähle einen sprechenden Namen), inkl. beider
   Fremdschlüssel, ihres gemeinsamen Primärschlüssels und des
   Beziehungsattributs.

??? tip "Musterlösung anzeigen"
    **Teil B — Neue Relation `EINWEISUNG` nach Regel 2**

    Regel 2 besagt: Der Beziehungstyp wird auf eine eigene, neue
    Relation abgebildet. Die Schlüsselattribute beider beteiligten
    Entity-Typen werden als (nicht optionale) Fremdschlüssel
    aufgenommen und bilden gemeinsam den Primärschlüssel; Beziehungs-
    attribute werden zu gewöhnlichen Attributen dieser neuen Relation.

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK, FK1 | personalnr | int | nein |
    | PK, FK2 | maschinennr | int | nein |
    | – | eingewiesen_am | date | nein |

    `FK1` (`personalnr`) referenziert `MITARBEITER`, `FK2`
    (`maschinennr`) referenziert `MASCHINE`. Da `bedient` eine N:M-
    Beziehung ist, kann kein einzelnes Fremdschlüsselattribut in einer
    der beiden bestehenden Relationen genügen — ein Mitarbeiter müsste
    sonst gleichzeitig mehrere Maschinennummern speichern können (und
    umgekehrt), was ein einzelnes Attribut nicht leisten kann. Deshalb
    braucht es die eigenständige Relation `EINWEISUNG`.

**Teil C — Rekursive 1:N-Beziehung**

Zusätzlich wird für jede Maschine vermerkt, ob es eine Ersatzmaschine
gibt: Jede Maschine hat höchstens eine Ersatzmaschine, kann selbst aber
für mehrere andere Maschinen als Ersatz dienen (rekursiver
Beziehungstyp `ist_ersatz_fuer`, 1:N mit den Rollen `ersatzmaschine`
auf der 1-Seite und `ersetzte_maschine` auf der N-Seite).

4. Wende Regel 3 auf diesen rekursiven Fall an: Erweitere `MASCHINE`
   um das passende Fremdschlüsselattribut. Wähle dabei einen zulässigen
   Namen und begründe, warum dieser Name nicht `maschinennr` lauten
   darf (das kennst du bereits aus Woche 4).
5. Entscheide, ob dieses Attribut optional sein darf, und begründe.

??? tip "Musterlösung anzeigen"
    **Teil C — `MASCHINE` erweitert um rekursiven Fremdschlüssel**

    Auch der rekursive Fall folgt Regel 3: Beziehung und Relation der
    N-Seite verschmelzen — hier ist die N-Seite aber dieselbe Relation
    `MASCHINE` wie die 1-Seite. `MASCHINE` erhält also ihren *eigenen*
    Schlüssel ein zweites Mal, diesmal als Fremdschlüssel.

    | Schlüssel | Attribut | Wertebereich | optional? |
    |---|---|---|---|
    | PK | maschinennr | int | nein |
    | – | bezeichnung | string | nein |
    | – | standort | string | nein |
    | FK | ersatz_maschinennr | int | **ja** |

    Der neue Fremdschlüssel kann nicht `maschinennr` heißen, weil es in
    `MASCHINE` sonst zwei gleichnamige Attribute gäbe — dann wäre nicht
    mehr unterscheidbar, welches der eigene Primärschlüssel des
    Datensatzes ist und welches der Verweis auf die Ersatzmaschine
    (derselbe Grund, aus dem in Woche 4 `ersatz_rohstoffnr` nicht
    `rohstoffnr` heißen durfte). Ein an der Rolle orientierter Name wie
    `ersatz_maschinennr` macht zusätzlich auf einen Blick klar, wofür
    das Attribut steht.

    `ersatz_maschinennr` ist **optional**, da laut Aufgabenstellung
    nicht jede Maschine eine Ersatzmaschine hat — für Maschinen ohne
    Ersatz steht hier der NULL-Wert.

## Selbstkontrolle

### Frage 1

Erkläre, warum bei einer 1:N-Beziehung im Gegensatz zu einer N:M-
Beziehung keine eigene, dritte Relation entsteht, sondern die Beziehung
mit einer bestehenden Relation verschmilzt.

??? question "Antwort anzeigen"
    Bei einer N:M-Beziehung muss ein eigenständiges Relationenschema
    für die Beziehung angelegt werden, weil sonst nicht abgebildet
    werden könnte, dass ein Objekt der einen Seite mit *beliebig
    vielen* Objekten der anderen Seite in Beziehung stehen kann — und
    umgekehrt. Ein einzelnes Fremdschlüsselattribut kann aber immer nur
    auf *genau einen* referenzierten Datensatz verweisen, niemals auf
    mehrere gleichzeitig. Bei einer 1:N-Beziehung genügt dagegen ein
    einzelnes Fremdschlüsselattribut in der Relation der N-Seite, weil
    jedes Objekt der N-Seite zu höchstens einem Objekt der 1-Seite
    gehört — das lässt sich mit einem einzelnen Attributwert abbilden,
    eine eigene dritte Relation wäre hier unnötiger Aufwand.

### Frage 2

Erkläre, warum bei der Transformation einer 1:1-Beziehung das neu
hinzugefügte Fremdschlüsselattribut zusätzlich als Unique Key (UK)
gekennzeichnet wird, obwohl das bei der Transformation einer
1:N-Beziehung nicht der Fall ist.

??? question "Antwort anzeigen"
    Bei einer 1:1-Beziehung darf zu jedem Datensatz der referenzierten
    Relation höchstens ein Datensatz der verschmolzenen Relation
    existieren — das ist gerade die "1" auf beiden Seiten der
    Beziehung. Das lässt sich nur sicherstellen, wenn der
    Fremdschlüsselwert in der verschmolzenen Relation nicht mehrfach
    vorkommen darf, das Attribut also selbst ein Schlüsselkandidat
    (Unique Key) ist. Bei einer 1:N-Beziehung dürfen dagegen durchaus
    mehrere Datensätze der N-Seite denselben Fremdschlüsselwert (also
    dieselbe 1-Seite) referenzieren — genau das drückt die "N" aus.
    Eine Unique-Bedingung wäre hier falsch und wird deshalb nicht
    ergänzt.

### Frage 3

<quiz>
Welche Aussagen zur Transformation von Beziehungstypen in das Relationenmodell sind korrekt? (Mehrfachauswahl möglich)

- [x] Bei einer N:M-Beziehung entsteht immer eine eigenständige, dritte Relation.
- [x] Bei einer 1:N-Beziehung verschmilzt die Beziehung mit der Relation der N-Seite.
- [ ] Bei einer 1:1-Beziehung entstehen grundsätzlich drei Relationen: eine für jeden Entity-Typ und eine für die Beziehung.
  > Falsch: Bei einer 1:1-Beziehung verschmelzen die Beziehung und einer der beiden Entity-Typen zu einer gemeinsamen Relation — es entstehen also nur zwei Relationen.
- [ ] Beziehungsattribute gehen bei der Transformation verloren, da das Relationenmodell keine Attribute für Beziehungen kennt.
  > Falsch: Beziehungsattribute werden bei der Transformation zu ganz gewöhnlichen Attributen der jeweils entstehenden Relation.
</quiz>

### Frage 4

Erkläre am Beispiel des rekursiven Beziehungstyps `ist-Vorgänger-von`
zwischen Modulen (aus dem Lehrbrief, Abschnitt 5.2.4): Warum benötigt
die daraus entstehende Relation `VERLAUF` zwei Fremdschlüssel, die
beide auf dieselbe Relation `MODUL` verweisen, und warum müssen diese
zwei Fremdschlüssel unterschiedliche Namen tragen?

??? question "Antwort anzeigen"
    `ist-Vorgänger-von` ist eine N:M-Beziehung zwischen zwei Modulen
    (ein Modul kann mehrere Nachfolgemodule und mehrere Vorgänger-
    module haben). Nach Regel 2 entsteht dafür eine eigene Relation
    `VERLAUF`, deren Primärschlüssel sich aus den Schlüsselattributen
    *beider* an der Beziehung beteiligten Entity-Typen zusammensetzt —
    hier ist das aber zweimal derselbe Entity-Typ `MODUL` (die
    Beziehung ist ja rekursiv). Deshalb enthält `VERLAUF` zwei
    Fremdschlüssel, die beide `modnr` referenzieren: einen für die
    Vorgänger-Rolle, einen für die Nachfolger-Rolle. Beide könnten
    nicht denselben Namen tragen, weil `VERLAUF` sonst zwei gleichnamige
    Attribute hätte und nicht mehr unterscheidbar wäre, welcher Wert
    für die Vorgänger- und welcher für die Nachfolger-Rolle steht —
    genau wie schon bei einem einzelnen rekursiven Fremdschlüssel muss
    hier für jede Rolle ein eigener Name gewählt werden.

### Frage 5

<quiz>
Der Entity-Typ `STUDIENGANG` hat als Schlüssel die Attributkombination (`name`, `abschluss`). Welche Aussage zur Transformation dieses Entity-Typs in eine Relation ist korrekt?

- [ ] Die Kombination (`name`, `abschluss`) wird unverändert als Primärschlüssel der entstehenden Relation übernommen.
- [x] Es wird ein künstliches, meist numerisches Schlüsselattribut (Surrogatschlüssel) ergänzt und zum Primärschlüssel erklärt; die Kombination (`name`, `abschluss`) wird zum Unique Key.
- [ ] Da der Schlüssel aus zwei Attributen besteht, muss aus `STUDIENGANG` zwingend eine eigene N:M-Relation gebildet werden.
</quiz>
