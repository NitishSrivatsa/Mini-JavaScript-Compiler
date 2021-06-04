%{
	#include "y.tab.h"
	#include <string.h>
	#include <stdlib.h>

	void yyerror(char *a){printf("\n %s\n", a);return;}

	char *justparsed;
	int main(int argc,char *argv[])
{
if(argc == 2){
		yyin = fopen(argv[1],"r");
	}
	yyparse();
	return 0;	
	
}
%}

%%

[0-9]+                              {yylval.rvalues.value = strdup(yytext); return T_NUM;}

mov                                 {yylval.rvalues.value = strdup(yytext); return T_MOV;}
label                               {yylval.rvalues.value = strdup(yytext); return T_LABEL;}
iffalse                             {yylval.rvalues.value = strdup(yytext); return T_FALSE;}
iftrue                              {yylval.rvalues.value = strdup(yytext); return T_TRUE;}
goto                                {yylval.rvalues.value = strdup(yytext); return T_GOTO;}
l[0-9]+                             {yylval.rvalues.value = strdup(yytext); return T_LVAR;}
t[0-9]+                             {yylval.rvalues.value = strdup(yytext); return T_TVAR;}
([a-zA-Z]|\_)([a-zA-Z0-9]|\_)*      {yylval.rvalues.value = strdup(yytext); return T_AVAR;}
(\[|\])								{return(yytext[0]);}

\"([^"]|\\\")*\"|\'([^']|\\\')*\' 	{yylval.rvalues.value = strdup(yytext); return T_STR;}
=                                   {yylval.rvalues.value = strdup(yytext); return T_ASSIGN;}
(&&|\|\|)							{yylval.rvalues.value = strdup(yytext); return T_BOOLOP;}
(\<|\>|\=)\=?						{yylval.rvalues.value = strdup(yytext); return T_LOGOP;}
(\+|\-|\*|\**|\/)                       {yylval.rvalues.value = strdup(yytext); return T_MATOP;}
[\n]								{yylval.rvalues.value = strdup(yytext); return T_DELIM;}
[\t ]	                            {}	


%%



