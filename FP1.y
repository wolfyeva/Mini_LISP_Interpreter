%{
#  include <stdio.h>
#  include <stdlib.h>
#  include <string.h>
void yyerror(char *s);
int yylex();
extern int yylineno;
struct symbol *lookup(char*);
struct symbol {
  char *name;
  int value;
  int bool;
};
struct symbol symtab[100];
int a=0;
int isB=0;
int temp=0;
char output[100];
struct symbol *lookup(char* sym)
{
  struct symbol *sp = &symtab[0];
  int scount = 100;
  while(--scount >= a) {
    if(sp->name && !strcmp(sp->name, sym)) { return sp; }
    if(!sp->name) {	
      sp->name = strdup(sym);
      sp->value = 0;
	  sp->bool =0;
	  a++;
      return sp;
    }
	if(++sp >= symtab+100) sp = symtab;
  }
}
struct ast {
  int nodetype;
  struct ast *l;
  struct ast *r;
};
struct flow {
  int nodetype;			/* type I */
  struct ast *cond;		
  struct ast *tl;		
  struct ast *el;	
};
struct numval {
  int nodetype;	
  int number;
};
struct idref {
  int nodetype;			/* type S */
  int bool;
  struct symbol *s;
};
struct ast *newast(int nodetype, struct ast *l, struct ast *r);
struct ast *newnum(int d);
struct ast *newbol(int d);
struct ast *newid(struct symbol *s);
void newasgn(struct symbol *, struct ast *);
struct ast *newflow( struct ast *, struct ast *, struct ast *);
int eval(struct ast *);
struct ast * newast(int nodetype, struct ast *l, struct ast *r)
{
  struct ast *a = malloc(sizeof(struct ast));
  a->nodetype = nodetype;
  a->l = l;
  a->r = r;
  return a;
}
struct ast * newnum(int d)
{
  struct numval *a = malloc(sizeof(struct numval));
  a->nodetype = 'K';
  a->number = d;
  return (struct ast *)a;
}
struct ast * newbol(int d)
{
  struct numval *a = malloc(sizeof(struct numval));
  a->nodetype = 'B';
  a->number = d;
  return (struct ast *)a;
}
struct ast * newid(struct symbol *s)
{
  struct idref *a = malloc(sizeof(struct idref));
  a->nodetype = 'S';
  a->s = s;
  return (struct ast *)a;
}
void newasgn(struct symbol *s, struct ast *v)
{
  if (s->value==NULL){
	s->value=eval(v);
	s->bool=isB;
  }
  else{
	printf("Redefining is not allowed.\n");
	exit(0);
  }
}
struct ast *newflow( struct ast *cond, struct ast *tl, struct ast *el)
{
  struct flow *a = malloc(sizeof(struct flow));
  a->nodetype = 'I';
  a->cond = cond;
  a->tl = tl;
  a->el = el;
  return (struct ast *)a;
}
int eval(struct ast *a)
{
  int v, ta, tb;
  switch(a->nodetype) {
  case 'B': v = ((struct numval *)a)->number;isB=1; break;
  case 'K': v = ((struct numval *)a)->number;isB=0; break;
  case 'S': if(((struct idref *)a)->s->value){v = ((struct idref *)a)->s->value;isB=((struct idref *)a)->s->bool;}
			else {printf("Symbol not defined: %s\n",((struct idref *)a)->s->name);exit(0);}; break;
  case '+': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = ta + tb; break;
  case '-': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = ta - tb; break;
  case '*': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = ta * tb; break;
  case '/': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = ta / tb; break;
  case '%': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = ta % tb; break;
  case '>': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = (ta > tb)? 1 : 0; isB=1; break;
  case '<': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = (ta < tb)? 1 : 0; isB=1; break;
  case '=': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = (ta == tb)? 1 : 0; isB=1; break;
  case '?': ta=eval(a->l);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			tb=eval(a->r);if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};
			v = (ta == tb)? (eval(a->l)) : NULL; isB=0; break;
  case '&': ta=eval(a->l);if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
			tb=eval(a->r);if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
			v = ta && tb;isB=1; break;
  case '|': ta=eval(a->l);if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
			tb=eval(a->r);if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
			v = ta || tb; isB=1; break;
  case '^': ta=eval(a->l);if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
			v = 1- ta;isB=1; break;
  case 'I':
	ta=eval( ((struct flow *)a)->cond); if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
    if( ta != 0) {
      if( ((struct flow *)a)->tl) {
	v = eval( ((struct flow *)a)->tl);
      } else
	v = 0;		/* a default value */
    } else {
      if( ((struct flow *)a)->el) {
        v = eval(((struct flow *)a)->el);
      } else
	v = 0;		/* a default value */
    }
    break;
  }
  return v;
}
void yyerror(char *s)
{
  printf("%s\n",s);
}
%}

