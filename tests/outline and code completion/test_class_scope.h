#ifndef _TEST_CLASS_SCOPE_H_
#define _TEST_CLASS_SCOPE_H_

class MyClass
{
private:
    void my_private_func(int my_param);
protected:
    void my_protected_func(int my_param);
public:
    void my_public_func(int my_param);
};

class MyClassPrivate: private MyClass
{
private:
    void my_private_func1(int my_param);
protected:
    void my_protected_func1(int my_param);
public:
    void my_public_func1(int my_param);
};

class MyClassProtected: protected MyClass
{
private:
    void my_private_func2(int my_param);
protected:
    void my_protected_func2(int my_param);
public:
    void my_public_func2(int my_param);
};

class MyClassPublic: public MyClass
{
private:
    void my_private_func3(int my_param);
protected:
    void my_protected_func3(int my_param);
public:
    void my_public_func3(int my_param);
};

#endif

