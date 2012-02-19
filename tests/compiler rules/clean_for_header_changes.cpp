#include <iostream>
#include "clean_for_header_changes.h"

using namespace std;

int main(int argc, char *argv[])
{
#ifdef ERROR_CLEAN 
    cout << "#define ERROR_CLEAN\n";
#else
    cout << "ERROR_CLEAN not defined\n";
#endif
    cin.get();
    return 0;
}

