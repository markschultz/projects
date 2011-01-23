#include <stdio.h>

// print fahrenheit-celsius table

main(){
	float fahr, celsius;
	int lower, upper, step;

	lower = 0;
	upper = 300;
	step = 10;

	fahr = lower;
	printf(" F      C\n");
	while (fahr <= upper){
		celsius = 5.0*(fahr-32.0)/9.0;
		printf("%3.0f %6.1f\n",fahr, celsius);
		fahr = fahr + step;
	}
}

