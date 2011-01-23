/*******************************************************************************
*
* FILE:		calc.c
*
* DESC:		EECS 337 Assignment 7
*
* AUTHOR:	caseid
*
* DATE:		October 5, 2010
*
* EDIT HISTORY:	
*      		Main routine to call the Calculator page 292
*
*******************************************************************************/
#include <stdlib.h>
#include <stdio.h>
#include	<time.h>

extern	int	yydebug; 
extern	int	yyparse();

/*******************************************************************************
 *	main program
 ******************************************************************************/
int	main( int argc, char *argv[])
{
	time_t	t;
/*
 *	print start of test time
 */
	time( &t);
	fprintf( stdout, "for caseid start time: %s", ctime( &t));
/*
 *	check command line
 */
	if( 1 < argc)
		yydebug = 1;
/*
 *	print the sizeof integers, longs, floats and doubles
 */
	printf( "SIZEOF int: %d long: %d float: %d double: %d\n", sizeof( int), sizeof( long), sizeof( float), sizeof( double));
/*
 *	call the parser
 */
	printf( "Enter calculator expression and $ to exit\n");
	yyparse();
/*
 *	return
 */
	return 0;
}

