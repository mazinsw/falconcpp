#include "test_class_scope.h"

void MyClass::my_private_func(int my_param)
{
    this->my_private_func(10);
    this->my_protected_func(10);
    this->my_public_func(10);
}
void MyClass::my_protected_func(int my_param){}
void MyClass::my_public_func(int my_param){}

void MyClassPrivate::my_private_func1(int my_param)
{
    this->my_private_func1(10);
    this->my_protected_func1(10);
    this->my_public_func1(10);
    this->my_protected_func(10);
    this->my_public_func(10);
}
void MyClassPrivate::my_protected_func1(int my_param){}
void MyClassPrivate::my_public_func1(int my_param){}

void MyClassProtected::my_private_func2(int my_param)
{
    this->my_private_func2(10);
    this->my_protected_func2(10);
    this->my_public_func2(10); 
    this->my_protected_func(10);
    this->my_public_func(10);  
}
void MyClassProtected::my_protected_func2(int my_param){}
void MyClassProtected::my_public_func2(int my_param){}

void MyClassPublic::my_private_func3(int my_param)
{
    this->my_private_func3(10);
    this->my_protected_func3(10);
    this->my_public_func3(10);
    this->my_protected_func(10);
    this->my_public_func(10);
}
void MyClassPublic::my_protected_func3(int my_param){}
void MyClassPublic::my_public_func3(int my_param){}

int main()
{
    MyClass mc;
    MyClassPrivate mc_private;
    MyClassProtected mc_protected;
    MyClassPublic mc_public;
    
    mc.my_public_func(10);

    mc_private.my_public_func1(10);
    // don't call, don't show hint
#ifdef NDEBUG
    mc_private.my_public_func(10);
    mc_private.my_protected_func(10);
    mc_private.my_protected_func1(10);
    mc_private.my_private_func(10);
    mc_private.my_private_func1(10);
#endif

    mc_protected.my_public_func2(10);
    // don't call, don't show hint
#ifdef NDEBUG
    mc_protected.my_public_func(10);
    mc_protected.my_protected_func(10);
    mc_protected.my_protected_func2(10);
    mc_protected.my_private_func(10);
    mc_protected.my_private_func2(10);
#endif
    
    mc_public.my_public_func(10);
    mc_public.my_public_func3(10);
    // don't call, don't show hint
#ifdef NDEBUG
    mc_public.my_protected_func(10);
    mc_public.my_protected_func3(10);
    mc_public.my_private_func(10);
    mc_public.my_private_func3(10);
#endif
    return 0;   
}
