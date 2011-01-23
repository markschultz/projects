/*******************************************************************************
*
* FILE:		yacc.y 
*
* DESC:		EECS 337 Assignment 7
* SYNOPSIS:	Calculator (page 292)
* 		yacc -dv yacc.y 
* 		mv -f y.tab.c yacc.c
*
*
* AUTHOR:	caseid
*
* DATE:		October 5, 2010
*
* EDIT HISTORY:	
*
*	added lex.l for the scanner and removed yylex() and parser encoder
*	productions for constants
*
*******************************************************************************/
%{
#include <stdio.h>
#include <ctype.h>
#include "yystype.h"

%}

%start lines

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
	| LONG
	| DOUBLE
	;

%% /*start of programs */

void	yyerror( char *s)
{
	printf( "%s\n", s);
}

