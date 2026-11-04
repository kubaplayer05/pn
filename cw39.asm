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

.macro SET_DIGIT
    out  Digits_P, r20
    mov  r16, Digit_@0
    rcall DigitTo7segCode
    out  Segments_P, r16
    ldi  r19, (16>>@0)
    out  Digits_P, r19
    LOAD_CONST r17, r16, 5
    rcall DelayInMs
.endmacro

ldi r16, 0b01111111
out DDRD, r16
ldi r16, 0b00011110
out DDRB, r16

ldi  r16, 6
mov  Digit_0, r16
ldi  r16, 7
mov  Digit_1, r16
ldi  r16, 8
mov  Digit_2, r16
ldi  r16, 9
mov  Digit_3, r16
ldi  r20, 0

ldi  r20, 0

MainLoop:
SET_DIGIT 0
SET_DIGIT 1
SET_DIGIT 2
SET_DIGIT 3
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

DigitTo7segCode:
	push r30
    push r31

    ldi  r30, low(SegTable<<1)   
    ldi  r31, high(SegTable<<1)

    add  r30, r16         
    ldi  r16, 0
    adc  r31, r16       

    lpm  r16, Z           

    pop  r31
    pop  r30
    ret

SegTable: .db 0b00111111, 0b00000110, 0b01011011, 0b01001111, 0b01100110, 0b01101101, 0b01111101, 0b00000111, 0b01111111, 0b01101111