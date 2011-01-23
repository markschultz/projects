/*******************************************************************************
*
* FILE:		scan.l
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

%%
.			{ count(); sscanf( yytext, "%c", &yylval); return T_UNIVERSE; }

%%

/*
 *	yywrap function
 */
int	yywrap( void)
{
	return(1);
}

/*
 *	c preprocessor function
 */
void	pdefine( void)
{
	char c;

	if( IS_FLAGS_ECHO( data.flags))
	    ECHO;
	while(( c = input()) != '\n' && c != 0)
	      if( c && IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
}

/*
 *	c comment function
 */
void	comment( void)
{
	char c, c1;

	if( IS_FLAGS_ECHO( data.flags))
	    ECHO;
loop:
	while(( c = input()) != '*' && c != 0)
	      if( c && IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c);

	if(( c1 = input()) != '/' && c != 0)
	{
		unput(c1);
		goto loop;
	}
	if( c != 0)
	      if( IS_FLAGS_ECHO( data.flags))
	      	  putchar(c1);
}

/*
 *	update the current column index value
 */
void	count( void)
{
	int i;

	for( i = 0; yytext[i] != '\0'; i++)
		if( yytext[i] == '\n')
			data.column = 0;
		else if( yytext[i] == '\t')
			data.column += 8 - (data.column % 8);
		else
			data.column++;
	if( yytext[0] && IS_FLAGS_ECHO( data.flags))
	    ECHO;
}

