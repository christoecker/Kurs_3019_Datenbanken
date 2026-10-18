# Fehlerbildkatalog für SQL-Abfragen

Viele fehlerhafte Abfragen — egal ob von Hand oder von einer KI
geschrieben — laufen ohne Fehlermeldung durch und liefern trotzdem ein
falsches Ergebnis. Hier findet ihr einige typische **Fehlerbilder**,
damit ihr sie bei fremden Statements schnell erkennt. Alle Beispiele
stammen aus der Datenbank **BestTec**. 

## F1 — Verknüpfungsbedingung fehlt

**Symptom:** Das Ergebnis hat viel zu viele Zeilen, in denen
Datensätze zusammengehören, die nichts miteinander zu tun haben.

**Ursache:** Mehrere Tabellen stehen im `FROM`, aber im `WHERE` fehlt die
Gleichheit von Schlüssel und Fremdschlüssel. Die Datenbank bildet dann
alle Kombinationen (Kreuzprodukt).

**So erkennt ihr es:** Zählt die Tabellen im `FROM` und die
Verknüpfungsbedingungen im `WHERE` bzw. `ON`. Bei *n* Tabellen braucht
ihr mindestens *n − 1* Bedingungen. Die Zeilenzahl liegt nahe am Produkt
der Tabellengrößen (ABT × PRJ = 20, MA × ABT = 100).

## F2 — Duplikate durch den Verbund

**Symptom:** Dieselbe Zeile erscheint mehrfach.

**Ursache:** Zu einer Zeile gibt es mehrere Partner in der verbundenen
Tabelle, und die Auswahlliste enthält keine Spalte, die sie
unterscheidet. Beispiel: Abteilung 20 hat vier Mitarbeiter mit Job
Engineer oder Programmierer, deshalb erscheint jedes ihrer drei
Projekte viermal (12 statt 3 Zeilen).

**So erkennt ihr es:** Fragt euch, wie viele Partner jede Zeile haben
kann. Soll jede Zeile nur einmal erscheinen, hilft `DISTINCT` — aber nur,
wenn die Duplikate tatsächlich unerwünscht sind.

## F3 — `AND` und `OR` ohne Klammern

**Symptom:** Es erscheinen Zeilen, die eine Einschränkung eigentlich
ausschließen sollte.

**Ursache:** `AND` bindet stärker als `OR`. Die Bedingung
`abtnr IN (10, 20) AND job = 'Manager' OR gehalt > 5000` bedeutet
„(Abteilung 10/20 **und** Manager) **oder** Gehalt über 5000“ und liefert
6 statt 4 Zeilen.

**So erkennt ihr es:** Steht ein `OR` neben einem `AND`, setzt gedanklich
Klammern um jedes `AND`-Paar und prüft, ob das der Anforderung
entspricht.

## F4 — Falscher Vergleich oder falsche Negation

**Symptom:** Das Ergebnis enthält genau die Zeilen, die ausgeschlossen
sein sollten, oder umgekehrt.

**Ursache:** `=` statt `<>`, `>` statt `>=`, `IN` statt `NOT IN`, oder
`LIKE` mit einem Muster, das mehr oder weniger Zeilen trifft als
gedacht.

**So erkennt ihr es:** Lest jede Bedingung laut in Worten und gleicht
sie mit der Anforderung ab. Prüft Randwerte (liegt 2800 noch im
Bereich?).

## F5 — Widersprüchliche Bedingung

**Symptom:** Das Ergebnis ist leer, obwohl es passende Daten gibt.

**Ursache:** Zwei Bedingungen, die nie gleichzeitig wahr sein können,
sind mit `AND` verbunden, z. B. `sitz = 'Verl' AND sitz = 'Paderborn'`.
Gemeint war `OR` bzw. `IN`.

**So erkennt ihr es:** Ein leeres Ergebnis ist nicht immer ein Fehler
(niemand verdient mehr als sein Vorgesetzter) — prüft aber, ob die
Bedingung für eine einzelne Zeile überhaupt erfüllbar ist.

## F6 — `WHERE` statt `HAVING`

**Symptom:** Gruppenwerte (Durchschnitt, Summe, Anzahl) sind zu hoch oder
zu niedrig, oder es erscheinen Gruppen, die es nicht geben dürfte.

**Ursache:** Eine Bedingung, die sich auf die **ganze Gruppe** bezieht
(z. B. Durchschnitt über 4000), steht im `WHERE`-Teil. `WHERE` wirkt
aber auf einzelne Zeilen **vor** der Gruppierung. Aus dem Durchschnitt aller Mitarbeiter wird der Durchschnitt
der gut Verdienenden: Die Zentrale kommt auf 6500 statt 5100.

**So erkennt ihr es:** Fragt euch, ob die Bedingung eine einzelne Zeile
oder eine ganze Gruppe beschreibt. Gruppenbedingungen mit Gruppenfunktionen
gehören in `HAVING`.

## F7 — Falsche Aggregationsebene

**Symptom:** Gezählte oder summierte Werte sind ein Vielfaches des
erwarteten Werts.

