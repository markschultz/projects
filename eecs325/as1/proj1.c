

#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <sys/param.h>
#include <math.h>

// global declarations
typedef struct {
	char *name;
	int mac;
} DATA; // struct w/ string and mac address for the 

DATA *mac_array = NULL;
int elements = 0; //current size of the array
int allocated = 0; //number of elements accocated to the array

int add_to_array(DATA);

int add_to_array(DATA item) {
	if(elements == allocated) {
		if(allocated == 0) 
			allocated=10; //initially 3 references
		else
			allocated *= 2; // otherwise double the number of refs

		void *tmp = realloc(mac_array, (allocated * sizeof(DATA)));
		if(!tmp){ //something went wrong, try to exit
			fprintf(stderr,"ERROR: Problem reallocating memory.\n");
			return(-1);
		}
		mac_array = (DATA*)tmp;
	}
	mac_array[elements] = item;
	elements++;
	return elements;
}
