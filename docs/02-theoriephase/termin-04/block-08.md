---
typ: theoriephase-block
termin: 4
block_id: "08"
datum: "2026-11-17"
kurztitel: "Prozeduren und Trigger"
thema: "Prozeduren und Trigger: gespeicherte Prozeduren und Trigger lesen, ihre Wirkung vorhersagen, mit KI-Unterstützung erzeugen und prüfen, Entscheidung Logik in der Datenbank oder in der Anwendung"
lernziele:
  - "Ihr könnt erklären, was eine gespeicherte Prozedur ist, und einen Aufruf mit Parametern lesen."
  - "Ihr könnt vorhersagen, wann ein Trigger feuert und wie viele Zeilen er verarbeitet, und erklären, was die Pseudotabellen inserted und deleted enthalten."
  - "Ihr könnt einen Trigger deaktivieren, aktivieren und entfernen und seine Nebenwirkungen benennen."
  - "Ihr könnt einen von einer KI erzeugten Trigger auf typische Fehler prüfen und begründen, ob eine Regel in eine Constraint, eine Prozedur, einen Trigger oder die Anwendung gehört."
musterloesungen_sichtbar: false
fallstudie: "BestTec (Lehrbrief Anhang 9.2, S. 97–98), erweitert um die Tabellen testlauf, gehalt_log und prj_archiv"
ki_einsatz: stufe_2_pair_programmer
bearbeitungsstatus: entworfen
publish_date: 2026-11-17
quiz:
  show_progress: false
  disable_after_submit: false
---

# Prozeduren und Trigger (17.11.2026)

## Übung { .modus-uebung }

### Worum geht es?

Eben habt ihr den Zugriff auf die Daten geregelt: wer was lesen und
ändern darf. Jetzt geht es um die Frage, wo Regeln und Abläufe leben, die
mehr tun als Daten zu speichern. Zwei Mittel kennt eine Datenbank dafür:
**gespeicherte Prozeduren**, die man ausdrücklich aufruft, und
**Trigger**, die automatisch ausgelöst werden, wenn sich Daten ändern.
Wir lesen, probieren und bewerten beides an BestTec. Am Ende steht die
Frage, die in der Praxis wichtiger ist als die Syntax: Gehört eine
Regel überhaupt in die Datenbank?

!!! abstract "Lernziele"
    - Ihr könnt erklären, was eine gespeicherte Prozedur ist, und einen
      Aufruf mit Parametern lesen.
    - Ihr könnt vorhersagen, wann ein Trigger feuert und wie viele
      Zeilen er verarbeitet, und erklären, was `inserted` und
      `deleted` enthalten.
    - Ihr könnt begründen, ob eine Regel in eine Constraint, eine
      Prozedur, einen Trigger oder die Anwendung gehört.

### Ausgangslage: BestTec <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Ausgangslage: BestTec" }

Zwei neue Wünsche liegen vor. Der Prüfstand soll Testläufe nur noch über
einen festen Weg melden, der vorher prüft, ob das Projekt existiert. Und
die Personalabteilung möchte nachvollziehen können, wann welches Gehalt
von welchem Wert auf welchen anderen geändert wurde. Dafür gibt es die
neue Tabelle `gehalt_log` mit den Spalten `lognr`, `manr`, `gehalt_alt`,
`gehalt_neu`, `zeitpunkt` und `benutzer`.

Bleibt ihr direkt im Anschluss an die vorherige Einheit in derselben
Datenbank, genügt Schritt 6. Sonst stellt ihr den Ausgangszustand mit
diesen Skripten her, in dieser Reihenfolge:

1. [uebung-07-aufraeumen.sql](code/uebung-07-aufraeumen.sql)
2. [uebung-05-besttec-datenbank.sql](../termin-03/code/uebung-05-besttec-datenbank.sql)
3. [uebung-05-besttec-testdaten.sql](../termin-03/code/uebung-05-besttec-testdaten.sql)
4. [uebung-07-besttec-testlauf.sql](code/uebung-07-besttec-testlauf.sql)
5. [uebung-07-besttec-rechte-gesamt.sql](code/uebung-07-besttec-rechte-gesamt.sql)
6. [uebung-08-besttec-gehaltlog.sql](code/uebung-08-besttec-gehaltlog.sql)

---

### Eine gespeicherte Prozedur lesen und aufrufen <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Eine gespeicherte Prozedur lesen und aufrufen" }

Eine **gespeicherte Prozedur** ist ein kleines Programm, das mit Namen in
der Datenbank liegt. Man übergibt ihr Werte (Parameter), und sie führt
mehrere Schritte aus: prüfen, rechnen, ändern. Sie läuft nur, wenn
jemand sie ausdrücklich aufruft.

#### Die Prozedur anlegen

