%option noyywrap nodefault yylineno
%{
# include "FP1.tab.h"
struct ast {
  int nodetype;
  struct ast *l;
  struct ast *r;
};
struct symbol {	
  char *name;
  int value;
  int bool;
};

extern struct symbol symtab[100];
struct symbol* lookup(char*);
%}

%%
"+" |
"-" |
"*" |
"/" |
"|" |
"(" |
")" |
">" |
"<" |
"="     { return yytext[0]; }
0|[1-9][0-9]*|-[1-9][0-9]* { yylval.d = atof(yytext); return NUMBER; }
"#t"	{yylval.d =1; return BOOL;}
"#f"	{yylval.d =0; return BOOL;}
"mod"	{return MOD;}
"and"	{return AND;}
"or"	{return OR;}
"not"	{return NOT;}
"define"	{return DEFINE;}
"fun"	{return FUN;}
"if"	{return IF;}
"print-num"	{return PRINTN;}
"print-bool"	{return PRINTB;}
[a-z]([a-z]|[0-9]|"-")*	{yylval.s = lookup(yytext); return ID;}

[ \t\r\n]   { /* ignore white space */ }
.	{  }
%%