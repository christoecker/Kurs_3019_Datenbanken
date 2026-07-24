# Glossar

Hier findest du die wichtigsten Fachbegriffe aus dem Kurs kurz erklärt.
Nutze diese Seite zum Nachschlagen, wenn dir ein Begriff aus einem
Arbeitsauftrag oder einer Übung nicht mehr geläufig ist. Das Glossar
wächst im Laufe des Semesters mit.

## A

**Anforderungsanalyse**
: Erste Phase des Datenbankentwurfs: informelles Erfassen und
Dokumentieren, welche Daten gespeichert werden müssen und wer wie darauf
zugreifen soll.

**Attribut**
: Eigenschaft eines Entity-Typs oder Beziehungstyps, die für jedes
Entity bzw. jede Beziehung einen konkreten Wert annehmen kann (z. B.
Bezeichnung, Datum).

## B

**Beziehungsattribut**
: Ein Attribut, das nicht zu einem Entity-Typ, sondern zu einem
Beziehungstyp selbst gehört, weil die Information nur im Kontext der
Beziehung sinnvoll ist.

**Beziehungstyp**
: Die Menge aller gleichartigen Beziehungen (Relationships) zwischen
Objekten zweier — oder desselben — Entity-Typen; im ER-Diagramm als
Raute dargestellt.

## C

**Chen-Notation**
: Grafische Notation für ER-Diagramme (nach Peter Chen), bei der
Kardinalitäten nur als Obergrenze (1, N, M) angegeben werden, nicht als
Untergrenze.

## D

**Dateiansatz**
: Verwaltung von Massendaten direkt in einzelnen Dateien ohne DBMS;
Ausgangspunkt für die Motivation, warum Datenbanksysteme benötigt
werden.

**Datenbank**
: Eine logisch zusammenhängende Sammlung von Daten, die einen Ausschnitt
der realen Welt beschreibt und von einer Gruppe von Nutzern für einen
bestimmten Zweck verwendet wird — der fachliche/konzeptionelle Begriff,
im Alltag oft synonym mit "Datenbanksystem" verwendet.

**Datenbankmanagementsystem (DBMS)**
: Die Software, die den kontrollierten, koordinierten Zugriff mehrerer
Nutzer auf die Datenbasis ermöglicht.

**Datenbanksystem**
: Die technische Realisierung einer Datenbank, bestehend aus der
Datenbasis und dem Datenbankmanagementsystem (DBMS).

**Datenbasis**
: Die eigentlich gespeicherten Daten innerhalb eines Datenbanksystems,
ohne die verwaltende Software.

**Datendefinition**
: Letzte Phase des Datenbankentwurfs: die konkrete Umsetzung des
logischen Schemas in Datenstrukturen einer Datenbanksprache (z. B. SQL).

**Datenunabhängigkeit**
: Eigenschaft der Drei-Ebenen-Schema-Architektur: Eine Ebene (z. B. die
physische Speicherung) lässt sich ändern, ohne die anderen Ebenen (z. B.
Anwendungen) anpassen zu müssen.

**Drei-Ebenen-Schema-Architektur**
: Aufteilung eines Datenbanksystems in externe Ebene (Sichten je
Nutzergruppe), logische Ebene (ein Schema für alle gespeicherten Daten)
und interne Ebene (physische Speicherung), um Datenunabhängigkeit zu
erreichen.

## E

**Entity**
: Ein einzelnes, konkretes Objekt der Anwendungswelt, über das Daten
gespeichert werden (z. B. eine bestimmte Maschine).

**Entity-Typ**
: Die Schablone bzw. Menge aller gleichartigen Entities mit denselben
Attributen; im ER-Diagramm als Rechteck dargestellt.

**ER-Diagramm**
: Das grafische Ergebnis der konzeptuellen Datenmodellierung: eine
Darstellung aller relevanten Entity-Typen, Beziehungstypen und Attribute
einer Anwendungswelt.

**ER-Modell (Entity-Relationship-Modell, ERM)**
: Ein grafischer, technikferner Formalismus für den konzeptuellen
Datenbankentwurf mit den Grundkonzepten Entity, Relationship und
Attribut.

## I

**Informationssystem**
: Ein Softwaresystem zur Erfassung, Verarbeitung, Speicherung,
Auswertung und Anzeige von Informationen, i. d. R. mit
Benutzeroberfläche (z. B. ein Warenwirtschaftssystem).

**Inkonsistenz**
: Widersprüchliche Datenstände, die entstehen, wenn redundant
gespeicherte Daten bei einer Änderung nicht überall synchron
aktualisiert werden.

## K

**Kardinalität**
: Angabe, in welchem zahlenmäßigen Verhältnis (z. B. 1:N, N:M, 1:1)
Objekte zweier Entity-Typen an einem Beziehungstyp teilnehmen dürfen.

**Konzeptueller Datenbankentwurf**
: Zweite Phase des Datenbankentwurfs: Erstellung eines technikfernen,
grafischen Modells (i. d. R. ein ER-Modell) als Diskussionsgrundlage mit
dem Anwender.

## L

**Logischer Datenbankentwurf** 
: Dritte Phase des Datenbankentwurfs: Überführung des konzeptuellen
Schemas in ein logisches Schema, i. d. R. das Relationenmodell.

## M

**Mehrbenutzerbetrieb**
: Gleichzeitiger Zugriff mehrerer Nutzer auf denselben Datenbestand; ein
Datenbanksystem koordiniert diesen Zugriff, ein reiner Dateiansatz kann
das kaum.

## R

**Redundanz**
: Mehrfache, getrennte Speicherung derselben Information; typische
Ursache für Inkonsistenz.

**Rekursive Beziehung**
: Ein Beziehungstyp, bei dem beide beteiligten Seiten vom selben
Entity-Typ sind.

**Relationenmodell**
: Das Datenmodell, in das ein konzeptuelles Schema beim logischen
Datenbankentwurf überführt wird; wird ab Praxisphase Woche 4 im Detail
behandelt.

**Relationship**
: Eine konkrete Beziehung zwischen zwei (oder mehr) Objekten der
Anwendungswelt; die Ausprägung eines Beziehungstyps.

**Rollenname**
: Optionale Beschriftung an der Verbindungslinie zwischen Entity-Typ und
Beziehungstyp, die die Rolle des Entity-Typs in dieser Beziehung
benennt; besonders hilfreich bei rekursiven Beziehungen.

## S

**Schlüsselattribut**
: Ein Attribut (oder eine Kombination von Attributen) eines
Entity-Typs, dessen Wert(e) jedes Entity eindeutig identifizieren.

**SQL (Structured Query Language)**
: Die standardisierte, mengenorientierte und deskriptive
Datenbanksprache zur Definition, Abfrage und Änderung von Daten in
relationalen Datenbanken.

## U

**UML-Notation**
: Eine an das ER-Modell angelehnte grafische Notation, die zusätzlich zu
Obergrenzen auch Untergrenzen für Kardinalitäten (Multiplizitäten)
ausdrücken kann.