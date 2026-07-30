---
typ: praxisphase-woche
woche: 10
thema: "Installation und erste Schritte SQL Server 2025 Express"
workload_minuten: 90
lernziele:
  - "kann SQL Server 2025 Express und SQL Server Management Studio (SSMS) eigenständig anhand offizieller Microsoft-Dokumentation installieren"
  - "kann sich in SSMS per Windows-Authentifizierung mit einer lokalen SQL-Server-Instanz verbinden"
  - "kann mithilfe eines einfachen T-SQL-Skripts selbstständig prüfen, ob die eigene Installation erfolgreich war"
quelle_lehrbrief: "keine"
quelle_lehrbuch: "keine"
fallstudie: "keine"
ki_einsatz: stufe_1_nachschlagewerk
bearbeitungsstatus: entworfen
publish_date: 2026-09-21
---

# Woche 10: Installation und erste Schritte in SQL Server 2025 Express

> Zeitbedarf: ca. 1-1,5 Stunden.

## Worum geht es?

Bisher hast du dich in der Praxisphase ausschließlich mit Papier, Stift und
Modellen beschäftigt — ER-Diagramme, Relationenmodelle, Normalisierung. Ab
der Theoriephase arbeitest du an konkreten Tabellen in einem echten
Datenbankmanagementsystem. Diese Woche schaffst du dafür die technische
Voraussetzung: Du installierst **Microsoft SQL Server 2025 Express** (das
DBMS selbst) sowie **SQL Server Management Studio (SSMS)** (das
grafische Werkzeug, mit dem du dich damit verbindest und SQL-Skripte
ausführst) auf deinem eigenen Rechner.

Du findest hier **keine
Schritt-für-Schritt-Anleitung mit Screenshots**. Stattdessen wirst du auf
die offizielle Microsoft-Dokumentation verwiesen.

## Das sollte diese Woche erreicht sein

- Du hast SQL Server 2025 Express und SSMS auf deinem Rechner installiert
  und lauffähig.
- Du kannst dich in SSMS mit deiner lokalen Instanz verbinden.
- Du kannst mit einem kurzen SQL-Skript selbst prüfen, ob deine
  Installation vollständig und korrekt ist.

## Voraussetzungen

- Ein **Windows-Rechner** (SQL Server 2025 Express setzt Windows voraus).
- **Administratorrechte** auf diesem Rechner — die Installation lässt sich
  ohne sie nicht durchführen.
- Mindestens **6 GB freier Speicherplatz** (SQL Server Express und SSMS
  zusammen).
- Eine stabile Internetverbindung, da beide Installationsprogramme Daten
  nachladen.

## Installation SQL Server 2025 Express

Lade das Installationsprogramm von der offiziellen Microsoft-Seite herunter:

> <a href="https://www.microsoft.com/de-de/sql-server/sql-server-downloads" target="_blank" rel="noopener">microsoft.com/de-de/sql-server/sql-server-downloads</a>

Wähle dort die **Express**-Edition (kostenlos, für unsere Zwecke völlig
ausreichend).

!!! info "Installationstyp: Basic"
    Wähle im Installationsprogramm den Installationstyp **"Basic"** — die
    einfachste der angebotenen Optionen. Damit vergibt der Installer
    automatisch den Instanznamen `SQLEXPRESS` und richtet die
    **Windows-Authentifizierung** ein. Du musst dafür keine weiteren
    Auswahlentscheidungen treffen (z. B. zu Dateipfaden oder
    Speicherorten) — das übernimmt "Basic" für dich.

Die eigentlichen Installationsschritte (welche Dialoge in welcher
Reihenfolge erscheinen) findest du im offiziellen Installationsleitfaden
von Microsoft:

> <a href="https://learn.microsoft.com/de-de/sql/database-engine/install-windows/install-sql-server?view=sql-server-ver17" target="_blank" rel="noopener">learn.microsoft.com/de-de/sql/database-engine/install-windows/install-sql-server</a>

Suche dort gezielt nach dem Abschnitt zur **Express-Edition** bzw. zum
**Basic-Installationstyp**.

## Installation SQL Server Management Studio (SSMS) 22

SSMS ist ein eigenständiges Programm und **nicht** Teil der
SQL-Server-Installation — du installierst es getrennt. Download und
offizieller Installationsleitfaden liegen auf derselben Seite:

