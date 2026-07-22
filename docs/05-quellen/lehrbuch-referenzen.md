---
quelle: Grundkurs_Datenbankentwicklung.pdf
autor: Stephan Kleuker (Hochschule Osnabrück)
titel: "Grundkurs Datenbankentwicklung — Von der Anforderungsanalyse zur komplexen Datenbankanfrage"
auflage: 5. Auflage, 2024, Springer Vieweg
isbn: 978-3-658-43022-1
umfang: 429 Seiten, 17 Kapitel
hinweis_urheberrecht: >
  Nur Kapitelstruktur/Seitenverweise, KEINE Textübernahme. Beim Erstellen
  von Materialien immer neu formulieren.
---

# Lehrbuch — Kapitelstruktur (als Referenz)

Aufbau folgt dem typischen Ablauf einer Datenbankentwicklung (Anforderung →
Entwurf → SQL → Betrieb → Vertiefung). Mit `[*]` markierte Kapitel/
Abschnitte sind laut Autor beim ersten Durcharbeiten auslassbar.

1. Warum Datenbanken? — Grundmotivation, Anforderungen an DB/DBMS, Ebenen
   eines DBMS
2. Anforderungsanalyse für Datenbanken — Entwicklungsprozess, ER-Modell,
   Fallstudie
3. Systematische Ableitung von Tabellenstrukturen — ER→Tabellen-Übersetzung
4. Normalisierung — funktionale Abhängigkeit, 1.–3. NF, `[*]` Boyce-Codd-NF
5. `[*]` Relationenalgebra
6. Formalisierung von Tabellen in SQL — DDL, Datentypen, NULL/3-wertige
   Logik, Constraints, ALTER
7. Einfache SQL-Anfragen — SELECT, WHERE, Aggregatsfunktionen, Joins
8. Gruppierungen in SQL — GROUP BY, HAVING
9. Verschachtelte Anfragen in SQL — Subqueries, Mengenoperatoren, `[*]`
   Join-Operatoren im Detail
10. Transaktionen — paralleler Zugriff, Transaktionssteuerung
11. **Rechte und Views** — Views, DB-Administrationsrechte,
    Projekt-Administrationsrechte
12. **Stored Procedures und Trigger** — PL/SQL, Cursor, Trigger
13. Einführung in JDBC
14. Testen von Datenbanksystemen — JUnit, DBUnit
15. Objekt-relationales Mapping (JPA)
16. **NoSQL mit MongoDB und Java**
17. Zusammenfassung und Ausblick

## Abgleich mit dem Lehrbrief

Dieses Lehrbuch schließt genau die Lücken, die der Lehrbrief laut Vorgabe
offenlässt:

- **DCL/Rechte** → Kapitel 11
- **Prozeduren und Trigger** → Kapitel 12
- **Ausblick NoSQL** → Kapitel 16

Für diese drei Themen ist also das Lehrbuch die primäre Quelle (statt des
Lehrbriefs), inkl. jeweils eigener Fallstudien-Abschnitte und
Übungsaufgaben mit Lösungsvorschlägen im Buch selbst — gut geeignet als
Grundlage für eigene Übungen/Musterlösungen, aber wie gehabt nicht
wörtlich zu übernehmen.

Kapitel 13–15 (JDBC, Testen, ORM/JPA) sind laut Modulbeschreibung nicht
Pflichtinhalt dieses Kurses und werden hier nicht verplant — bleiben aber
als Option für eine spätere Erweiterung verfügbar.
