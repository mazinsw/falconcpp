typedef std::reverse_iterator<const_iterator>
	const_reverse_iterator;

template<typename T>
void No<T>::add(No<T>* adj)
{
	adj->paret = this;
	adj->level = level + 1;
	childs.push_back(adj);
}

template<typename T>
No<T>::No(T info)
{
	nivel = 0;
	this->info = info;
	visitado = false;
	pai = NULL;
}

template<typename T>
No::~No()
{
	if(!raiz)
		delete raiz;
}
