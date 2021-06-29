%{
#include <stdlib.h>
#include <stdio.h>
#include <string.h>



extern void yyerror(const char*c);

#include "provol_one.tab.h"

char *p;

const char *context;


int nline = 1;

%}


%option noyywrap 





%%



[ \t]+     {;}

\n {nline++; 
return(EOL);}



"ENTRADA" { 

		return(ENTRADA);}

"SAIDA" { 
		return(SAIDA); }

"ENQUANTO" {
			return (ENQUANTO);}

"INC" { 


 	return(INC);}


"FACA" {

	return (FACA);}


"FIM" {

	return (FIM);}



"ZERA" {
	return (ZERA);}

"DEC" {
	return (DEC);}

[=] { return (ig); 
}


[,] { return (virgula); 
}


[(] {

	return (opar);
}
[)] {

	return (fepar);
}






[a-zA-z]+ {  
	yylval.istring=strdup(yytext);
	
	return(id);}


.    {printf("--\n");}

%%


