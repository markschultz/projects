int	main( int argc, char *argv[])
{
	char	o;
/*
 *	warning: data conversion error
 *	warning: overflow in implicit constant conversion
 */
	o = 0777;
	printf( "o: %02.2x\n", o);
	return 0;
}
