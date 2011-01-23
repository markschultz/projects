int	main( int argc, char *argv[])
{
	unsigned char	c;
/*
 *	test octal char NUL to DEL
 */
	c = '\000';
	printf( "c: %02.2x\n", c);
	c = '\377';
	printf( "c: %02.2x\n", c);
/*
 *	return success
 */
	return 0;
}

