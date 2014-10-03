class Foo
{
private:
	int privFoo;
protected:
	int protFoo;
public:
	int publFoo;

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
		
	};
};