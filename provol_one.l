%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>



extern void yyerror(const char*c);

#include "provol_one.tab.h"

char *p;


%}


%option noyywrap 





%%


ENTRADA  return(ENTRADA);

SAIDA  return(SAIDA); 

ENQUANTO return (ENQUANTO);

INC return(INC);

ZERA return (ZERA);

\n {return (EOL);}

[a-zA-z]+ {  
		p = (char*)malloc((strlen(yytext)+1)*sizeof(char));
		strcpy(p, yytext);
		yylval.istring = p;
		return(id);}


[=] { return ig; 
}


[(] {
	return opar;
}

[)] {
	return fepar;
}

[,] {
	return virgula;
}

. { yyerror("Token errado\n");}

%%


