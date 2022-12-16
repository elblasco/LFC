bison -d calc.y
flex calc.l
cc calc.tab.c lex.yy.c -lfl
./a.out