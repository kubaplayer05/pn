		AREA	MAIN_CODE, CODE, READONLY
		GET		LPC213x.s
		
		ENTRY
__main
__use_two_region_memory
		EXPORT			__main
		EXPORT			__use_two_region_memory

CURRENT_DIGIT RN R12

DIGIT_0	RN R8
DIGIT_1	RN R9  
DIGIT_2	RN R10  
DIGIT_3	RN R11 

	; IODIR0 = 0xF << 16 ustawienie pinów cyfr na wyjscie
	LDR R4, =IODIR0
	LDR R5, =(0xF<<16)
	STR R5, [R4]
	
	; IODIR1 = 0xFF << 16 ustawienie pinów segmentów na wyjscie
	LDR R4, =IODIR1
	LDR R5, =(0xFF<<16)
	STR R5, [R4]
	
	; wyzerowanie licznika dekadowego
	LDR DIGIT_0, =0
	LDR DIGIT_1, =0
	LDR DIGIT_2, =0
	LDR DIGIT_3, =0

	; wyzerowanie licznika cyfr
	LDR CURRENT_DIGIT, =0
	
main_loop
	; IO0CLR=0xF0000 wygaszenie cyfr
    LDR R4, =IO0CLR
    LDR R5, =(0xF<<16)
    STR R5, [R4]

    ; IO1CLR=0xFF0000 wygaszenie segmentów
    LDR R4, =IO1CLR
    LDR R5, =(0xFF<<16)
    STR R5, [R4]

	; IO0SET = 0x80000 >> CURRENT_DIGIT wlaczenie cyfry
	LDR R4, =IO0SET
	LDR R5, =0x80000
	MOV R5, R5, LSR CURRENT_DIGIT
	STR R5, [R4]
	
	; R6 <= DIGIT_X, gdzie X = CURRENT_DIGIT
	CMP CURRENT_DIGIT, #0
	MOVEQ R6, DIGIT_0
	
	CMP CURRENT_DIGIT, #1
	MOVEQ R6, DIGIT_1
	
	CMP CURRENT_DIGIT, #2
	MOVEQ R6, DIGIT_2
	
	CMP CURRENT_DIGIT, #3
	MOVEQ R6, DIGIT_3
	
	;R6 = SEGMENT_CODES[R6]
	ADR R7, SEGMENT_CODES
	ADD R6, R7, R6
	LDRB R6, [R6]
	
	; IO1SET = R6 << 16 wlaczenie segmentów
	LDR R4, =IO1SET
	MOV R5, R6, LSL #16
	STR R5, [R4]
	
	; inkrementacja licznika dekadowego (DIGIT_0 .. DIGIT_3
	ADD DIGIT_0, DIGIT_0, #1
	CMP DIGIT_0, #10
	EOREQ DIGIT_0, DIGIT_0, #10
	
	ADDEQ DIGIT_1, DIGIT_1, #1
	CMP DIGIT_1, #10
	EOREQ DIGIT_1, DIGIT_1, #10
	
	ADDEQ DIGIT_2, DIGIT_2, #1
	CMP DIGIT_2, #10
	EOREQ DIGIT_2, DIGIT_2, #10
	
	ADDEQ DIGIT_3, DIGIT_3, #1
	CMP DIGIT_3, #10
	EOREQ DIGIT_3, DIGIT_3, #10
	
	; CURRENT_DIGIT = (CURRENT_DIGIT+1)%4 inkrementacja licznika cyfr
	ADD CURRENT_DIGIT, CURRENT_DIGIT, #1
	CMP CURRENT_DIGIT, #4
	EOREQ CURRENT_DIGIT, CURRENT_DIGIT, #4
	
	LDR R0, =5
	BL	delay_in_ms
	
	b	main_loop

delay_in_ms
	LDR R1, =15000
	MUL R2, R0, R1

loop
	SUBS R2, R2, #1
	BNE loop
	
	BX lr

SEGMENT_CODES DCB 0x3f,0x06,0x5B,0x4F,0x66,0x6d,0x7D,0x07,0x7f,0x6f

	END
