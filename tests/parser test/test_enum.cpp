enum 
{
	red, orange, yellow, green,  blue, indigo, violet
} a;

typedef enum {RANDOM, IMMEDIATE, SEARCH} strategy[1];

int main()
{
	strategy s;
	s[0] = RANDOM;
	return 0;
}