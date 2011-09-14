
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stddef.h>
#include <sys/param.h>
#include <math.h>

// global declarations
typedef struct {
	char *name;
	char *mac;
	int count;
} DATA; // struct w/ string and mac address for the 

DATA 	*the_array = NULL;
int 	num_elements = 0; // To keep track of the number of elements used
int		num_allocated = 0; // This is essentially how large the array is

int add_to_array(DATA);
void parse_file(FILE*);

int AddToArray (DATA item)
{
	if(num_elements == num_allocated) { // Are more refs required?
		
		// Feel free to change the initial number of refs and the rate at which refs are allocated.
		if (num_allocated == 0)
			num_allocated = 7; // Start off with 3 refs
		else
			num_allocated *= 2; // Double the number of refs allocated
		
		// Make the reallocation transactional by using a temporary variable first
		void *_tmp = realloc(the_array, (num_allocated * sizeof(DATA)));
		
		// If the reallocation didn't go so well, inform the user and bail out
		if (!_tmp)
		{ 
			fprintf(stderr, "ERROR: Couldn't realloc memory!\n");
			return(-1); 
		}
		
		// Things are looking good so far, so let's set the 
		the_array = (DATA*)_tmp;	
	}
	
	the_array[num_elements] = item; 
	num_elements++;
	
	return num_elements;
}

void parse_file(FILE *fp) {

	char line[128]; //128 is now max line length. sounds reasonable...
	char *cp,*tokenMac,*tokenCo;
	char delimiters[] = " ";
	while (fgets(line,sizeof(line),fp)!=NULL){ //read a line

		cp = strdup(line);
		tokenMac = strtok(cp,delimiters); // split the string on spaces
		tokenCo = strtok(NULL,delimiters);
		DATA toAdd;
		toAdd.name = malloc((strlen(tokenCo) + 1) * sizeof(char));
		strncpy(toAdd.name, tokenCo, strlen(tokenCo) + 1);
		toAdd.mac = malloc((strlen(tokenMac) + 1) * sizeof(char));
		strncpy(toAdd.mac, tokenMac, strlen(tokenMac) + 1);
		toAdd.count = 0;
		if (AddToArray(toAdd) == -1)
		{
			perror("error adding to array");
			return 1;
		}
	}
}

int main(int argc, char *argv[]) {
	char *mac_vendor_list = argv[2];
	char *mac_dat_file = argv[3];

	//open file for reading
	FILE *mvl = fopen(mac_vendor_list, "r");
	if(!mvl) {
		perror("File open error");
		exit(1);
	} else {
		parse_file(mvl);
		fclose(mvl);
	}
	
	printf("%d,%d\n",num_elements,num_allocated);
	printf("%s,%s\n",the_array[1].name,the_array[1].mac);
	return 0;
}
