/*******************************************************************************
*
* FILE:		book1.y copy to yacc.y to build and test
*
* DESC:		EECS 337 Assignment 6
* SYNOPSIS:	Calculator (page 292)
* 		yacc -dv yacc.y 
* 		mv -f y.tab.c yacc.c
*
*
* AUTHOR:	caseid
*
* DATE:		September 28, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/
%{
#include <ctype.h>
#include <stdio.h>

/*
 *	for debugging
 */
#define	YYDEBUG	1
/*
 *	define yystype
 */
#define YYSTYPE double

%}

%start lines

%token NUMBER

%left '+' '-'
%left '*' '/' 
%right UMINUS /* supples precedence for unary minus */

%% 	/* beginning of rules section */

lines	: lines expr '\n' { printf("%g\n", $2); }
	| lines error '\n' { yyerrok; }
	| /* empty */
	;
expr
	: expr '+' expr	{ $$ = $1 + $3;	}
	| expr '-' expr	{ $$ = $1 - $3;	}
	| expr '*' expr	{ $$ = $1 * $3;	}
	| expr '/' expr	{ $$ = $1 / $3;	}
	| '(' expr ')'	{ $$ = $2; }
	| '-' expr %prec UMINUS { $$ = - $2; }
	| NUMBER
	;

%% /*start of programs */

void	yyerror( char *s)
{
	printf( "%s\n", s);
}

#ifdef	junk
/*
 *	book sample code is non-functional
 */
yylex()
{
	int c;
	while(( c = getchar()) == ' ');
	if(( c == '.') || (isdigit(c)))
	{
	     ungetc( c, stdin);
	     scanf( "lf", &yylval);
	     return NUMBER;
	}
}
#endif
/*
 *	functional version of yylex()
 *
 *	Input:	yylval:	Return:
 *	space	skip	continue
 *	tab	skip	continue
 *	'$'	-	EOF
 *	'\n'	-	'\n'
 *	[0-9]	value	NUMBER
 *	[.]	-	char
 *	EOF	-	EOF
 */
yylex()
{
	int c;

	while(( c = getchar()) != 0)
	{
		if( c == ' ')
			continue;
		if( c == '\t')
			continue;
		if( c == '$')
			return( -1);
		if( c == '\n')
			return( '\n');
		if( isdigit( c))
		{
			yylval = c - '0';	/* convert single ascii digit ('0'-'9') to binary value (0-9) */
			return NUMBER;
		}
		return( c);
	}
	return( -1);
}

