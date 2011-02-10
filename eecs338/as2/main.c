#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>


#define READ 0 // for use in the pipes
#define WRITE 1

int main(int argc, char* argv[])
{
	int pipe_a[2];
	int pipe_b[2];
	int pipe_c[2];
	int pipe_d[2];
	
}