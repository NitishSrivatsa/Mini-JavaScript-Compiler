CC=gcc

compiler: lex.yy.c header.h
	$(CC) lex.yy.c -ll -ly -o icgen -w

lex.yy.c: y.tab.c lexer.l
	lex lexer.l

y.tab.c: parser.y
	yacc -d parser.y

clean:
	$(RM) lex.yy.c asticg y.tab.c y.tab.h
