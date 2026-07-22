# Fallstudien-Pool

Bewusst **mehrere** Fallstudien statt eines einzigen durchgängigen Cases
(explizite Vorgabe). Pro Thema/Block wird im Frontmatter der jeweiligen
Aufgabe vermerkt, welche Fallstudie verwendet wird — Variation ist
gewünscht, damit der Kurs nicht monoton wird und unterschiedliche
Domänen zeigt.

## Verfügbar / geplant

| Kürzel | Herkunft | Domäne | Eignet sich gut für |
|---|---|---|---|
| `fh-info` | aus dem Lehrbrief übernommen | Hochschulverwaltung (Studierende, Module, Prüfungen) | ERM-Grundlagen, klassische Joins/Aggregation — Studierende kennen das Domänenwissen bereits aus dem Lehrbrief |
| `mea-maschinenpark` | eigen, MEA-Bezug | Maschinen, Wartungsaufträge, Ersatzteile | Praxisphase-Themen, DML, Constraints |
| `mea-produktionsauftraege` | eigen, MEA-Bezug | Fertigungsaufträge, Stücklisten, Ressourcen | Joins, Gruppierung, Prozeduren |
| `mea-sensormessreihen` | eigen, MEA-Bezug | Zeitreihen aus Sensoren/SPS | SQLite/TwinCAT-Termin, später NoSQL-Ausblick |
| `bestTec` / `eLibri` | aus dem Lehrbrief, optional | Handel / Bibliothek | Ergänzend, falls Abwechslung gewünscht |

Jede Fallstudie bekommt bei Ausarbeitung einen eigenen Unterordner mit
Schema (als SQL-Server-DDL-Skript) und einer kurzen Domänenbeschreibung.
Noch nicht ausgearbeitet — wird bei Bedarf pro Thema ergänzt.
