#include "test_ADT.h"
#include <stdlib.h>

struct list
{
	void* data;
	List* next;
};

List* List_create() {
	List* l;

	l = (List*)malloc(sizeof(List));
	l->data = 0;
	l->next = (List*)malloc(sizeof(List));
	l->next->data = 0;
	l->next->next = (List*)malloc(sizeof(List));
	l->next->next->data = 0;
	return l;
}
