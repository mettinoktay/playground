#include <stdio.h>
#include <stdlib.h>
#include <math.h>

void add(int *, int *), subtract(int *, int *);

int main (){
	int number = 0, change = 0;
	
	printf("Initial: ");
	scanf("%d", &number);
	printf("Change: ");
	scanf("%d", &change);
	
	
	while (abs(number) < 100){
//		add(&numberOne, &numberTwo);
		subtract(&number, &change);
		printf("%d\t%d\n", (int) number,  (int) abs(number));
	}
}

//void add(int * numberOne, int * numberTwo) {
//	*numberOne += *numberTwo;
//	*numberTwo += 2;
//}

void subtract(int * number, int * change) {
	*number += *change;
	//blablablbalba
}
