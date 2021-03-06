/*******************************************************************************
*
* FILE:		yystype.h for ansi_c compiler
*
* DESC:		EECS 337 Assignment 11
*
* AUTHOR:	caseid
*
* DATE:		November 9, 2010
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
 *	define pic instructions
 */
#define I_LABEL		0
#define I_MOV		1
#define I_ADD		2
#define I_AND		3
#define I_IOR		4
#define I_SUB		5
#define I_XOR		6
#define I_COMF		7
#define I_DECF		8
#define I_DECFSZ	9
#define I_INCF		10
#define I_INCFSZ	11
#define I_RLF		12
#define I_RRF		13
#define	I_SWAPF		14
#define I_BCF		15
#define I_BSF		16
#define I_BTFSC		17
#define I_BTFSS		18
#define I_CALL		19
#define I_GOTO		20
#define I_TRIS		21
#define I_CLR		22
#define I_RETLW		23
#define I_CLRWDT	24
#define I_NOP		25
#define I_OPTION	26
#define I_RETFIE	27
#define I_RETURN	28
#define I_SLEEP		29
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
#define YYSTYPE struct yyansi_c
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
	int	column;
	int	flags;
#define	FLAGS_ECHO	0x0001
#define	FLAGS_DEBUG	0x0002
#define	FLAGS_PARSE	0x0004
#define	FLAGS_SYMBOL	0x0008
#define	FLAGS_MAIN	0x0010
#define	IS_FLAGS_ECHO(a)	(a & FLAGS_ECHO)	
#define	SET_FLAGS_ECHO(a)	(a |= FLAGS_ECHO)
#define	CLR_FLAGS_ECHO(a)	(a &= ~FLAGS_ECHO)
#define	IS_FLAGS_DEBUG(a)	(a & FLAGS_DEBUG)	
#define	SET_FLAGS_DEBUG(a)	(a |= FLAGS_DEBUG)
#define	CLR_FLAGS_DEBUG(a)	(a &= ~FLAGS_DEBUG)
#define	IS_FLAGS_PARSE(a)	(a & FLAGS_PARSE)	
#define	SET_FLAGS_PARSE(a)	(a |= FLAGS_PARSE)
#define	CLR_FLAGS_PARSE(a)	(a &= ~FLAGS_PARSE)
#define	IS_FLAGS_SYMBOL(a)	(a & FLAGS_SYMBOL)	
#define	SET_FLAGS_SYMBOL(a)	(a |= FLAGS_SYMBOL)
#define	CLR_FLAGS_SYMBOL(a)	(a &= ~FLAGS_SYMBOL)
#define	IS_FLAGS_MAIN(a)	(a & FLAGS_MAIN)	
#define	SET_FLAGS_MAIN(a)	(a |= FLAGS_MAIN)
#define	CLR_FLAGS_MAIN(a)	(a &= ~FLAGS_MAIN)
	int	errors;
	int	warnings;
	int	memory;
	CLIPS	*typedef_table;
	int	level;
	CLIPS	*symbol_table;
#define	TOP_STATIC	0x000c
#define	BOTTOM_STATIC	0x004f
	int	address;
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
extern	YYSTYPE	yylval;		
extern	int	yywrap( void);
extern	void	pdefine( void);
extern	void	comment( void);
extern	void	count( void);
extern	int	check_type( void);

extern	char	*tokens[];
extern	char	*instr_table[];
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
