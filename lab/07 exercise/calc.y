%{
#include <stdio.h>
#include <stdlib.h>
int yylex();
int yyerror();
int hex=0;
%}

/*tokens*/
%token HEXNUMBER NUMBER ADD SUB MUL DIV ABS EOL OP CP

%%

calclist: /* nothing */
	| calclist exp EOL	{ hex=0?printf("=%d\n",$2):printf("=0x%x\n",$2);}
;

exp: factor
	| exp ADD factor	{$$=$1+$3;}
	| exp SUB factor 	{$$=$1+$3;}
;

factor: term
	| factor MUL term	{$$=$1*$3;}
	| factor DIV term 	{$$=$1/$3;}
;

term: NUMBER
	| HEXNUMBER	{hex=1;}
	| ABS term	{$$ = $2>=0 ? $2: -$2;}
	| OP exp CP	{$$=$2;}
;

%%

int main(){
	yyparse();
}

int yyerror(char *s){
	fprintf(stderr,"error: %s\n",s);
}