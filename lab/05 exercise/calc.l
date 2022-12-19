%{
#include "calc.tab.h"
%}

%%

"+"	{ return ADD; }

"-"	{ printf("MINUS\n"); }

"*"	{ printf("TIMES\n"); }

"/"	{ printf("DIVIDE\n"); }

"|"	{ printf("ABS\n"); }

[0-9]+	{ yylval=atoi(yytext); return NUMBER; }

[ \t]	{ }

"\n"	{ return EOL; }

.	{ printf("Not allowed: %s\n",yytext); }

%%