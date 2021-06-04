struct tentr{
	int type,scope,lndec,lnused;
	struct tentr *n;
	char *d;
};

struct tentr idtopp={0},stopp={0},ntopp={0};

int mkentr(int type,char *d,int scp)
{
	struct tentr *a,*b;int c=0;
	switch(type){
		case 0:a=&idtopp;
				break;
		case 1:a=&stopp;
				break;
		case 2:a=&ntopp;
				break;
		default:return -1;
	}
	while(a->n!=NULL){
		if(strcmp(a->n->d,d)==0)
			return c;
		a=a->n;
		c++;
	}
	b=malloc(sizeof(struct tentr));
	b->n=NULL;
	b->d=strdup(d);
	a->n=b;
	if(type==0){
		b->scope=scp;
		b->lndec=b->lnused=elno;
		b->type=-1;
	}
	return c;
}

void printall(){
	struct tentr *a;
	printf("\n\nidentifiers:\n");
	a=&idtopp;
	printf("Name \t scope \t type \t declared line \t last used line\n");
	printf("--------------------------------------------------------\n");
	while(a->n!=NULL){
		printf("%s \t %d \t %d \t %d \t\t %d\n",a->n->d,a->n->scope,a->n->type,a->n->lndec,a->n->lnused);
		a=a->n;
		}
	printf("\n\nstrings:\n");
	a=&stopp;
	while(a->n!=NULL){
		printf("%s\n",a->n->d);
		a=a->n;
		}
	printf("\n\nnumber:\n");
	a=&ntopp;
	while(a->n!=NULL){
		printf("%s\n",a->n->d);
		a=a->n;
	}
}


int chkentr(char *d)
{
	int tp=stop-1,pscp;
	//printf("chkentr called!!!\n");
	struct tentr *a;int c=0;
	for(tp=stop-1;tp>=0;tp--){
			pscp=scs[0];a=&idtopp;
			while(a->n!=NULL){
				if(strcmp(d,a->n->d)==0&&(pscp==a->n->scope||1)){
					a->n->lnused=elno;return c;}a=a->n;c++;
				}
		}
		
	printf("\nError in line %d, %s not found... Parsing Continued!!\n", elno,d);
	//printf("chkentr exited\n");
	return -1;
}

void add_type_name(char *d, int type)
{
	int tp=stop-1,pscp;
	struct tentr *a;
	for(tp=stop-1;tp>=0;tp--){
		pscp=scs[tp];a=&idtopp;
		while(a->n!=NULL){
			if(strcmp(d,a->n->d)==0&&pscp==a->n->scope){
				a->n->type=type;return;}a=a->n;
			}
		}
		
	printf("Error in line %d, %s not found\n", elno,d);
}

//more string functions

char *ap(char *a,char *b)
{
	char *o;
	int m,n;
	m=strlen(a);
	n=strlen(b);
	o=malloc(sizeof(char)*(m+n+10));
	strcpy(o,a);
	strcpy(o+m,b);
	return o;
}

char *ap3(char *a,char *b,char *c)
{
	char *o;
	int m,n,p;
	m=strlen(a);
	n=strlen(b);
	p=strlen(c);
	o=malloc(sizeof(char)*(m+n+p+10));
	
	strcpy(o,a);
	strcpy(o+m,b);
	strcpy(o+m+n,c);
	return o;
}

char *getname(int c)
{
	struct tentr *t;
	int i;
	t=idtopp.n;
	for(i=0;i<c;i++)
		t=t->n;
		
	return t->d;
}

char *getsname(int s)
{
	return "<sign>";
}
