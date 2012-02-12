#include "test_debug_file.h"

int sum(int a, int b)
{
    int c;
    c = a + b;
    return c;
}

void fill(char * name)
{
    *name++ = 'F';   
    *name++ = 'a';
    *name++ = 'l';
    *name++ = 'c';
    *name++ = 'o';
    *name++ = 'n';
    *name++ = ' ';
    *name++ = 'C';
    *name++ = '+';
    *name++ = '+';
    *name++ = 0;
}
