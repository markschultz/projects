/******************************************************************************
*
* FILE:		examples.y
*
* DESC:		EECS 337 Assignment 3
*
* AUTHOR:	caseid
*
* DATE:		September 14, 2010
*
* EDIT HISTORY:	
*
*	This file provides two examples of coding productions in the
*	parser. The first example puts the non-terminal symbol before the
*	terminal symbol. The second example puts the terminal symbol
*	before the non-terminal symbol. YACC is an LR parser (left-reduce) so
*	one of these examples pushes all the tokens onto the yacc stack before
*	reducing, Where the other one pushes and pops tokens onto the stack.
*	
*	The debug statements are conditioned by C preprocessor #ifdef that
*	allow the debug statements to be included or excluded from the build.
*	In this case YYDEBUG is also used by the yacc software to include the
*	verbose debug stack statements in the build of the parser. The yacc
*	stack debug statements are switched based on the +yydebug flag where
*	the parser debug statements are switched based on the +debug flag.
*	
*	Attibutes are accessed in productions using the $$, $1, $2,
*	format. Where $$ is the left hand variable and $1, $2, etc are for
*	each right hand variable. If no actions are include in the production,
*	then by default the production reduces to $$ = $1.
*	
*******************************************************************************/
/*
 *	example one
 *	replace the smallest compiler in the gram.y file with this example
 *	compile and run it with the debug flags and look at the output
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
		| universes T_UNIVERSE
		{
#ifdef	YYDEBUG
			if( IS_FLAGS_DEBUG( data.flags))
				printf( "universes: $1=%d T_UNIVERSE: $2=%d\n", $1, $2);
#endif
		}
		;
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

