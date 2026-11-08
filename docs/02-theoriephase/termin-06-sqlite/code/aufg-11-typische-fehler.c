// Typische Fehler in KI-erzeugtem SQLite-Code (jeweils falsch und richtig).
// Die Funktionen sind nur Ausschnitte und werden nicht aufgerufen.
#include <stdio.h>
#include "sqlite3.h"

// --8<-- [start:f1]
static void f1_falsch(sqlite3 *db, const char *englisch, const char *deutsch)
{
    char sql[256];
    snprintf(sql, sizeof sql,
             "INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (1, '%s', '%s');",
             englisch, deutsch); // bricht bei einem Apostroph im Text
    sqlite3_exec(db, sql, NULL, NULL, NULL);
}

static void f1_richtig(sqlite3 *db, const char *englisch, const char *deutsch)
{
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(db,
        "INSERT INTO vokabel (lektion_id, englisch, deutsch) VALUES (1, ?, ?);",
        -1, &stmt, NULL);
    sqlite3_bind_text(stmt, 1, englisch, -1, SQLITE_TRANSIENT);
    sqlite3_bind_text(stmt, 2, deutsch, -1, SQLITE_TRANSIENT);
    sqlite3_step(stmt);
    sqlite3_finalize(stmt);
}
// --8<-- [end:f1]

// --8<-- [start:f2]
static void f2_falsch(sqlite3 *db)
{
    sqlite3_stmt *stmt = NULL;
    sqlite3_prepare_v2(db, "SELECT titel FROM lektion;", -1, &stmt, NULL);
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        printf("%s\n", sqlite3_column_text(stmt, 0));
    }
    // sqlite3_finalize fehlt: die Anweisung bleibt offen
}

static void f2_richtig(sqlite3 *db)
{
    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, "SELECT titel FROM lektion;", -1, &stmt, NULL) != SQLITE_OK) {
        return;
    }
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        printf("%s\n", sqlite3_column_text(stmt, 0));
    }
    sqlite3_finalize(stmt);
}
// --8<-- [end:f2]

// --8<-- [start:f3]
static void f3_falsch(sqlite3 *db, sqlite3_stmt *stmt)
{
    (void)db; // der Fehlertext wird nie abgefragt
    // Bei einem Fehler liefert step nie SQLITE_DONE: Endlosschleife
    while (sqlite3_step(stmt) != SQLITE_DONE) {
        printf("%s\n", sqlite3_column_text(stmt, 0));
    }
}

static void f3_richtig(sqlite3 *db, sqlite3_stmt *stmt)
{
    int rc;
    while ((rc = sqlite3_step(stmt)) == SQLITE_ROW) {
        printf("%s\n", sqlite3_column_text(stmt, 0));
    }
    if (rc != SQLITE_DONE) {
        fprintf(stderr, "Fehler: %s\n", sqlite3_errmsg(db));
    }
}
// --8<-- [end:f3]

// --8<-- [start:f4]
static int f4_falsch(sqlite3 **db)
{
    // Fremdschluessel bleiben aus: PRAGMA foreign_keys fehlt
    return sqlite3_open("vokabeln.db", db);
}

static int f4_richtig(sqlite3 **db)
{
    int rc = sqlite3_open_v2("vokabeln.db", db, SQLITE_OPEN_READWRITE, NULL);
    if (rc != SQLITE_OK) {
        return rc;
    }
    return sqlite3_exec(*db, "PRAGMA foreign_keys = ON;", NULL, NULL, NULL);
}
// --8<-- [end:f4]

// --8<-- [start:f5]
static void f5_falsch(sqlite3_stmt *stmt, int lektion_id)
{
    sqlite3_bind_int(stmt, 0, lektion_id); // Parameter zaehlen ab 1: Fehler SQLITE_RANGE
    sqlite3_step(stmt);
    printf("%s\n", sqlite3_column_text(stmt, 1)); // Spalten zaehlen ab 0
}

static void f5_richtig(sqlite3_stmt *stmt, int lektion_id)
{
    sqlite3_bind_int(stmt, 1, lektion_id);
    if (sqlite3_step(stmt) == SQLITE_ROW) {
        printf("%s\n", sqlite3_column_text(stmt, 0));
    }
}
// --8<-- [end:f5]
