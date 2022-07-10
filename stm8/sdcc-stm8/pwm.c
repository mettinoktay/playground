#include "stm8s.h"

/*

Pulse width modulation mode allows you to generate a signal with a frequency determined
by the value of the TIM1_ARR register and a duty cycle determined by the value of the
TIM1_CCRi registers.

The PWM mode can be selected independently on each channel (one PWM per OCi output)
by writing 110 (PWM mode 1) or 111 (PWM mode 2) in the OCiM bits in the TIM1_CCMRi
registers. The corresponding preload register must be enabled by setting the OCiPE bits in
the TIM1_CCMRi registers. The auto-reload preload register (in up-counting or center-
aligned modes) may be optionally enabled by setting the ARPE bit in the TIM1_CR1
register.

As the preload registers are transferred to the shadow registers only when an UEV occurs,
all registers have to be initialized by setting the UG bit in the TIM1_EGR register before
starting the counter.

OCi polarity is software programmable using the CCiP bits in the TIM1_CCERi registers. It
can be programmed as active high or active low. The OCi output is enabled by a
combination of CCiE, MOE, OISi, OSSR and OSSI bits (TIM1_CCERi and TIM1_BKR
registers). Refer to the TIM1_CCERi register descriptions for more details.

In PWM mode (1 or 2), TIM1_CNT and TIM1_CCRi are always compared to determine
whether TIM1_CCRi ≤ TIM1_CNT or TIM1_CNT≤ TIM1_CCRi (depending on the direction
of the counter).

The timer is able to generate PWM in edge-aligned mode or center-aligned mode
depending on the CMS bits in the TIM1_CR1 register.

*/

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
