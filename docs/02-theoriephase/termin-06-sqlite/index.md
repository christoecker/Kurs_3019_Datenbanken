---
typ: theoriephase-termin-uebersicht
termin: 6
datum: "2026-12-01"
thema_termin: "SQLite: eine Datenbank ohne Server, auf der Konsole und im C-Programm"
workload_minuten: 45
lernziele:
  - "Ihr könnt SQLite installieren und prüfen, dass die Konsole sqlite3 und die Bibliothek (sqlite3.c, sqlite3.h) in eurer Entwicklungsumgebung funktionieren."
  - "Ihr könnt erklären, was eine eingebettete Datenbank ist und wodurch sie sich von einem Datenbankserver wie SQL Server unterscheidet."
bearbeitungsstatus: entworfen
publish_date: 2026-11-24
---

# Termin 6 (01.12.2026) — SQLite: eine Datenbank ohne Server

Bisher habt ihr mit SQL Server gearbeitet, einem Datenbankserver, der
unabhängig von eurer Anwendung läuft. Heute lernt ihr das Gegenstück
kennen: **SQLite**, eine Datenbank, die aus einer einzigen Datei besteht
und als Bibliothek direkt in ein Programm eingebunden wird. Im ersten
Block, [SQLite auf der Konsole](block-11.md), probiert ihr SQLite an
BestTec aus und seht, was gleich bleibt und was anders ist. Im zweiten
Block, [SQLite im C-Programm](block-12.md), greift ein C-Programm auf die
Datenbank zu. Dort baut ihr selbst einen kleinen Vokabeltrainer, mit
KI-Unterstützung.

> Zeitbedarf zur Vorbereitung: ca. 45 Minuten.

## Vorbereitung

### Worum geht es?

Für diesen Termin müsst ihr nichts lesen, aber ihr braucht zwei
Werkzeuge auf eurem Rechner. Richtet sie vorab ein und probiert sie aus,
damit im Termin keine Zeit für die Installation verloren geht. Beides
funktioniert ohne Installationsprogramm und ohne Administratorrechte.

### Zu bearbeiten: SQLite einrichten

