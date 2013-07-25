#ifndef _PLUGIN_UTILS_H_
#define _PLUGIN_UTILS_H_
#include "plugin.h"

#include "plugin_begin.h"
/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

unsigned short Plugin_makeShortCut(char ch, int state);

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif
#include "plugin_end.h"

#endif /* _PLUGIN_UTILS_H_ */