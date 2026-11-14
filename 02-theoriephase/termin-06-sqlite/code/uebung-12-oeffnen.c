#include <stdio.h>
#include "sqlite3.h"

int main(void)
{
    sqlite3 *db = NULL; // (1)!
    int rc = sqlite3_open_v2("besttec.db", &db, SQLITE_OPEN_READWRITE, NULL); // (2)!
    if (rc != SQLITE_OK) { // (3)!
        fprintf(stderr, "Fehler beim Oeffnen: %s\n", sqlite3_errmsg(db)); // (4)!
        sqlite3_close(db);
        return 1;
    }

    char *fehler = NULL;
    rc = sqlite3_exec(db, "PRAGMA foreign_keys = ON;", NULL, NULL, &fehler); // (5)!
    if (rc != SQLITE_OK) {
        fprintf(stderr, "PRAGMA fehlgeschlagen: %s\n", fehler);
        sqlite3_free(fehler); // (6)!
        sqlite3_close(db);
        return 1;
    }

    printf("Datenbank geoeffnet, Fremdschluessel aktiv.\n");

    sqlite3_close(db); // (7)!
    return 0;
}
