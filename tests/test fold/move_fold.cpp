namespace name
{
	int function()
	{
		int x;
	}
}

int function2()
{
	name::function();
	if(true)
	{
		name::function();
	}
	name::function();
	if(true)
	{
		name::function();
		if(true)
		{
			name::function();
		}
		name::function();
		if(true)
		{
			name::function();
		}
		name::function();
		if(true)
		{
			name::function();
		}
		name::function();
	}
	name::function();
}

int function3()
{
	if(true)
	{
		name::function();
	}
}

