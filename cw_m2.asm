.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

MainLoop:
LOAD_CONST r17, r16, 5
rcall DelayInMs
rjmp MainLoop

DelayInMs:
push r16
push r17
DelayLoop:
	rcall DelayOneMs
	subi r16, 1
	sbci r17, 0
	brne DelayLoop
pop r17
pop r16 
ret	

DelayOneMs:
	push r24
	push r25
	LOAD_CONST r25, r24, $7CB
L1ms: sbiw r25:r24, 1
	brne L1ms
	pop r25
	pop r24
	ret
