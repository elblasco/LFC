%{
#include <stdio.h>

int chars=0;

int words=0;

int lines=0;
%}

%%

[^ \t\r\n\f\v]+  { words++; chars+=strlen(yytext); }

\n { lines++; }

. { chars++; }

%%

int main(){
   yylex(); //scanner routine
   printf("Chars=%d \tWords=%d \tLines=%d\n",chars,words,lines);
}


//Scrivere il 2 in modo più elegante