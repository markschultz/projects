#include <stdio.h>

// print fahrenheit-celsius table
#define lower 0
#define upper 300
#define step 10

main(){
	float fahr, celsius;

	fahr = lower;
	printf(" F      C\n");
	while (fahr <= upper){
		celsius = 5.0*(fahr-32.0)/9.0;
		printf("%3.0f %6.1f\n",fahr, celsius);
		fahr = fahr + step;
	}
}

