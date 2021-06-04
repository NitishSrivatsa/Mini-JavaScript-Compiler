CC=gcc

token: y.tab.c
	$(CC) y.tab.c -ll -ly -o phase1 -w

lex.yy.c: lexer.l
	lex lexical_analysis.l

y.tab.c: parser.y
	yacc -d parser.y

clean:
	$(RM) lex.yy.c y.tab.c y.tab.h token 
