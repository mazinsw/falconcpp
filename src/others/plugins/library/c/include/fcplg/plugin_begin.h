#ifdef _PLUGIN_BEGIN_H_
# error Include plugin_end.h at end of header
#endif

#ifndef DECLSPEC
# ifdef BUILD_DLL
#  define DECLSPEC __declspec(dllexport)
# else
#  define DECLSPEC
# endif
#endif
#define FCPCALL __cdecl
