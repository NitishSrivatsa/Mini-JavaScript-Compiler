struct symbolTable{
	int type,scope,line_declared,line_used;
	struct symbolTable *next; //next pointer
	char *d;
};

struct symbolTable id_top={0},string_top={0},number_top={0};


void insert_entry(int type,char *d,int scp){
	struct symbolTable *a,*b;
	switch(type){
	case 0: a=&id_top; 
			break;
	case 1: a=&string_top;
			break;
	case 2: a=&number_top;
			break;
	default: 
			return;
	}
	while(a->next!=NULL){
		if(strcmp(a->next->d,d)==0)
			return;
		a=a->next;
	}
	b=malloc(sizeof(struct symbolTable)); 
	b->next=NULL;
	b->d=strdup(d);
	a->next=b;
	if(type==0){
		b->scope=scp;
		b->line_declared=b->line_used=line_no;
		b->type=-1;
	}
}


void displayTable(){
	struct symbolTable *a;
	printf("\nIdentifiers:\n");
	a=&id_top;
	printf("NAME \t SCOPE \t TYPE \t DECLARED LINE \t LAST USED LINE\n");
	printf("--------------------------------------------------------\n");
	while(a->next!=NULL){
		printf("%s \t %d \t %d \t %d \t\t %d\n", a->next->d, a->next->scope, a->next->type, a->next->line_declared, a->next->line_used);
		a=a->next;
		}
	printf("\nStrings:\n");
	a=&string_top;
	while(a->next!=NULL){
		printf("%s\n",a->next->d);
		a=a->next;
		}
	printf("\nNumbers:\n");
	a=&number_top;
	while(a->next!=NULL){
		printf("%s ",a->next->d);
		a=a->next;
	}
	printf("\n");
}


void check_entry(char *d){
	int tp=stop-1,pscp;
	//printf("check_entry called!!!\n");
	struct symbolTable *a;
	for(tp=stop-1;tp>=0;tp--){
		pscp=scope[tp];
		a=&id_top;
		while(a->next!=NULL){
			if(strcmp(d,a->next->d)==0&&pscp==a->next->scope){
				a->next->line_used=line_no;
				return;
			}
			a=a->next;
		}
	}
	printf("Error in line %d, %s not found\n", line_no,d);
}


void add_type_name(char *d, int type){
	int tp=stop-1,pscp;
	struct symbolTable *a;
	for(tp=stop-1;tp>=0;tp--){
		pscp=scope[tp];
		a=&id_top;
		while(a->next!=NULL){
			if(strcmp(d,a->next->d)==0&&pscp==a->next->scope){
				a->next->type=type;
				return;
				}
			a=a->next;
			}
	}
	printf("Error in line %d, %s not found\n", line_no,d);
}
