int	main( int argc, char *argv[])
{
	unsigned char	c;
/*
 *	test special characters
 */
	c = '\n';	/* newline */
	printf( "c: %02.2x\n", c);
	c = '\r';	/* cr */
	printf( "c: %02.2x\n", c);
	c = '\t';	/* tab */
	printf( "c: %02.2x\n", c);
	c = '\b';	/* backspace */
	printf( "c: %02.2x\n", c);
	c = '\\';	
	printf( "c: %02.2x\n", c);
	c = '\?';
	printf( "c: %02.2x\n", c);
	c = '\'';
	printf( "c: %02.2x\n", c);
	c = '\"';
	printf( "c: %02.2x\n", c);
/*
 *	return success
 */
	return 0;
}