Der Prüfstand soll Testläufe über eine Prozedur melden. Welche Werte
braucht sie als Eingabe? Was soll passieren, wenn es das gemeldete
Projekt nicht gibt?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/uebung-08-prozedur.sql"
    ```

    1. `CREATE PROCEDURE` legt die Prozedur an. Die **Parameter** beginnen
       in T-SQL mit `@` und sind die Eingaben der Prozedur: das Projekt
       (`@prjnr`) und das Ergebnis (`@ergebnis`).
    2. `SET NOCOUNT ON` schaltet die Meldung „(n Zeilen betroffen)“ für
       die Anweisungen in der Prozedur ab. An den Daten ändert das nichts;
       aufrufende Programme (z. B. eine SPS) werden so nicht durch
       zusätzliche Meldungen gestört.
    3. `EXISTS` fragt nur, ob die Abfrage in den Klammern mindestens eine
       Zeile liefert. Welche Spalte sie auswählt, ist egal: `SELECT 1` ist
       ein Platzhalter (`SELECT *` ginge genauso). Findet die Datenbank das
       Projekt, hört sie sofort auf zu suchen. `NOT EXISTS` dreht die
       Frage um: Die Bedingung ist wahr, wenn es das Projekt **nicht**
       gibt.
    4. `THROW` löst einen eigenen Fehler aus und beendet die Prozedur.
       Die drei Werte sind die Fehlernummer (ab 50000 für selbst
       definierte Fehler), der Fehlertext und der Status, eine frei
       wählbare Zahl von 0 bis 255, die die Stelle im Programm
       kennzeichnet (meist 1).
    5. `testnr` und `zeitpunkt` füllt die Datenbank selbst (`IDENTITY`
       bzw. `DEFAULT`), deshalb stehen sie nicht in der Spaltenliste.

    Die Prozedur trägt den Testlauf nur ein, wenn die Prüfung besteht.

#### Die Prozedur aufrufen

Mit `EXEC` ruft man eine Prozedur auf. Was erwartet ihr bei diesen drei
Aufrufen?

```sql
EXEC p_testlauf_melden @prjnr = 232, @ergebnis = 'bestanden';
EXEC p_testlauf_melden @prjnr = 999, @ergebnis = 'bestanden';
EXEC p_testlauf_melden @prjnr = 232, @ergebnis = 'unklar';
```

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/uebung-08-prozedur-aufruf.sql"
    ```

    Der erste Aufruf trägt den Testlauf ein. Der zweite scheitert mit
    Fehler 50001 aus der Prozedur: Das Projekt 999 gibt es nicht. Beim
    dritten Aufruf prüft die Prozedur nichts, aber die Tabelle wehrt
    sich: Der `CHECK`-Constraint erlaubt nur `bestanden` und
    `fehlerhaft` (Fehler 547). Regeln der Tabelle gelten also auch für
    Änderungen über eine Prozedur.

---

### Prozedur und Rechte <span class="zeitangabe">ca. 5 Min.</span> { data-toc-label="Prozedur und Rechte" }

Der Prüfstand soll Testläufe künftig nur noch über die Prozedur melden.
Was muss sich am Rechtekonzept aus der vorherigen Einheit ändern? Und
wie prüft ihr, ob es wirkt?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/uebung-08-prozedur-rechte.sql"
    ```

    `r_pruefstand` verliert das `INSERT`-Recht auf `testlauf` und
    bekommt dafür `EXECUTE` auf die Prozedur. Ein direkter `INSERT`
    scheitert nun mit Fehler 229, der Aufruf der Prozedur funktioniert
    trotzdem: Prozedur und Tabelle gehören demselben Besitzer, deshalb
    prüft SQL Server nur das Recht auf die Prozedur — dasselbe Prinzip
    wie bei der Sicht in der vorherigen Einheit. Der Prüfstand kann
    jetzt nur noch tun, was die Prozedur zulässt, einschließlich ihrer
    Prüfung.

    Genau diese Konstruktion verwenden wir in Termin 7, wenn eine echte
    SPS Messdaten in die Datenbank schreibt: ein technischer Nutzer mit
    einer einzigen Berechtigung, nämlich `EXECUTE` auf eine Prozedur.

---

### Ein Trigger: Wann feuert er? <span class="zeitangabe">ca. 10 Min.</span> { data-toc-label="Ein Trigger: Wann feuert er?" }

Die Prozedur schützt einen Weg in die Datenbank. Aber Gehälter lassen
sich auch direkt mit einem `UPDATE` ändern, aus der Anwendung, aus SSMS
oder aus einem Skript. Damit jede Änderung protokolliert wird, egal wie
sie geschieht, braucht es etwas, das automatisch reagiert: einen
**Trigger**.

#### Den Trigger anlegen

Wie beschreibt man, dass bei jedem `UPDATE` auf `ma` etwas passieren
soll? Und woher weiß der Trigger, welche Zeilen sich geändert haben und
wie ihre alten und neuen Werte lauten?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/uebung-08-trigger.sql"
    ```

    1. `AFTER UPDATE` legt fest, wann der Trigger läuft: nach jedem
       `UPDATE` auf `ma`, **einmal pro Anweisung** und nicht einmal pro
       Zeile. Direkt nach dem Anlegen ist er aktiv, ein extra Einschalten
       ist nicht nötig.
    2. `SET NOCOUNT ON` unterdrückt die Meldung „(n Zeilen betroffen)“
       für die Anweisung im Trigger, damit sie nicht zusätzlich zur
       Meldung des auslösenden `UPDATE` erscheint.
    3. `UPDATE(gehalt)` ist wahr, wenn die Spalte `gehalt` in der
       `SET`-Klausel vorkommt, auch wenn ihr Wert gleich bleibt.
    4. `inserted` enthält die **neuen** Zustände, `deleted` die **alten**
       Zustände aller geänderten Zeilen. Beide Pseudotabellen gibt es nur
       innerhalb des Triggers.
    5. Die Verknüpfung über die Mitarbeiternummer führt alten und neuen
       Zustand derselben Zeile zusammen. Ohne sie entstünde das
       Kreuzprodukt (Fehlerbild F1).
    6. Der Vergleich behält nur Zeilen, deren Gehalt sich wirklich
       geändert hat.

    Weil der Trigger einmal pro Anweisung läuft, verarbeitet er bei einem
    `UPDATE` auf viele Zeilen alle auf einmal.

