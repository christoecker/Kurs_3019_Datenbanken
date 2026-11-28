#include <stdio.h>
#include "sqlite3.h"

int main(void)
{
    sqlite3 *db = NULL;
    int rc = sqlite3_open_v2("besttec.db", &db, SQLITE_OPEN_READWRITE, NULL);
    if (rc != SQLITE_OK) {
        fprintf(stderr, "Fehler beim Oeffnen: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }
    sqlite3_exec(db, "PRAGMA foreign_keys = ON;", NULL, NULL, NULL);

    // --8<-- [start:abfrage]
    const char *sql =
        "SELECT m.name, m.job, m.gehalt, m.prov "
        "FROM ma m JOIN abt a ON m.abtnr = a.abtnr "
        "WHERE a.bezeichnung = 'Zentrale' "
        "ORDER BY m.gehalt DESC;";

    sqlite3_stmt *stmt = NULL;
    rc = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL); // (1)!
    if (rc != SQLITE_OK) {
        fprintf(stderr, "Fehler im SQL: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    while ((rc = sqlite3_step(stmt)) == SQLITE_ROW) { // (2)!
        const char *name = (const char *)sqlite3_column_text(stmt, 0); // (3)!
        const char *job = (const char *)sqlite3_column_text(stmt, 1);
        double gehalt = sqlite3_column_double(stmt, 2);

        printf("%-10s %-15s %8.2f", name, job, gehalt);
        if (sqlite3_column_type(stmt, 3) == SQLITE_NULL) { // (4)!
            printf("  keine Provision\n");
        } else {
            printf("  Provision %.2f\n", sqlite3_column_double(stmt, 3));
        }
    }
    if (rc != SQLITE_DONE) { // (5)!
        fprintf(stderr, "Fehler beim Lesen: %s\n", sqlite3_errmsg(db));
    }

    sqlite3_finalize(stmt); // (6)!
    // --8<-- [end:abfrage]

    sqlite3_close(db);
    return 0;
}
