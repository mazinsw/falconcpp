#ifndef _TEST_NAMESPACE_H_
#define _TEST_NAMESPACE_H_

namespace MyNamespace
{

    class TestNamespace2
    {
    private:
        int private_field;
        void private_function();
    protected:
        int protected_field;
        void protected_function();
    public:
        int public_field;
        void public_function();
    };

}

namespace MyExternalNamespace
{

    namespace MyInternalNamespace
    {
        class TestNamespace2
        {
        private:
            int private_field2;
            void private_function2();
        protected:
            int protected_field2;
            void protected_function2();
        public:
            int public_field2;
            void public_function2();
        };

    }
}

#endif

