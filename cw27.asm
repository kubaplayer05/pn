MainLoop:
ldi  r16, low(5)
ldi  r17, high(5) 
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
	ldi r24, $CB
	ldi r25, $7
L1ms: sbiw r25:r24, 1
	brne L1ms
	pop r25
	pop r24
	ret