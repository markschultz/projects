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

/*
 *	two global variables needed to encode longs and doubles in parser
 */
double	factor;	/* keep track of digits past dot '.' */
int	radix;	/* keep track of decimal or octal format */

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
/*
 *	a solution to encoding longs and most doubles
 *	note: for doubles only 5 characters past dot are encoded
 *	and formats 1e9 and 099.1 do not encode correct
 */
long	: numbers lLuU
	| NUMBER xletter hexidecimal lLuU
	{
		$$.lvalue = $3.lvalue;
	}
	;

numbers	: NUMBER
	{
		if( $1.lvalue)
			radix = 10;	/* radix is 10 or 8 */
		else
			radix = 8;	/* if first digit is 0 then octal format */
	}
	| numbers NUMBER
	{
		$$.lvalue = $1.lvalue * radix + $2.lvalue;
	}
	;

lLuU	: lletter
	| uletter
	| /* empty */
	;

lletter	: 'l'
	| 'L'
	;

uletter	: 'u'
	| 'U'
	;

xletter	: 'x'
	| 'X'
	;

hexidecimal
	: hexnumber	/* radix is 16 */
	| hexidecimal hexnumber 
	{
		$$.lvalue = $1.lvalue * 16 + $2.lvalue;
	}
	;

hexnumber
	: NUMBER
	| aletter	{ $$.lvalue = 0x0a; }
	| bletter	{ $$.lvalue = 0x0b; }
	| cletter	{ $$.lvalue = 0x0c; }
	| dletter	{ $$.lvalue = 0x0d; }
	| eletter	{ $$.lvalue = 0x0e; }
	| fletter	{ $$.lvalue = 0x0f; }
	;

aletter	: 'a'
	| 'A'
	;

bletter	: 'b'
	| 'B'
	;

cletter	: 'c'
	| 'C'
	;

dletter	: 'd'
	| 'D'
	;

eletter	: 'e'
	| 'E'
	;

fletter	: 'f'
	| 'F'
	;

double	: numbers '.' exponent lLfF
	{
		$$.dvalue = ($1.dvalue = (double)$1.lvalue) * $3.dvalue;
	}
	| '.' remainder exponent lLfF
	{
		$$.dvalue = $2.dvalue * $3.dvalue;
	}
	| numbers '.' remainder exponent lLfF
	{
		$$.dvalue = (($1.dvalue = (double)$1.lvalue) + $3.dvalue) * $4.dvalue;
	}
	;

lLfF	: lletter
	| fletter
	| /* empty */
	;

remainder
	: NUMBER
	{
		factor = 0.1;
		$$.dvalue = ($1.dvalue = (double)$1.lvalue) * factor;
	}
	| remainder NUMBER
	{
		factor *= 0.1;
		$$.dvalue = $1.dvalue + (($2.dvalue = (double)$2.lvalue) * factor);
	}
	;

exponent
	: eletter sign numbers
	{
		if( $2.type)
			$$.dvalue = pow( 10.0, ($3.dvalue = (double)$3.lvalue));
		else
			$$.dvalue = pow( 10.0, -($3.dvalue = (double)$3.lvalue));
	}
	| /* empty */
	{
		$$.dvalue = 1.0;
	}
	;

sign	: '+'
	{
		$$.type = 1;
	}
	| '-'
	{
		$$.type = 0;
	}
	| /* empty set default '+' */
	{
		$$.type = 1;
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
			yylval.lvalue = c - '0';	/* convert single ascii digit ('0'-'9') to binary value (0-9) */
			return NUMBER;
		}
		return( c);
	}
	return( -1);
}
