%{

		#include <stdio.h>
		#include <stdlib.h>
		#include <string.h>
		#define YYERROR_VERBOSE	
	 	int yylex(void);
	    extern char *yytext;
		void check_update(char **, char **, char **);
		struct VALTAB * find_node(char *);
		void add_node(char *, char *, int);
		void print_current_vt();
		char * constant_fold();


		struct VALTAB {
			   struct VALTAB *next;
			   struct VALTAB *prev;
			   char *tname;
			   char *tval;
			   int type;
			   // 0 -> integer, 1 -> string constant, 2 -> var    
		};

%}

%union{
	struct {char *value;} rvalues;
}

%token <rvalues> T_ASSIGN T_BOOLOP T_LOGOP T_MATOP T_DELIM T_END
%token <rvalues> T_MOV T_LABEL T_FALSE T_TRUE T_TVAR
%token <rvalues> T_GOTO T_LVAR T_TVALVEC
%token <rvalues> T_NUM T_STR T_AVAR

%type <rvalues> operator tvar_tnum value_constants no_num

%start start


%%

start: pgm {FILE *f;f=fopen("/Users/aswin/Downloads/Code Optimization/inputFiles/icg.txt","w");fclose(f);}

pgm: block pgm
	 | block
	 | 
	 ;

block: statement T_DELIM
	   | statement
	   | T_DELIM
	   ;

statement: T_MOV T_TVAR value_prod
		   | T_MOV T_AVAR value_constants {check_update(&$1.value, &$2.value, &$3.value);printf("%s %s %s\n", $1.value, $2.value, $3.value);}
		   | T_TVAR T_ASSIGN T_NUM operator no_num {print_current_vt();check_update(&$1.value, &$3.value, &$5.value); printf("%s %s %s %s %s\n", $1.value, $2.value, $3.value, $4.value, $5.value);print_current_vt();}
		   | T_TVAR T_ASSIGN no_num operator T_NUM {print_current_vt();check_update(&$1.value, &$3.value, &$5.value); printf("%s %s %s %s %s\n", $1.value, $2.value, $3.value, $4.value, $5.value);print_current_vt();}
		   | T_TVAR T_ASSIGN T_NUM operator T_NUM {printf("mov %s %s\n", $1.value, constant_fold($3.value, $4.value, $5.value));}
		   | T_TVAR T_ASSIGN no_num operator no_num {print_current_vt();check_update(&$1.value, &$3.value, &$5.value); printf("%s %s %s %s %s\n", $1.value, $2.value, $3.value, $4.value, $5.value);print_current_vt();}
		   | T_FALSE value_constants T_GOTO T_LVAR {check_update(&$1.value, &$2.value, &$3.value);printf("%s %s %s %s\n", $1.value, $2.value, $3.value, $4.value);}
		   | T_TRUE value_constants T_GOTO T_LVAR {check_update(&$1.value, &$2.value, &$3.value);printf("%s %s %s %s\n", $1.value, $2.value, $3.value, $4.value);}
		   | T_GOTO T_LVAR  {check_update(&$1.value, &$2.value, &$2.value);printf("%s %s\n", $1.value, $2.value);}
		   | T_LABEL T_LVAR {check_update(&$1.value, &$2.value, &$2.value);printf("%s %s\n", $1.value, $2.value);}
		   | T_TVALVEC T_ASSIGN T_TVAR {check_update(&$1.value, &$2.value, &$3.value);printf("%s %s %s\n", $1.value, $2.value, $3.value);}
		   | T_TVAR '[' tvar_tnum ']' T_ASSIGN tvar_tnum {check_update(&$1.value, &$3.value, &$6.value);printf("%s[%s] %s %s\n", $1.value, $3.value, $5.value, $6.value);}
		   | T_TVAR T_ASSIGN value_constants '[' value_constants ']' {check_update(&$1.value, &$3.value, &$5.value);printf("%s %s %s[%s]\n", $1.value, $2.value, $3.value, $5.value);}	   



