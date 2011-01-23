int	main( int argc, char *argv[])
{
	unsigned int	x;
/*
 *	test hex integer zero to 255
 */
	x = 0x00;
	printf( "x: %02.2x\n", x);
	x = 0xff;
	printf( "x: %02.2x\n", x);
	x = 0x00l;
	printf( "x: %02.2x\n", x);
	x = 0xffl;
	printf( "x: %02.2x\n", x);
	x = 0x00u;
	printf( "x: %02.2x\n", x);
	x = 0xffu;
	printf( "x: %02.2x\n", x);
/*
 *	return success
 */
	return 0;
}

