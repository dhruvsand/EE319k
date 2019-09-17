;*****Your name goes here*******
; -5 points if you do not add your name
;DHRUV SANDESARA
;This is Exam2_BCD  
;EE319K Fall 2013
;November 7, 2013
;You edit this file only
       AREA   Data, ALIGN=4


       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB

;***** PosOrNeg subroutine*********************
;Determines if the given BCD number in R0 is a positive or negative number 
;Input:   R0 has a number in 3-digit, 16-bit signed BCD format
;Output:  R0 returned as +1 if the number was positive and -1 if the number was negative
;Invariables (AAPCS): You must not permanently modify registers R4 to R11, and LR
;Error conditions: none, all inputs will be valid BCD numbers
;Test cases:
; Input = 0x0125 ; result is 1   (0x00000001)
; Input = 0xF042 ; result is -1  (0xFFFFFFFF)
; Input = 0x0999 ; result is 1   (0x00000001)
; Input = 0xF001 ; result is -1  (0xFFFFFFFF)
; Input = 0x0000 ; result is 1   (0x00000001)
      EXPORT PosOrNeg
PosOrNeg 
; put your code here
	AND R0,R0,#0XF000;
	CMP R0,#0;
	BEQ ZERO
	MOV R0,#-1;
	B DONE
ZERO
	MOV R0,#1;
DONE     
      BX    LR
      
;***** BCD2Dec subroutine*********************
; Converts a 3-digit, 16-bit signed number in BCD format into a 
; regular binary representation.
; Note that BCD is positional number system with each successive nibble
; having a place value that is a power of 10.
;Input:   R0 has a number in 3-digit, 16-bit signed BCD format
;Output:  R0 has the signed 32-bit binary-encoded value of the input
;Invariables (AAPCS): You must not permanently modify registers R4 to R11, and LR
;Error conditions: none, all inputs will be valid BCD numbers
;Test cases:
; Input = 0x0125 ; result is 125 (in Hex: 0x0000007D)
; Input = 0xF042 ; result is -42 (in Hex: 0xFFFFFFD6)
; Input = 0x0999 ; result is 999 (in Hex: 0x000003E7)
; Input = 0xF001 ; result is -1  (in Hex: 0xFFFFFFFF)
; Input = 0xF999 ; result is -999(in Hex: 0xFFFFFC19)
      EXPORT BCD2Dec
BCD2Dec 
; put your code here
	PUSH {R1-R7,LR};
	MOV R1,R0;
	BL PosOrNeg;
	CMP R0,#-1;
	BEQ NEGATIVE
	MOV R3,#0;
	MOV R4,#10;

	AND R2,R1,#0X000F; 0TH PLACE
	ADD R3,R2;
	LSR R1,#4;
	AND R2,R1,#0X000F; 10S PLACE
	MUL R2,R2,R4;
	ADD R3,R2;
	
	LSR R1,#4;
	AND R2,R1,#0X000F;
	MUL R2,R2,R4;
	MUL R2,R2,R4; 100S PLACE
	ADD R3,R2;
	
	B BCDDONE
	
	
	
	
	
NEGATIVE	
	MOV R3,#0;
	MOV R4,#10;

	AND R2,R1,#0X000F; 0TH PLACE
	SUB R3,R2;
	LSR R1,#4;
	AND R2,R1,#0X000F; 10S PLACE
	MUL R2,R2,R4;
	SUB R3,R2;
	
	LSR R1,#4;
	AND R2,R1,#0X000F;
	MUL R2,R2,R4;
	MUL R2,R2,R4; 100S PLACE
	SUB R3,R2;
	
	
	
BCDDONE
	MOV R0,R3;
	
	POP {R1-R7,LR};

      BX   LR
      
