#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sqlite3.h"

#define DB_DATEI "vokabeln.db"
#define ZEILE 128
#define MAX_VOKABELN 200

// --8<-- [start:hilfen]
static void eingabe_zeile(const char *frage, char *puffer, size_t groesse)
{
    printf("%s", frage);
    if (fgets(puffer, (int)groesse, stdin) == NULL) {
        puffer[0] = '\0';
        return;
    }
    puffer[strcspn(puffer, "\r\n")] = '\0';
}

static int eingabe_zahl(const char *frage)
{
    char puffer[ZEILE];
    eingabe_zeile(frage, puffer, sizeof puffer);
    return atoi(puffer); // 0 bei ungueltiger Eingabe; gueltige IDs beginnen bei 1
}

static int gleich_ohne_gross_klein(const char *a, const char *b)
{
    while (*a && *b) {
        if (tolower((unsigned char)*a) != tolower((unsigned char)*b)) {
            return 0;
        }
        a++;
        b++;
    }
    return *a == *b;
}

static void sql_fehler(sqlite3 *db, const char *wo)
{
    fprintf(stderr, "Datenbankfehler (%s): %s\n", wo, sqlite3_errmsg(db));
}
// --8<-- [end:hilfen]

// --8<-- [start:lektionen]
static void lektionen_anzeigen(sqlite3 *db)
{
    const char *sql =
        "SELECT l.lektion_id, l.titel, COUNT(v.vokabel_id) "
        "FROM lektion l LEFT JOIN vokabel v ON v.lektion_id = l.lektion_id "
        "GROUP BY l.lektion_id, l.titel ORDER BY l.lektion_id;";

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "Lektionen");
        return;
    }

    printf("\nNr  Lektion         Vokabeln\n");
    int rc;
    while ((rc = sqlite3_step(stmt)) == SQLITE_ROW) {
        printf("%-3d %-15s %d\n",
               sqlite3_column_int(stmt, 0),
               (const char *)sqlite3_column_text(stmt, 1),
               sqlite3_column_int(stmt, 2));
    }
    if (rc != SQLITE_DONE) {
        sql_fehler(db, "Lektionen lesen");
    }
    sqlite3_finalize(stmt);
}
// --8<-- [end:lektionen]

// --8<-- [start:abfragen]
static int vokabel_ids_laden(sqlite3 *db, int lektion_id, int nur_schwierige,
                             int ids[], int max)
{
    const char *sql_alle =
        "SELECT vokabel_id FROM vokabel WHERE lektion_id = ? ORDER BY RANDOM();";
    const char *sql_schwierig =
        "SELECT vokabel_id FROM vokabel WHERE lektion_id = ? AND falsch > richtig "
        "ORDER BY falsch - richtig DESC, RANDOM();";

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, nur_schwierige ? sql_schwierig : sql_alle,
                           -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "IDs laden");
        return 0;
    }
    sqlite3_bind_int(stmt, 1, lektion_id);

    int anzahl = 0;
    while (anzahl < max && sqlite3_step(stmt) == SQLITE_ROW) {
        ids[anzahl++] = sqlite3_column_int(stmt, 0);
    }
    sqlite3_finalize(stmt);
    return anzahl;
}

static int ergebnis_speichern(sqlite3 *db, int vokabel_id, int war_richtig)
{
    const char *sql =
        "UPDATE vokabel SET richtig = richtig + ?, falsch = falsch + ?, "
        "zuletzt_geprueft = datetime('now') WHERE vokabel_id = ?;";

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "Ergebnis speichern");
        return 0;
    }
    sqlite3_bind_int(stmt, 1, war_richtig ? 1 : 0);
    sqlite3_bind_int(stmt, 2, war_richtig ? 0 : 1);
    sqlite3_bind_int(stmt, 3, vokabel_id);

    int rc = sqlite3_step(stmt);
    if (rc != SQLITE_DONE) {
        sql_fehler(db, "Ergebnis speichern");
    }
    sqlite3_finalize(stmt);
    return rc == SQLITE_DONE;
}

static int vokabel_abfragen(sqlite3 *db, int vokabel_id)
{
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, "SELECT englisch, deutsch FROM vokabel WHERE vokabel_id = ?;",
                           -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "Vokabel lesen");
        return 0;
    }
    sqlite3_bind_int(stmt, 1, vokabel_id);

    int richtig = 0;
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        char antwort[ZEILE];
        printf("\n%s = ", (const char *)sqlite3_column_text(stmt, 0));
        eingabe_zeile("", antwort, sizeof antwort);

        const char *loesung = (const char *)sqlite3_column_text(stmt, 1);
        richtig = gleich_ohne_gross_klein(antwort, loesung);
        if (richtig) {
            printf("Richtig!\n");
        } else {
            printf("Falsch, richtig ist: %s\n", loesung);
        }
    }
    sqlite3_finalize(stmt);
    ergebnis_speichern(db, vokabel_id, richtig);
    return richtig;
}

static void lektion_abfragen(sqlite3 *db, int nur_schwierige)
{
    lektionen_anzeigen(db);
    int lektion_id = eingabe_zahl("Welche Lektion (Nr)? ");

    int ids[MAX_VOKABELN];
    int anzahl = vokabel_ids_laden(db, lektion_id, nur_schwierige, ids, MAX_VOKABELN);
    if (anzahl == 0) {
        printf("Keine passenden Vokabeln gefunden.\n");
        return;
    }

    int richtig = 0;
    for (int i = 0; i < anzahl; i++) {
        richtig += vokabel_abfragen(db, ids[i]);
    }
    printf("\nErgebnis: %d von %d richtig.\n", richtig, anzahl);
}
// --8<-- [end:abfragen]

