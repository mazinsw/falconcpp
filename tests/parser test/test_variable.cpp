#include <vector>
namespace Test
{
	template <typename T> 
	class Class { static T a; };
}
int a;
char b, c;
long * d, * & e = d;
unsigned int f[] = {};
std::vector<std::vector<int> >::iterator * v[10][2] = {};

template <typename T> 
T Test::Class<T>::a = 0;
extern FILE (*_imp___iob)[];	/* A pointer to an array of FILE */
// зг