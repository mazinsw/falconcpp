#include "plugin_utils.h"

unsigned short Plugin_makeShortCut(char ch, int state)
{
	unsigned short sc = (unsigned char)ch;
	
	return sc | state;
}
