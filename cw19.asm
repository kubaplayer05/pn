ldi r22, 5
DelayMs:
	ldi r24, $CF
	ldi r25, $7
Inc16:
	sbiw r25:r24, 1
	brne Inc16
	dec r22
	brne DelayMs; 
End: rjmp End