Öffnet die Seite [sqlite.org/download.html](https://www.sqlite.org/download.html)
und sucht im Abschnitt „Precompiled Binaries for Windows“ und im Abschnitt
„Source Code“ nach diesen beiden Paketen:

| Paket | Inhalt |
|---|---|
| `sqlite-tools-win-x64-…zip` | die Konsole `sqlite3.exe` |
| `sqlite-amalgamation-…zip` | die Quelldateien `sqlite3.c` und `sqlite3.h` |

Die Zahl im Dateinamen ist die Versionsnummer (3540100 steht für 3.54.1).
Nehmt jeweils die aktuelle Version. Die Pakete `sqlite-dll-…` braucht ihr
nicht: Wir übersetzen SQLite einfach mit unserem Programm zusammen. So
gibt es keine Probleme mit 32- oder 64-Bit-Versionen oder mit fehlenden
Bibliotheksdateien.

**Mac:** Auf einem Mac ist `sqlite3` bereits vorinstalliert (im Terminal
`sqlite3 --version` eingeben). Ihr braucht dann nur das Paket
`sqlite-amalgamation-…zip`. Das C-Programm übersetzt ihr im Terminal mit
`cc version.c sqlite3.c -o version` und startet es mit `./version`. Falls
`cc` noch fehlt, bietet macOS beim ersten Aufruf die Installation der
Kommandozeilen-Werkzeuge an.

**1. Die Konsole prüfen.** Entpackt `sqlite-tools-win-x64-…zip` in einen
Ordner, z. B. `C:\sqlite`. Öffnet dort eine Eingabeaufforderung oder
PowerShell und startet die Konsole (in PowerShell muss es `.\sqlite3`
heißen, in der Eingabeaufforderung genügt `sqlite3`):

```text
.\sqlite3
```

Gebt dann diese Anweisung ein (mit Semikolon) und beendet die Konsole mit
dem Punkt-Befehl `.quit`:

```text
SELECT sqlite_version();
.quit
```

Erscheint eine Versionsnummer, funktioniert die Konsole. Wollt ihr
`sqlite3` aus jedem Ordner heraus starten, nehmt den Ordner in die
Umgebungsvariable `Path` eures Benutzerkontos auf. Das ist nicht
nötig: Ihr könnt auch jedes Mal im Ordner mit `sqlite3.exe` arbeiten.
Werden Umlaute in der Eingabeaufforderung
falsch dargestellt, hilft vor dem Start der Befehl `chcp 65001`.

**2. Die Bibliothek in ein C-Projekt einbinden.** Entpackt
`sqlite-amalgamation-…zip` und legt die beiden Dateien `sqlite3.c` und
`sqlite3.h` in einen neuen Projektordner. Daneben legt ihr eine Datei
`version.c` mit diesem kleinen Programm an:

```c linenums="1"
--8<-- "02-theoriephase/termin-06-sqlite/code/uebung-12-version.c"
```

1. Der Header `sqlite3.h` beschreibt alle Funktionen der Bibliothek. Die
   Anführungszeichen statt spitzer Klammern bedeuten: Die Datei liegt im
   eigenen Projektordner.
2. `sqlite3_libversion()` liefert die Versionsnummer der eingebundenen
   Bibliothek als Text. Eine Datenbank wird hier noch nicht geöffnet.

Übersetzt das Programm und startet es. Es gibt die Version von SQLite aus.
Je nach Entwicklungsumgebung geht ihr so vor:

- **Visual Studio:** Legt ein Konsolenprojekt an und fügt `sqlite3.c`,
  `sqlite3.h` und `version.c` über *Hinzufügen → Vorhandenes Element* zum
  Projekt hinzu. Dateien mit der Endung `.c` werden als C übersetzt. Ist
  im Projekt die Option „Vorkompilierte Header“ aktiv, stellt ihr sie in den
  Eigenschaften von `sqlite3.c` auf „Nicht verwenden“ (*C/C++ →
  Vorkompilierte Header*). Tragt außerdem in den Projekteigenschaften unter
  *C/C++ → Präprozessor* die Definition `_CRT_SECURE_NO_WARNINGS` ein,
  denn sonst brechen Funktionen wie `scanf` oder `strcpy`, die KI-Code
  gern verwendet, mit einer Fehlermeldung ab. Das erste Übersetzen dauert
  etwas länger, weil `sqlite3.c` sehr groß ist. Später wird die Datei nur
  neu übersetzt, wenn ihr sie ändert.
- **Visual Studio Code:** Öffnet die „Developer Command Prompt for VS“
  (oder das Terminal, in dem `cl` bzw. `gcc` bekannt ist) im
  Projektordner. Mit dem Microsoft-Compiler übersetzt ihr `sqlite3.c`
  einmal vorab und danach nur noch euer Programm. Mit `gcc` geht es in einem
  Schritt:

    ```text
    cl /c sqlite3.c
    cl version.c sqlite3.obj
    version.exe
    ```

    ```text
    gcc version.c sqlite3.c -o version
    version.exe
    ```

Klappt etwas nicht, notiert die Fehlermeldung und bringt sie zum Termin
mit. Dort ist Zeit, um Probleme gemeinsam zu lösen.

### Alles verstanden?

1. Welche beiden Pakete braucht ihr, und wofür?

    ??? note "Musterlösung anzeigen"
        Die Tools (`sqlite3.exe`) für die Arbeit auf der Konsole im ersten
        Teil des Termins und die Amalgamation (`sqlite3.c`, `sqlite3.h`) für
        das C-Programm im zweiten Teil.

2. Warum liegt `sqlite3.c` mit im Projekt, statt dass ihr ein Datenbankprogramm installiert und ansprecht?

    ??? note "Musterlösung anzeigen"
        SQLite ist keine eigene Anwendung und kein Server, sondern eine
        Bibliothek. Ihr übersetzt sie zusammen mit eurem Programm, und die
        Datenbank läuft dann als Teil davon. Es gibt nichts zu installieren
        und nichts zu konfigurieren.

### Zur Auffrischung

**Für „SQLite auf der Konsole“** — aus den vorherigen Terminen:

- Die Fallstudie BestTec mit ihren Tabellen `abt`, `ma` und `prj`
  ([BestTec: Datenbestand](../termin-03/besttec-daten.md)).
- Fremdschlüssel als Regel, die die Datenbank selbst durchsetzt
  (Termin 2).
- Der Trigger zur Protokollierung von Gehaltsänderungen aus
  Termin 4, Prozeduren und Trigger.

**Für „SQLite im C-Programm“** — aus dem Modul Programmieren:

- Funktionen, Zeichenketten und Zeiger in C, außerdem das Einlesen von
  Eingaben mit `fgets`.
- Die SQL-Abfragen aus Termin 3 (`SELECT` mit `JOIN` und `GROUP BY`),
  die ihr im C-Programm als Text weitergebt.
