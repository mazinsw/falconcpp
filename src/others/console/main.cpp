/*
 * This file is part of the Falcon C++ IDE and licensed under the GNU General 
 * Public License, version 3
 * http://www.gnu.org/licenses/gpl-3.0.html
 *
 */

#include <stdio.h>
#include <stdlib.h>
#include <windows.h>
#include <time.h>
#include <conio.h>
#include <string.h>

bool canAddQuotes(const char* str)
{
    char last = 0;
    while (str && *str)
    {
        if ((*str == ' ' || *str == '\t') && last != '\\')
            return true;
        last = *str++;
    }
    return false;
}

int main(int argc, char** argv)
{
    if (argc < 2)
    {
        printf("Usage: ConsoleRunner <filename> <args ...>\n");
        return 1;
    }

    // count size of arguments
    int fullsize = 0;
    for (int i = 1; i < argc; ++i)
    {
        fullsize += strlen(argv[i]);
    }
    // add some slack for spaces between args plus quotes around executable
    fullsize += argc + 32;

    char* cmdline = new char[fullsize];
    char* consoleTitle = new char[fullsize];
    memset(cmdline, 0, fullsize);
    strcpy(consoleTitle, argv[1]);
    AnsiToOem(consoleTitle, consoleTitle);

    // 1st arg (executable) enclosed in quotes to support filenames with spaces
    bool sp = canAddQuotes(argv[1]);
    if (sp)
        strcat(cmdline, "\"");
    strcat(cmdline, argv[1]);
    if (sp)
        strcat(cmdline, "\"");
    strcat(cmdline, " ");

    for (int i = 2; i < argc; ++i)
    {
        sp = canAddQuotes(argv[i]);
        if (sp)
            strcat(cmdline, "\"");
        strcat(cmdline, argv[i]);
        if (sp)
            strcat(cmdline, "\"");
        strcat(cmdline, " ");
    }

    SetConsoleTitle(consoleTitle);

    STARTUPINFO si;
    PROCESS_INFORMATION pi;

    ZeroMemory( &si, sizeof(si) );
    si.cb = sizeof(si);
    ZeroMemory( &pi, sizeof(pi) );

    // Start the child process. 
    clock_t cl = clock();
    CreateProcess( NULL, TEXT(cmdline), NULL, NULL, FALSE, 0,
                   NULL, NULL, &si, &pi );

    // Wait until child process exits.
    WaitForSingleObject( pi.hProcess, INFINITE );
    cl = clock() - cl;
    cl *= 1000;
    cl /= CLOCKS_PER_SEC;

    // Get the return value of the child process
    DWORD ret;
    GetExitCodeProcess( pi.hProcess, &ret );

    // Close process and thread handles.
    CloseHandle( pi.hProcess );
    CloseHandle( pi.hThread );

    printf("\nProcess returned %ld   execution time : %0.3f s", ret, ((float)cl) / 1000);
    printf("\nPress any key to continue.\n");

    getch();

    delete[] cmdline;
    delete[] consoleTitle;
    return ret;
}

