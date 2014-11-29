#include <stdio.h>

enum 
{
	red = 2, orange, yellow = 5, green,  blue, indigo, violet
} a;

enum state
{
	stop, run
} b;

typedef enum {RANDOM, IMMEDIATE, SEARCH} strategy[1];

int main()
{
	strategy s;
	s[0] = RANDOM;
	a = green;
	printf("%d\n", a);
	b = run;
	printf("%d\n", b);
	return 0;
}