#### Die Wirkung vorhersagen

Wie viele Zeilen stehen nach jeder dieser Anweisungen in `gehalt_log`?
Leert vor jeder Anweisung das Protokoll mit `TRUNCATE TABLE gehalt_log;`.

- (a) `UPDATE ma SET gehalt = 3000 WHERE manr = 7329;` (Frohn verdient bisher 2900)
- (b) `UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;`
- (c) `UPDATE ma SET job = 'Entwickler' WHERE manr = 7329;`
- (d) `UPDATE ma SET gehalt = gehalt WHERE abtnr = 20;`
- (e) `UPDATE ma SET gehalt = 0 WHERE abtnr = 99;` (diese Abteilung gibt es nicht)

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/uebung-08-trigger-test.sql"
    ```

    | Anweisung | Logzeilen | Begründung |
    |---|---|---|
    | (a) | 1 | Eine Zeile geändert, das Gehalt ist anders. |
    | (b) | 6 | **Ein** Trigger-Lauf für **sechs** Zeilen: `inserted` und `deleted` enthalten alle Mitarbeiter der Abteilung 20. |
    | (c) | 0 | `gehalt` kommt in `SET` nicht vor, `UPDATE(gehalt)` ist falsch. |
    | (d) | 0 | `UPDATE(gehalt)` ist wahr, aber alter und neuer Wert sind gleich; der Vergleich filtert alle Zeilen heraus. |
    | (e) | 0 | Der Trigger läuft trotzdem (`AFTER UPDATE`), aber `inserted` ist leer. |

    Ein `DELETE` oder `INSERT` auf `ma` löst diesen Trigger nicht aus,
    denn er ist nur für `UPDATE` angelegt. Genau darüber stolpern Trigger,
    die von KI erzeugt wurden: Sie feuern zu oft, zu selten oder
    verarbeiten nur eine Zeile (Fehlerbild F16 und F18).

---

### Trigger verwalten und Nebenwirkungen <span class="zeitangabe">ca. 6 Min.</span> { data-toc-label="Trigger verwalten und Nebenwirkungen" }

Ein zweiter Trigger soll Gehaltssenkungen verbieten. Was passiert, wenn
ein `UPDATE` sechs Gehälter senkt und der Trigger eingreift? Was
geschieht mit dem Protokoll des ersten Triggers? Und wie schaltet man
einen Trigger ab und wieder an?

??? quote musterloesung-hervorgehoben "Lösung"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/uebung-08-trigger-senkung.sql"
    ```

    1. `EXISTS` fragt, ob es mindestens eine Zeile gibt, deren neues
       Gehalt kleiner ist als das alte. Das `SELECT 1` ist nur ein
       Platzhalter (siehe Prozedur oben).
    2. `THROW` im Trigger bricht die **ganze** `UPDATE`-Anweisung ab, und
       alle Änderungen werden zurückgenommen.

    Kein Gehalt ändert sich, und im Protokoll bleibt nichts zurück. Der
    Grund: Das `UPDATE` und alle Trigger, die es auslöst, laufen in
    **einer Transaktion**. Bricht ein Trigger mit einem Fehler ab, wird
    alles zurückgenommen, auch das, was ein anderer Trigger schon
    geschrieben hat. Nur wenn alle Trigger durchlaufen, bleiben die
    Änderungen bestehen. Steht das `UPDATE` selbst in einer
    `BEGIN TRANSACTION`-Klammer, wird sogar diese ganze Transaktion
    zurückgenommen. Das ist eine wichtige Nebenwirkung: Ein Fehler im
    Trigger lässt den Datenzugriff scheitern, der ihn ausgelöst hat.

    Verwalten:

    - `DISABLE TRIGGER … ON …` schaltet einen Trigger ab, er bleibt
      aber bestehen.
    - `ENABLE TRIGGER … ON …` schaltet ihn wieder ein.
    - `DROP TRIGGER …` entfernt ihn ganz.
    - `sys.triggers` zeigt alle Trigger und ihren Zustand
      (`is_disabled`).

    Weitere Nebenwirkungen: Ein Trigger läuft unsichtbar mit. Wer nur
    den `UPDATE` sieht, ahnt nicht, dass ein zweiter Schreibvorgang
    stattfindet. Bei großen Änderungen kostet er Zeit. Er darf in
    Tabellen schreiben, auf die der auslösende Benutzer kein Recht hat.
    Und hängen mehrere Trigger an derselben Tabelle, ist ihre
    Reihenfolge nicht festgelegt; sie sollten deshalb nicht voneinander
    abhängen.

