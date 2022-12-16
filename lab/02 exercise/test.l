%{
#include <stdio.h>

int chars=0;

int words=0;

int lines=0;
%}

%%

[a-zA-Z0-9]+  { words++; chars+=strlen(yytext); }

\n { lines++; }

%%

int main(){
   yylex(); //scanner routine
   printf("Chars=%d \tWords=%d \tLines=%d\n",chars,words,lines);
}

//esercizio: contare caratter, parole e linee