#include <stdlib.h>
#include <stdio.h>
#include <math.h>

char * main () {
	FILE * sinFunc = fopen("sinusoidal.txt", "w");
	double sinDegree = 0;
	
	for (double degree = 0; degree <= 180 ; degree += 0.1) {
		sinDegree = sin(degree);
		if(sinDegree >= 0) {
			fprintf(sinFunc, " %f\n", sinDegree);
		}
		else {
			fprintf(sinFunc, "%f\n", sinDegree);
		}
	}
	
	fclose(sinFunc);
	return "you shouldn't've gotten here"; 	
}
