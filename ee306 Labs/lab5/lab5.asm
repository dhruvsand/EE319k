	.ORIG x3000
; start the main program here


LD R0,ADRESS
STI R0,ISR;
LD R6,STACK;
LD R0,ENABLE;
STI R0,KBSR; 
AND R1,R1,#0;
ADD R1,R1,#1


LOOP




JSR DELAY
LD R0,ASCIIX;
OUT

BR LOOP






; end the main program here
	 HALT
ASCIIX  .FILL X0078
KBSR	.FILL XFE00
ENABLE  .FILL X4000
ADRESS	.FILL X1500
ISR	.FILL X0180
STACK	.FILL X3000





; you must use this delay subroutine
DELAY	ST R0, SAVE
	LD R0, COUNT
DELLOOP	ADD R0, R0, -1
	BRzp DELLOOP
	LD R0, SAVE
	RET
SAVE	.BLKW 1
COUNT	.FILL x4000

	.END