---

### Wohin mit der Logik? <span class="zeitangabe">ca. 7 Min.</span> { data-toc-label="Wohin mit der Logik?" }

Prüfregeln, Abläufe und Protokolle können an vier Orten leben. Jeder
passt zu einer anderen Art von Anforderung:

- **Constraint** — wenn die Regel nur Werte betrifft: ein erlaubter
  Wertebereich, eine Liste erlaubter Werte, Eindeutigkeit, ein
  Fremdschlüssel. Das ist die erste Wahl, denn eine Constraint ist
  einfach, schnell und gilt automatisch für jeden Zugriffsweg, ganz ohne
  Programmcode.
- **Prozedur** — wenn es einen festen Weg geben soll, der mehrere
  Schritte zusammenfasst (erst prüfen, dann eintragen) und den man gezielt
  freigeben möchte, z. B. für ein Gerät, das nicht direkt auf die Tabellen
  zugreifen soll. Eine Prozedur wirkt aber nur, wenn sie aufgerufen wird;
  wer Tabellenrechte hat, kann sie umgehen.
- **Trigger** — wenn bei jeder Änderung automatisch etwas geschehen muss,
  egal wer sie wie ausführt, und eine Constraint dafür nicht reicht:
  typisch sind Protokollieren und Archivieren. Der Preis: Ein Trigger
  läuft unsichtbar mit, hat Nebenwirkungen und ist schwerer zu testen.
  Man setzt ihn deshalb nur ein, wenn nichts Einfacheres genügt.
- **Anwendung** — wenn die Aufgabe nicht zur Datenhaltung gehört:
  Darstellung, Berechnungen für eine Oberfläche, Aktionen außerhalb der
  Datenbank wie E-Mails oder andere Systeme. Gilt die Regel nur für diese
  eine Anwendung, kann sie auch dort leben.

Ordnet diese Anforderungen zu und begründet die Wahl. Denkt an
Konsistenz (gilt die Regel für jeden Zugriffsweg?), Wartbarkeit und
Testbarkeit.

| Anforderung | Wohin? |
|---|---|
| 1. Ein Gehalt darf nie negativ sein. | |
| 2. Jede Änderung eines Gehalts soll nachvollziehbar sein, egal wer sie wie ausführt. | |
| 3. Der Prüfstand soll Testläufe nur über einen festen Weg melden, der das Projekt prüft. | |
| 4. Gehälter sollen in der Oberfläche als „4.800,00 €“ angezeigt werden. | |
| 5. Bei einem fehlerhaften Testlauf soll der Projektleiter eine E-Mail bekommen. | |

??? quote musterloesung-hervorgehoben "Lösung"
    | Anforderung | Wohin? | Begründung |
    |---|---|---|
    | 1. Gehalt nie negativ | **Constraint** (`CHECK (gehalt > 0)`) | Einfache Wertregel, gilt für jeden Zugriffsweg, deklarativ und schnell. |
    | 2. Gehaltsänderungen nachvollziehbar | **Trigger** | Muss für jeden Zugriffsweg gelten (Anwendung, SSMS, Skript) und darf nicht von einer Anwendung vergessen werden. |
    | 3. Fester Weg für Testläufe | **Prozedur** mit `EXECUTE`-Recht | Ein definierter Einstieg mit zentraler Prüfung; der Prüfstand braucht kein Tabellenrecht. |
    | 4. Anzeige als „4.800,00 €“ | **Anwendung** | Reine Darstellung, gehört nicht in die Datenbank. |
    | 5. E-Mail bei fehlerhaftem Testlauf | **Anwendung** (oder ein Dienst) | Eine Aktion außerhalb der Datenbank. Im Trigger würde sie jede Meldung verlangsamen, und ein Mailfehler ließe die Meldung scheitern. |

---

### Gesamtergebnis <span class="zeitangabe">ca. 2 Min.</span> { data-toc-label="Gesamtergebnis" }

