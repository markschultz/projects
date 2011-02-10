#include <stdio.h>
#include <stdlib.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>


#define READ 0 // for use in the pipes
#define WRITE 1
#define MAX_BUFFER_SIZE 256

int main(int argc, char* argv[])
{
	int ref_to_p1[2];
	int p1_to_ref[2];
	int ref_to_p2[2];
	int p2_to_ref[2];
    pid1_t pid1, pid2;
    char buffer[MAX_BUFFER_SIZE];

    //initialize pipes
    if(pipe(ref_to_p1) == -1)
    {
        perror("main:ref:pipe1");
        exit(EXIT_FAILURE);
    }
    if(pipe(p1_to_ref) == -1)
    {
        perror("main:ref:pipe2");
        exit(EXIT_FAILURE);
    }    
    if(pipe(ref_to_p2) == -1)
    {
        perror("main:ref:pipe3");
        exit(EXIT_FAILURE);
    }    
    if(pipe(p2_to_ref) == -1)
    {
        perror("main:ref:pipe4");
        exit(EXIT_FAILURE);
    }

    //fork twice, error handle
    pid1 = fork();
    if(pid1 == -1)
    {
        perror("main:ref:fork1");
        exit(EXIT_FAILURE);
    } else {
        printf("child 1 with pid %5d spawned.\n",pid1);
    }
    
    //second fork
	if(pid1 != 0) {
		//must be parent
		pid2 = fork();
        if(pid2 == -1)
        {
            perror("main:ref:fork2");
            exit(EXIT_FAILURE);
        } else {
        printf("child 2 with pid %5d spawned.\n",pid2);
    }

	}

return 0;
}
