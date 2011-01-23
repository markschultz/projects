/*******************************************************************************
*
* FILE:		book2.y copy to yacc.y to build and test
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
*	For maximum execution speed the YYSTYPE data structure is defined
*	using a structure definition and the math operations are coded directly
*	in-line. The trade-off for increased speed is more source code to
*	maintain and a larger executable image. This model allows yacc
*	generated programs to be used in soft real time applications such as
*	on-line interpreters and communication systems.
*
*	The YYSTYPE struct is defined using an int for the type (LONG or DOUBLE)
*	and a long and double field to hold the value.The NUMBER token is
*	returned by yylex() to the parser. The function yylex() returns only
*	one digit at a time (0-9) to the parser. In this assignment design and
*	implement the number encoding using only yacc productions.Your
*	productions shall support decimal, hexadecimal, octal and floating
*	point formats. Encode the integers into the long lvalue and the
*	floating point into the double dvalue.
* 
*******************************************************************************/
%{
#include <stdio.h>
#include <ctype.h>
#include <math.h>

/*
 *	for debugging
 */
#define	YYDEBUG	1
/*
 *	define yystype
 */
#define YYSTYPE struct yycalc
YYSTYPE
{
	int	type;
	long	lvalue;
	double	dvalue;
};

%}

%start lines

%token NUMBER
%token LONG
%token DOUBLE

%left '|'
%left '^'
%left '&'
%left '+' '-'
%left '*' '/' '%'
%right UMINUS '~' /* supples precedence for unary minus */

%% 	/* beginning of rules section */

lines	: lines expr '\n'
	{
		switch( $2.type)
		{
		case LONG:
			printf("%d\n", $2.lvalue);
			break;
		case DOUBLE:
			printf("%g\n", $2.dvalue);
			break;
		}
	}
	| lines error '\n' { yyerrok; }
	| /* empty */
	;
expr
/*
 *	for bit operators if doubles, convert doubles to longs 
 */
	: expr '|' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue | $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = $1.lvalue | ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) | $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) | ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		}
	}
	| expr '^' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue ^ $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = $1.lvalue ^ ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) ^ $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) ^ ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		}
	}
	| expr '&' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue & $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = $1.lvalue & ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) & $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) & ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		}
	}
/*
 *	for math operators if doubles convert longs to doubles 
 */
	| expr '+' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue + $3.lvalue;
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = ($1.dvalue = (double)$1.lvalue) + $3.dvalue;
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue + ($3.dvalue = (double)$3.lvalue);
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue + $3.dvalue;
				break;
			}
			break;
		}
	}
	| expr '-' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue - $3.lvalue;
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = ($1.dvalue = (double)$1.lvalue) - $3.dvalue;
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue - ($3.dvalue = (double)$3.lvalue);
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue - $3.dvalue;
				break;
			}
			break;
		}
	}
	| expr '*' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue * $3.lvalue;
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = ($1.dvalue = (double)$1.lvalue) * $3.dvalue;
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue * ($3.dvalue = (double)$3.lvalue);
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue * $3.dvalue;
				break;
			}
			break;
		}
	}
	| expr '/' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue / $3.lvalue;
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = ($1.dvalue = (double)$1.lvalue) / $3.dvalue;
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue / ($3.dvalue = (double)$3.lvalue);
				break;
			case DOUBLE:
				$$.type = DOUBLE;
				$$.dvalue = $1.dvalue / $3.dvalue;
				break;
			}
			break;
		}
	}
	| expr '%' expr
	{
		switch( $1.type)
		{
		case LONG:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = $1.lvalue % $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = $1.lvalue % ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		case DOUBLE:
			switch( $3.type)
			{
			case LONG:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) % $3.lvalue;
				break;
			case DOUBLE:
				$$.type = LONG;
				$$.lvalue = ($1.lvalue = (long)$1.dvalue) % ($3.lvalue = (long)$3.dvalue);
				break;
			}
			break;
		}
	}
	| '(' expr ')'
	{
		$$ = $2;	/* C allows structure to structure copy */
	}
	| '~' expr
	{
		switch( $2.type)
		{
		case LONG:
			$$.type = LONG;
			$$.lvalue = ~ $2.lvalue;
			break;
		case DOUBLE:
			$$.type = LONG;
			$$.lvalue = ~ ($2.lvalue = (long)$2.dvalue);
			break;
		}
	}
	| '-' expr	%prec UMINUS
	{
		switch( $2.type)
		{
		case LONG:
			$$.type = LONG;
			$$.lvalue = - $2.lvalue;
			break;
		case DOUBLE:
			$$.type = DOUBLE;
			$$.dvalue = - $2.dvalue;
			break;
		}
	}
	| long
	{
		$$.type = LONG;
		$$.lvalue = $1.lvalue;
	}
	| double
	{
		$$.type = DOUBLE;
		$$.dvalue = $1.dvalue;
	}
	;

long	: NUMBER 
	{
		$$.lvalue = $1.lvalue;
	}
	;

double	: NUMBER '.'
	{
		$$.dvalue = $1.lvalue;
	}
	;

%% /*start of programs */

void	yyerror( char *s)
{
	printf( "%s\n", s);
}

/*
 *	yylex()
 *
 *	Input:	yylval:	Return:
 *	space	skip	continue
 *	tab	skip	continue
 *	'$'	-	EOF
 *	'\n'	-	'\n'
 *	[0-9]	digit	NUMBER
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
			yylval.lvalue = c - '0';	/* convert single ascii digit ('0'-'9') to binary value (0-9) */
			return NUMBER;
		}
		return( c);
	}
	return( -1);
}
