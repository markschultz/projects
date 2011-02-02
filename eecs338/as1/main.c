//Mark Schultz
//EECS338 AS#1 2/2/2011
//

#include <stdio.h>
#include <sys/types.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/times.h>
#include <time.h>
#include <sys/param.h>

int main(int argc, char *argv[]) {

	int printHippo(int, int);
	int childID1 = 0, childID2 = 0; // process ids for both children from fork
	//get hostname to print
	char hostname[1024];
	hostname[1023] = '\0';
	gethostname(hostname,1023);
	//get username to print
	char *username = getlogin(); //cuserid() is depricated, manpages suggested getlogin instead
	//get time then parse readable time for printing
	time_t resulttime = time(NULL);
	//getcwd - current working directory 
	char path[MAXPATHLEN];
	getcwd(path,MAXPATHLEN);
	
	//print all this info
	printf("Parent process started with\n PID: %5d\n on HOST: %s\n by user: %s\n at %s in %s\n", getpid(),hostname,username,asctime(localtime(&resulttime)),path);

	//procede to next part of the program w. forking
	putenv("HIPPO=11");
	char *hippo = getenv("HIPPO");
	printf("hippo inits as %s\n",hippo);

	//now to forking children
	int pid2=-2;
	int pid = fork();
	if (pid == -1) {
		perror("Error: first fork");
		exit(1);
	}
	else if (pid == 0) {
		//must be child
		childID1=getpid();
		if (pid == -1) {
			perror("Error: cant get first child pid");
			_exit(1);
		}
		else {
			printf("child 1 with pid %5d spawned.\n",childID1);
		}
	}

	//second fork
	if(pid != 0) {
		//must be parent
		pid2 = fork();
	}

	//error checking on second child
	if(pid2 == -1) {
		perror("Error: second fork");
		exit(1);
	}
	else if (pid2 == 0) {
		//must be second child
		childID2=getpid();
		if (pid2 == -1) {
			perror("Error: cant get second child pid");
			_exit(1);
		}
		else {
			printf("child 2 with pid %5d spawned.\n",childID2);
		}
	}

	if (pid == 0){sleep(1);printf("the sleeps will take a very long time\n");}//warning...
	//now we have to sleep different values for each process because they arent really waiting for eachother
	int hippoi = atoi(getenv("HIPPO"));
	if (pid == 0) {
			//must be parent
		}
		if ((pid !=0) && (pid2 !=0)) {
			//must be second child
			sleep(10);
			hippoi = hippoi -2; //decrement by 2 because its last in line to print
		}
		if ((pid != 0)&&(pid2 == 0)) {
			//must be first chilD
	    sleep(5);
			hippoi = hippoi -1; //decrement by one because it will have to start at 10-1 because it comes after parent
		}

	while (hippoi > 0) { //printing loop
		if (pid == 0) {
			//must be parent
			hippoi = printHippo(hippoi, 0);
			fflush(NULL);
		}
		if ((pid !=0) && (pid2 ==0)) {
			//must be second child
			hippoi = printHippo(hippoi, 1);
			fflush(NULL);
		}
		if ((pid != 0)&&(pid2 != 0)) {
			//must be first child
			hippoi = printHippo(hippoi, 2);
			fflush(NULL);
		}	
	}
	putenv("HIPPO=1");//after decrementing put back to env
	if(pid != 0) {sleep(30);}//children wait for parent to wait so they execute in the correct order	
	int status;
	//final process stuff before return
	if (pid == 0) { //parent
		sleep(20);
		printf("Final value of Hippo is %d.\n",atoi(getenv("HIPPO"))+1);
	}	if ((pid !=0) && (pid2 ==0)) { //child2 pwd, get increment print hippo, exit
		getcwd(path, MAXPATHLEN);
		printf("final statement from C2: cwd: %s hippo: %d exiting c2...\n",path,atoi(getenv("HIPPO"))+1);
		fflush(NULL);
		_exit(1);
	} if ((pid != 0)&&(pid2 != 0)) { //child1 ch, exec, ls, exit
		if (chdir(path) == -1){perror("Error: chdir.");}//changedir to current dir
		printf("final print from C1: ");
		if (execlp("ls", path, NULL) == -1){perror("Error: execlp");}
		printf("exiting c1...\n");
		fflush(NULL);
		_exit(1);
	}
	return 0;

}
int printHippo(int hippo, int p) { //not really necessary but I wanted to make sure i remembered how to make a separate function

	if (p == 0) {
		sleep(16); //sleep should be at least 30 on all of them
		printf("P: %d little hippopotamus\n", hippo);
	} else if (p==1) {
		sleep(16);
		printf("C1: %d little hippopotamus\n", hippo);
	} else if (p==2) {
		sleep(16);
		printf("C2: %d little hippopotamus\n", hippo);
	}
	return(hippo-3); //decrement by 3 because there is a ring of three taking turns
}
