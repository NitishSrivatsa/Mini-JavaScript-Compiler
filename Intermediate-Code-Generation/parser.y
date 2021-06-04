%union{
struct {char *code,*ast;int next;} stt;
struct {char *code,*ast;int idn;} eq;
struct {int dt[4];} dt;
struct {int idn,off;char *code,*ast;} ls;
}

%type<stt> estt seq statement for if 
%type<eq> expr unit defn anyopl anyoph rhsl rhsh
%type<ls> list
%type<dt> elb lhs lhsv edt
%token T_VAR T_DEF T_KEY T_ID T_NUM T_LBR T_RBR T_STR T_SHA T_LCG T_LOP T_OP1 T_OP2 T_OP3 T_OP4 T_FOR T_IF T_ELSE T_IN T_LET T_DO T_WHILE
%start start

%%
start:seq{FILE *f;f=fopen("/home/nitish/Desktop/CD FINAL/3. Code Optimization/icg.txt","w");	
	fprintf(f,"%s",$1.code);
	fclose(f);};
estt:;
elb:;
edt:;


anyopl:T_LOP {$$.code=strdup(ysign);}|T_OP1 {$$.code=strdup(ysign);}|T_LCG {$$.code=strdup(ysign);};

anyoph:T_OP2 {$$.code=strdup(ysign);}|T_OP3 {$$.code=strdup(ysign);};

adlm:';'|'\n';

seq:statement seq{$$.code=ap($1.code,$2.code);$$.ast=ap3($1.ast,strdup("\n"),$2.ast);}|
	{$$.code=strdup("");$$.ast=strdup("");};

statement:defn adlm {$$.code=$1.code;$$.ast=$1.ast;}|
	expr adlm {$$.code=$1.code;$$.ast=$1.ast;}|
	if {$$.code=$1.code;$$.ast=$1.ast;}|
	for {$$.code=$1.code;$$.ast=$1.ast;}|
	'{'{scs[stop++]=sid++;} seq '}' {stop--;} adlm  
	{$$.code=$3.code;$$.ast=ap3(strdup("{"),$3.ast,strdup("} "));}|
	adlm {$$.code=strdup("");$$.ast=strdup("");};

lhs:T_ID {int v=mkentr(0,ygbl,scs[stop-1]);$$.dt[0]=v;};

lhsv:T_ID {int v=chkentr(ygbl);if(v==-1){yyerrok;}$$.dt[0]=v;};

eqb:'='|T_SHA;

expr: lhs eqb expr 
	{char *a;sprintf(bbuf,"mov %s t%d\n",a=getname($1.dt[0]),$3.idn);
	$$.code=ap($3.code,strdup(bbuf));$$.idn=$3.idn;
	sprintf(bbuf,"%s = (",a);$$.ast=ap3(strdup(bbuf),$3.ast,strdup(")"));}|
	rhsl {$$.code=$1.code;$$.idn=$1.idn;$$.ast=$1.ast;};

rhsl:rhsh anyopl rhsl 
	{int k=tmp++;
	sprintf(bbuf,"t%d = t%d %s t%d\n",k,$1.idn,$2.code,$3.idn);
	$$.code=ap3($1.code,$3.code,strdup(bbuf));$$.idn=k;
	$$.ast=ap3(ap3(strdup(" ("),$1.ast,strdup(") ")),$2.code,ap3(strdup(" ("),$3.ast,strdup(") ")));free($2.code);}|
	rhsh {$$.code=$1.code;$$.idn=$1.idn;$$.ast=$1.ast;};

rhsh:unit anyoph rhsh 
	{int k=tmp++;
	sprintf(bbuf,"t%d = t%d %s t%d\n",k,$1.idn,$2.code,$3.idn);
	$$.code=ap3($1.code,$3.code,strdup(bbuf));$$.idn=k;
	$$.ast=ap3(ap3(strdup(" ("),$1.ast,strdup(") ")),$2.code,ap3(strdup(" ("),$3.ast,strdup(") ")));free($2.code);}|
	unit {$$.code=$1.code;$$.idn=$1.idn;$$.ast=$1.ast;};

