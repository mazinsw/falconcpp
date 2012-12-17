/*
 * This file is part of the Falcon C++ IDE and licensed under the GNU General 
 * Public License, version 3
 * http://www.gnu.org/licenses/gpl-3.0.html
 *
 */

#include <stdio.h>
#include <stdlib.h>
#define _WIN32_IE 0x0400
#include <windows.h>
#include <shlobj.h>
#include <time.h>
#include <conio.h>
#include <vector>
#include <string.h>
#include <locale.h>
#include "inih/cpp/INIReader.h"

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

std::string get_appdata(std::string folder)
{
    char buffer[MAX_PATH];

    SHGetSpecialFolderPath(0, buffer, CSIDL_APPDATA, 0);
    return std::string(buffer) + "\\" + folder + "\\";
}

std::string ExtractPath(const char * file)
{
    const char * str = file;

    str += strlen(file) - 1;
    while(str >= file && str[0] != '\\' && str[0] != '/')
        str--;
    return std::string(file, str - file + 1);
}

void find_files(const char * dir, const char * filter, std::vector<std::string>& files)
{
    WIN32_FIND_DATA ffd;
    HANDLE hFind;
    std::string search = std::string(dir) + filter;

    hFind = FindFirstFile(search.c_str(), &ffd);
    if (INVALID_HANDLE_VALUE == hFind)
        return;
    do
    {
        if (!(ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))
        {
            files.push_back(std::string(dir) + ffd.cFileName);
        }
    }
    while (FindNextFile(hFind, &ffd) != 0);
    FindClose(hFind);
}

int main(int argc, char** argv)
{
    std::string alterfile, cfgfile, lngdir, apppath;
    std::string proc_ret = "Process returned %ld   execution time : %0.3f s";
    std::string press_key = "Press any key to continue.";
    INIReader* inif, *_inif;
    std::vector<std::string> files;
    std::vector<std::string>::iterator it;
    unsigned short lngid, ld_lngid;
    bool altercfg;
    
    if (argc < 2)
    {
        printf("Usage: ConsoleRunner <filename> <args ...>\n");
        return 1;
    }
    apppath = ExtractPath(argv[0]);
    cfgfile = get_appdata("Falcon") + "Config.ini";
    inif = new INIReader(cfgfile);
    if(inif->ParseError() == 0)
    {
        altercfg = inif->GetBoolean("EnvironmentOptions", "AlternativeConfFile", false);
        if(altercfg)
        {
            alterfile = inif->Get("EnvironmentOptions", "ConfigurationFile", cfgfile);
            _inif = new INIReader(alterfile);
            if(_inif->ParseError() == 0)
            {
                delete inif;
                inif = _inif;
            }                                  
        }
        lngdir = inif->Get("EnvironmentOptions", "LanguageDir", apppath + "Lang\\");
        if(strchr(lngdir.c_str(), ':') == NULL)
            lngdir = apppath + lngdir;
        
        lngid = inif->GetInteger("EnvironmentOptions", "LanguageID", GetSystemDefaultLangID());
        find_files(lngdir.c_str(), "*.lng", files);
        ld_lngid = 0;
        for(it = files.begin(); it != files.end(); it++)
        {
            delete inif;
            inif = new INIReader(*it);
            if(inif->ParseError() == 0)
            {
                ld_lngid = inif->GetInteger("FALCON", "LangID", 0);
                if(ld_lngid == lngid)
                    break;
            } 
        }
        if(ld_lngid == lngid)
        {
            proc_ret = inif->Get("FALCON", "6001", proc_ret);
            press_key = inif->Get("FALCON", "6002", press_key);
        }
    }
    delete inif;
    proc_ret = std::string("\n") + proc_ret;
    press_key = std::string("\n") + press_key + std::string("\n");
    char* c_proc_ret = new char[proc_ret.length() + 1];
    AnsiToOem(proc_ret.c_str(), c_proc_ret);
    char* c_press_key = new char[press_key.length() + 1];
    AnsiToOem(press_key.c_str(), c_press_key);
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

    printf(c_proc_ret, ret, ((float)cl) / 1000);
    printf(c_press_key);

    getch();

    delete[] cmdline;
    delete[] consoleTitle;
    delete[] c_press_key;
    delete[] c_proc_ret;
    return ret;
}