??? quote musterloesung-hervorgehoben "Lösung"
    | Mittel | Wann es greift | Gut für | Worauf achten |
    |---|---|---|---|
    | **Constraint** | bei jeder Änderung, automatisch | einfache Wertregeln (`CHECK`, `UNIQUE`, Fremdschlüssel) | kann nichts protokollieren oder berechnen |
    | **Prozedur** | nur wenn sie aufgerufen wird | ein fester Weg mit Prüfung, Rechte über `EXECUTE` | wird umgangen, wenn Tabellenrechte offen sind |
    | **Trigger** | automatisch bei `INSERT`, `UPDATE` oder `DELETE` | Regeln und Protokolle für jeden Zugriffsweg | unsichtbar; läuft einmal pro Anweisung für alle Zeilen; ein Fehler macht die Änderung rückgängig |
    | **Anwendung** | im Programm | Darstellung, Berechnung, externe Aktionen | Regeln gelten nicht für andere Zugriffswege |

    Als Faustregel gilt: Was für jeden Zugriffsweg gelten muss, gehört in
    die Datenbank, und zwar so einfach wie möglich (erst Constraint, dann
    Trigger oder Prozedur). Alles andere gehört in die Anwendung.

    In SQL Server feuern Trigger **einmal pro Anweisung** und nicht pro
    Zeile; alte und neue Werte stehen in `deleted` und `inserted`. Andere
    Datenbanksysteme arbeiten zeilenweise mit `BEFORE`, `OLD` und `NEW`
    (siehe [SQL Server und Lehrbuch/Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md)).
    Neben `AFTER` kennt SQL Server auch `INSTEAD OF`, ein Trigger, der
    die auslösende Anweisung ersetzt; den brauchen wir hier nicht.

---

## Betreutes Selbststudium { .modus-selbststudium }

### Worum geht es?

Trigger sind mächtig und gefährlich zugleich: Sie laufen unsichtbar
mit, und kleine Fehler fallen oft erst bei Massenänderungen auf. Ihr
müsst keinen Trigger selbst von Grund auf schreiben. Wichtiger ist, dass
ihr einen Trigger lesen, seine Wirkung vorhersagen und einen Vorschlag
der KI beurteilen könnt: Feuert er zur richtigen Zeit? Verarbeitet er
alle betroffenen Zeilen? Passt die Syntax zu SQL Server? Dazu kommt die
Entscheidung, ob eine Regel überhaupt in die Datenbank gehört.

!!! abstract "Lernziele"
    - Ihr könnt die Wirkung eines Triggers auf verschiedene Anweisungen
      vorhersagen.
    - Ihr könnt einen Trigger mit KI-Unterstützung erzeugen, ihn
      erklären, aktivieren und deaktivieren.
    - Ihr könnt fehlerhafte Trigger an typischen Merkmalen erkennen.
    - Ihr könnt begründen, ob eine Anforderung in die Datenbank oder in
      die Anwendung gehört.

### Aufgabe 08: Trigger prüfen, mit KI erzeugen und einordnen

??? info "Bezug zu Lehrinhalten"
    Die Übung oben und Lehrbuch (Kleuker), Kapitel 12 (Stored Procedures und
    Trigger). <br>
    SQL-Server-Besonderheiten: [SQL Server und Lehrbuch/Lehrbrief: Abweichungen](../../info/sql-server-vs-lehrbrief.md). <br>
    Typische Fehlerbilder: [Fehlerbildkatalog](../../info/fehlerbildkatalog.md) (F16–F18). <br>
    KI-Einsatz gem. [KI-Nutzungsrichtlinie](../../03-ki-erweiterungsaufgaben/ki-nutzungsrichtlinie.md)
    (Stufe 2, KI als Pair Programmer): KI darf aktiv helfen, ihr müsst
    jeden Vorschlag aber erklären und prüfen können.

Alle Aufgaben beziehen sich auf BestTec. Stellt den Ausgangszustand mit
diesen Skripten her, in dieser Reihenfolge:
[uebung-05-besttec-datenbank.sql](../termin-03/code/uebung-05-besttec-datenbank.sql),
[uebung-05-besttec-testdaten.sql](../termin-03/code/uebung-05-besttec-testdaten.sql),
[uebung-07-besttec-testlauf.sql](code/uebung-07-besttec-testlauf.sql),
[uebung-08-besttec-gehaltlog.sql](code/uebung-08-besttec-gehaltlog.sql) und
für Teil B zusätzlich
[aufg-08-besttec-archiv.sql](code/aufg-08-besttec-archiv.sql).

#### Teil A — Die Wirkung eines Triggers vorhersagen <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Teil A — Die Wirkung eines Triggers vorhersagen" }

Ein Kollege hat diesen Trigger geschrieben, um alle Gehaltsänderungen zu
protokollieren. Legt ihn an (den Trigger aus der Übung entfernt ihr
vorher mit `DROP TRIGGER IF EXISTS tr_ma_gehalt;`):

```sql
CREATE TRIGGER tr_ma_gehalt_v2
ON ma
AFTER UPDATE
AS
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    SELECT i.manr, d.gehalt, i.gehalt
    FROM inserted i, deleted d
    WHERE i.manr = d.manr;
END;
```