unit: lhsv {char *a;int k=tmp++;
	sprintf(bbuf,"mov t%d %s\n",k,a=getname($1.dt[0]));
	$$.code=strdup(bbuf);$$.idn=k;$$.ast=strdup(a);}|	
	T_OP4 lhsv |lhsv T_OP4|
	T_STR {int k=tmp++;add_type_name(ygbl, 1);
	sprintf(bbuf,"mov t%d %s\n",k,yytext);
	$$.code=strdup(bbuf);$$.idn=k;$$.ast=strdup(yytext);}|
	T_NUM {int k=tmp++;add_type_name(ygbl, 0);
	sprintf(bbuf,"mov t%d %s\n",k,yytext);
	$$.code=strdup(bbuf);$$.idn=k;$$.ast=strdup(yytext);}|
	'[' list ']' {$$.code=$2.code;$$.idn=$2.idn;add_type_name(ygbl, 2);$$.ast=ap3(strdup(" ["),$2.ast,strdup("] "));} |
	lhsv '[' expr ']' {char *a;int k=tmp++;$$.idn=tmp++;sprintf(bbuf,"mov t%d %s\nt%d=t%d[t%d]\n",k,a=getname($1.dt[0]),$$.idn,k,$3.idn);$$.code=ap($3.code,strdup(bbuf));sprintf(bbuf," %s[",a);$$.ast=ap3(strdup(bbuf),$3.ast,strdup("] "));};


list: list ',' expr {sprintf(bbuf,"t%d[%d]=t%d\n",$1.idn,$1.off+1,$3.idn);$$.code=ap3($1.code,$3.code,strdup(bbuf));$$.off=$1.off+1;$$.idn=$1.idn;$$.ast=ap3($1.ast,strdup(","),$3.ast);}|
	expr {$$.idn=tmp++;$$.off=0;sprintf(bbuf,"t%d[%d]=t%d\n",$$.idn,$$.off,$1.idn);$$.code=ap($1.code,strdup(bbuf));$$.ast=$1.ast;}|{$$.code=strdup("");$$.idn=tmp++;$$.ast=strdup("");};

defn: T_VAR vtail|T_LET vtail;

vtail:lhs |lhs ',' vtail|lhs '=' expr|lhs '=' expr ',' vtail;

for: T_FOR edt {$2.dt[0]=lbl++;$2.dt[1]=lbl++;} 
	'(' expr ';' expr ';' expr ')' statement {char *a,*b,*c;
	sprintf(bbuf,"label l%d\n",$2.dt[0]);
	a=ap3($5.code,strdup(bbuf),$7.code);
	sprintf(bbuf,"iffalse t%d goto l%d\n",$7.idn,$2.dt[1]);
	b=ap3(strdup(bbuf),$11.code,$9.code);
	sprintf(bbuf,"goto l%d\nlabel l%d\n",$2.dt[0],$2.dt[1]);
	$$.code=ap3(a,b,strdup(bbuf));
	
	a=ap3(strdup("for ("),$5.ast,strdup(";"));
	a=ap3(a,$7.ast,strdup(";"));
	a=ap3(a,$9.ast,strdup(")"));
	$$.ast=ap(a,$11.ast);
};

if : T_IF '('expr')' edt 
	{$5.dt[0]=lbl++;$5.dt[1]=lbl++;$5.dt[2]=lbl++;}
	statement T_ELSE statement 
	{char *a,*b,*c;
	sprintf(bbuf,"iftrue t%d goto l%d\ngoto l%d\nlabel l%d\n",$3.idn,$5.dt[0],$5.dt[1],$5.dt[0]);
	a=ap3($3.code,strdup(bbuf),$7.code);
	sprintf(bbuf,"goto l%d\nlabel l%d\n",$5.dt[2],$5.dt[1]);
	b=ap(strdup(bbuf),$9.code);
	sprintf(bbuf,"label l%d\n",$5.dt[2]);
	$$.code=ap3(a,b,strdup(bbuf));
	
	a=ap3(strdup("if("),$3.ast,strdup(")"));
	a=ap3(a,$7.ast,strdup(" else "));
	$$.ast=ap(a,$9.ast);
};

%%
