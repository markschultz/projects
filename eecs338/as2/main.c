#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>


#define READ 0 // for use in the pipes
#define WRITE 1
#define COOP 1
#define DEF 0
#define MAX_BUFFER_SIZE 256
int do_game(pid_t, pid_t, int *b);
int ref_to_p1[2];
int p1_to_ref[2];
int ref_to_p2[2];
int p2_to_ref[2];

int main(int argc, char* argv[])
{
	pid_t pid1, pid2;
    int wait_ret, status;

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
    } else if(pid1 > 0) { //parent
        printf("player 1 with pid %d spawned.\n",pid1);
    }
    
    //second fork
	if(pid1 != 0) {
		//must be parent
		pid2 = fork();
        if(pid2 == -1)
        {
            perror("main:ref:fork2");
            exit(EXIT_FAILURE);
        } else if(pid2 > 0) { //parent
            printf("player 2 with pid %d spawned.\n",pid2);
        }
	}
    
    //now start the game
    //ref behavior
    if(pid1 > 0 && pid2 > 0) { //parent
    }        




    //wait for 2 children to terminate
    wait_ret = (int)wait(&status);
    printf("player with pid %d terminated\n",wait_ret);
    wait_ret = (int)wait(&status);
    printf("player with pid %d terminated\n",wait_ret);

    //now children have terminated
    printf("now terminating.\n");
    return EXIT_SUCCESS;
}
int do_game(pid_t pid1, pid_t pid2, int *scores) {
    /*char buffer1[MAX_BUFFER_SIZE];
    char buffer2[MAX_BUFFER_SIZE];*/ //not needed
    int buffer1, buffer2;
    //ref behavior
    if(pid1 > 0 && pid2 > 0) { //parent
       read(p1_to_ref[READ],buffer1,1);
       read(p2_to_ref[READ],buffer2,1);
       if(buffer1 == COOP && buffer2 == COOP) {
           scores[0]+=6;
           scores[1]+=6;
       } else if(buffer1 == COOP && buffer2 == DEF) {
           scores[0]+=120;
       } else if(buffer1 == DEF && buffer2 == COOP) {
           scores[1]+=120;
       } else if(buffer1 == DEF && buffer2 == DEF) {
           scores[0]+=72;
           scores[1]+=72;
       } else {
           perror("do_game:ref:read");
           exit(EXIT_FAILURE);
       }
    } else if(pid1 == 0) { //child1
       //player1 behavior 
    }


}
return EXIT_SUCCESS;
}
