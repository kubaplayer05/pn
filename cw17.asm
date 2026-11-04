ldi r22, 5
OneMsLoop:
	  ldi  r16, 31
Outer:
      ldi  r17, 85
Inner:
      dec  r17
      brne Inner
      dec  r16
      brne Outer
	  nop
      nop  ; OneMsLoop Cycles = 3*R16*(R17+1) + 2
dec r22
brne OneMsLoop
End:  rjmp End