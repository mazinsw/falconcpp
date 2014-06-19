
class Test
{
private:
	char c;
protected:
	int a;
public:
	Test& operator () (int index);
	Test& operator >> (int index);
	Test& operator << (int index);
	Test& operator < (int index);
	Test& operator > (int index);
	Test& operator = (int index);
	Test& operator == (int index);
	Test& operator != (int index);
	Test& operator >= (int index);
	Test& operator <= (int index);
	Test& operator | (int index);
	Test& operator || (int index);
	Test& operator & (int index);
	Test& operator && (int index);
	Test& operator ~ (int index);
	Test& operator ^ (int index);
	Test& operator + (int index);
	Test& operator - (int index);
	Test& operator * (int index);
	Test& operator / (int index);
	Test& operator delete (int index);
	Test& operator new (int index);
	int func2();
	Test& operator[](int index)
	{
		
	}
	int func1()
	{
		
	}
};