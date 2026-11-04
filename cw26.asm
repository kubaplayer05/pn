MainLoop:
ldi r24, 5
rcall DelayInMs
rjmp MainLoop

DelayInMs:
sts $60, r24
sts  $61, r25
rcall DelayOneMs
dec r24
brne DelayInMs; 
ret

DelayOneMs:
	ldi r24, $CB
	ldi r25, $7
L1ms: sbiw r25:r24, 1
	  brne L1ms
	lds  r24, $60
	lds  r25, $61
	ret