%{
#include <stdio.h>
int yylex();
int yyerror();
%}

/*tokens*/
%token NUMBER ADD EOL

%%

calclist: /* nothing */
	| calclist exp EOL	{ printf("=%d\n",$2); }
;

exp: NUMBER				/*default: $$=$1*/
	| exp ADD NUMBER	{ $$=$1+$3; }
;

%%

int main(){
	yyparse();
}

int yyerror(char *s){
	fprintf(stderr,"error: %s\n",s);
}