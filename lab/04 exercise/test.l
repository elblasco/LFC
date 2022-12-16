/*riconosce i token di calcolo*/

%%

"+"	{ printf("PLUS\n"); }

"-"	{ printf("MINUS\n"); }

"*"	{ printf("TIMES\n"); }

"/"	{ printf("DIVIDE\n"); }

"|"[0-9]+"|"	{ printf("ABS\n"); }

[0-9]+	{ printf("NUMBER %s\n",yytext); }

[ \t]	{ }

.	{ printf("Not allowed: %s\n",yytext); }

%%

//prima parte: dichiarazione ed opzioni
//seconda parte: pattern + codice C da eseguire
//terza parte: programma main (di default prende lo standard input)

//esercizio: riconoscere le operazioni matematiche
