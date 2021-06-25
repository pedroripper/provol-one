%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdarg.h>

int yylex(void);

extern FILE *yyin;
extern int yyparse();
extern int yylex();
FILE *comp;

char *codigo;

struct YYLTYPE;

extern void yyerror(const char*c);

%}


%union yylval{
char *istring;
};



%token ENQUANTO
%token ENTRADA
%token FIM
%token SAIDA
%token FACA
%token ZERA
%token INC 
%token opar
%token fepar
%token virgula
%token EOL
%token ig

%token <istring> id
%type <istring> varlist
%type <istring> cmd
%type <istring> cmds



%%

program: 
	ENTRADA varlist EOL SAIDA varlist cmds FIM EOL{
	printf("Passei por aqui 1 \n");
	strcat(codigo,"int func(");
	strcat(codigo,$2);
	strcat(codigo,"){\n");
	strcat(codigo,$6);
	strcat(codigo,"\n return ");
	strcat(codigo, $5);
	strcat(codigo,"; \n }");
	}
	;

varlist:
	id virgula varlist {
	
	strcat(codigo,$1);
	strcat(codigo, ", ");
	strcat(codigo,$3);
	}
	| id {strcat(codigo,$1);}
	;

cmds:
	cmd EOL cmds {
	strcat(codigo, $1);
	strcat(codigo, $3);
	}
	| cmd EOL {
	strcat(codigo, $1);
	}
	;

cmd:
	ENQUANTO id FACA cmds FIM EOL{
	strcat(codigo, "for(int temp= 0; temp <");
	strcat(codigo, $2);
	strcat(codigo, "; temp ++){\n");
	strcat(codigo, $4);
	strcat(codigo,"}");
	}
	| id ig id EOL{
	strcat(codigo, $1);
	strcat(codigo, " = ");
	strcat(codigo, $3);
	strcat(codigo, ";\n");
	}
	| INC opar id fepar EOL{
	strcat(codigo, $3);
	strcat(codigo, "++;\n");
	} 
	| ZERA opar id fepar EOL{
	strcat(codigo, $3);
	strcat(codigo, "=0;\n");
	} 
	;

%%



int main() {

	FILE *codigo_provolone = fopen("provolone_source.txt","r");
	
	comp = fopen("programa_c.c","w");
	fputs("#include <stdio.h>\n\n",comp);

	codigo = malloc(500*sizeof(char));

	yyin = codigo_provolone;

	do {
			yyparse();
	} while(!feof(yyin));


	fputs("int main(){\n",comp);
	fputs(codigo,comp);
	fputs("\n return 0;}",comp);



	return 0;
}

void yyerror(const char *s){
	
}