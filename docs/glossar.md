# Glossar

Hier findest du die wichtigsten Fachbegriffe aus dem Kurs kurz erklärt.
Nutze diese Seite zum Nachschlagen, wenn dir ein Begriff aus einem
Arbeitsauftrag oder einer Übung nicht mehr geläufig ist.

## A

**Abhängiger Entity-Typ (schwacher Entity-Typ)**
: Ein Entity-Typ, dessen Objekte in ihrer Existenz von einem anderen
("identifizierenden") Entity-Typ abhängen und keinen eigenen Schlüssel
besitzen — sie werden erst durch die Kombination aus einem lokalen
Attribut und der Beziehung zum identifizierenden Entity-Typ eindeutig
identifizierbar. Ein abhängiger Entity-Typ kann auch von mehreren
Eigentümer-Entity-Typen gleichzeitig abhängen — dann braucht er
entsprechend mehrere identifizierende Beziehungen, und erst die
Kombination aus lokalem Attribut und allen beteiligten
Fremdschlüsseln macht ihn eindeutig identifizierbar.

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

**Denormalisierung (bewusster Verzicht auf Normalform)**
: Die bewusste Entscheidung, eine Relation trotz erkannter Redundanz
nicht (vollständig) zu normalisieren bzw. zusätzlich abgeleitete
(aus anderen Daten berechenbare) Werte zu speichern — meist aus
pragmatischen Gründen wie Lese-Performance. Anders als eine
Normalform-Verletzung ist das eine begründete Entwurfsentscheidung,
kein handwerklicher Fehler.

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

**Datensatz**
: Eine einzelne Zeile einer Relation; repräsentiert ein konkretes
Objekt der Anwendungswelt mit einem Wert für jedes Attribut der
Relation.

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

**Entity-/Schlüsselintegrität**
: Die vom Datenbanksystem überwachte Eigenschaft, dass keine zwei
Datensätze einer Relation in den Werten ihres Primärschlüssels
übereinstimmen dürfen.

**Entity-Typ**
: Die Schablone bzw. Menge aller gleichartigen Entities mit denselben
Attributen; im ER-Diagramm als Rechteck dargestellt.

**ER-Diagramm**
: Das grafische Ergebnis der konzeptuellen Datenmodellierung: eine
Darstellung aller relevanten Entity-Typen, Beziehungstypen und Attribute
einer Anwendungswelt.

**Erhaltung der Informationskapazität**
: Eigenschaft einer Schema-Transformation, bei der das logische
(relationale) Schema genau dieselben Datenbankzustände zulässt wie das
konzeptuelle (ER-)Schema — nicht mehr und nicht weniger. Bei den
Standard-Transformationsregeln ist dies nicht immer der Fall, da
Untergrenzen (Mindestteilnahmen) dabei verloren gehen können.

**ER-Modell (Entity-Relationship-Modell, ERM)**
: Ein grafischer, technikferner Formalismus für den konzeptuellen
Datenbankentwurf mit den Grundkonzepten Entity, Relationship und
Attribut.

## F

**Fremdschlüssel (FK)**
: Ein Attribut (oder eine Attributkombination) einer Relation, das den
Schlüssel einer anderen — oder derselben — Relation referenziert und
damit eine Beziehung zwischen Datensätzen abbildet.

**Fremdschlüsselintegrität**
: Die vom Datenbanksystem überwachte Eigenschaft, dass zu jedem
Fremdschlüsselwert ein passender Datensatz mit demselben Schlüsselwert
in der referenzierten Relation existieren muss.

**Funktionale Abhängigkeit**
: Ein Zusammenhang zwischen zwei Attributen einer Relation, bei dem der
Wert des einen Attributs den Wert des anderen eindeutig festlegt — zwei
Datensätze mit gleichem Wert im ersten Attribut müssen dann auch im
zweiten Attribut übereinstimmen.

## G

**Generalisierung**
: Die Sichtweise, bei der aus mehreren speziellen Entity-Typen ein
gemeinsamer, allgemeinerer Entity-Typ (Supertyp) gebildet wird — die
gedanklich umgekehrte Blickrichtung zur Spezialisierung, beschreibt aber
dieselbe Struktur.

## I

**Identifizierende Beziehung**
: Die Beziehung zwischen einem abhängigen Entity-Typ und dem Entity-Typ,
über den er eindeutig identifiziert wird; im ER-Diagramm durch
Unterstreichen gekennzeichnet. Ein abhängiger Entity-Typ kann auch
mehrere identifizierende Beziehungen zu unterschiedlichen
Eigentümer-Entity-Typen gleichzeitig haben.

**Informationssystem**
: Ein Softwaresystem zur Erfassung, Verarbeitung, Speicherung,
Auswertung und Anzeige von Informationen, i. d. R. mit
Benutzeroberfläche (z. B. ein Warenwirtschaftssystem).

**Inkonsistenz**
: Widersprüchliche Datenstände, die entstehen, wenn redundant
gespeicherte Daten bei einer Änderung nicht überall synchron
aktualisiert werden.

**Instanz (Datenbankinstanz)**
: Eine einzelne, eigenständig laufende Kopie eines
Datenbankmanagementsystems auf einem Rechner, die ihre eigenen
Datenbanken (z. B. die Systemdatenbanken) verwaltet und über einen
eigenen Namen ansprechbar ist; ein Rechner kann mehrere Instanzen
parallel betreiben.

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

## N

**Nichtschlüsselattribut**
: Ein Attribut einer Relation, das nicht Teil eines Schlüsselkandidaten
ist.

