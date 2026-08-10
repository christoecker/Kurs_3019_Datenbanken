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
| `mea-pruefmittel` | eigen, MEA-Bezug | Prüfmittelverwaltung, Kalibrierung | 1:N-Beziehung, abhängiger Entity-Typ, Normalisierung (Transfer-Aufgabe Woche 9) |
| `mea-kompressor-zustandsueberwachung` | eigen, MEA-Bezug | Zustandsbasierte Wartung eines Kompressors (Sensordaten, Extremwert-Erkennung, Schädigungsauswertung) | Normalisierung inkl. bewusster Redundanz (Theoriephase Block 03); Gerät speichert eigenständig, ohne Geräte-ID |
| `mea-lackproduktion` | eigen, MEA-Bezug | Chargenbetrieb einer Lackproduktion (Prozesswerte im 30-s-Raster, Rezepte, Reaktoren, Qualitätsanalysen, Wareneingang) | Normalisierung einer gewachsenen Bestandstabelle, Schema-Erweiterung aus einer Kundenspezifikation, Umgang mit widersprüchlichen und sich ändernden Anforderungen (Theoriephase Block 03, betreutes Selbststudium) |

Jede Fallstudie bekommt bei Ausarbeitung einen eigenen Unterordner mit
Schema (als SQL-Server-DDL-Skript) und einer kurzen Domänenbeschreibung.
Noch nicht ausgearbeitet — wird bei Bedarf pro Thema ergänzt.
