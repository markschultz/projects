int	main( int argc, char *argv[])
{
	char c;	   /* char */
	int i;	/* decimal */
	int x;	/* hex */
	int o;	/* octal */
	float f;   /* float */
	double d;  /* double */
/*
 *	determine if there any other ways to enter 3 (excluding floats, doubles)
 *	and save all the other examples in a file called three.c
 */
	c = '\03';
	c = '\003';
	c = '\x3';
	c = '\x03';
	c = '\x003';
	c = '\x0003';
	c = '\x00003';
	c = '\x000003';
	i = 3;
	x = 0x3;
	x = 0x03;
	x = 0x003;
	x = 0x0003;
	x = 0x00003;
	x = 0x000003;
	x = 0x0000003;
	x = 0x00000003;
	x = 0x000000003;
	o = 03;
	o = 003;
	o = 0003;
	o = 00003;
	o = 000003;
	o = 0000003;
	o = 00000003;
	o = 000000003;
	o = 0000000003;
	o = 00000000003;
	o = 000000000003;
/*
 *	a few float and double examples, get rounded to decimal 3
 */
	f = 3.14;
	f = .314e1;
	d = 3.1415359;
	d = 0.31415359e1;
/*
 *	return 3
 */
	return 3;
}
