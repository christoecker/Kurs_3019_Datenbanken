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
