#include <stdio.h>
#include <string.h>
#include "sqlite3.h"

// --8<-- [start:unsicher]
static void suche_unsicher(sqlite3 *db, const char *eingabe)
{
    char sql[256];
    snprintf(sql, sizeof sql,
             "SELECT name, job FROM ma WHERE name = '%s';", eingabe); // (1)!

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) { // (2)!
        printf("  Fehler: %s\n", sqlite3_errmsg(db));
        return;
    }
    int treffer = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        printf("  %s (%s)\n", sqlite3_column_text(stmt, 0), sqlite3_column_text(stmt, 1));
        treffer++;
    }
    printf("  %d Treffer\n", treffer);
    sqlite3_finalize(stmt);
}
// --8<-- [end:unsicher]

// --8<-- [start:sicher]
static void suche_sicher(sqlite3 *db, const char *eingabe)
{
    const char *sql = "SELECT name, job FROM ma WHERE name = ?;"; // (1)!

    sqlite3_stmt *stmt = NULL;
    if (sqlite3_prepare_v2(db, sql, -1, &stmt, NULL) != SQLITE_OK) { // (2)!
        printf("  Fehler: %s\n", sqlite3_errmsg(db));
        return;
    }
    sqlite3_bind_text(stmt, 1, eingabe, -1, SQLITE_TRANSIENT); // (3)!

    int treffer = 0;
    while (sqlite3_step(stmt) == SQLITE_ROW) {
        printf("  %s (%s)\n", sqlite3_column_text(stmt, 0), sqlite3_column_text(stmt, 1));
        treffer++;
    }
    printf("  %d Treffer\n", treffer);
    sqlite3_finalize(stmt);
}
// --8<-- [end:sicher]

int main(void)
{
    sqlite3 *db = NULL;
    if (sqlite3_open_v2("besttec.db", &db, SQLITE_OPEN_READONLY, NULL) != SQLITE_OK) {
        fprintf(stderr, "Fehler beim Oeffnen: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    char eingabe[100];
    printf("Name: ");
    if (fgets(eingabe, sizeof eingabe, stdin) == NULL) {
        sqlite3_close(db);
        return 1;
    }
    eingabe[strcspn(eingabe, "\r\n")] = '\0';

    printf("Mit sprintf:\n");
    suche_unsicher(db, eingabe);
    printf("Mit bind:\n");
    suche_sicher(db, eingabe);

    sqlite3_close(db);
    return 0;
}
