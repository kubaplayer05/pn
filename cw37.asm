Loop:
	ldi  r16, 7
    rcall Square           
    ldi  r16, 9
    rcall Square          
    rjmp Loop

Square:
	push r30
    push r31

    ldi  r30, low(SquareTable<<1)   
    ldi  r31, high(SquareTable<<1)

    add  r30, r16         
    ldi  r16, 0
    adc  r31, r16           

    lpm  r16, Z             

    pop  r31
    pop  r30
    ret

SquareTable: .db 0, 1, 4, 9, 16, 25, 36, 49, 64, 81