Sagt für jede Anweisung vorher, wie viele Zeilen danach in `gehalt_log`
stehen, und kontrolliert es. Leert vor jeder Anweisung das Protokoll mit
`TRUNCATE TABLE gehalt_log;`.

1\. `UPDATE ma SET job = 'Entwickler' WHERE manr = 7329;`

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.1 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-a.sql:a1"
    ```

    **1 Zeile**, obwohl sich das Gehalt gar nicht geändert hat
    (`gehalt_alt` = `gehalt_neu` = 2900). Der Trigger hat weder
    `IF UPDATE(gehalt)` noch einen Vergleich, er protokolliert jede
    geänderte Zeile, egal welche Spalte betroffen ist (Fehlerbild F18).
<!-- MUSTERLOESUNG-ENDE -->

2\. `UPDATE ma SET gehalt = gehalt * 1.02 WHERE abtnr = 20;`

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.2 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-a.sql:a2"
    ```

    **6 Zeilen.** Der Trigger läuft einmal, aber `inserted` und `deleted`
    enthalten alle sechs Mitarbeiter der Abteilung 20, und der Verbund
    über `manr` bildet sechs Paare.
<!-- MUSTERLOESUNG-ENDE -->

3\. `UPDATE ma SET prov = 100 WHERE job = 'Vertrieb';`

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.3 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-a.sql:a3"
    ```

    **3 Zeilen** (Kurt, Schulte, Langer), alle mit unverändertem
    Gehalt. Auch hier hat der Trigger nur die geänderte Zeile gesehen,
    nicht die geänderte Spalte (Fehlerbild F18).
<!-- MUSTERLOESUNG-ENDE -->

4\. `DELETE FROM ma WHERE manr = 8800;`

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.4 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-a.sql:a4"
    ```

    **0 Zeilen.** Der Trigger ist nur für `UPDATE` angelegt. Ein
    `DELETE` löst ihn nicht aus.
<!-- MUSTERLOESUNG-ENDE -->

5\. Erfüllt der Trigger die Anforderung „jede Gehaltsänderung
protokollieren“? Was ändert ihr? Vergleicht ihn mit dem Trigger aus der
Übung.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung A.5 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-a.sql:a5"
    ```

    Nein, nicht gut. Der Trigger protokolliert auch Änderungen, bei denen
    sich das Gehalt nicht geändert hat (A.1 und A.3). Das Protokoll
    füllt sich mit Einträgen, die nichts aussagen. Verbessert wird er wie
    in der Übung: `IF UPDATE(gehalt)` prüft, ob die Spalte in `SET`
    vorkommt, und `i.gehalt <> d.gehalt` behält nur Zeilen mit
    tatsächlich geändertem Wert.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil B — Einen Trigger mit KI erzeugen und verstehen <span class="zeitangabe">ca. 14 Min.</span> { data-toc-label="Teil B — Einen Trigger mit KI erzeugen und verstehen" }

Gelöschte Projekte sollen nicht verloren gehen. Beim Löschen eines
Projekts aus `prj` soll jede gelöschte Zeile samt Zeitpunkt und Benutzer
in der Tabelle `prj_archiv` gesichert werden. Die Tabelle hat die
Spalten `lfdnr`, `prjnr`, `abtnr`, `kdnr`, `titel`, `geloescht_am` und
`geloescht_von`.

1\. Formuliert einen Prompt, mit dem die KI einen passenden Trigger
erzeugt. Gebt Schema, Dialekt und Anforderung an.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.1 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-b.sql:b1"
    ```

    Wichtig sind das Schema beider Tabellen (`CREATE TABLE`), der
    Dialekt „Microsoft SQL Server (T-SQL)“ und die genaue Anforderung.
    Ob die KI auch den Fall „mehrere Projekte in einem `DELETE`“
    berücksichtigt, gehört zum Prüfen in B.2.
<!-- MUSTERLOESUNG-ENDE -->

2\. Legt den Trigger der KI an und löscht mit
`DELETE FROM prj WHERE prjnr IN (212, 256);` zwei Projekte auf einmal.
Kontrolle: Danach stehen **2 Zeilen** in `prj_archiv`.

