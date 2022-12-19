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

0x[0-9A-F]+	{ yylval=strtol(yytext,NULL,0); return HEXNUMBER; }

[ \t]	{ }

"\n"	{ return EOL; }

.	{ printf("Not allowed: %c\n",*yytext); }

%%

//Gestire gli esadecimali diocane