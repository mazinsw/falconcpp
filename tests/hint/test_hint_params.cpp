#include <stdio.h>
#include <stdlib.h>

typedef int (*my_sum)(int a, int b);

typedef struct
{
    int a, b;
    my_sum sum;
} MyResult;

int test() {}

int test(int param1) {}

int test(int param1, int param2){}

int test(int param1, int param2, int updown_now){}

int test(int param1, int param2, int updown_now, int cont){}

int test(int param1, int param2, int updown_now, int cont, ...){}

int main(int argc, char *argv[])
{
    MyResult mr = {};
    test(test, s, a);
    main(main(argc, argv), main(argc, "dsdsd"));
    mr.sum();
    return 0;
}

