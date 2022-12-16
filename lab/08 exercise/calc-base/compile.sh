bison -d calc.y
flex calc.l
cc calc.tab.c lex.yy.c funcs.c
./a.out
