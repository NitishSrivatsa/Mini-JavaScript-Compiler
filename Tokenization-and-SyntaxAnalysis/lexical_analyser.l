%{

int yyparse(void);
int yylex(void);
void yyerror(char *);
int scope[100]={0},stop=1,sid=1, line_no=1;
char *indentifier;
#include<string.h>
#include"symbolTable.h"
#include"y.tab.h"

void insert_token(char *t, char *s);

void yyerror(char *a)
{
	printf("\nError in line %d, %s\n", line_no,a);
}

int main(int argc, char *argv[]){

	if(argc == 2){
		yyin = fopen(argv[1],"r");
	}
	yyparse();
	displayTable();
	return 0;
}

%}


%%

\/\*([^*]|\*[^/])*\*\/			;
\/\/[^\n]*				;
var 				{insert_token("Type",yytext);return T_VAR;}
def 				{insert_token("Function", yytext);return T_DEF;}
if					{insert_token("Keyword",yytext);return T_IF; }
else				{insert_token("Keyword",yytext);return T_ELSE;}
in					{insert_token("Keyword",yytext);return T_IN;}
let					{insert_token("Keyword",yytext);return T_LET;}
do					{insert_token("Keyword",yytext);return T_DO;}
while 				{insert_token("Keyword",yytext);return T_WHILE;}
console.log			{insert_token("Print", yytext);return T_CONSOLE;}
document.write	{insert_token("Print", yytext);return T_DOCUMENT;}
break|case|catch|continue|debugger|default|delete|do|else|finally|function|if|for|in|instanceof|new|return|switch|this|throw|try|typeof|var|void|while|with				{insert_token("Keyword", yytext);return T_KEY;}
([a-zA-Z]|\_)([a-zA-Z0-9]|\_)* 		{indentifier=strdup(yytext);insert_token("Identifer", yytext);return T_ID;}
[0-9]+(\.[0-9]+)?(E[-+]?[0-9]+)? 	{insert_entry(2,yytext,0);insert_token("Number", yytext);return T_NUM;}

[\[\(\{]			{insert_token("Open Brackets", yytext); return yytext[0];}
[\]\)\}]			{insert_token("Close Brackets", yytext); return yytext[0];}

\"([^"]|\\\")*\"|\'([^']|\\\')*\' 	{insert_entry(1,yytext,0);insert_token("String", yytext);return T_STR;}

=					{insert_token("Equals", yytext);return '=';}
\.					{insert_token("Dot", yytext);return '.';}
[+\-*/^&|]=			{insert_token("ShortHand", yytext);return T_SHA;}
(&&|\|\|)			{insert_token("Logical Operators", yytext);return T_LCG;}
([<>]|==)=?		{insert_token("Equality", yytext);return T_LOP;}
,					{insert_token("Comma", yytext);return ',';}
[+-]				{insert_token("Op1", yytext);return T_OP1;}
[*/^&|]				{insert_token("Op2", yytext);return T_OP2;}
\*\*					{insert_token("Op3", yytext);return T_OP3;}
(\+\+|\-\-)			{insert_token("Op4", yytext);return T_OP4;}
;					{insert_token("Colon", ";");return ';';}
[\n]					{line_no++;}
[\t ]	            			{printf("");}	

%%


void insert_token(char *t, char *s){
   	FILE *fptr;
   	
   	fptr = fopen("Tokens.txt", "a");
   	if(fptr == NULL)
   	{
      	printf("Error!");
      	exit(1);
   	}

   	fprintf(fptr,"%s : %s\n", t, s);
   	fclose(fptr);
}