> <a href="https://learn.microsoft.com/ssms/install/install" target="_blank" rel="noopener">learn.microsoft.com/ssms/install/install</a>

Ein normaler Durchlauf des Installationsprogramms mit den
vorgeschlagenen Standardeinstellungen reicht aus.

## Verbindung mit SSMS herstellen

Starte SSMS. Im Dialog "Mit Server verbinden" trägst du ein:

- **Servername:** `.\SQLEXPRESS` (alternativ `(local)\SQLEXPRESS`) — der
  Punkt bzw. `(local)` steht dabei für "dieser Rechner".
- **Authentifizierung:** Windows-Authentifizierung ist bereits
  voreingestellt und muss nicht geändert werden — du meldest dich mit
  deinem angemeldeten Windows-Benutzerkonto an, ohne separates Passwort.

!!! info "Zertifikatswarnung"
    Erscheint beim Verbindungsaufbau eine Warnung zum
    Server-Zertifikat, aktiviere die Option **"Trust server
    certificate"** und verbinde dich erneut. Das ist bei einer rein
    lokalen Testinstallation unbedenklich: Die Warnung weist nur darauf
    hin, dass das Zertifikat nicht von einer offiziell anerkannten
    Stelle bestätigt wurde — für eine Verbindung, die den eigenen Rechner
    nie verlässt, spielt das keine Rolle.

## Selbstkontrolle: Installations-Test-Skript

Öffne in SSMS ein neues Query-Fenster (z. B. über "New Query" oder "Neue Abfrage") und führe
das folgende Skript aus (`ALT+X` oder über den Button "Ausführen"), um deine Installation zu prüfen.

```sql
-- a) Läuft hier tatsächlich SQL Server 2025?
SELECT @@VERSION;

-- b) Wie heißt meine Instanz?
SELECT @@SERVERNAME;

-- c) Sind die Standard-Systemdatenbanken vorhanden?
SELECT name FROM sys.databases;
```

Woran erkennst du eine erfolgreiche Installation?

- **a) `SELECT @@VERSION;`** — Die Ausgabe ist ein längerer Text. Eine
  erfolgreiche Installation erkennst du daran, dass darin die
  Zeichenfolge **"Microsoft SQL Server 2025"** auftaucht (die genaue
  Build- und Versionsnummer dahinter ist nicht entscheidend und kann sich
  durch Updates jederzeit ändern).
- **b) `SELECT @@SERVERNAME;`** — Das Ergebnis sollte auf **`\SQLEXPRESS`**
  enden, z. B. `DEIN-RECHNERNAME\SQLEXPRESS`. Das bestätigt, dass die
  Basic-Installation den Instanznamen wie erwartet vergeben hat.
- **c) `SELECT name FROM sys.databases;`** — In der Ergebnisliste sollten
  mindestens die vier **Systemdatenbanken** `master`, `tempdb`, `model`
  und `msdb` auftauchen (Reihenfolge egal, weitere Einträge könnten erscheinen, falls du schon Datenbanken angelegt hast).
  Sie werden bei jeder SQL-Server-Installation automatisch angelegt und
  sind die Grundlage, auf der das DBMS selbst arbeitet.

Tauchen alle drei erwarteten Ergebnisse auf, ist deine Installation
einsatzbereit für Woche 11 und die Theoriephase.

!!! tip "Bei Problemen mit der Installation"
    Installationsfehler hängen oft stark vom konkreten Rechner ab (fehlende
    Windows-Updates, Berechtigungen, Speicherplatz). Ein KI-Assistent kann
    dir hier gut helfen, eine unbekannte Fehlermeldung einzuordnen und
    mögliche Ursachen zu erklären — die Lösung suchst und prüfst du aber
    selbst, z. B. anhand des Installationsleitfadens. Lässt sich ein
    Problem so gar nicht lösen, warte damit **nicht bis zum nächsten
    Präsenztermin** — in Woche 11 baut die nächste Praxisphase-Einheit
    bereits praktisch auf einer funktionierenden Installation auf. Melde
    dich stattdessen zeitnah direkt bei mir; meine Kontaktdaten findest du
    im <a href="https://www.hsbi.de/elearning/ilias.php?baseClass=ilrepositorygui&ref_id=1700711" target="_blank" rel="noopener">ILIAS-Kursraum</a>.
