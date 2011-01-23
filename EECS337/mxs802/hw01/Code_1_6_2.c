/*******************************************************************************
*
* FILE:		Code_1_6_2.c
*
* DESC:		EECS 337 Homework Assignment 1
*
* AUTHOR:	mxs802
*
* DATE:		August 26, 2010
*
* EDIT HISTORY:	
*
*******************************************************************************/

/*
 *	main program
 */
int	main( int argc, char *argv[])
{
/*
 *	enter the sample code from 1.6.2
 */
	int w, x, y, z;
	int i = 3; int j =4;
	{   int i = 5;
	    w = i + j;
	}
	x = i + j;
	{   int j = 6;
	    i = 7;
	    y = i + j;
	}
	z = i + j;
/*
 *	print the results
 */
	printf( "w:%d,\tx:%d,\ty:%d,\tz:%d\n", w, x, y, z);
/*
 *	return success
 */
	return 0;
}
