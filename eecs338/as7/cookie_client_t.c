#include "cookie.h"
#include <stdlib.h>
#include <unistd.h>
#include <time.h>

void do_tina(CLIENT *clnt){
	sleep(rand()%7+1);//sleep random time 1-8
	
	int  *result;
	int  get_cookie_1_arg = 1;// 1 is tina
	void  *result_2;
	int  remote_exit_1_arg = 1;
	
	result = get_cookie_1(&get_cookie_1_arg, clnt);
	if (result == (int *) NULL) {
		//clnt_perror (clnt, "call failed");
		clnt_destroy (clnt);
		exit(1);
	}
	switch(*result){
		case 0:
			printf("tina: empty jar\n");
			break;
		case 1:
			printf("tina: got cookie\n");
			break;
		case 2:
			printf("tina: didn't get cookie -- shouldn't happen\n");
			break;
		default:
			printf("tina: error result: %d\n",*result);
			break;
	}
	if(*result == 0){
		result_2 = remote_exit_1(&remote_exit_1_arg, clnt);
		printf("tina: killed server\n");
		clnt_destroy (clnt);
		exit(0);
	} 
}

int main (int argc, char *argv[])
{
	srand((unsigned int) time(NULL));//seed rand
	char *host;
	int remote_exit_1_arg = 2;

	if (argc < 2) {
		printf ("usage: %s server_host\n", argv[0]);
		exit (1);
	}
	host = argv[1];
	
	CLIENT *clnt;

	clnt = clnt_create (host, COOKIE_PROG, COOKIE_VERS, "tcp"); //create TCP client
	if (clnt == NULL) { //error checking
		clnt_pcreateerror (host);
		exit (1);
	}
	
	sleep(3);//allow time to exec judy
	
	for (int i=0;i<15;i++){
		do_tina(clnt);
		}
	remote_exit_1(&remote_exit_1_arg, clnt);//make sure server isnt still running
	clnt_destroy (clnt); // kill client
	
exit (0);
}
