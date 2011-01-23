/*******************************************************************************
*
* FILE:		yystype.h for universe compiler
*
* DESC:		EECS 337 Assignment 3
*
* AUTHOR:	mxs802
*
* DATE:		September 14, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/
#ifndef	YYSTYPE_H
#define	YYSTYPE_H	1

#include	<stdio.h>
#include	<stdlib.h>
#include	<string.h>
#include	<time.h>

/*
 *	define a clips structure
 *	supports: CONSTANT STRING_LITERAL IDENTIFIER types
 */
#define	CLIPS	struct clips
CLIPS
{
	CLIPS		*next;
	int		token;
	unsigned char	value;
	int		address;
#define	MASK_VALUE	0x0001
#define	MASK_ADDRESS	0x0002
#define	MASK_LABEL	0x0004
#define	MASK_W_REG	0x0008
#define	MASK_F_REG	0x0010
#define	MASK_INSTR	0x0020
	int		mask;
	char		*buffer;
	int		length;
	int		level;
};

/*
 *	define yystype
 */
#define YYSTYPE union yyansi_c
YYSTYPE
{
	int	token;
	CLIPS	*clips;
};

/*
 *	define a global data structure
 */
#define	DATA	struct data
DATA
{
	CLIPS *typedef_table;
	int memory;
	int	column;
	int	flags;
#define	FLAGS_ECHO	0x0001
#define	FLAGS_DEBUG	0x0002
#define	FLAGS_PARSE	0x0004
#define	IS_FLAGS_ECHO(a)	(a & FLAGS_ECHO)	
#define	SET_FLAGS_ECHO(a)	(a |= FLAGS_ECHO)
#define	CLR_FLAGS_ECHO(a)	(a &= ~FLAGS_ECHO)
#define	IS_FLAGS_DEBUG(a)	(a & FLAGS_DEBUG)	
#define	SET_FLAGS_DEBUG(a)	(a |= FLAGS_DEBUG)
#define	CLR_FLAGS_DEBUG(a)	(a &= ~FLAGS_DEBUG)
#define	IS_FLAGS_PARSE(a)	(a & FLAGS_PARSE)	
#define	SET_FLAGS_PARSE(a)	(a |= FLAGS_PARSE)
#define	CLR_FLAGS_PARSE(a)	(a &= ~FLAGS_PARSE)
	int 	errors;
	int 	warnings;
};

/*
 *	define for yyparser debugging
 */
#define	YYDEBUG	1
/*
 *	external variables and functions from scan.l
 */
extern FILE	*yyin;
extern FILE	*yyout;
extern	char	*yytext;
extern	int	yyleng;
extern	int	yynerrs;
extern	YYSTYPE	yylval;		/* YYSTYPE */
extern	int	yywrap( void);
extern	void	pdefine( void);
extern	void	comment( void);
extern	void	count( void);
extern	int	check_type( void);
extern	char	*tokens[];
extern	void	al_error( int length);
extern	char	*al_buffer( char *text, int length);
extern	void	de_buffer( char *buffer, int length);
extern	CLIPS	*al_clips( int token, unsigned char value, int address, int mask, char *buffer, int length);
extern	void	de_clips( CLIPS *clips);
extern	void	de_clips_list( CLIPS *clips);
extern	CLIPS	*end_clips( CLIPS *clips);
extern	void	print_clips( CLIPS *clips);
extern	void	print_clips_list( CLIPS *clips);
/*
 *	external variables and functions from gram.y
 */
extern	int	yydebug;
extern	int	yyparse( void);
extern	void	yyerror( char *s);
/*
 *	external variables and functions from main.c
 */
extern	DATA	data;
extern	int	main( int argc, char *argv[]);

#endif
