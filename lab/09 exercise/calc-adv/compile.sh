bison -d calc.y
flex calc.l
gcc calc.tab.c lex.yy.c funcs.c -lm
./a.out
