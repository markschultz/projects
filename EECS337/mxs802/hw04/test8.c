int	main( int argc, char *argv[])
{
	float	f;
/*
 *	test float zero to 255
 */
	f = 0.0;
	printf( "f: %f\n", f);
	f = 255.0;
	printf( "f: %f\n", f);
	f = 0.0l;
	printf( "f: %f\n", f);
	f = 255.0l;
	printf( "f: %f\n", f);
	f = 0.0f;
	printf( "f: %f\n", f);
	f = 255.0f;
	printf( "f: %f\n", f);
	f = 0.;
	printf( "f: %f\n", f);
	f = 255.;
	printf( "f: %f\n", f);
	f = 0.l;
	printf( "f: %f\n", f);
	f = 255.l;
	printf( "f: %f\n", f);
	f = 0.f;
	printf( "f: %f\n", f);
	f = 255.f;
	printf( "f: %f\n", f);
	f = .0;
	printf( "f: %f\n", f);
	f = .255e3;
	printf( "f: %f\n", f);
	f = .0l;
	printf( "f: %f\n", f);
	f = .255e3l;
	printf( "f: %f\n", f);
	f = .0f;
	printf( "f: %f\n", f);
	f = .255e3f;
	printf( "f: %f\n", f);
/*
 *	return success
 */
	return 0;
}

