%{

	int yyparse(void);
	int yylex(void);
	void yyerror(char *);
	int scs[100]={0},stop=1,sid=1, elno=1,lbl=0,tmp=0;
	char *ygbl,bbuf[1000],ysign[10];

	#include<string.h>
	#include"header.h"
	#include"y.tab.c"

	void yyerror(char *a){
		printf("\nError in line %d, %s\n", elno,a);
		return;
	}
	
	int main(int argc, char *argv[]){
		if(argc == 2){
			yyin = fopen(argv[1],"r");
		}
		yyparse();
		printall();
		return 0;
	}

%}

%%

\/\*([^*]|\*[^/])*\*\/			;
\/\/[^\n]*						;
var 				{return T_VAR;}
def 				{return T_DEF;}
if					{return T_IF; }
else				{return T_ELSE;}
do					{return T_DO;}
while 				{return T_WHILE;}
in					{return T_IN;}
let					{return T_LET;}
for					{return T_FOR;}
break|case|catch|continue|debugger|default|delete|do|else|finally|for|function|if|in|instanceof|new|return|switch|this|throw|try|typeof|var|void|while|with		  {return T_KEY;}
([a-zA-Z]|\_)([a-zA-Z0-9]|\_)* 		{ygbl=strdup(yytext);return T_ID;}
[0-9]+(\.[0-9]+)?(E[-+]?[0-9]+)? 	{mkentr(2,yytext,0);return T_NUM;}

[\[\(\{]			{return yytext[0];}
[\]\)\}]			{return yytext[0];}

\"([^"]|\\\")*\"|\'([^']|\\\')*\' 	{mkentr(1,yytext,0);return T_STR;}

=					{return '=';}
\.					{return '.';}
[+\-*/^&|]=			{return T_SHA;}
(&&|\|\|)			{strcpy(ysign,yytext);return T_LCG;}
([<>]|==)=?			{strcpy(ysign,yytext);return T_LOP;}
,					{return ',';}
[+-]				{strcpy(ysign,yytext);return T_OP1;}
[*/^&|]				{strcpy(ysign,yytext);return T_OP2;}
\*\*				{strcpy(ysign,yytext);return T_OP3;}
(\+\+|\-\-)			{return T_OP4;}
;					{return ';';}
[\n]				{elno++;return '\n';}
[\t ]	            ;	

%%

//printf("*************\n************\nafter %d line , symbol table is\n", elno-1);
//printall();
