#include "stm8s.h"

#define FREQ_16MHZ (char) 0
typedef unsigned char uint8_t;

void setup(void), 
	 loop(void), 
	 delay(void),
     clockSetup(char frequency), 
	 PWM_Setup(void), 
	 setDutyCycle(unsigned int perCent);
 
void main(void) {
	clockSetup(FREQ_16MHZ);
	PWM_Setup();
	loop();
}

void clockSetup(char frequency) {
	CLK_CKDIVR = frequency;
}

void PWM_Setup(void) {

	/*Time base configuration*/
	TIM2_PSCR = (uint8_t) 0;
  	TIM2_ARRH = (uint8_t) 999 >> 8;
  	TIM2_ARRL = (uint8_t) 999;
	
	/*Disable channel 1: Reset the CCE Bit, Set the Output State and output polarity*/
	TIM2_CCER1 &= (uint8_t) (~(0x01 | 0x02));
	
	/*Set the output state and polarity*/
	TIM2_CCER1 |= (uint8_t) ( (uint8_t) (0x11 & 0x01) | (uint8_t) (0x00 & 0x02));
	
	/*Reset the output compare bits and set the output compare mode*/
	TIM2_CCMR1 =  (uint8_t) ((TIM2_CCMR1 & (uint8_t) ~0x70) | ((uint8_t)0x60));
	
	/*Set Duty Cycle*/
	TIM2_CCR1H = (uint8_t) 0;
	TIM2_CCR1L = (uint8_t) 0;
	
	/*Prelod register configuration*/
	TIM2_CCMR1 |= (uint8_t) 0x08; 
	
	/*ARR Preload Configuration*/
	TIM2_CR1 |= (uint8_t) 0x80;
	
	/*Counter enable*/
	TIM2_CR1 |= (uint8_t) 0x01;
}

void setDutyCycle(unsigned int dutyCycle) {
	TIM2_CCR1H = (uint8_t) ((0x0000 | dutyCycle) >> 8);
	TIM2_CCR1L = (uint8_t) dutyCycle;	
}	

void loop(void) {
	unsigned int perCent = 0;	

	while(1) {

		while(perCent < 1000) {
			setDutyCycle(perCent);
			perCent++;
			delay();
		}

		while(perCent > 0) {
			setDutyCycle(perCent);
			perCent--;
			delay();
		}
	}
}

void delay(void) {
	unsigned int counter = 5000;
	while (counter) counter--;
}
