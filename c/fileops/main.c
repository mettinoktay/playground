#include <stdlib.h>
#include <stdio.h>
#include <math.h>

#define pi (double) 3.14159

char * main () {
	FILE * sinFunc     = fopen("sinusoidal.txt", "w");
	
	double sinDegree = 0;
	
	for (double degree = 0; degree <= 180 ; degree += 0.1) {
		sinDegree = sin(pi/degree);
		if(sinDegree >= 0) {
			fprintf(sinFunc, " %f\n", sinDegree);
		}
		else {
			fprintf(sinFunc, "%f\n", sinDegree);
		}
	}
	
	fclose(sinFunc);
	
	FILE * sinFuncRead = fopen("sinusoidalCopy.txt", "rw");
	
	//değişiklik

	return "you shouldn't have come here"; 	
}
