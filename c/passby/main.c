#include <stdio.h>
#include <stdlib.h>

void addFive(unsigned int *, unsigned int *);

int main (){
	unsigned int numberOne = 0, numberTwo = 0;
	
	printf("Initial: ");
	scanf("%d", &numberOne);
	printf("Increment: ");
	scanf("%d", &numberTwo);
	
	while (numberOne < 100){
		addFive(&numberOne, &numberTwo);
		printf("%d\t%d\n", (unsigned int) numberOne, (unsigned int) numberTwo);
	}
}

void addFive(unsigned int * numberOne, unsigned int * numberTwo) {
	*numberOne += *numberTwo;
	*numberTwo += 2;
}
