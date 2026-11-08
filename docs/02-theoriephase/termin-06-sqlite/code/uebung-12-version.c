#include <stdio.h>
#include "sqlite3.h" // (1)!

int main(void)
{
    printf("SQLite-Version: %s\n", sqlite3_libversion()); // (2)!
    return 0;
}
