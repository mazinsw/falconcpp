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
        void TestNamespace::private_function2()
        {

        }

        void TestNamespace::protected_function2()
        {

        }

        void TestNamespace::public_function2()
        {

        }
    }
}

int main()
{
    return 0;
}

