program COOKIE_PROG
{
	version COOKIE_VERS
	{
		int get_cookie(int) = 1;
		void remote_exit(int) = 2;
	} = 1;
} = 0x20000001;