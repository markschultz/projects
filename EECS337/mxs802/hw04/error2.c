int	main( int argc, char *argv[])
{
	char	x;
/*
 *	error: invalid suffix "g" on integer constant
 *	return error
 */
	x = 0xag;
	printf( "x: %2.2x\n", x);
	return 0;
}
