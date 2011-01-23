/*******************************************************************************
*
* FILE:		gram.y
*
* DESC:		EECS 337 Assignment 3
*
* AUTHOR:	caseid
*
* DATE:		September 14, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/
%{

#include	"yystype.h"
#include	"y.tab.h"

%}

%token T_UNIVERSE

%start everything

%%

/*
 *	the smallest compiler, parsers any one thing or everything 
 */
everything	: T_UNIVERSE
		{
#ifdef	YYDEBUG
			if( IS_FLAGS_DEBUG( data.flags))
				printf( "everything: $1=%d\n", $1);
#endif
		}
		;
%%

void	yyerror( char *s)
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", data.column, "^", data.column, s);
}
