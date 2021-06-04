//C Declarations
%{
	#include "lex.yy.c"	
%}

//Yacc Declarations
%token T_VAR T_DEF T_KEY T_ID T_NUM T_LBR T_RBR T_STR T_SHA T_LCG T_LOP T_OP1 T_OP2 T_OP3 T_OP4 T_IF T_ELSE T_IN T_LET T_CONSOLE T_DOCUMENT T_DO T_WHILE 

%start start

//Grammar Rules
%%
start: seqOfStmts;

seqOfStmts: statement seqOfStmts | statement | while;

anyOperator: T_LCG | T_LOP | T_OP1 | T_OP2 | T_OP3;

terminator: ';' | '\n' | { yyerrok; yyclearin;printf("\nMissing Semi Colon in line no %d! PARSING CONTINUED !\n",line_no-2);};

statement: declare terminator| expression terminator|  if | do | '{'{scope[stop++]=sid++;} seqOfStmts '}' {stop--;} | T_CONSOLE '(' T_STR ')' terminator| T_CONSOLE '(' list ')' terminator | T_DOCUMENT '(' T_STR ')' | T_DOCUMENT '(' list ')';

id: T_ID {insert_entry(0,indentifier,scope[stop-1]);printf("Updating in Symbol Table:%s, scope:%d\n",indentifier,scope[stop-1]);};

idV: T_ID {check_entry(indentifier);printf("Checking in Symbol Table:%s, scope:%d\n",indentifier,scope[stop-1]);};

assign: '=' | T_SHA;

expression: id assign expression  | value;

value: unit anyOperator value | unit;

unit: idV | T_OP4 idV | idV T_OP4 | T_STR {add_type_name(indentifier, 1);}| T_NUM {add_type_name(indentifier, 0);}| '(' list ')'| func | '[' list ']';

func: idV '(' list ')'; 

list: expression ',' list | expression;

declare: T_VAR declaration | T_LET declaration;

declaration: id |id ',' declaration|id '=' expression|id '=' expression ',' declaration;

if: T_IF '(' expression ')' statement | ifelse;  

ifelse: T_ELSE '{' statement '}';

do: T_DO '{' seqOfStmts '}';

while: T_WHILE '(' expression ')' terminator seqOfStmts;

%%

