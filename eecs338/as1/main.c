//Mark Schultz
//EECS338 AS#1 2/2/2011
//

#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/times.h>
#include <time.h>
#include <sys/param.h>

int main(int argc, char *argv[]) {


	int childID1 = 0, childID2 = 0; // process ids for both children from fork
	//get hostname to print
	char hostname[1024];
	hostname[1023] = '\0';
	gethostname(hostname,1023);
	//get username to print
	char username[1024] = getlogin(); //cuserid() is depricated, manpages suggested getlogin instead
	//get time then parse readable time for printing
	time_t resulttime = time(NULL);
	//getcwd - current working directory 
	char path[MAXPATHLEN];
	getcwd(path,MAXPATHLEN);
	
	
	int err = gethostname()
	printf("Parent process started with PID: %5d\n on HOST: %s\n by user: %s\n at %s\n in ", getpid(),hostname,username,asctime(localtime(&resulttime)),path);
	