| Prüfpunkt | Eure Notiz |
|---|---|
| Stimmt die Zeilenzahl in `prj_archiv`? | |
| Hat die KI die Pseudotabelle `deleted` verwendet, und verarbeitet der Trigger alle Zeilen, nicht nur eine? | |
| Ist es ein Trigger für SQL Server (`AFTER DELETE`), oder steckt Syntax eines anderen Systems drin (`BEFORE`, `FOR EACH ROW`, `OLD`)? | |
| Was habt ihr am Vorschlag der KI geändert oder verworfen? | |

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.2 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-b.sql:b2"
    ```

    Der Trigger ist ein `AFTER DELETE`. Bei einem `DELETE` enthält
    `deleted` die gelöschten Zeilen, `inserted` ist leer. Weil alle
    Zeilen auf einmal gesichert werden, entstehen beim Löschen von zwei
    Projekten zwei Archivzeilen.

    Achtet darauf, dass folgende Fehler nicht passieren:

    - Der Trigger nimmt nur eine Zeile an (`SELECT @prjnr = prjnr FROM
      deleted`) und sichert bei mehreren gelöschten Projekten nur eines
      (Fehlerbild F16).
    - Syntax eines anderen Systems: `BEFORE DELETE`, `FOR EACH ROW`,
      `OLD.prjnr` (Fehlerbild F17).
    - Der Trigger ist für `UPDATE` oder `INSERT` statt für `DELETE`
      angelegt (Fehlerbild F18).
<!-- MUSTERLOESUNG-ENDE -->

3\. Erklärt in eigenen Worten: Wann läuft der Trigger? Was enthalten
`deleted` und `inserted` bei einem `DELETE`? Was passiert, wenn ihr das
Projekt 232 löschen wollt, zu dem es Testläufe gibt?

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.3 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-b.sql:b3"
    ```

    Der Trigger läuft einmal nach jedem `DELETE` auf `prj`. In `deleted`
    stehen die gelöschten Zeilen, `inserted` ist leer. Das Projekt 232
    lässt sich nicht löschen: Der Fremdschlüssel `fk_testlauf_prj`
    lehnt den `DELETE` ab (Fehler 547). Weil ein `AFTER`-Trigger erst
    nach der erfolgreichen Änderung läuft, wird er gar nicht
    ausgelöst, und `prj_archiv` bleibt unverändert.
<!-- MUSTERLOESUNG-ENDE -->

4\. Legt zwei Testprojekte an:
`INSERT INTO prj (prjnr, abtnr, kdnr, titel) VALUES (500, 10, 'T56', 'Testprojekt');`
und dasselbe mit der Nummer 501 und dem Titel „Testprojekt 2“. Schaltet
den Trigger ab, löscht das Projekt 500, schaltet den Trigger wieder ein
und löscht das Projekt 501. Wie viele Zeilen stehen jeweils in
`prj_archiv`? Wie könnt ihr prüfen, ob ein Trigger aktiv ist?

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung B.4 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-b.sql:b4"
    ```

    Mit `DISABLE TRIGGER` bleibt der Trigger bestehen, läuft aber nicht:
    Das Projekt 500 wird gelöscht, ohne archiviert zu werden (weiterhin
    2 Archivzeilen). Nach `ENABLE TRIGGER` wird das Projekt 501
    archiviert (3 Zeilen). `sys.triggers` zeigt mit `is_disabled`, ob
    ein Trigger aktiv ist (0 = aktiv). Wer einen Trigger abschaltet,
    muss sich merken, ihn wieder einzuschalten: Sonst fehlt das
    Protokoll, ohne dass es jemand merkt.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil C — Fehlerhafte Trigger erkennen <span class="zeitangabe">ca. 11 Min.</span> { data-toc-label="Teil C — Fehlerhafte Trigger erkennen" }

Vier Trigger sollen „jede Gehaltsänderung protokollieren“. Drei davon
enthalten typische Fehler, einer ist korrekt. Entfernt vorher alle
früheren Trigger auf `ma`:

```sql
DROP TRIGGER IF EXISTS tr_ma_gehalt;
DROP TRIGGER IF EXISTS tr_ma_gehalt_v2;
DROP TRIGGER IF EXISTS tr_ma_gehalt_v3;
```

Prüft jeden Trigger mit diesem Test (6 Mitarbeiter der Abteilung 20,
also **6 Logzeilen** erwartet) und löscht ihn danach wieder:

```sql
TRUNCATE TABLE gehalt_log;
UPDATE ma SET gehalt = gehalt * 1.05 WHERE abtnr = 20;
SELECT manr, gehalt_alt, gehalt_neu FROM gehalt_log;
```

Sagt vorher, was jeder Trigger liefert, was falsch ist und welches
Fehlerbild vorliegt ([Fehlerbildkatalog](../../info/fehlerbildkatalog.md)).

1\. Trigger C.1

```sql
CREATE TRIGGER tr_ma_gehalt_c1
ON ma
AFTER UPDATE
AS
BEGIN
    DECLARE @manr NUMERIC(4), @alt NUMERIC(9,2), @neu NUMERIC(9,2);
    SELECT @manr = manr, @neu = gehalt FROM inserted;
    SELECT @alt = gehalt FROM deleted;
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    VALUES (@manr, @alt, @neu);
END;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung C.1 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-c.sql:c1"
    ```

    **Fehlerhaft** (Fehlerbild F16): Der Trigger geht von genau einer
    Zeile aus. Mit Variablen liest er aus `inserted` und `deleted` nur
    eine einzige Zeile. Es entsteht **1 Logzeile statt 6**, und welche
    es ist, ist nicht festgelegt. Bei Einzelzeilenänderungen fällt das
    nie auf. Korrektur: `INSERT … SELECT` über `inserted` und `deleted`
    ohne Variablen.
<!-- MUSTERLOESUNG-ENDE -->

2\. Trigger C.2

```sql
CREATE TRIGGER tr_ma_gehalt_c2
BEFORE UPDATE ON ma
FOR EACH ROW
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    VALUES (OLD.manr, OLD.gehalt, NEW.gehalt);
END;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung C.2 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-c.sql:c2"
    ```

    **Fehlerhaft** (Fehlerbild F17): Das ist die Schreibweise eines
    anderen Datenbanksystems. `BEFORE`, `FOR EACH ROW` sowie `OLD` und
    `NEW` gibt es in SQL Server nicht, das Anlegen scheitert mit einem
    Syntaxfehler. Korrektur: `AFTER UPDATE`, ohne `FOR EACH ROW`, und
    `inserted`/`deleted` statt `OLD`/`NEW`.
<!-- MUSTERLOESUNG-ENDE -->

3\. Trigger C.3

```sql
CREATE TRIGGER tr_ma_gehalt_c3
ON ma
AFTER UPDATE
AS
BEGIN
    INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
    SELECT i.manr, d.gehalt, i.gehalt
    FROM inserted i, deleted d;
