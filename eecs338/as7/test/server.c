#include "test.h"

int *test_proc_1_svc(int *in, struct svc_req *rqstp)
{
  static  int response;
  response = *in;
  printf("Server Received %d and sent %d \n", *in, response);
  fflush(NULL);
  return(&response);
}

void *test_exit_1_svc(int *in, struct svc_req *rqstp)
{
  printf("Request for Termination Received\n");
  fflush(NULL);
  exit(0);
}
