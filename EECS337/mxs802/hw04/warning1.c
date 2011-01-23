int	main( int argc, char *argv[])
{
	char	c;
/*
 *	warning: multi-character character constant
 *	warning: overflow in implicit constant conversion
 */
	c = '\abc';
	printf( "c: %02.2x\n", c);
	return 0;
}