**Ursache:** Ein Verbund mit einer weiteren Tabelle vervielfacht die
Zeilen, bevor gezählt wird. Beispiel: Engineering hat 6 Mitarbeiter und 3
Projekte; über beide verbunden ergibt `COUNT(*)` 18.

**So erkennt ihr es:** Prüft bei jedem Verbund, ob die Zeilen pro
gezähltem Objekt mehrfach vorkommen. `COUNT(DISTINCT …)` zählt jedes Objekt nur einmal; oft ist es besser,
die zusätzliche Tabelle gar nicht erst zu verbinden.

## F8 — `NULL` in Rechnung, Vergleich oder Durchschnitt

**Symptom:** Ein Wert ist leer (`NULL`) oder 0, obwohl er berechnet
werden sollte; eine Abfrage mit `= NULL` findet nichts; ein Durchschnitt
ist zu hoch.

**Ursache:** Rechnen mit `NULL` ergibt `NULL`. Ein Vergleich mit `=` ist
bei `NULL` nie wahr. Gruppenfunktionen wie `AVG` und `SUM` übergehen
`NULL`-Werte; `AVG(prov)` mittelt nur über die 3 Mitarbeiter mit
Provision.

**So erkennt ihr es:** Prüft für jede beteiligte Spalte, ob sie `NULL`
enthalten darf. Ersetzt `NULL` vor der Rechnung (`ISNULL(prov, 0)`), und prüft mit `IS NULL`. Achtet auf die Stelle des
`ISNULL`: `ISNULL(prov + gehalt, 0)` hilft nicht.

## F9 — `NOT IN` mit `NULL`

**Symptom:** Das Ergebnis ist leer, obwohl es passende Zeilen geben
müsste.

**Ursache:** Enthält die Liste der Unteranfrage ein `NULL`, wird die
`NOT IN`-Bedingung für jede Zeile unbekannt. Beispiel:
`manr NOT IN (SELECT vorgnr FROM ma)`, denn Hansen hat keinen
Vorgesetzten.

**So erkennt ihr es:** Kann die Spalte der Unteranfrage `NULL` enthalten?
Dann `WHERE spalte IS NOT NULL` in die Unteranfrage aufnehmen.

## F10 — Änderung trifft zu viele Zeilen

**Symptom:** Nach `UPDATE` oder `DELETE` meldet SQL Server mehr Zeilen
als erwartet, oder Daten sind verändert, die nicht gemeint waren.

**Ursache:** Das `WHERE` fehlt (dann sind alle Zeilen betroffen) oder ist
zu weit gefasst, z. B. `OR` statt `AND`: `abtnr = 20 OR job = 'Engineer'`
trifft 10 statt 6 Mitarbeiter.

**So erkennt ihr es:** Führt dieselbe Bedingung vorher in einem `SELECT`
aus und vergleicht die Zeilenzahl mit der Meldung „n Zeilen betroffen“.

## F11 — Der Verbund blendet Zeilen ohne Partner aus

**Symptom:** Zeilen fehlen im Ergebnis, die „keine“ zugehörigen Zeilen
in der anderen Tabelle haben, z. B. Abteilungen ohne Projekt.

**Ursache:** Ein Verbund über Schlüssel und Fremdschlüssel liefert nur
Zeilen, die einen Partner haben. Soll auch „keiner“ im Ergebnis vorkommen
(`höchstens ein Projekt`, `0` als Anzahl), zählt der Verbund sie nicht
mit.

**So erkennt ihr es:** Fragt euch, ob Zeilen ohne Partner in das Ergebnis
gehören. Dann hilft z. B. eine Unteranfrage, die die Partner je Zeile
zählt.

## F12 — Spalte fehlt in `GROUP BY`

**Symptom:** SQL Server meldet Fehler 8120: Eine Spalte der Auswahlliste
sei ungültig, weil sie weder in einer Aggregatfunktion noch in der
`GROUP BY`-Klausel enthalten ist.

**Ursache:** Die Auswahlliste enthält neben der Gruppenfunktion eine
Spalte, nach der nicht gruppiert wird. Die Datenbank kann dann nicht
entscheiden, welchen der Werte einer Gruppe sie anzeigen soll.
Beispiel: `SELECT abtnr, name, COUNT(*) FROM ma GROUP BY abtnr`.

**So erkennt ihr es:** Prüft jede Spalte der Auswahlliste: Steht sie in
einer Gruppenfunktion oder in `GROUP BY`? Gehört die Spalte fachlich zur
Gruppe (z. B. die Bezeichnung zur Abteilungsnummer), nehmt sie in
`GROUP BY` auf. Soll sie die Gruppen verfeinern (z. B. `job`), ändert
sich das Ergebnis: Es gibt dann eine Zeile je Kombination.

## F13 — Zu weitreichende Rechte

**Symptom:** Ein Nutzer darf mehr, als seine Aufgabe verlangt: Er kann
Daten ändern oder löschen, obwohl er nur lesen soll, oder er sieht
Tabellen, die ihn nichts angehen. Es erscheint keine Fehlermeldung.

