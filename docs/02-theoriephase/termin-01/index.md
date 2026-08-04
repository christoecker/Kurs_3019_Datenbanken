---
typ: theoriephase-termin-uebersicht
termin: 1
datum: "2026-10-12"
thema_termin: "ER-Modell & Transformation"
workload_minuten: 15
lernziele:
  - "Ihr könnt die Kernbegriffe des ER-Modells (Entity-Typ, Beziehungstyp, Kardinalität, abhängiger Entity-Typ, Spezialisierung) und die sechs Transformationsregeln ins Relationenmodell aus dem Gedächtnis abrufen."
bearbeitungsstatus: entworfen
---

# 20.10.2026: Termin 1 — ER-Modell & Transformation

Heute geht es in zwei Schritten von der Idee zur fertigen
Datenbank-Struktur. Im ersten Block, [ER-Modell
aufstellen](block-01.md), modelliert ihr live gemeinsam ein neues
Fallbeispiel (eLibri) als ER-Diagramm und erweitert es anschließend
selbstständig. Im zweiten Block, [Transformation ins
Relationenmodell](block-02.md), überführt ihr genau dieses Modell
systematisch in ein Relationenschema — die Grundlage für die spätere
Implementierung in SQL Server (Termin 2). Beide Blöcke bauen direkt
aufeinander auf: Was ihr im ersten Block modelliert, transformiert ihr
im zweiten.

## Vorbereitung

<span class="zeitangabe">Zeitbedarf: ca. 15 Minuten.</span>

### Worum geht es?

Termin 1 baut ausschließlich auf Themen auf, die ihr in der
Praxisphase bereits vollständig durchgearbeitet habt — ER-Modell in
Woche 2+3, Transformation ins Relationenmodell in Woche 4–6. Diese
Vorbereitung ist deshalb bewusst kurz: Frischt die folgenden
Kernpunkte auf, dann seid ihr für beide Blöcke startklar.

### Zur Auffrischung

**Für Block 1 (ER-Modell aufstellen)** — aus Praxisphase Woche 2+3,
Lehrbrief Kap. 3:

- Entity-Typ, Attribut, Beziehungstyp: die drei Grundbausteine des
  ER-Modells (Kap. 3.2, S. 22–28).
- Kardinalitäten in Chen-Notation (nur Obergrenzen: 1/N/M) und in
  UML-Notation (auch Untergrenzen, z. B. `0..*`) (Kap. 3.3, S. 28–30).
- Abhängiger Entity-Typ: hat keinen eigenen Schlüssel, wird erst durch
  lokales Attribut **und** identifizierende Beziehung eindeutig
  (Kap. 3.4.1, S. 31).
- Spezialisierung: ein Subtyp "erbt" alle Attribute und Beziehungen
  seines Supertyps zusätzlich zu seinen eigenen (Kap. 3.4.2, S. 32–33).

**Für Block 2 (Transformation ins Relationenmodell)** — aus
Praxisphase Woche 4–6, Lehrbrief Kap. 4–5:

- Relation, Datensatz, Attribut, Wertebereich, Relationenschema: die
  Grundbegriffe des Relationenmodells (Kap. 4.1, S. 35–36).
- Primärschlüssel (PK) vs. Unique Key (UK): aus mehreren
  Schlüsselkandidaten wird genau einer zum PK, die übrigen bleiben UK
  (Kap. 4.2, S. 36–37).
- Fremdschlüssel (FK): referenziert den Schlüssel einer anderen — oder
  derselben — Relation (Kap. 4.3, S. 37–39).
- Die sechs Transformationsregeln (Kap. 5.1–5.3, S. 40–48):
    - **Regel 1 — Einfacher Entity-Typ:** wird zu einer eigenen
      Relation; das Schlüsselattribut wird Primärschlüssel (bei einem
      aus mehreren Attributen zusammengesetzten Schlüssel ggf. ein
      Surrogatschlüssel).
    - **Regel 2 — N:M-Beziehung:** eigene, neue Relation; ihr
      Primärschlüssel setzt sich aus den Fremdschlüsseln beider
      beteiligten Entity-Typen zusammen; Beziehungsattribute werden zu
      gewöhnlichen Attributen dieser neuen Relation.
    - **Regel 3 — 1:N-Beziehung:** Beziehung und Relation der N-Seite
      verschmelzen; diese erhält den Schlüssel der 1-Seite als
      Fremdschlüssel.
    - **Regel 4 — 1:1-Beziehung:** wie Regel 3, der neue Fremdschlüssel
      wird zusätzlich als Unique Key gekennzeichnet.
    - **Regel 5 — Abhängiger Entity-Typ:** sein Primärschlüssel setzt
      sich aus einem lokalen Attribut und dem Fremdschlüssel zum
      identifizierenden Entity-Typ zusammen.
    - **Regel 6 — Spezialisierung:** je eine Relation für Supertyp und
      jeden Subtyp; jede Subtyp-Relation erhält den Supertyp-Schlüssel
      als Fremd- **und** Primärschlüssel.
- Empfohlene Reihenfolge beim Transformieren eines vollständigen
  ER-Diagramms: zuerst Spezialisierungshierarchien, dann abhängige
  Entity-Typen, zuletzt die (normalen) Beziehungstypen — jeweils erst,
  nachdem die daran beteiligten Entity-Typen schon als Relation
  existieren (Kap. 5.5, S. 49).