;***** BCDMul subroutine*********************
; Multiplies two 3-digit, 16-bit signed numbers in BCD format 
; and returns the result in regular binary representation
;Input:   R0, R1 have numbers in 3-digit, 16-bit signed BCD format
;Output:  R0 has the signed 32-bit product of the two input numbers
;Invariables (AAPCS): You must not permanently modify registers R4 to R11, and LR
;Error conditions: none, all inputs will be valid BCD numbers. No overflow can occur
;Test cases:
; Input R0=0x0005 R1=0x0002; result is 5*2=10           (0x0000000A)
; Input R0=0xF001 R1=0x0008; result is -1*8=-8          (0xFFFFFFF8)
; Input R0=0xF999 R1=0xF999; result is -999*-999=998001 (0x000F3A71)
; Input R0=0x0013 R1=0xF001; result is 13*-1 = -13      (0xFFFFFFF3)
      EXPORT BCDMul
BCDMul 
; put your code here
	PUSH {R2-R4,LR}
	
	BL BCD2Dec;
	MOV R2,R0;
	
	
	MOV R0,R1;
	BL  BCD2Dec;
	MOV R3,R0;
	
	MUL R0,R2,R3;
	
	
	
	
	
	
	POP {R2-R4,LR}

      BX   LR
	  
;***** DotProduct subroutine*********************
; Computes the dot product of two BCD-encoded arrays of numbers.
; The inputs are two pointers to arrays of 3-digit signed BCD numbers
; and the size of the two arrays.
;Input:   R0 has address of the first array A
;         R1 has address of the second array B
;         R2=n is the size of both arrays
;Output:  R0 has the binary-encoded result of computing the dot product
;            A[0]*B[0] + A[1]*B[1] + ...+A[n-1]*B[n-1]
;         If the arrays are empty, return 0
;Invariables (AAPCS): You must not permanently modify registers R4 to R11, and LR
;Error conditions: none, all numbers will be valid
;Test cases:
; Test case 1:
;	first array = {0x0010,0x0020}
;	second array= {0x0030,0x0040}
;   R2 gives a size of 2
;   Result = 10*30+20*40 = 300+800 = 1100 = 0x0000044C
; Test case 2:
;	first array = {0xF010,0x0002}
;	second array= {0x0001,0x0003}
;   R2 gives a size of 2
;   Result = -1*10 + 2*3 = -10+6 = -4 = 0xFFFFFFFC
; Test case 3:
;	first array = {0x0999,0xF999,0xF999}
;	second array= {0x0999,0xF999,0x0999}
;   R2 gives a size of 3
;   Result = 998001 + -998001 + 998001 = 998001 = 0x000F3A71
; Test case 4:
;	first array = {1,2,3,4,5}
;	second array= {1,1,1,1,2}
;   R2 gives a size of 5
;   Result = 1+2+3+4+10 = 20 = 0x000000014
; Test case 5:
;	first array = {1,2,3,4,5,6,7,8,9,0x10}
;	second array= {1,2,3,4,5,6,7,8,9,0x10}
;   R2 gives a size of 10
;   Result = 1+4+9+25+36+49+64+81 = 385 = 0x00000181
; Test case 6:
;	first array = empty
;	second array= empty
;   R2 gives a size of 0
;   Result = 0 = 0x00000000
      EXPORT DotProduct
DotProduct
; put your code here
	PUSH {R3-R7,LR}
	MOV R3,R0;
	MOV R4,R1;
	MOV R5,R2;
	MOV R6,#0; NO REASON TO USE
	MOV R7,#0;
	
DOTLOOP	
	CMP R5,#0;
	BEQ DOTDONE
	LDRH R0,[R3]
	LDRH R1,[R4];
	BL BCDMul;
	ADD R7,R0;
	ADD R3,#2;
	ADD R4,#2;
	ADD R5,#-1;
	B DOTLOOP
	
	
	
	
DOTDONE
	MOV R0,R7
	
	POP {R3-R7,LR}	
 
	  BX   LR
	  ALIGN
      END
      
