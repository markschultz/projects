int	main( int argc, char *argv[])
{
	unsigned int	o;
/*
 *	test octal integer zero to 255
 */
	o = 0;
	printf( "o: %02.2x\n", o);
	o = 0377;
	printf( "o: %02.2x\n", o);
	o = 0l;
	printf( "o: %02.2x\n", o);
	o = 0377l;
	printf( "o: %02.2x\n", o);
	o = 0u;
	printf( "o: %02.2x\n", o);
	o = 0377u;
	printf( "o: %02.2x\n", o);
/*
 *	return success
 */
	return 0;
}

