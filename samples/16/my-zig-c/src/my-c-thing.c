#include <stdio.h>

#include "my-c-thing.h"

int my_function(int a, int b) {
    printf(" From C: the numbers are: %d, %d\n", a, b);
    return a + b;
}
