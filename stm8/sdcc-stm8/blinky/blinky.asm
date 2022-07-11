;--------------------------------------------------------
; File Created by SDCC : free open source ANSI-C Compiler
; Version 4.0.0 #11528 (Linux)
;--------------------------------------------------------
	.module blinky
	.optsdcc -mstm8
	
;--------------------------------------------------------
; Public variables in this module
;--------------------------------------------------------
	.globl _main
	.globl _rand
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
;	blinky.c: 6: int main() {
;	-----------------------------------------
;	 function main
;	-----------------------------------------
_main:
	sub	sp, #8
;	blinky.c: 7: unsigned int d=0;
	clrw	x
	ldw	(0x07, sp), x
;	blinky.c: 11: PB_DDR = 0x20; /* 0b 0010 0000 */
	mov	0x5007+0, #0x20
;	blinky.c: 12: PB_CR1 = 0x20; /* 0b 0010 0000 */
	mov	0x5008+0, #0x20
;	blinky.c: 15: do {
00105$:
;	blinky.c: 16: PB_ODR ^= 0x20;
	ld	a, 0x5005
	clrw	x
	xor	a, #0x20
	ld	0x5005, a
;	blinky.c: 18: do{
00101$:
;	blinky.c: 19: randomNumber = rand();
	call	_rand
	ld	a, xh
	clrw	y
	tnz	a
	jrpl	00138$
	decw	y
00138$:
	exg	a, xl
	ld	(0x04, sp), a
	exg	a, xl
	ld	(0x03, sp), a
	ldw	(0x01, sp), y
;	blinky.c: 20: } while (randomNumber < 15000);
	ldw	x, (0x03, sp)
	cpw	x, #0x3a98
	ld	a, (0x02, sp)
	sbc	a, #0x00
	ld	a, (0x01, sp)
	sbc	a, #0x00
	jrc	00101$
	ldw	y, (0x07, sp)
00109$:
;	blinky.c: 22: for(; d < randomNumber; d++) {;}
	ldw	x, y
	clr	(0x06, sp)
	clr	(0x05, sp)
	cpw	x, (0x03, sp)
	ld	a, (0x06, sp)
	sbc	a, (0x02, sp)
	ld	a, (0x05, sp)
	sbc	a, (0x01, sp)
	jrnc	00104$
	incw	y
	jra	00109$
00104$:
;	blinky.c: 24: d = 0;
	clrw	x
	ldw	(0x07, sp), x
;	blinky.c: 25: } while(1);
	jra	00105$
;	blinky.c: 26: }
	addw	sp, #8
	ret
	.area CODE
	.area CONST
	.area INITIALIZER
	.area CABS (ABS)
