%{
#include <stdio.h>
int yylex();
int yyerror();
%}

/*tokens*/
%token NUMBER ADD SUB MUL DIV ABS EOL OP CP

%%

calclist: /* nothing */
	| calclist exp EOL	{ printf("=%d\n",$2); }
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