Always: ldi r20, 5
	Loop: dec r20
	nop
	nop
	brne Loop
nop
nop
nop
nop
nop
rjmp Always; Cycles = (R20 * 5) + 5