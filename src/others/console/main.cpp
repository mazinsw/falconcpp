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
#include <charsetdetect.h>
#define BUFFER_SIZE 4096

bool canAddQuotes(const wchar_t *str)
{
	wchar_t last = 0;
	while (str && *str)
	{
		if ((*str == L' ' || *str == L'\t') && last != L'\\')
			return true;
		last = *str++;
	}
	return false;
}

std::wstring get_appdata(std::wstring folder)
{
	wchar_t buffer[MAX_PATH];

#ifdef FALCON_PORTABLE
	int len = GetModuleFileNameW(GetModuleHandleW(NULL), buffer, MAX_PATH) - 1;
	while(len >= 0 && buffer[len] != L'\\')
		len--;
	buffer[len] = L'\0';
# ifndef NDEBUG
	wprintf(L"Console Path: %s\n", buffer);
# endif
#else
	SHGetSpecialFolderPathW(0, buffer, CSIDL_APPDATA, 0);
#endif
	return std::wstring(buffer) + L"\\" + folder + L"\\";
}

std::wstring ExtractPath(const wchar_t *file)
{
	const wchar_t *str = file;

	str += wcslen(file) - 1;
	while(str >= file && str[0] != L'\\' && str[0] != L'/')
		str--;
	return std::wstring(file, str - file + 1);
}

int CSD_ToCodePage(const char *enc)
{
	if(enc != NULL && strcmp(enc, "UTF-8") == 0)
		return CP_UTF8;
	if(enc != NULL && strcmp(enc, "OEM") == 0)
		return CP_OEMCP;
	return CP_ACP;
}

std::string ConvertToUtf8(const std::wstring& wstr, const char *enc = NULL)
{
	std::string convertedString;
	int cp = CSD_ToCodePage(enc);
	int requiredSize = WideCharToMultiByte(cp, 0, wstr.c_str(), -1, 0, 0, 0, 0);
	if(requiredSize > 0)
	{
		std::vector<char> buffer(requiredSize);
		WideCharToMultiByte(cp, 0, wstr.c_str(), -1, &buffer[0], requiredSize, 0, 0);
		convertedString.assign(buffer.begin(), buffer.end() - 1);
	}
	return convertedString;
}

std::wstring ConvertToUtf16(const std::string& str, const char *enc = NULL)
{
	std::wstring convertedString;
	int cp = CSD_ToCodePage(enc);
	int requiredSize = MultiByteToWideChar(cp, 0, str.c_str(), -1, 0, 0);
	if(requiredSize > 0)
	{
		std::vector<wchar_t> buffer(requiredSize);
		MultiByteToWideChar(cp, 0, str.c_str(), -1, &buffer[0], requiredSize);
		convertedString.assign(buffer.begin(), buffer.end() - 1);
	}

	return convertedString;
}

void find_files(const wchar_t *dir, const wchar_t *filter,
                std::vector<std::wstring>& files)
{
	WIN32_FIND_DATAW ffd;
	HANDLE hFind;
	std::wstring search = std::wstring(dir) + filter;

	hFind = FindFirstFileW(search.c_str(), &ffd);
	if (INVALID_HANDLE_VALUE == hFind)
		return;
	do
	{
		if (!(ffd.dwFileAttributes & FILE_ATTRIBUTE_DIRECTORY))
		{
			files.push_back(std::wstring(dir) + ffd.cFileName);
		}
	}
	while (FindNextFileW(hFind, &ffd) != 0);
	FindClose(hFind);
}

const char *detect_encoding(FILE *fp)
{
	csd_t csd = csd_open();
	if (csd == (csd_t) - 1)
	{
#ifndef NDEBUG
		printf("csd_open failed\n");
#endif
		return NULL;
	}

	int size;
	char buf[BUFFER_SIZE] = {0};

	while ((size = fread(buf, sizeof(char), sizeof(buf), fp)) != 0)
	{
		int result = csd_consider(csd, buf, size);
		if (result < 0)
		{
#ifndef NDEBUG
			printf("csd_consider failed\n");
#endif
			return NULL;
		}
		else if (result > 0)
		{
			// Already have enough data
			break;
		}
	}

	const char *result = csd_close(csd);
	if (result == NULL)
	{
#ifndef NDEBUG
		printf("Unknown character set\n");
#endif
		return NULL;
	}
	else
	{
#ifndef NDEBUG
		printf("%s\n", result);
#endif
		return result;
	}
}

