/*******************************************************************************
*
* FILE:		lex.l
*
* DESC:		EECS 337 Assignment 7
* SYNOPSIS:	Calculator (page 292)
* 		flex  -t lex.l > lex.c
* 		gcc -g -c -o lex.o lex.c
*
* AUTHOR:	caseid
*
* DATE:		October 5, 2010
*
* EDIT HISTORY:	
*      		Version 2 uses lex.l as input scanner for longs and doubles
*		and uses a static YYSTYPE structure with type, lvalue, fvalue.
*
*******************************************************************************/
D			[0-9]
L			[a-zA-Z_]
H			[a-fA-F0-9]
E			[Ee][+-]?{D}+
FS			(f|F|l|L)
IS			(u|U|l|L)*

%{
#include	"yystype.h"
#include	"y.tab.h"

%}

%%

"$"			{ return -1; }
[\n]			{ return( '\n'); /* return cr */ }
0[xX]{H}+{IS}?		{ sscanf( yytext, "%lx", &yylval.lvalue); yylval.type = LONG; return( LONG); }
0{D}+{IS}?		{ sscanf( yytext, "%lo", &yylval.lvalue); yylval.type = LONG; return( LONG); }
{D}+{IS}?		{ sscanf( yytext, "%ld", &yylval.lvalue); yylval.type = LONG; return( LONG); }
{D}+{E}{FS}?		{ sscanf( yytext, "%lf", &yylval.dvalue); yylval.type = DOUBLE; return( DOUBLE); }
{D}*"."{D}+({E})?{FS}?	{ sscanf( yytext, "%lf", &yylval.dvalue); yylval.type = DOUBLE; return( DOUBLE); }
{D}+"."{D}*({E})?{FS}?	{ sscanf( yytext, "%lf", &yylval.dvalue); yylval.type = DOUBLE; return( DOUBLE); }
[ \t]			{ /* ignore white characters */ }
.			{ return( yytext[ 0]); /* return everything else */ }

%%

/*
 *	yy wrap function	always return EOF
 */
yywrap()
{
	return( 1);
}

