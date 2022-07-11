;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module pwm
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area DATA
;--------------------------------------------------------
; ram data
;--------------------------------------------------------
	.area INITIALIZED
;--------------------------------------------------------
; Stack segment in internal ram 
;--------------------------------------------------------
	.area	SSEG
__start__stack:
	.ds	1

;--------------------------------------------------------
; absolute external ram data
;--------------------------------------------------------
	.area DABS (ABS)

; default segment ordering for linker
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area CONST
	.area INITIALIZER
	.area CODE

;--------------------------------------------------------
; interrupt vector 
;--------------------------------------------------------
	.area HOME
__interrupt_vect:
	int s_GSINIT ; reset
;--------------------------------------------------------
; global & static initialisations
;--------------------------------------------------------
	.area HOME
	.area GSINIT
	.area GSFINAL
	.area GSINIT
__sdcc_gs_init_startup:
__sdcc_init_data:
; stm8_genXINIT() start
	ldw x, #l_DATA
	jreq	00002$
00001$:
	clr (s_DATA - 1, x)
	decw x
	jrne	00001$
00002$:
	ldw	x, #l_INITIALIZER
	jreq	00004$
00003$:
	ld	a, (s_INITIALIZER - 1, x)
	ld	(s_INITIALIZED - 1, x), a
	decw	x
	jrne	00003$
00004$:
; stm8_genXINIT() end
	.area GSFINAL
	jp	__sdcc_program_startup
;--------------------------------------------------------
; Home
;--------------------------------------------------------
	.area HOME
	.area HOME
__sdcc_program_startup:
	jp	_main
;	return from main will return to caller
;--------------------------------------------------------
; code
;--------------------------------------------------------
	.area CODE
;	pwm.c: 44: void main(void) {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
;	pwm.c: 45: clockSetup(0);
	push	#0x00
	call	_clockSetup
	pop	a
;	pwm.c: 46: PWM_Setup();
	call	_PWM_Setup
;	pwm.c: 47: loop();
;	pwm.c: 48: }
	jp	_loop
;	pwm.c: 50: void clockSetup(char frequency) {
;	-----------------------------------------
;	 function clockSetup
;	-----------------------------------------
_clockSetup:
;	pwm.c: 51: CLK_CKDIVR = frequency;
	ldw	x, #0x50c6
	ld	a, (0x03, sp)
	ld	(x), a
;	pwm.c: 52: }
	ret
;	pwm.c: 54: void PWM_Setup(void) {
;	-----------------------------------------
;	 function PWM_Setup
;	-----------------------------------------
_PWM_Setup:
;	pwm.c: 57: TIM2_PSCR = (uint8_t) 0;
	mov	0x530e+0, #0x00
;	pwm.c: 58: TIM2_ARRH = (uint8_t) 999 >> 8;
	mov	0x530f+0, #0x00
;	pwm.c: 59: TIM2_ARRL = (uint8_t) 999;
	mov	0x5310+0, #0xe7
;	pwm.c: 62: TIM2_CCER1 &= (uint8_t) (~(0x01 | 0x02));
	ld	a, 0x530a
	and	a, #0xfc
;	pwm.c: 65: TIM2_CCER1 |= (uint8_t) ( (uint8_t) (0x11 & 0x01) | (uint8_t) (0x00 & 0x02));
	ld	0x530a, a
	or	a, #0x01
	ld	0x530a, a
;	pwm.c: 68: TIM2_CCMR1 =  (uint8_t) ((TIM2_CCMR1 & (uint8_t) ~0x70) | ((uint8_t)0x60));
	ld	a, 0x5307
	and	a, #0x8f
	or	a, #0x60
	ld	0x5307, a
;	pwm.c: 71: TIM2_CCR1H = (uint8_t) 0;
	mov	0x5311+0, #0x00
;	pwm.c: 72: TIM2_CCR1L = (uint8_t) 0;
	mov	0x5312+0, #0x00
;	pwm.c: 75: TIM2_CCMR1 |= (uint8_t) 0x08; 
	bset	21255, #3
;	pwm.c: 78: TIM2_CR1 |= (uint8_t) 0x80;
	ld	a, 0x5300
	or	a, #0x80
;	pwm.c: 81: TIM2_CR1 |= (uint8_t) 0x01;
	ld	0x5300, a
	or	a, #0x01
	ld	0x5300, a
;	pwm.c: 82: }
	ret
;	pwm.c: 84: void setDutyCycle(unsigned int dutyCycle) {
;	-----------------------------------------
;	 function setDutyCycle
;	-----------------------------------------
_setDutyCycle:
	sub	sp, #2
;	pwm.c: 94: TIM2_CCR1H = (uint8_t) ((0x0000 | dutyCycle) >> 8);
	ldw	x, (0x05, sp)
	ld	a, xh
	clr	(0x01, sp)
	ld	0x5311, a
;	pwm.c: 95: TIM2_CCR1L = (uint8_t) dutyCycle;
	ld	a, xl
	ld	0x5312, a
;	pwm.c: 97: }	
	addw	sp, #2
	ret
;	pwm.c: 99: void loop(void) {
;	-----------------------------------------
;	 function loop
;	-----------------------------------------
_loop:
	sub	sp, #2
;	pwm.c: 101: unsigned int perCent = 0;	
	clrw	x
;	pwm.c: 105: while(perCent < 1000) {
00101$:
	cpw	x, #0x03e8
	jrnc	00115$
;	pwm.c: 106: setDutyCycle(perCent);
	pushw	x
	pushw	x
	call	_setDutyCycle
	addw	sp, #2
	popw	x
;	pwm.c: 107: perCent++;
	incw	x
;	pwm.c: 108: delay();
	pushw	x
	call	_delay
	popw	x
	jra	00101$
;	pwm.c: 111: while(perCent > 0) {
00115$:
	ldw	(0x01, sp), x
00104$:
	ldw	y, (0x01, sp)
	jreq	00101$
;	pwm.c: 112: setDutyCycle(perCent);
	ldw	x, (0x01, sp)
	pushw	x
	call	_setDutyCycle
	addw	sp, #2
;	pwm.c: 113: perCent--;
	ldw	x, (0x01, sp)
	decw	x
	ldw	(0x01, sp), x
;	pwm.c: 114: delay();
	pushw	x
	call	_delay
	popw	x
	jra	00104$
;	pwm.c: 120: }
	addw	sp, #2
	ret
;	pwm.c: 122: void delay(void) {
;	-----------------------------------------
;	 function delay
;	-----------------------------------------
_delay:
;	pwm.c: 124: while (counter) counter--;
	ldw	x, #0x1388
	clrw	y
00101$:
	tnzw	x
	jrne	00117$
	tnzw	y
	jrne	00117$
	ret
00117$:
	subw	x, #0x0001
	jrnc	00101$
	decw	y
	jra	00101$
;	pwm.c: 125: }
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
