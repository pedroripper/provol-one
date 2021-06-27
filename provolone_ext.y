

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
%token <val> DEC
%token <val> INC 
%token <val> opar 
%token <val> fepar 
%token <val> ig 
%token <val> virgula 
%token <val> EOL
%token <val> SE
%token <val> ENTAO
%token <val> SENAO
%token <val> VEZES

%token <istring> id


%type <istring> varlist

%type <istring> cmd
%type <istring> cmds
%type <istring> program

%start program

%%




program: ENTRADA varlist EOL SAIDA id EOL cmds FIM{

	comp = fopen("programa_provolone_saida.txt","w");



	char *varRes = (char*)malloc((strlen($2)+strlen($5)+strlen($7)+21)*sizeof(char));

	sprintf(varRes,"ENTRADA %s\nSAIDA %s\n%s\nFIM\n", $2, $5, $7 );


	printf("%s", varRes);	
	fputs(varRes, comp);


	free(varRes);

	exit(0);

	}
	;


varlist: id virgula varlist {


	char *varRes = (char*)malloc((strlen($1)+strlen($3)+4)*sizeof(char));
	strcat(varRes,$1);
	strcat(varRes," , ");
	strcat(varRes,$3);
	strcat(varRes,"\0");
	$$ = varRes;
	}
	| id {	

	char *varRes = (char*)malloc((strlen($1)+1)*sizeof(char));
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
	strcat(varRes,"\0");
	$$ = varRes;
	}
	;

cmd:
	SE id ENTAO EOL cmds FIM {
	char *varRes = (char*)malloc((strlen($2)+strlen($5)+46)*sizeof(char));
	strcpy(varRes, "temp = "); 
	strcat(varRes, $2);
	strcat(varRes, "\n"); 
	strcat(varRes,"ENQUANTO ");
	strcat(varRes,"temp"); 
	strcat(varRes,"\n"); 
	strcat(varRes, "FACA\n"); 
	strcat(varRes,$5);
	strcat(varRes,"ZERA ( temp )");
	strcat(varRes,"\nFIM\0"); 
	$$ = varRes;

	} 
	| SE id ENTAO EOL cmds SENAO EOL cmds FIM{
	char *varRes = (char*)malloc((2*strlen($2)+strlen($5)+strlen($8)+145)*sizeof(char));
	strcpy(varRes, "tempi = "); 	
	strcat(varRes, $2);
	strcat(varRes, "\n");           
	strcat(varRes, "INC ( tempi )");   
	strcat(varRes,"ENQUANTO tempi\n");   
	strcat(varRes, "FACA"); 			
	strcpy(varRes, "tempii = "); 		
	strcat(varRes, $2);
	strcat(varRes,"ENQUANTO tempii\n"); 
	strcat(varRes, "FACA\n"); 			
	strcat(varRes, $5); 
	strcat(varRes, "ZERA ( tempi )\n"); 
	strcat(varRes, "ZERA ( tempii )\n"); 
	strcat(varRes, "FIM\n");  
	strcat(varRes,"ENQUANTO tempi\n"); 
	strcat(varRes,"FACA\n"); 
	strcat(varRes, $8); 
	strcat(varRes, "ZERA ( tempi )\n"); 
	strcat(varRes, "FIM\nFIM\0"); 

	$$ = varRes;

	}|
	FACA EOL cmds EOL id VEZES EOL FIM {
	char *varRes = (char*)malloc((strlen($3)+strlen($5)+39)*sizeof(char));
	printf("Trab");
	strcpy(varRes, "tempiii = "); 
	strcat(varRes, $5);
	strcat(varRes, "\nENQUANTO "); 
	strcat(varRes, "tempiii FACA\n"); 
	strcat(varRes,$3); 
	strcat(varRes,"\nFIM\0"); 
	$$ =varRes;
	
	}
	| ENQUANTO id FACA EOL cmds FIM{

	char *varRes = (char*)malloc((strlen($2)+strlen($5)+20)*sizeof(char));
	sprintf(varRes,"ENQUANTO %s FACA\n%s\nFIM",$2,$5);
	$$ =varRes;
	}
	| id ig id{

	char *varRes = (char*)malloc((strlen($1)+strlen($3)+2)*sizeof(char));
	strcpy(varRes,$1);
	strcat(varRes," = ");
	strcat(varRes,$3);
	strcat(varRes,"\0");
	$$ =varRes;

	}
	| INC opar id fepar{
	char *varRes = (char*)malloc((strlen($3)+10)*sizeof(char));
	strcpy(varRes, "INC ( ");
	strcat(varRes, $3);
	strcat(varRes, " )\n\0");
	$$ = varRes;
	} 
	| ZERA opar id fepar{
	char *varRes = (char*)malloc((strlen($3)+11)*sizeof(char));
	strcpy(varRes, "ZERA ( ");
	strcat(varRes, $3);
	strcat(varRes, " )\n\0");
	$$ = varRes;
	}
	| DEC opar id fepar {
	char *varRes = (char*)malloc((strlen($3)+10)*sizeof(char));
	strcpy(varRes, "DEC ( ");
	strcat(varRes, $3);
	strcat(varRes, " )\n\0");
	$$ = varRes;
	} 
	;




%%



int main() {

	FILE *codigo_provolone = fopen("provolone_source_2.txt","r");
	

	yyin = codigo_provolone;

	yyparse();	



	return 0;
}

void yyerror(const char *s) {
   fprintf(stderr, "%s\nLine %d\n", s, nline);
};





