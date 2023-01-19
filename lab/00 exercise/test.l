%{
	#include <stdio.h>
	#include <stdlib.h>
	int x=3;
%}

%%

.*	{printf("%d\n",x);}

%%