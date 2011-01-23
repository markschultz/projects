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
 *	example two
 *	now replace the previous productions in the gram.y file with this example
 *	compile and run it with the debug flags and look at the output
 *	now compare both and determine which is the better way to write productions
 */
everything	: universes
		{
#ifdef	YYDEBUG
			if( IS_FLAGS_DEBUG( data.flags))
				printf( "universes: $1=%d\n", $1);
#endif
		}
		;
universes	: T_UNIVERSE
		{
#ifdef	YYDEBUG
			if( IS_FLAGS_DEBUG( data.flags))
				printf( "T_UNIVERSE: $1=%d\n", $1);
#endif
		}
		| T_UNIVERSE universes 
		{
#ifdef	YYDEBUG
			if( IS_FLAGS_DEBUG( data.flags))
				printf( "T_UNIVERSE: $1=%d universes: $2=%d\n", $1, $2);
#endif
		}
		;

%%

void	yyerror( char *s)
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", data.column, "^", data.column, s);
}
