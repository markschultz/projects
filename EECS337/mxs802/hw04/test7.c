int	main( int argc, char *argv[])
{
	unsigned int	d;
/*
 *	test decimal integer zero to 255
 */
	d = 0;
	printf( "d: %02.2x\n", d);
	d = 255;
	printf( "d: %02.2x\n", d);
	d = 0l;
	printf( "d: %02.2x\n", d);
	d = 255l;
	printf( "d: %02.2x\n", d);
	d = 0u;
	printf( "d: %02.2x\n", d);
	d = 255u;
	printf( "d: %02.2x\n", d);
/*
 *	return success
 */
	return 0;
}