no_num: T_AVAR {$$.value = $1.value;}
		| T_TVAR {$$.value = $1.value;}

tvar_tnum: T_NUM {$$.value = $1.value;}
		   | T_TVAR {$$.value = $1.value;}


value_constants: T_NUM {$$.value = $1.value;}
				 | T_STR {$$.value = $1.value;}
				 | T_AVAR {$$.value = $1.value;}
				 | T_TVAR {$$.value = $1.value;}

value_prod: T_NUM {add_node($<rvalues>0.value, $1.value, 0);}
	   | T_STR {add_node($<rvalues>0.value, $1.value, 1);}
       | T_AVAR {add_node($<rvalues>0.value, $1.value, 2);}

operator: T_BOOLOP {$$.value = $1.value;}
		  | T_LOGOP {$$.value = $1.value;}
		  | T_MATOP {$$.value = $1.value;}

%%


struct VALTAB *head, *end;



char* constant_fold(char *operand1, char *operator, char *operand2)
{
	int op1 = atoi(operand1), op2 = atoi(operand2);
	int result;
	char *returnval = (char*)malloc(sizeof(char)*32);

	if(strcmp(operator, "&&") == 0){
		result = op1 && op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}
	
	if(strcmp(operator, "||") == 0){
		result = op1 || op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "<") == 0){
		result = op1 < op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, ">") == 0){
		result = op1 > op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "<=") == 0){
		result = op1 <= op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, ">=") == 0){
		result = op1 >= op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "==") == 0){
		result = op1 == op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "+") == 0){
		result = op1 + op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}


	if(strcmp(operator, "**") == 0){	
		if (op2==2){
			printf("Using Strength reduction -> ");
			result = op1*op1;}
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "-") == 0){
		result = op1 - op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "/") == 0){
		if (op2==2){
			printf("Using Strength reduction -> ");
			result = op1 >> 1;}		
		result = op1 / op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	if(strcmp(operator, "*") == 0){
		if (op1==2){
			printf("Using Strength reduction -> ");
			result = op2 << 1;}	
		if (op2==2){
			printf("Using Strength reduction -> ");
			result = op1 << 1;}		
		result = op1 * op2;
		sprintf(returnval, "%d", result);
		return(returnval);
	}

	else
		return "NaN";

}

void print_current_vt()
{
	if(head == NULL)
		return;

	//printf("***************\n");
	struct VALTAB *temp = head;
	while(temp != NULL){
	     //printf("%s %s\n", temp->tname, temp->tval);
		 temp = temp->next;
	}
	//printf("***************\n");
	return;
	
}

void check_update(char **param1, char **param2, char **param3)
{

	if(*param1 != NULL){
	     struct VALTAB *temp = find_node(*param1);
		 if(temp != NULL){
			   if(temp != head)
			   		  temp->prev->next = temp->next;
			   else
					  head = temp->next;
			   if(temp != end)
			   		  temp->next->prev = temp->prev;
			   else
					  end = temp->prev;
		 }
	}

	if(*param2 != NULL){
	     struct VALTAB *temp = find_node(*param2);
		 if(temp != NULL){
				*param2 = temp->tval;
		 }
	}

	if(*param3 != NULL){
	     struct VALTAB *temp = find_node(*param3);
		 if(temp != NULL){
				*param3 = temp->tval;
		 }
	}

}

struct VALTAB * find_node(char *tname)
{
	if(head == NULL)
		return NULL;

	struct VALTAB *temp = head;
	while(temp != NULL){
		 if(strcmp(temp->tname, tname) == 0)
		 	 return temp;
		 temp = temp->next;
	}
	return NULL;
}

void add_node(char *tname, char *tvalue, int type)
{
	struct VALTAB *temp = (struct VALTAB*)malloc(sizeof(struct VALTAB));
	temp->prev = end;
	temp->next = NULL;
	temp->tname = strdup(tname);
	temp->tval = strdup(tvalue);
	temp->type = type;

	if(head == NULL)
			head = temp;
	if(end != NULL)
		   end->next = temp;   
	end = temp;
}


