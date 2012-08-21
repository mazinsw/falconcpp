#include <stdio.h>
#include <stdlib.h>

int sum(int a, int b)
{
    return a + b;   
}

int main(int argc, char *argv[])
{
    int a, b, result;
    if(argc < 3)
        return 1;
    a = atoi(argv[1]);
    b = atoi(argv[2]);
    result = sum(a, b);
    return 0;
}
