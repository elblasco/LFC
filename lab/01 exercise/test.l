%{
#include <stdio.h>
%}

%%

[0-9]+   printf("NUMBER\n");

[A-Za-z][a-zA-Z0-9]*   printf("WORD\n");

%%

//prima parte: dichiarazione ed opzioni
//seconda parte: pattern + codice C da eseguire
//terza parte: programma main (di default prende lo standard input)

//esercizio: gestire le maiuscole, minuscole e numeri