// --8<-- [start:hinzufuegen]
static void vokabel_hinzufuegen(sqlite3 *db)
{
    lektionen_anzeigen(db);
    int lektion_id = eingabe_zahl("In welche Lektion? ");

    char englisch[ZEILE], deutsch[ZEILE];
    eingabe_zeile("Englisch: ", englisch, sizeof englisch);
    eingabe_zeile("Deutsch:  ", deutsch, sizeof deutsch);
    if (englisch[0] == '\0' || deutsch[0] == '\0') { // (1)!
        printf("Beide Felder muessen ausgefuellt sein.\n");
        return;
    }

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db,
            "INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (?, ?, ?);", // (2)!
            -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "Vokabel anlegen");
        return;
    }
    sqlite3_bind_int(stmt, 1, lektion_id); // (3)!
    sqlite3_bind_text(stmt, 2, englisch, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 3, deutsch, -1, SQLITE_TRANSIENT);

    int rc = sqlite3_step(stmt);
    int erweitert = sqlite3_extended_errcode(db); // (4)!
    if (rc == SQLITE_DONE) {
        printf("Gespeichert.\n");
    } else if (erweitert == SQLITE_CONSTRAINT_FOREIGNKEY) { // (5)!
        printf("Diese Lektion gibt es nicht.\n");
    } else {
        sql_fehler(db, "Vokabel anlegen");
    }
    sqlite3_finalize(stmt);
}
// --8<-- [end:hinzufuegen]

// --8<-- [start:statistik]
static void statistik_anzeigen(sqlite3 *db)
{
    const char *sql =
        "SELECT l.titel, COALESCE(SUM(v.richtig), 0), COALESCE(SUM(v.falsch), 0), " // (1)!
        "100.0 * SUM(v.richtig) / (SUM(v.richtig) + SUM(v.falsch)) " // (2)!
        "FROM lektion l LEFT JOIN vokabel v ON v.lektion_id = l.lektion_id " // (3)!
        "GROUP BY l.lektion_id, l.titel ORDER BY l.lektion_id;";

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "Statistik");
        return;
    }

    printf("\nLektion         richtig falsch Quote\n");
    int rc;
    while ((rc = sqlite3_step(stmt)) == SQLITE_ROW) {
        printf("%-15s %7d %6d ",
               (const char *)sqlite3_column_text(stmt, 0),
               sqlite3_column_int(stmt, 1),
               sqlite3_column_int(stmt, 2));
        if (sqlite3_column_type(stmt, 3) == SQLITE_NULL) { // (4)!
            printf("-\n");
        } else {
            printf("%.0f %%\n", sqlite3_column_double(stmt, 3));
        }
    }
    if (rc != SQLITE_DONE) {
        sql_fehler(db, "Statistik lesen");
    }
    sqlite3_finalize(stmt);
}
// --8<-- [end:statistik]

// --8<-- [start:loeschen]
static void lektion_loeschen(sqlite3 *db)
{
    lektionen_anzeigen(db);
    int lektion_id = eingabe_zahl("Welche Lektion loeschen? ");

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, "DELETE FROM lektion WHERE lektion_id = ?;",
                           -1, &stmt, NULL) != SQLITE_OK) {
        sql_fehler(db, "Lektion loeschen");
        return;
    }
    sqlite3_bind_int(stmt, 1, lektion_id);

    int rc = sqlite3_step(stmt);
    int erweitert = sqlite3_extended_errcode(db); // (1)!
    if (rc == SQLITE_DONE) {
        if (sqlite3_changes(db) == 0) { // (2)!
            printf("Diese Lektion gibt es nicht.\n");
        } else {
            printf("Lektion geloescht.\n");
        }
    } else if (erweitert == SQLITE_CONSTRAINT_FOREIGNKEY) { // (3)!
        printf("Die Lektion enthaelt noch Vokabeln und bleibt bestehen.\n");
    } else {
        sql_fehler(db, "Lektion loeschen");
    }
    sqlite3_finalize(stmt);
}
// --8<-- [end:loeschen]

// --8<-- [start:main]
int main(void)
{
    sqlite3 *db = NULL;
    int rc = sqlite3_open_v2(DB_DATEI, &db, SQLITE_OPEN_READWRITE, NULL);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "Datenbank '%s' laesst sich nicht oeffnen: %s\n",
                DB_DATEI, sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    char *fehler = NULL;
    if (sqlite3_exec(db, "PRAGMA foreign_keys = ON;", NULL, NULL, &fehler) != SQLITE_OK) {
        fprintf(stderr, "PRAGMA fehlgeschlagen: %s\n", fehler);
        sqlite3_free(fehler);
        sqlite3_close(db);
        return 1;
    }

    int wahl;
    do {
        printf("\n--- Vokabeltrainer ---\n"
               "1 Lektionen anzeigen\n"
               "2 Lektion abfragen\n"
               "3 Schwierige Vokabeln ueben\n"
               "4 Vokabel hinzufuegen\n"
               "5 Statistik\n"
               "6 Lektion loeschen\n"
               "0 Beenden\n");
        wahl = eingabe_zahl("Auswahl: ");
        switch (wahl) {
        case 1: lektionen_anzeigen(db); break;
        case 2: lektion_abfragen(db, 0); break;
        case 3: lektion_abfragen(db, 1); break;
        case 4: vokabel_hinzufuegen(db); break;
        case 5: statistik_anzeigen(db); break;
        case 6: lektion_loeschen(db); break;
        case 0: break;
        default: printf("Unbekannte Auswahl.\n");
        }
    } while (wahl != 0);

    sqlite3_close(db);
    return 0;
}
// --8<-- [end:main]
