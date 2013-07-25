#ifndef _PLUGIN_H_
#define _PLUGIN_H_
#include "plugin.h"

#include "plugin_begin.h"
/* Set up for C function definitions, even when using C++ */
#ifdef __cplusplus
extern "C" {
#endif

extern DECLSPEC int  FCPCALL Plugin_initialize(int handle, PluginInfo* info, void** data);
extern DECLSPEC int  FCPCALL Plugin_dispatchCommand(DispatchCommand* msg, 
	void* data);
extern DECLSPEC void FCPCALL Plugin_finalize(void* data);

/* Ends C function definitions when using C++ */
#ifdef __cplusplus
}
#endif
#include "plugin_end.h"

#endif /* _PLUGIN_H_ */