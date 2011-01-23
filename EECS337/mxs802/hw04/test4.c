int	main( int argc, char *argv[])
{
	unsigned char	c;
/*
 *	test hex char NUL to DEL
 */
	c = '\x00';
	printf( "c: %02.2x\n", c);
	c = '\xff';
	printf( "c: %02.2x\n", c);
/*
 *	return success
 */
	return 0;
}

