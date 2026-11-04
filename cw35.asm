.equ Digits_P = PORTB
.equ Segments_P = PORTD

.def Digit_0 = R2      
.def Digit_1 = R3       
.def Digit_2 = R4      
.def Digit_3 = R5

.macro LOAD_CONST
ldi @0, high(@2)
ldi @1, low(@2)
.endmacro

ldi r16, 0b01111111
out DDRD, r16
ldi r16, 0b00011110
out DDRB, r16

ldi r18, 0b01001111; "3" 
mov Digit_0, r18
ldi r18, 0b01011011; "2"  
mov Digit_1, r18
ldi r18, 0b00000110; "1" 
mov Digit_2, r18
ldi r18, 0b00111111; "0" 
mov Digit_3, r18

LOAD_CONST r17, r16, 5
ldi  r20, 0

MainLoop:
out  Digits_P, r20
out Segments_P, Digit_0
ldi r19, 0b00010000
out Digits_P, r19
rcall DelayInMs

out  Digits_P, r20
out Segments_P, Digit_1
ldi r19, 0b00001000
out Digits_P, r19
rcall DelayInMs

out  Digits_P, r20
out Segments_P, Digit_2
ldi r19, 0b00000100 
out Digits_P, r19
rcall DelayInMs

out  Digits_P, r20
out Segments_P, Digit_3
ldi r19, 0b00000010
out Digits_P, r19
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