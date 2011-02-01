#include <stdio.h>
#include <sys/types.h>
#include <unistd.h>
#include <sys/wait.h>
#include <sys/times.h>
#include <time.h>

int main(int argc, char *argv[]) {


	int childID1 = 0, childID2 = 0; // process ids for both children from fork