END;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung C.3 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-c.sql:c3"
    ```

    **Fehlerhaft** (Fehlerbild F1): Die Verknüpfung zwischen `inserted`
    und `deleted` fehlt. Es entsteht das Kreuzprodukt: **36 Zeilen**
    (6 × 6), von denen 30 falsche Paare aus altem und neuem Gehalt
    verschiedener Mitarbeiter sind. Korrektur: `WHERE i.manr = d.manr`.
<!-- MUSTERLOESUNG-ENDE -->

4\. Trigger C.4

```sql
CREATE TRIGGER tr_ma_gehalt_c4
ON ma
AFTER UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    IF UPDATE(gehalt)
        INSERT INTO gehalt_log (manr, gehalt_alt, gehalt_neu)
        SELECT i.manr, d.gehalt, i.gehalt
        FROM inserted i, deleted d
        WHERE i.manr = d.manr
          AND i.gehalt <> d.gehalt;
END;
```

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung C.4 anzeigen"
    ```sql
    --8<-- "02-theoriephase/termin-04/code/aufg-08-besttec-teil-c.sql:c4"
    ```

    **Korrekt.** `inserted` und `deleted` sind über `manr` verknüpft,
    `IF UPDATE(gehalt)` und der Vergleich sorgen dafür, dass nur echte
    Gehaltsänderungen protokolliert werden. Ergebnis: **6 Zeilen**.
<!-- MUSTERLOESUNG-ENDE -->

---

#### Teil D — Datenbank oder Anwendung? <span class="zeitangabe">ca. 8 Min.</span> { data-toc-label="Teil D — Datenbank oder Anwendung?" }

Ordnet jede Anforderung einem der vier Orte zu — Constraint, Prozedur,
Trigger oder Anwendung — und begründet die Wahl in ein bis zwei Sätzen.
Achtet auf Konsistenz, Wartbarkeit und Testbarkeit.

1\. Die SPS speichert Testergebnisse zwischen, wenn die Verbindung zur
Datenbank ausfällt, und überträgt sie später.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.1 anzeigen"
    **Anwendung** (hier: das SPS-Programm). Ist die Datenbank nicht
    erreichbar, kann sie selbst nichts tun: Weder Prozedur noch Trigger
    laufen. Die Pufferung muss dort stattfinden, wo die Daten
    entstehen. Das greifen wir in Termin 7 wieder auf.
<!-- MUSTERLOESUNG-ENDE -->

2\. Bei einem fehlerhaften Testlauf soll der Projektleiter automatisch
eine E-Mail bekommen.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.2 anzeigen"
    **Anwendung** oder ein eigener Dienst, der neue Zeilen abfragt.
    Ein Trigger sollte nur Datenbankinternes tun: Ein Mailversand würde
    jede Meldung des Prüfstands verlangsamen, und scheitert die Mail,
    scheitert auch die Meldung.
<!-- MUSTERLOESUNG-ENDE -->

3\. Das Ergebnis eines Testlaufs darf nur `bestanden` oder `fehlerhaft`
lauten.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.3 anzeigen"
    **Constraint** (`CHECK`). Die Regel gilt für jeden Zugriffsweg,
    ist einfach, schnell und ohne Programmcode. In `testlauf` ist sie
    bereits als `ck_testlauf_ergebnis` angelegt.
<!-- MUSTERLOESUNG-ENDE -->

4\. Jedes gelöschte Projekt soll mit Zeitpunkt und Benutzer gesichert
werden, egal wer es wie löscht.

<!-- MUSTERLOESUNG-START -->
???+ note "Musterlösung D.4 anzeigen"
    **Trigger** (`AFTER DELETE`, wie in Teil B). Die Sicherung muss
    für jeden Zugriffsweg gelten, auch für ein Skript oder SSMS. Eine
    Anwendung könnte sie umgehen oder vergessen.
<!-- MUSTERLOESUNG-ENDE -->
