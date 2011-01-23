/*******************************************************************************
*
* FILE:		yystype.h for calculator program page 292
*
* DESC:		EECS 337 Assignment 7
*
* AUTHOR:	caseid
*
* DATE:		October 5, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/
#ifndef	YYSTYPE_H
#define	YYSTYPE_H	1

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
 *	lex variables
 */
extern FILE	*yyin;
extern FILE	*yyout;
extern	char	*yytext;
extern	int	yyleng;
extern	int	yynerrs;
extern	int	yydebug; 
extern	YYSTYPE yylval;
extern	int	yyparse();

#endif
