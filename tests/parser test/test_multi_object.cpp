class Foo
{
private:
	int privFoo;
protected:
	int protFoo;
	enum Color
	{
		red = 2, orange, yellow = 5, green,  blue, indigo, violet
	};
public:
	int publFoo;
	typedef enum
	{
		RANDOM, IMMEDIATE, SEARCH
	} Strategy;
	Foo() {}
	~Foo() {}

	class Bar
	{
	private:
		int privBar;
	protected:
		int protBar;
	public:
		int publBar;
		struct A
		{
			struct B
			{
				int type;
			};
		};
		union C: public B
		{
			A a;
			B b;
		} c;
	};
};