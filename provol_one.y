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

void yyerror(const char *s);

extern int nline;



%}


%union yylval{
char *istring;
int val;
};



%token <val> ENQUANTO 
%token <val> ENTRADA 
%token <val> FIM 
%token <val> SAIDA 
%token <val> FACA 
%token <val> ZERA 
%token <val> INC 
%token <val> opar 
%token <val> fepar 
%token <val> ig 
%token <val> virgula 
%token <val> EOL

%token <istring> id


%type <istring> varlist

%type <istring> cmd
%type <istring> cmds
%type <istring> program

%start program

%%

program: ENTRADA varlist EOL SAIDA id EOL cmds FIM{

	comp = fopen("programa_c.c","w");

	fputs("#include <stdio.h>\n\n",comp);


	char *varRes = (char*)malloc((strlen($2)+2*strlen($5)+strlen($7)+46)*sizeof(char));


	strcpy(varRes,"int func("); 
	strcat(varRes,$2);

	strcat(varRes,"){\n");    

	strcat(varRes,"int ");    
	strcat(varRes,$5);    
	strcat(varRes,";\n");    

	strcat(varRes,$7);
	strcat(varRes,"\n return "); 
	strcat(varRes, $5);
	strcat(varRes,"; \n }\n\n"); 

	strcat(varRes,"int main(){\n");	
	strcat(varRes,"\n return 0;\n}\0");
	printf("%s", varRes);	
	fputs(varRes, comp);


	free(varRes);

	exit(0);

	}
	;

varlist: id virgula varlist {


	char *varRes = (char*)malloc((strlen($1)+strlen($3)+6)*sizeof(char));
	strcpy(varRes,"int ");
	strcat(varRes,$1);
	strcat(varRes,",");
	strcat(varRes,$3);
	strcat(varRes,"\0");
	$$ = varRes;
	}
	| id {	

	char *varRes = (char*)malloc((strlen($1)+5)*sizeof(char));
	strcpy(varRes,"int ");
	strcat(varRes,$1);
	strcat(varRes,"\0");
	$$ = varRes;

	}
	;

	



cmds:
	cmd EOL cmds {


	char *varRes = (char*)malloc((strlen($1)+strlen($3)+2)*sizeof(char));
	strcpy(varRes,$1);
	strcat(varRes,"\n");
	strcat(varRes, $3);
	strcat(varRes,"\0");
	$$ = varRes;
	}
	| cmd EOL{
	char *varRes = (char*)malloc((strlen($1)+2)*sizeof(char));
	strcpy(varRes,$1);
	strcat(varRes,"\n\0");
	$$ = varRes;
	}
	;

cmd:
	ENQUANTO id FACA EOL cmds FIM{

	char *varRes = (char*)malloc((strlen($2)+strlen($5)+16)*sizeof(char));
	strcpy(varRes, "do{\n"); 
	strcat(varRes, $5);
	strcat(varRes, "\n}while("); 
	strcat(varRes, $2);
	strcat(varRes,");\n\0"); 
	$$ =varRes;
	}
	| id ig id{

	char *varRes = (char*)malloc((strlen($1)+strlen($3)+4)*sizeof(char));
	strcpy(varRes,$1);
	strcat(varRes,"=");
	strcat(varRes,$3);
	strcat(varRes,";\n\0");
	$$ =varRes;

	}
	| INC opar id fepar{

	char *varRes = (char*)malloc((strlen($3)+5)*sizeof(char));
	strcpy(varRes, $3);
	strcat(varRes, "++;\n\0");
	$$ = varRes;
	} 
	| ZERA opar id fepar{

	char *varRes = (char*)malloc((strlen($3)+5)*sizeof(char));
	strcpy(varRes, $3);
	strcat(varRes, "=0;\n\0");
	$$ = varRes;
	} 
	;

%%



int main() {

	FILE *codigo_provolone = fopen("provolone_source.txt","r");
	

	yyin = codigo_provolone;

	yyparse();	



	return 0;
}

void yyerror(const char *s) {
   fprintf(stderr, "%s\nLine %d\n", s, nline);
};