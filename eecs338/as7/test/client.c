#include "test.h"

int main(int argc, char**argv)
{
  CLIENT *cl;
  
  if(argc != 3)
  {
      printf("Usage: ./client HOSTNAME i\n");
      return 1;
  }

  cl = clnt_create(argv[1], TEST_PROG, TEST_VERS, "udp");
  int i = atoi(argv[2]);
  
  if(i == -1)
  {
    test_exit_1(&i, cl);
    printf("Terminated Server\n");
    return 0;
  }
  int* result = test_proc_1(&i, cl);
  printf("Received result %d\n", *result);
  clnt_destroy(cl);
  return 0;
}