**Normalform**
: Eines von mehreren aufeinander aufbauenden, prüfbaren Kriterien für
die Qualität eines Relationenschemas. Die erste Normalform verlangt
atomare Wertebereiche, die zweite verlangt, dass kein Nichtschlüsselattribut 
nur von einem Teil eines zusammengesetzten Schlüssels abhängt,
und die dritte verlangt, dass kein Nichtschlüsselattribut nur indirekt
(transitiv) über ein anderes Nichtschlüsselattribut vom Schlüssel
abhängt.

**Normalisierung**
: Die schrittweise Prüfung eines Relationenschemas auf Verletzung der
Normalformen und die Beseitigung gefundener Verletzungen durch
Zerlegung in mehrere Relationen, mit dem Ziel, unerwünschte Redundanz
zu vermeiden.

**NULL-Wert**
: Kennzeichnet im Relationenmodell, dass ein optionales Attribut für
einen bestimmten Datensatz keinen Wert hat.

## P

**Primärschlüssel (PK)**
: Der aus den Schlüsselkandidaten einer Relation für die Implementierung
ausgewählte Schlüssel; darf keine optionalen Attribute enthalten und
wird in der Notation mit PK gekennzeichnet.

## R

**Redundanz**
: Mehrfache, getrennte Speicherung derselben Information; typische
Ursache für Inkonsistenz.

**Rekursive Beziehung**
: Ein Beziehungstyp, bei dem beide beteiligten Seiten vom selben
Entity-Typ sind.

**Relation**
: Im Relationenmodell die formale Bezeichnung für eine Tabelle; stellt
eine konkrete Menge von Objekten der Anwendungswelt dar und wird durch
ein Relationenschema beschrieben.

**Relationale Datenbank**
: Eine Menge von Relationen, deren Konsistenz (u. a. Entity-/Schlüssel-
und Fremdschlüsselintegrität) von einem relationalen Datenbanksystem
überwacht wird.

**Relationenmodell**
: Das Datenmodell, in das ein konzeptuelles Schema beim logischen
Datenbankentwurf überführt wird — Standard zur Implementierung von
Datenbanken, da dem ER-Modell eine Sprachkomponente für Anfragen und
Änderungen fehlt.

**Relationenschema**
: Die Struktur-Beschreibung einer Relation: ein Name sowie eine Liste
von Attributen, jeweils mit Wertebereich und Angabe, ob das Attribut
optional ist.

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

**Schlüsselkandidat**
: Eine minimale Menge von Attributen einer Relation, die jeden
Datensatz eindeutig identifiziert; eine Relation kann mehrere
Schlüsselkandidaten besitzen.

**Spezialisierung**
: Die Ableitung eines neuen, spezielleren Entity-Typs (Subtyp) aus einem
bereits bestehenden Entity-Typ (Supertyp); der Subtyp besitzt alle
Attribute und Beziehungen des Supertyps zusätzlich zu seinen eigenen.

**SQL (Structured Query Language)**
: Die standardisierte, mengenorientierte und deskriptive
Datenbanksprache zur Definition, Abfrage und Änderung von Daten in
relationalen Datenbanken.

**SQL Server Management Studio (SSMS)**
: Das grafische Administrations- und Abfragewerkzeug von Microsoft für
den SQL Server; wird getrennt vom Datenbankmanagementsystem selbst
installiert und dient u. a. dazu, sich mit einer Instanz zu verbinden
und SQL-Skripte auszuführen.

**Subtyp**
: Der speziellere Entity-Typ innerhalb einer Spezialisierung; jedes
seiner Objekte ist automatisch auch ein Objekt des zugehörigen
Supertyps, zusätzlich zu seinen eigenen Attributen.

**Supertyp**
: Der allgemeinere Entity-Typ innerhalb einer Spezialisierung, von dem
ein oder mehrere Subtypen abgeleitet werden.

**Surrogatschlüssel (künstlicher Schlüssel)**
: Ein eigens für die Implementierung ergänztes, meist numerisches
Schlüsselattribut einer Relation, das anstelle eines aus mehreren
Attributen zusammengesetzten Schlüssels zum Primärschlüssel erklärt
wird; der ursprüngliche Schlüssel bleibt dabei als Unique Key erhalten.

**Systemdatenbank**
: Eine der vom Datenbankmanagementsystem selbst zur Verwaltung
benötigten Datenbanken (bei SQL Server z. B. `master`, `tempdb`,
`model`, `msdb`), die bereits direkt nach der Installation vorhanden
sind, unabhängig von eigenen Anwendungsdatenbanken.

## U

**UML-Notation**
: Eine an das ER-Modell angelehnte grafische Notation, die zusätzlich zu
Obergrenzen auch Untergrenzen für Kardinalitäten (Multiplizitäten)
ausdrücken kann.

**Unique Key (UK)**
: Ein Schlüsselkandidat einer Relation, der nicht als Primärschlüssel
gewählt wurde; kann im Gegensatz zum Primärschlüssel auch optionale
Attribute enthalten.

## W

**Wertebereich (Domäne)**
: Die Menge der für ein Attribut zulässigen Werte. Im Relationenmodell
sind nur atomare Wertebereiche zulässig (z. B. Zahlen, Zeichenketten,
Datumswerte) — Wertebereiche für Mengen oder Listen sind nicht erlaubt.

**Windows-Authentifizierung**
: Ein Anmeldeverfahren, bei dem sich Nutzer mit ihrem bereits
bestehenden Windows-Benutzerkonto bei einer Datenbankinstanz anmelden,
ohne einen separaten Datenbank-Benutzernamen und ein eigenes Passwort
einzugeben.