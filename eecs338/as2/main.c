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
#define ASK "1"
#define TERM "0"
#define str_eq(s1,s2)  (!strcmp ((s1),(s2)))
int p1_to_ref[2];
int p2_to_ref[2];
int ref_to_p1[2];
int ref_to_p2[2];

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
    if(pipe(ref_to_p1) == -1)
    {
        perror("main:ref:pipe3");
        exit(EXIT_FAILURE);
    }
    if(pipe(ref_to_p2) == -1)
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
    for(i = 0; i<=10; i++) {
    
        
        //ref behavior
        char buffer1[10];
        char buffer2[10];
        //ref behavior
        if(pid1 > 0 && pid2 > 0) { //parent
            if(i==10){
                //terminate children
                write(ref_to_p1[WRITE],TERM,strlen(TERM)+1);
                write(ref_to_p2[WRITE],TERM,strlen(TERM)+1);
                break;
            } else {
                printf("Game %d:\n",i+1);
                write(ref_to_p1[WRITE],ASK,strlen(ASK)+1);//ask 2 children for numbers
                write(ref_to_p2[WRITE],ASK,strlen(ASK)+1);
            }
            read(p1_to_ref[READ],buffer1,2);//read for responses
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
            char* choice = "1";
            char buf[5];
            read(ref_to_p1[READ],buf,2);
            if(str_eq(buf,ASK)) {
                write(p1_to_ref[WRITE],choice,strlen(choice)+1);//(rand() % 2),1);
            } else if (str_eq(buf,TERM)) {
                //printf("Player1 exiting...\n");
                fflush(NULL);
                _exit(EXIT_SUCCESS);
            } else {
                perror("main:p1:read");
                _exit(EXIT_FAILURE);
            }
        } else if(pid2 == 0) { //child2
            //player2 behavior
            char* choice = "0";
            char buf[5];
            read(ref_to_p2[READ],buf,2);
            if(str_eq(buf,ASK)) {
                write(p2_to_ref[WRITE],choice,strlen(choice)+1);//(rand() % 2),1);
            } else if (str_eq(buf,TERM)) {
                //printf("Player2 exiting...\n");
                fflush(NULL);
                _exit(EXIT_SUCCESS);
            } else {
                perror("main:p2:read");
                _exit(EXIT_FAILURE);
            }        
        }
    }
    //print total and cleanup pipes
    if(pid1 > 0 && pid2 > 0) { //parent
        printf("--------\nScore:\n");
        printf("%d: %d months\n",pid1,scores[0]);
        printf("%d: %d months\n",pid2,scores[1]);

        //close all pipes
        close(ref_to_p1[READ]);
        close(ref_to_p1[WRITE]);
        close(ref_to_p2[READ]);
        close(ref_to_p2[WRITE]);
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

