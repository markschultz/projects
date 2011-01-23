int	main( int argc, char *argv[])
{
	char	o;
/*
 *	error: invalid digit "9" in octal constant
 *	return error
 */
	o = 089;
	printf( "o: %2.2x\n", o);
	return 0;
}