int main(int argc, char **args)
{
	std::wstring alterfile, cfgfile, lngdir, apppath;
	std::wstring proc_ret = L"Process returned %ld   execution time : %0.3f s";
	std::wstring press_key = L"Press any key to continue.";
	std::wstring config_folder;
	INIReader *inif, *_inif;
	std::vector<std::wstring> files;
	std::vector<std::wstring>::iterator it;
	unsigned short lngid, ld_lngid;
	bool altercfg;

	wchar_t **argv = CommandLineToArgvW(GetCommandLineW(), &argc);
	if (argc < 2)
	{
		wprintf(L"Usage: ConsoleRunner <filename> <args ...>\n");
		return 1;
	}
	apppath = ExtractPath(argv[0]);
#ifdef FALCON_PORTABLE
	config_folder = L"Config";
#else
	config_folder = L"Falcon";
#endif
	cfgfile = get_appdata(config_folder) + L"Config.ini";
	inif = new INIReader(ConvertToUtf8(cfgfile));
#ifndef NDEBUG
	printf("%s: %d\n", ConvertToUtf8(cfgfile).c_str(), inif->ParseError());
#endif
	if(inif->ParseError() == 0)
	{
		altercfg = inif->GetBoolean("EnvironmentOptions", "AlternativeConfFile", false);
		if(altercfg)
		{
			alterfile = ConvertToUtf16(inif->Get("EnvironmentOptions", "ConfigurationFile",
			                                     ConvertToUtf8(cfgfile)));
			_inif = new INIReader(ConvertToUtf8(alterfile));
			if(_inif->ParseError() == 0)
			{
				delete inif;
				inif = _inif;
			}
		}
		lngdir = ConvertToUtf16(inif->Get("EnvironmentOptions", "LanguageDir",
		                                  ConvertToUtf8(apppath) + "Lang\\"));
		if(wcschr(lngdir.c_str(), L':') == NULL)
			lngdir = apppath + lngdir;

		lngid = inif->GetInteger("EnvironmentOptions", "LanguageID",
		                         GetSystemDefaultLangID());
	}
	else
	{
		lngdir = apppath + L"Lang\\";
		lngid = GetSystemDefaultLangID();
	}
	find_files(lngdir.c_str(), L"*.lng", files);
	ld_lngid = 0;
	const char *enc = NULL;
	for(it = files.begin(); it != files.end(); it++)
	{
		delete inif;
		FILE *fp = _wfopen((*it).c_str(), L"rb");
		if(fp != NULL)
		{
			enc = detect_encoding(fp);
			fclose(fp);
		}
		inif = new INIReader(ConvertToUtf8(*it));
		if(inif->ParseError() == 0)
		{
			ld_lngid = inif->GetInteger("FALCON", "LangID", 0);
			if(ld_lngid == lngid)
				break;
		}
	}
	if(ld_lngid == lngid)
	{
		proc_ret = ConvertToUtf16(inif->Get("FALCON", "6001", ConvertToUtf8(proc_ret)),
		                          enc);
		press_key = ConvertToUtf16(inif->Get("FALCON", "6002",
		                                     ConvertToUtf8(press_key)), enc);
	}
	delete inif;
	proc_ret = std::wstring(L"\n") + proc_ret;
	press_key = std::wstring(L"\n") + press_key + std::wstring(L"\n");
	// count size of arguments
	int fullsize = 0;
	for (int i = 1; i < argc; ++i)
	{
		fullsize += wcslen(argv[i]);
	}
	// add some slack for spaces between args plus quotes around executable
	fullsize += argc + 32;

	wchar_t *cmdline = new wchar_t[fullsize];
	wchar_t *consoleTitle = new wchar_t[fullsize];
	memset(cmdline, 0, fullsize);
	wcscpy(consoleTitle, argv[1]);
	//AnsiToOem(consoleTitle, consoleTitle);

	// 1st arg (executable) enclosed in quotes to support filenames with spaces
	bool sp = canAddQuotes(argv[1]);
	if (sp)
		wcscat(cmdline, L"\"");
	wcscat(cmdline, argv[1]);
	if (sp)
		wcscat(cmdline, L"\"");
	wcscat(cmdline, L" ");

	for (int i = 2; i < argc; ++i)
	{
		sp = canAddQuotes(argv[i]);
		if (sp)
			wcscat(cmdline, L"\"");
		wcscat(cmdline, argv[i]);
		if (sp)
			wcscat(cmdline, L"\"");
		wcscat(cmdline, L" ");
	}

	SetConsoleTitleW(consoleTitle);

	STARTUPINFOW si;
	PROCESS_INFORMATION pi;

	ZeroMemory( &si, sizeof(si) );
	si.cb = sizeof(si);
	ZeroMemory( &pi, sizeof(pi) );

	// Start the child process.
	clock_t cl = clock();
	CreateProcessW( NULL, TEXT(cmdline), NULL, NULL, FALSE, 0,
	                NULL, NULL, &si, &pi );

	// Wait until child process exits.
	WaitForSingleObject( pi.hProcess, INFINITE );
	cl = clock() - cl;

	// Get the return value of the child process
	DWORD ret;
	GetExitCodeProcess( pi.hProcess, &ret );

	// Close process and thread handles.
	CloseHandle( pi.hProcess );
	CloseHandle( pi.hThread );

	printf(ConvertToUtf8(proc_ret, "OEM").c_str(), ret,
	       ((float)cl) / CLOCKS_PER_SEC);
	printf(ConvertToUtf8(press_key, "OEM").c_str());
	getch();

	delete[] cmdline;
	delete[] consoleTitle;
	return ret;
}

