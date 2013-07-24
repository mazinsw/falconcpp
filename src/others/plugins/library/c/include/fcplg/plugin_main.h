#ifndef _PLUGIN_MAIN_H_
#define _PLUGIN_MAIN_H_

#ifdef __cplusplus
#define C_LINKAGE	"C"
#else
#define C_LINKAGE
#endif /* __cplusplus */

/** The prototype for the application's Plugin_main() function */
extern C_LINKAGE int Plugin_main(Plugin* plugin);

#endif /* _PLUGIN_MAIN_H_ */