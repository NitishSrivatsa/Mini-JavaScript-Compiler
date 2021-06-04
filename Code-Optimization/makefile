CC=gcc

optimizer: lex.yy.c y.tab.c
	$(CC) lex.yy.c y.tab.c -ll -ly -o icgopt -w

lex.yy.c: y.tab.c lexer.l
	lex lexer.l

y.tab.c: parser.y
	yacc -d parser.y

clean:
	$(RM) lex.yy.c y.tab.c y.tab.h optimizer
