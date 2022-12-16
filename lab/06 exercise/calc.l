%{
#include "calc.tab.h"
%}

%%

"+"	{ return ADD; }

"-"	{ return SUB; }

"*"	{ return MUL; }

"/"	{ return DIV; }

"|"	{ return ABS; }

"("	{ return OP; }

")"	{ return CP; }

[0-9]+	{ yylval=atoi(yytext); return NUMBER; }

\-[0-9]+	{ yylval=atoi(yytext); return NUMBER; }

[ \t]	{ }

"\n"	{ return EOL; }

.	{ printf("Not allowed: %c\n",*yytext); }

%%