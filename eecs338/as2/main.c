#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <errno.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <string.h>
#include <time.h>


// for use in the pipes
#define READ 0
#define WRITE 1
#define COOP "1"
#define DEF "0"
#define str_eq(s1,s2)  (!strcmp ((s1),(s2)))
int p1_to_ref[2];
int p2_to_ref[2];

int main(int argc, char* argv[])
{
	pid_t pid1, pid2;
    int wait_ret, status;
    int scores[2];
    scores[0]=scores[1]=0;

    //initialize pipes
    
    if(pipe(p1_to_ref) == -1)
    {
        perror("main:ref:pipe1");
        exit(EXIT_FAILURE);
    }    
        
    if(pipe(p2_to_ref) == -1)
    {
        perror("main:ref:pipe2");
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
	if(pid1 > 0) {
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
    int i;
    for(i = 0; i<10; i++) {
    
        
        //ref behavior
        if(pid1 > 0 && pid2 > 0) { //parent
            printf("Game %d:\n",i);
        }
        char buffer1[10];
        char buffer2[10];
        //ref behavior
        if(pid1 > 0 && pid2 > 0) { //parent
            read(p1_to_ref[READ],buffer1,2);
            //int *intbuf;
            //read(p1_to_ref[READ],intbuf,sizeof(int)); //my attempt at passing integers in the pipe
            read(p2_to_ref[READ],buffer2,2);
            if(str_eq(buffer1,COOP) && str_eq(buffer2,COOP)) {
                scores[0]+=6;
                scores[1]+=6;
                printf("%d: coop.\t%d: coop.\n",pid1,pid2);
            } else if(str_eq(buffer1,COOP) && str_eq(buffer2,DEF)) {
                scores[0]+=120;
                printf("%d: coop.\t%d: def.\n",pid1,pid2);
            } else if(str_eq(buffer1,DEF) && str_eq(buffer2,COOP)) {
                scores[1]+=120;
                printf("%d: def.\t%d: coop.\n",pid1,pid2);
            } else if(str_eq(buffer1,DEF) && str_eq(buffer2,DEF)) {
                scores[0]+=72;
                scores[1]+=72;
                printf("%d: def.\t%d: def.\n",pid1,pid2);
            } else {
                perror("do_game:ref:read");
                exit(EXIT_FAILURE);
            }
        } else if(pid1 == 0) { //child1
            //player1 behavior 
            //write random number
            //srand(time(NULL));
            /*/itoa(rand()%2,choice,10);
            sprintf(choice,"%d",rand()%2);
            printf("%s",choice);
            fflush(NULL);
            write(p1_to_ref[WRITE],(int*)(rand()%2),sizeof(int));
            *///too much work to convert random int to string with correct length
            char* choice = "1";
            write(p1_to_ref[WRITE],choice,strlen(choice)+1);//(rand() % 2),1);
        } else if(pid2 == 0) { //child2
            //player2 behavior
            //write random number
            srand(time(NULL));
            char* choice = "0";
            write(p2_to_ref[WRITE],choice,strlen(choice)+1);//(rand() % 2),1);
        }
    }
    //print total and cleanup pipes
    if(pid1 > 0 && pid2 > 0) { //parent
        printf("--------\nScore:\n");
        printf("%d: %d months\n",pid1,scores[0]);
        printf("%d: %d months\n",pid2,scores[1]);

        //close all pipes
        close(p2_to_ref[READ]);
        close(p2_to_ref[WRITE]);
        close(p1_to_ref[READ]);
        close(p1_to_ref[WRITE]);
    }
    //exit children
    if(pid1==0 || pid2==0) { //children
        _exit(EXIT_SUCCESS);
    }

    //wait for 2 children to terminate
    wait_ret = (int)wait(&status);
    printf("player with pid %d terminated\n",wait_ret);
    wait_ret = (int)wait(&status);
    printf("player with pid %d terminated\n",wait_ret);

    //now children have terminated
    printf("ref terminating.\n");
    return EXIT_SUCCESS;
}

