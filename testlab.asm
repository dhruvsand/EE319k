.ORIG x3000	
LEA	R1, String
JSR	OutS
TRAP 	x25
String	.STRINGZ "Hi"



OutS	ST	R7, Reg

Loop	LDR	R0, R1, #0
	
	BRz Done
	ADD	R1, R1, #1
	TRAP x21
	BRnzp	Loop
Done	LD	R7, Reg
	RET
Reg	.BLKW	1
	.END
