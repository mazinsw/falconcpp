#include <windows.h>
#include "main.h"

// a sample exported function
void DLL_EXPORT MsgBox(const char * msg)
{
    MessageBox(0, msg, "DLL Test", MB_OK);
}

int DLL_EXPORT sum(int a, int b)
{
    return a + b;
}

BOOL WINAPI DllMain(HINSTANCE hinstDLL, DWORD fdwReason, LPVOID lpvReserved)
{
    switch(fdwReason)
    {
        case DLL_PROCESS_ATTACH:
            // attach to process
            // return FALSE to fail DLL load
            break;
        case DLL_PROCESS_DETACH:
            // detach from process
            break;
        case DLL_THREAD_ATTACH:
            // attach to thread
            break;
        case DLL_THREAD_DETACH:
            // detach from thread
            break;
    }
    return TRUE; // succesful
}

