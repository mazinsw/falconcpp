namespace NA
{
    template <typename T>
    struct A {};
}

template <typename T>
struct B: public NA ::   A<NA::A<int> > {};