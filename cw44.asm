.equ Digits_P = PORTB
.equ Segments_P = PORTD
.equ DigitPeriod = 3

.def Digit_0 = R2      
.def Digit_1 = R3       
.def Digit_2 = R4      
.def Digit_3 = R5

.def PulseEdgeCtrL=R0
.def PulseEdgeCtrH=R1

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
    LOAD_CONST r17, r16, DigitPeriod
    rcall DelayInMs
.endmacro

ldi  r16, 0b01111111
out  DDRD, r16
ldi  r16, 0b00011110
out  DDRB, r16

clr  PulseEdgeCtrL
clr  PulseEdgeCtrH
clr  Digit_0
clr  Digit_1
clr  Digit_2
clr  Digit_3
ldi  r20, 0
ldi  r21, 10

MainLoop:
	SET_DIGIT 0
	SET_DIGIT 1
	SET_DIGIT 2
	SET_DIGIT 3

	LOAD_CONST r17, r16, 1
    add  PulseEdgeCtrL, r16
    adc  PulseEdgeCtrH, r17

	LOAD_CONST r17, r16, 1000
    cp   PulseEdgeCtrL, r16
    cpc  PulseEdgeCtrH, r17
    brne NoWrap             ; Ctr != 1000 -> zostaw
    clr  PulseEdgeCtrL      ; Ctr == 1000 -> 0
    clr  PulseEdgeCtrH
NoWrap:
	mov  r16, PulseEdgeCtrL
    mov  r17, PulseEdgeCtrH
    rcall NumberToDigits    ; R16..R19 = jednoœci..tysi¹ce
    mov  Digit_0, r16
    mov  Digit_1, r17
    mov  Digit_2, r18
    mov  Digit_3, r19

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

.def Dig0=R22 ; Digits temps
.def Dig1=R23 ;
.def Dig2=R24 ;
.def Dig3=R25

NumberToDigits:
	push Dig0
    push Dig1
    push Dig2
    push Dig3

    LOAD_CONST r19, r18, 1000
    rcall _Divide
	mov Dig3, r18

	LOAD_CONST r19, r18, 100
    rcall _Divide
	mov Dig2, r18

	LOAD_CONST r19, r18, 10
    rcall _Divide
	mov Dig1, r18

	mov Dig0, r16

	mov  r16, Dig0
    mov  r17, Dig1
    mov  r18, Dig2
    mov  r19, Dig3

    pop  Dig3
    pop  Dig2
    pop  Dig1
    pop  Dig0
	ret

.def XL=R16 ; dividend
.def XH=R17
.def YL=R18 ; divisor
.def YH=R19
; outputs
.def RL=R16 ; remainder
.def RH=R17
.def QL=R18 ; quotient
.def QH=R19
; internal
.def QCtrL=R24
.def QCtrH=R25

_Divide:
        push QCtrL              ; ochrona rejestrów wewnêtrznych
        push QCtrH

        clr  QCtrL              ; Quotient = 0
        clr  QCtrH

DivLoop:
        cp   XL, YL             ; porównaj X z Y (16 bit)
        cpc  XH, YH
        brcs DivEnd             ; X < Y -> koniec

        sub  XL, YL             ; X = X - Y (16 bit)
        sbc  XH, YH
        adiw QCtrH:QCtrL, 1     ; Quotient++
        rjmp DivLoop

DivEnd:
        ; reszta jest ju¿ w R17:R16 (RL/RH = XL/XH – te same rejestry)
        mov  QL, QCtrL          ; iloraz -> R19:R18
        mov  QH, QCtrH

        pop  QCtrH
        pop  QCtrL
        ret