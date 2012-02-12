#include "test_namespace.h"

namespace MyNamespace
{
    void TestNamespace::private_function()
    {

    }

    void TestNamespace::protected_function()
    {

    }

    void TestNamespace::public_function()
    {

    }
}

namespace MyExternalNamespace
{

    namespace MyInternalNamespace
    {
        void TestNamespace::private_function()
        {

        }

        void TestNamespace::protected_function()
        {

        }

        void TestNamespace::public_function()
        {

        }
    }
}

int main()
{
    return 0;
}

