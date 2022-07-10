                                      1 ;--------------------------------------------------------
                                      2 ; File Created by SDCC : free open source ANSI-C Compiler
                                      3 ; Version 4.0.0 #11528 (Linux)
                                      4 ;--------------------------------------------------------
                                      5 	.module blinky
                                      6 	.optsdcc -mstm8
                                      7 	
                                      8 ;--------------------------------------------------------
                                      9 ; Public variables in this module
                                     10 ;--------------------------------------------------------
                                     11 	.globl _main
                                     12 	.globl _rand
                                     13 ;--------------------------------------------------------
                                     14 ; ram data
                                     15 ;--------------------------------------------------------
                                     16 	.area DATA
                                     17 ;--------------------------------------------------------
                                     18 ; ram data
                                     19 ;--------------------------------------------------------
                                     20 	.area INITIALIZED
                                     21 ;--------------------------------------------------------
                                     22 ; Stack segment in internal ram 
                                     23 ;--------------------------------------------------------
                                     24 	.area	SSEG
      FFFFFF                         25 __start__stack:
      FFFFFF                         26 	.ds	1
                                     27 
                                     28 ;--------------------------------------------------------
                                     29 ; absolute external ram data
                                     30 ;--------------------------------------------------------
                                     31 	.area DABS (ABS)
                                     32 
                                     33 ; default segment ordering for linker
                                     34 	.area HOME
                                     35 	.area GSINIT
                                     36 	.area GSFINAL
                                     37 	.area CONST
                                     38 	.area INITIALIZER
                                     39 	.area CODE
                                     40 
                                     41 ;--------------------------------------------------------
                                     42 ; interrupt vector 
                                     43 ;--------------------------------------------------------
                                     44 	.area HOME
      008000                         45 __interrupt_vect:
      008000 82 00 80 07             46 	int s_GSINIT ; reset
                                     47 ;--------------------------------------------------------
                                     48 ; global & static initialisations
                                     49 ;--------------------------------------------------------
                                     50 	.area HOME
                                     51 	.area GSINIT
                                     52 	.area GSFINAL
                                     53 	.area GSINIT
      008007                         54 __sdcc_gs_init_startup:
      008007                         55 __sdcc_init_data:
                                     56 ; stm8_genXINIT() start
      008007 AE 00 00         [ 2]   57 	ldw x, #l_DATA
      00800A 27 07            [ 1]   58 	jreq	00002$
      00800C                         59 00001$:
      00800C 72 4F 00 00      [ 1]   60 	clr (s_DATA - 1, x)
      008010 5A               [ 2]   61 	decw x
      008011 26 F9            [ 1]   62 	jrne	00001$
      008013                         63 00002$:
      008013 AE 00 04         [ 2]   64 	ldw	x, #l_INITIALIZER
      008016 27 09            [ 1]   65 	jreq	00004$
      008018                         66 00003$:
      008018 D6 80 23         [ 1]   67 	ld	a, (s_INITIALIZER - 1, x)
      00801B D7 00 00         [ 1]   68 	ld	(s_INITIALIZED - 1, x), a
      00801E 5A               [ 2]   69 	decw	x
      00801F 26 F7            [ 1]   70 	jrne	00003$
      008021                         71 00004$:
                                     72 ; stm8_genXINIT() end
                                     73 	.area GSFINAL
      008021 CC 80 04         [ 2]   74 	jp	__sdcc_program_startup
                                     75 ;--------------------------------------------------------
                                     76 ; Home
                                     77 ;--------------------------------------------------------
                                     78 	.area HOME
                                     79 	.area HOME
      008004                         80 __sdcc_program_startup:
      008004 CC 80 28         [ 2]   81 	jp	_main
                                     82 ;	return from main will return to caller
                                     83 ;--------------------------------------------------------
                                     84 ; code
                                     85 ;--------------------------------------------------------
                                     86 	.area CODE
                                     87 ;	blinky.c: 6: int main() {
                                     88 ;	-----------------------------------------
                                     89 ;	 function main
                                     90 ;	-----------------------------------------
      008028                         91 _main:
      008028 52 08            [ 2]   92 	sub	sp, #8
                                     93 ;	blinky.c: 7: unsigned int d=0;
      00802A 5F               [ 1]   94 	clrw	x
      00802B 1F 07            [ 2]   95 	ldw	(0x07, sp), x
                                     96 ;	blinky.c: 11: PB_DDR = 0x20; /* 0b 0010 0000 */
      00802D 35 20 50 07      [ 1]   97 	mov	0x5007+0, #0x20
                                     98 ;	blinky.c: 12: PB_CR1 = 0x20; /* 0b 0010 0000 */
      008031 35 20 50 08      [ 1]   99 	mov	0x5008+0, #0x20
                                    100 ;	blinky.c: 15: do {
      008035                        101 00105$:
                                    102 ;	blinky.c: 16: PB_ODR ^= 0x20;
      008035 C6 50 05         [ 1]  103 	ld	a, 0x5005
      008038 5F               [ 1]  104 	clrw	x
      008039 A8 20            [ 1]  105 	xor	a, #0x20
      00803B C7 50 05         [ 1]  106 	ld	0x5005, a
                                    107 ;	blinky.c: 18: do{
      00803E                        108 00101$:
                                    109 ;	blinky.c: 19: randomNumber = rand();
      00803E CD 80 7F         [ 4]  110 	call	_rand
      008041 9E               [ 1]  111 	ld	a, xh
      008042 90 5F            [ 1]  112 	clrw	y
      008044 4D               [ 1]  113 	tnz	a
      008045 2A 02            [ 1]  114 	jrpl	00138$
      008047 90 5A            [ 2]  115 	decw	y
      008049                        116 00138$:
      008049 41               [ 1]  117 	exg	a, xl
      00804A 6B 04            [ 1]  118 	ld	(0x04, sp), a
      00804C 41               [ 1]  119 	exg	a, xl
      00804D 6B 03            [ 1]  120 	ld	(0x03, sp), a
      00804F 17 01            [ 2]  121 	ldw	(0x01, sp), y
                                    122 ;	blinky.c: 20: } while (randomNumber < 15000);
      008051 1E 03            [ 2]  123 	ldw	x, (0x03, sp)
      008053 A3 3A 98         [ 2]  124 	cpw	x, #0x3a98
      008056 7B 02            [ 1]  125 	ld	a, (0x02, sp)
      008058 A2 00            [ 1]  126 	sbc	a, #0x00
      00805A 7B 01            [ 1]  127 	ld	a, (0x01, sp)
      00805C A2 00            [ 1]  128 	sbc	a, #0x00
      00805E 25 DE            [ 1]  129 	jrc	00101$
      008060 16 07            [ 2]  130 	ldw	y, (0x07, sp)
      008062                        131 00109$:
                                    132 ;	blinky.c: 22: for(; d < randomNumber; d++) {;}
      008062 93               [ 1]  133 	ldw	x, y
      008063 0F 06            [ 1]  134 	clr	(0x06, sp)
      008065 0F 05            [ 1]  135 	clr	(0x05, sp)
      008067 13 03            [ 2]  136 	cpw	x, (0x03, sp)
      008069 7B 06            [ 1]  137 	ld	a, (0x06, sp)
      00806B 12 02            [ 1]  138 	sbc	a, (0x02, sp)
      00806D 7B 05            [ 1]  139 	ld	a, (0x05, sp)
      00806F 12 01            [ 1]  140 	sbc	a, (0x01, sp)
      008071 24 04            [ 1]  141 	jrnc	00104$
      008073 90 5C            [ 1]  142 	incw	y
      008075 20 EB            [ 2]  143 	jra	00109$
      008077                        144 00104$:
                                    145 ;	blinky.c: 24: d = 0;
      008077 5F               [ 1]  146 	clrw	x
      008078 1F 07            [ 2]  147 	ldw	(0x07, sp), x
                                    148 ;	blinky.c: 25: } while(1);
      00807A 20 B9            [ 2]  149 	jra	00105$
                                    150 ;	blinky.c: 26: }
      00807C 5B 08            [ 2]  151 	addw	sp, #8
      00807E 81               [ 4]  152 	ret
                                    153 	.area CODE
                                    154 	.area CONST
                                    155 	.area INITIALIZER
                                    156 	.area CABS (ABS)
