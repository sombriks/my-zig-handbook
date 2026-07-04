#include <stdio.h>

#include "foo.c"
#include "bar.c"

int main(int argc, char **argv) {
    int a = 2;
    int b = 2;
    foo(&a,&b);
    int c = bar(a,a);
    int d = bar(b,b);
    printf("a: %d, b: %d, c: %d, d: %d\n", a, b, c, d);
    return 0;
}
