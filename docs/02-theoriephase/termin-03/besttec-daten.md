---
typ: theoriephase-referenz
termin: 3
publish_date: 2026-11-03
---

# BestTec: Datenbestand

Zurück zu: [SQL-Abfragen mit BestTec](block-05.md) ·
[Eigene Abfragen und Datenänderung](block-06.md)

Diese Seite zeigt den Datenbestand der Fallstudie BestTec, mit dem ihr
in den Übungen dieses Termins arbeitet. Er entspricht dem
Datenbankzustand im Lehrbrief, Anhang 9.2 (S. 98), und wird durch die
Skripte
[uebung-05-besttec-datenbank.sql](code/uebung-05-besttec-datenbank.sql)
und [uebung-05-besttec-testdaten.sql](code/uebung-05-besttec-testdaten.sql)
in die Datenbank geladen.

`NULL` steht in den Tabellen für „kein Wert“.

| abtnr | bezeichnung | sitz |
|---|---|---|
| 10 | Zentrale | Gütersloh |
| 20 | Engineering | Verl |
| 30 | Automotive | Paderborn |
| 40 | Robotik | Bielefeld |
| 50 | Education | Münster |

| manr | name | job | vorgnr | gehalt | prov | abtnr |
|---|---|---|---|---|---|---|
| 7656 | Hansen | Geschäftsführer | NULL | 9800 | NULL | 10 |
| 7900 | Karl | Manager | 7656 | 7200 | NULL | 20 |
| 8801 | Langer | Vertrieb | 7656 | 4800 | 1200 | 10 |
| 7329 | Frohn | Programmierer | 7900 | 2900 | NULL | 20 |
| 8722 | Werther | Programmierer | 7900 | 2700 | NULL | 20 |
| 7643 | Kurt | Vertrieb | 8801 | 3100 | 900 | 10 |
| 7767 | John | Controller | 7656 | 4900 | NULL | 10 |
| 7783 | Kron | Manager | 7656 | 5200 | NULL | 50 |
| 8800 | Beier | Trainer | 7783 | 2700 | NULL | 50 |
| 7621 | Klaas | Trainer | 7783 | 3200 | NULL | 50 |
| 7768 | Schulte | Vertrieb | 8801 | 2900 | 500 | 10 |
| 7745 | Meier | Manager | 7656 | 5500 | NULL | 40 |
| 8956 | Dorn | Engineer | 7745 | 3000 | NULL | 40 |
| 7112 | Born | Manager | 7656 | 4800 | NULL | 30 |
| 8969 | Walter | Engineer | 7112 | 2500 | NULL | 30 |
| 8322 | Frei | Engineer | 7745 | 2500 | NULL | 40 |
| 7769 | Meyer | Engineer | 7900 | 5200 | NULL | 20 |
| 8659 | Sorge | Engineer | 7900 | 5800 | NULL | 20 |
| 8247 | Holle | Engineer | 7112 | 2900 | NULL | 30 |
| 7739 | Meier | Projektleiter | 7900 | 3200 | NULL | 20 |

| prjnr | abtnr | kdnr | titel |
|---|---|---|---|
| 232 | 20 | M341 | PeakControl |
| 244 | 10 | T56 | AutoRob |
| 212 | 20 | A12 | HydroControl |
| 256 | 20 | M341 | AvisyTurb |
