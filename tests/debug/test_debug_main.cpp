#include <stdio.h>
#include "test_debug_file.h"

int mult(float a, float b)
{
    float r;

    r = a + b;
    return r;
}

int main(int argc, char *argv[])
{
    int a, b, c;
    char name[10];
    //mult::r
    printf("Sum\n");
    printf("enter with a number: ");
    scanf("%d", &a);
    printf("enter with another number: ");
    scanf("%d", &b);
    c = sum(a, b);
    printf("a + b = %d\n", c);
    printf("Mult\n");
    printf("enter with a number: ");
    scanf("%d", &a);
    printf("enter with another number: ");
    scanf("%d", &b);
    c = mult(a, b);
    printf("a * b = %d\n", c);
    /*a + b*/
    fill(name);
    printf("%s\n", name);
    return 0;
}
