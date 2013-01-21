#ifndef _MAIN_H_
#define _MAIN_H_

/*  To use this exported function of dll, include this header
 *  in your project, if check create a linked library in project properties.
 *  or see a example how to use
 *  ****************************** load test *******************************
 *  #include <windows.h>
 *  #include <stdio.h>
 *  #include <stdlib.h>
 *  typedef void (*MsgBoxFunc)(const char * msg);
 *  typedef int (*sumFunc)(int a, int b);
 *  
 *  int main()
 *  {
 *      HMODULE hmod;
 *      MsgBoxFunc MsgBox;
 *      sumFunc sum;
 *      char msg[11];
 *      hmod = LoadLibrary("Project.dll");
 *      if(hmod == NULL)
 *      {
 *          printf("error Project.dll not found!\n");
 *          getchar();
 *          return 1;
 *      }
 *      MsgBox = (MsgBoxFunc)GetProcAddress(hmod, "MsgBox");
 *      sum = (sumFunc)GetProcAddress(hmod, "sum");
 *      sprintf(msg, "Sum 1 + 9 = %d", sum(1, 9));
 *      MsgBox(msg);
 *      FreeLibrary(hmod);
 *      return 0;
 *  }
 */

#ifdef BUILD_DLL
#  define DLL_EXPORT __declspec(dllexport)
#else
#  define DLL_EXPORT
#endif

#ifdef __cplusplus
extern "C"
{
#endif

void DLL_EXPORT MsgBox(const char * msg);

int DLL_EXPORT sum(int a, int b);

#ifdef __cplusplus
}
#endif

#endif /* _MAIN_H_ */