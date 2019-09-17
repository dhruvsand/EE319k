;This is Exam2_Quad
; DHRUV SANDESARA
; 35 MINS
;Your name goes here
;You edit this file only
      AREA    |.text|, CODE, READONLY, ALIGN=2
      THUMB
;***** Pow4 subroutine*********************
;Inputs:  Input1: R0 contains an quad number (range: 0-3).
;         Input2: R1 contains a number between 0 and 3 
;Output:  R0 contains the result of multiplying Input1 with 4^Input2
;         R0 = R0*(4^R1)
;Invariables: You must not modify registers R4 to R11
;Error conditions: none
;test case 0: R0=1; R1=2  => R0= 1*(4^2) = 16
;test case 1: R0=3; R1=3  => R0 = 3*(4^3) = 192
;test case 2: R0=3; R1=0  => R0 = 2*(4^0) = 3
;test case 3: R0=0; R1=3  => R0 = 0*(4^3) = 0 
      EXPORT Pow4
Pow4 
; put your code here
	PUSH {R2-R5};
	MOV R2,#4; remove this line
	ADD R1,#-1;
	CMP R1,#0;
	BLT DONE1;
	LSL R2,R2,R1;
	LSL R2,R2,R1;
	MUL R2,R2,R0
	MOV R0,R2;
		
DONE1	
	POP {R2-R5}
      BX    LR

;***** QuadDec subroutine *********************
;Inputs: R0 contains the address of a 4-element Array of quad numbers (range: 0-3)  
;Output: R0 contains the decimal value corresponding to the quad number in input
;Invariables: You must not modify registers R4 to R11
;test case 0: 0,1,2,3          => R0=27
;test case 1: 0,0,0,3		   => R0=3
;test case 2: 1,1,1,1		   => R0=87
;test case 3: 3,3,3,3		   => R0=255
;test case 4: 3,3,0,0		   => R0=240 
;test case 5: 0,0,0,0		   => R0=0 
      EXPORT QuadDec
QuadDec
; put your code here

 PUSH {R1-R8};
 MOV R2,#4;
 MOV R3,#64;
 MOV R4,#0;
 MOV R5,#0;
LOOP
	LDRB R1,[R0];
	MUL R4,R1,R3;
	ADD R5,R5,R4;
	ADD R2,#-1;
	ADD R0,#1;
	LSR R3,#2;
	CMP R2,#0;
	BNE LOOP;
 MOV R0,R5;
 
 
 
 
 
 POP{R1-R8};

      BX    LR
      
      ALIGN
      END
      
