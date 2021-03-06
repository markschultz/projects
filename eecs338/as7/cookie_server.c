/*
 * This is sample code generated by rpcgen.
 * These are only templates and you can use them
 * as a guideline for developing your own functions.
 */

#include "cookie.h"
int cookie = 20;
int tina = 0;

int *get_cookie_1_svc(int *argp, struct svc_req *rqstp)
{
	static int result;

	int client = *argp;
	
	if (cookie > 0){ //are there enough cookies?
		if (client==1){ //tina
			//printf("tina: req\n");
			tina++; //keep track of how many tina has had
			cookie--;
			result= 1; // 0=empty,1=yes,2=no
			printf("tina: gets \t\t%d cookies left, %d in a row\n",cookie,tina);
		} else if (client==2){ //judy
			//printf("judy: req\n");
			if (tina>=2){ //tina's had two so proceed
				tina=0;
				cookie--;
				result= 1;
				printf("judy: gets \t\t%d cookies left\n",cookie);
			} else {
				result= 2;
				printf("judy: doesn't get \t%d cookies left\n",cookie);
			}
		} else {
			perror("bad client ID"); // not tina or judy...
		}
	} else {
		printf("no more cookies!\n");
		result= 0; //no more cookies
	}

	return &result;
}

void *remote_exit_1_svc(int *argp, struct svc_req *rqstp)
{
	//static char * result;

	printf("exitting %d\n",*argp);
    fflush(NULL);
    exit(0);

	//return (void *) &result;
}
