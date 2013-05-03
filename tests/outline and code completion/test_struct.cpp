#include <stdio.h>
#include <stdlib.h>
#include <string.h>

typedef struct{
    char * sigla;
} UF;


typedef struct{
    char * pais;
    UF uf;
    char *cidade;
} Localizacao;

typedef struct{
    char sexo;
    char * nome;
    Localizacao loca[256];
} Info;

typedef struct{
    int idade;
    Info info;
} Aluno;

Aluno * test_trigger(int argument)
{
    return new Aluno;   
}

int main(int argc, char *argv[])
{
    Aluno a;
    
    a.idade = 20;
    printf("non zero");
    a
    .
    info.
    loca[10 /* comment */]    .    uf. sigla = (char*)"PI";
    test_trigger((int)"aaaaaaaa()*/")->info.loca;
    
    ((/* comment */ Aluno /* comment */ * )&a)
	->
	info.loca[0].uf.sigla = (char*)"SP";
    return 123;
}
