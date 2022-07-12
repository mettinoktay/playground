#include "stm8l.h"
#include <math.h>
#include <stdio.h>
#include <stdlib.h>

int main() {
	unsigned long int d=0;
	unsigned long int randomNumber = 0;
	// Configure pins

	PB_DDR = 0x20; /* 0b 0010 0000 */
	PB_CR1 = 0x20; /* 0b 0010 0000 */

	// Loop
	do {
		PB_ODR ^= 0x20;

		do{
			randomNumber = rand();
		} while (randomNumber < 15000);

		for(; d < randomNumber; d++) {;}

		d = 0;
	} while(1);
}