%union {
  struct ast *a;
  int d;
  struct symbol *s;
}
%token <d> NUMBER BOOL 
%token <s> ID
%token PRINTN PRINTB MOD AND OR NOT DEFINE FUN IF
%type <a> stmt print-stmt exp num-op logical-op def-stmt fun-exp fun-body fun-call params if-exp test-exp then-exp else-exp adexps mexps eexps anexps oexps
%type <sl> fun-ids ids
%type <s> fun-name
%%
program: stmt program	{}
		|
		;
stmt:	exp	{temp=eval($1); $$ = $1; }
		| def-stmt	{ $$ = $1; }
		| print-stmt	{ $$ = $1; }
		;
print-stmt:	'(' PRINTN exp ')'	{ temp=eval($3); if(isB==1){printf("Type Error: Expect ‘number’ but got ‘boolean’.\n");exit(0);};printf("%d\n",temp); }
			| '(' PRINTB exp ')'	{temp=eval($3); if(isB==0){printf("Type Error: Expect ‘boolean’ but got ‘number’.\n");exit(0);};
									if(temp==1){printf("#t\n");}
									else {printf("#f\n");}}
			;
exp	: BOOL	{ $$ = newbol($1); }
	| NUMBER	{ $$ = newnum($1); }
	| ID		{ $$ = newid($1); }
	| num-op	{ $$ = $1; }
	| logical-op	{ $$ = $1; }
	| fun-exp	{ $$ = $1; }
	| fun-call	{ $$ = $1; }
	| if-exp	{ $$ = $1; }
	;
adexps	: exp adexps	{$$=newast('+', $1,$2);}
		| exp 	{$$=$1;}
		;
mexps	: exp mexps	{$$=newast('*', $1,$2);}
		| exp	{$$=$1;}
		;
eexps	: exp eexps	{$$=newast('?', $1,$2);}
		| exp	{$$=$1;}
		;
anexps	: exp anexps	{$$=newast('&', $1,$2);}
		| exp	{$$=$1;}
		;
oexps	: exp oexps	{$$=newast('|', $1,$2);}
		| exp	{$$=$1;}
		;
num-op:	'(''+' exp adexps ')'	{$$= newast('+', $3,$4);}
		| '(''-' exp exp ')'	{$$= newast('-', $3,$4);}
		| '(''*' exp mexps ')'	{$$= newast('*', $3,$4);}
		| '(''/' exp exp ')'	{$$= newast('/', $3,$4);}
		| '(' MOD exp exp ')'	{$$= newast('%', $3,$4);}
		| '(''>' exp exp ')'	{$$= newast('>', $3,$4);}
		| '(''<' exp exp ')'	{$$= newast('<', $3,$4);}
		| '(''=' exp eexps ')'	{$$= newast('=', $3,$4);}
		;
logical-op:	'(' AND exp anexps ')'	{$$= newast('&', $3,$4);}
			| '(' OR exp oexps ')'	{$$= newast('|', $3,$4);}
			| '(' NOT exp ')'	{$$= newast('^', $3,NULL);}
			;
def-stmt:	'(' DEFINE ID exp ')'	{ newasgn($3,$4);}
			;
fun-exp:	'(' FUN fun-ids fun-body ')'	{}
			;
ids:	ID ids	{}
		|	{};
fun-ids:	'(' ids ')'	{  }
		;
fun-body:	exp	{}
		;
fun-call:	'(' fun-exp params ')'	{}
			| '(' fun-name params ')'	{  }
			;
params: exp params	{}
		|	{ $$ = NULL; }
		;
fun-name:	ID	{$$ = $1;}
		;
if-exp:	'(' IF test-exp then-exp else-exp ')'	{ $$ = newflow( $3, $4, $5); }
		;
test-exp:	exp	{$$ = $1;}
		;
then-exp:	exp	{$$ = $1;}
		;
else-exp:	exp	{$$ = $1;}
		;
%%
int main(){
	return yyparse();
}