**Ursache:** Das Skript vergibt eine Sammelberechtigung statt der
einzelnen nötigen Rechte, z. B. `GRANT CONTROL ON DATABASE::…`, die feste
Rolle `db_owner` oder `db_datareader` (die auch später angelegte
Tabellen freigibt) oder ein `GRANT … TO PUBLIC`. KI-Vorschläge greifen
gern zu solchen Abkürzungen.

**So erkennt ihr es:** Vergleicht jedes erteilte Recht mit der
Anforderung: Wird jede Operation tatsächlich gebraucht? Prüft mit
`EXECUTE AS`, ob der Nutzer etwas darf, das er nicht dürfen soll.

## F14 — Recht gilt für mehr Spalten oder Zeilen als nötig

**Symptom:** Ein Nutzer sieht vertrauliche Spalten (z. B. `gehalt`,
`kdnr`) oder Zeilen, die für ihn nicht bestimmt sind.

**Ursache:** Das Recht gilt für die ganze Tabelle, obwohl nur ein Teil
der Spalten gebraucht wird (`GRANT SELECT ON prj` statt
`GRANT SELECT ON prj (prjnr, titel)`). Oder ein Spaltenrecht wird
eingesetzt, wo auch Zeilen eingeschränkt werden müssten: Ein
Spaltenrecht blendet keine Zeilen aus. Dafür braucht es eine Sicht mit
`WHERE`.

**So erkennt ihr es:** Fragt euch für jedes Recht: Welche Spalten und
welche Zeilen sind tatsächlich nötig? Fragt `SELECT *` ab, wie es der
Nutzer täte, und zählt die Zeilen.

## F15 — `DENY` trifft mehr als gedacht

**Symptom:** Ein Nutzer, der ein Recht haben soll, bekommt Fehler 229
oder 230.

**Ursache:** Ein `DENY` schlägt jedes `GRANT`. Gehört ein Nutzer zu
mehreren Rollen, sperrt ein `DENY` in einer davon das Recht auch dann,
wenn eine andere Rolle es erlaubt. Ein `DENY` auf eine Rolle trifft
alle ihre Mitglieder.

**So erkennt ihr es:** Prüft bei jedem `DENY`, wer alles in der Rolle
Mitglied ist und ob diese Personen das Recht über eine andere Rolle
brauchen. Meist ist `REVOKE` (Recht zurücknehmen) besser als `DENY`.

## F16 — Der Trigger geht von einer Zeile aus

**Symptom:** Bei der Änderung einer einzelnen Zeile funktioniert der
Trigger, bei einer Änderung vieler Zeilen entstehen zu wenige oder
falsche Ergebnisse (z. B. nur eine Protokollzeile statt sechs).

**Ursache:** Ein Trigger läuft in SQL Server einmal pro Anweisung. In
`inserted` und `deleted` stehen alle betroffenen Zeilen. Wer mit
Variablen arbeitet (`SELECT @x = spalte FROM inserted`), liest nur eine
beliebige davon. Solcher Code stammt oft aus Beispielen anderer
Datenbanksysteme, die zeilenweise arbeiten.

**So erkennt ihr es:** Sucht im Trigger nach `DECLARE @…` und
`SELECT @… = … FROM inserted/deleted`. Testet den Trigger immer mit
einer Anweisung, die mehrere Zeilen ändert.

## F17 — Syntax eines anderen Datenbanksystems

**Symptom:** Das Anlegen einer Prozedur oder eines Triggers scheitert
mit einem Syntaxfehler, z. B. bei `BEFORE UPDATE`, `FOR EACH ROW`,
`OLD.spalte` oder `NEW.spalte`.

**Ursache:** Die KI oder ein Lehrbuch verwendet die Schreibweise eines
anderen Systems. SQL Server kennt `AFTER` und `INSTEAD OF`, keine
zeilenweisen Trigger und stattdessen die Pseudotabellen `inserted` und
`deleted`.

**So erkennt ihr es:** Prüft die Stichwörter im Kopf des Triggers und
den Zugriff auf alte und neue Werte. Nennt der KI im Prompt immer den
Dialekt „Microsoft SQL Server (T-SQL)“.

## F18 — Der Trigger feuert häufiger oder seltener als erwartet

**Symptom:** Es entstehen Protokollzeilen, obwohl sich nichts geändert
hat, oder erwartete Einträge fehlen.

**Ursache:** Häufige Gründe: Der Trigger prüft nicht, welche Spalte sich
geändert hat, oder vergleicht alte und neue Werte nicht. `IF
UPDATE(spalte)` ist schon wahr, wenn die Spalte in `SET` vorkommt, auch
wenn ihr Wert gleich bleibt. Ein Trigger für `UPDATE` löst bei `INSERT`
oder `DELETE` nichts aus. Schlägt die Änderung an einem Constraint
fehl, läuft ein `AFTER`-Trigger gar nicht erst.

**So erkennt ihr es:** Spielt Anweisungen durch, die den Trigger auslösen
sollen und die ihn nicht auslösen sollen (andere Spalte, gleicher Wert,
keine passende Zeile, andere Anweisungsart), und zählt die Protokollzeilen.
