#include <stdio.h>
#include "sqlite3.h"

static void insert_versuchen(sqlite3 *db, const char *text)
{
    char *fehler = NULL;
    int rc = sqlite3_exec(db,
        "INSERT INTO ma VALUES (9001, 'Neu', 'Tester', NULL, 3000, NULL, 99);",
        NULL, NULL, &fehler);

    if (rc == SQLITE_OK) {
        printf("%s: eingefuegt (Abteilung 99 gibt es gar nicht!)\n", text);
        sqlite3_exec(db, "DELETE FROM ma WHERE manr = 9001;", NULL, NULL, NULL);
    } else {
        printf("%s: Fehler %d (erweitert %d): %s\n", // (1)!
               text, rc, sqlite3_extended_errcode(db), fehler);
        sqlite3_free(fehler);
    }
}

int main(void)
{
    sqlite3 *db = NULL;
    if (sqlite3_open_v2("besttec.db", &db, SQLITE_OPEN_READWRITE, NULL) != SQLITE_OK) {
        fprintf(stderr, "Fehler beim Oeffnen: %s\n", sqlite3_errmsg(db));
        sqlite3_close(db);
        return 1;
    }

    insert_versuchen(db, "ohne PRAGMA");
    sqlite3_exec(db, "PRAGMA foreign_keys = ON;", NULL, NULL, NULL);
    insert_versuchen(db, "mit PRAGMA ");

    sqlite3_close(db);
    return 0;
}
