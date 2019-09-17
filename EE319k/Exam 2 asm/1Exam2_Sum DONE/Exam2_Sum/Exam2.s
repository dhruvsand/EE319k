;This is Exam 2
;Dhruv Sandesara
; 35 mins
;Your name goes here
;You edit this file only
      AREA    |.text|, CODE, READONLY, ALIGN=2
      THUMB
;***************** Size****************************
; Determines the length of an array of data.  
; Input parameter: R0 points to the array of 8-bit signed numbers
;                  array has null(0) termination 
; Each entry occupies one 8-bit byte, 
;   such that entries are located at sequential memory addresses
; The zero itself is NOT one of the data points
; Output parameter: R0 equals the length
; Error conditions: none 
      EXPORT Size
Size 
; put your code here
	PUSH{R1-R4};
	MOV R2,#0;
LOOP11	
	LDRB R1,[R0];
	CMP R1,#0;
	BEQ DONE11
	ADD R0,#1;
	ADD R2,#1;
	B LOOP11;
	
DONE11
	MOV R0,R2;
	POP{R1-R4};
      BX    LR

;*********Sum********************************
;Find the sum of an array 
;if any input number is negative, then return 0x7FFFFFFF
;Input parameter:  R0 points to the array of 8-bit signed numbers
;                  array has null(0) termination 
;Output parameter: The 32-bit sum is returned in R0. 
;Error conditions: Return R0 equal to 0x7FFFFFFF on any negative input

DATA
	DCD 0x7FFFFFFF;
      EXPORT Sum
Sum
; put your code here
	PUSH{R1-R4};
	MOV R2,#0;
LOOP	
	LDRSB R1,[R0];
	CMP R1,#0;
	BEQ DONE;
	BLT DONE2;
	ADD R2,R2,R1;
	ADD R0,#1;
	B LOOP;
	
DONE2
	LDR R0,=DATA;
	LDR R0,[R0]
	B DONE3;
DONE
	MOV R0,R2;
DONE3
	POP{R1-R4};	
	BX    LR
      
      ALIGN
      END
      
