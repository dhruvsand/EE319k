; average.s
; Created By: Vickie Fridge and Thomas McRoberts
; Date Modified: April 3, 2017
	EXPORT   Average
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	PRESERVE8
    THUMB
		
		; EDIT THIS FILE!
;-------------------------------------------------------
; INSTRUCTIONS:
; 	Debug the following subroutines (Sum & Average)
;  	until you get the correct Average values in the
;	grader in UART1
;-------------------------------------------------------		
; NOTE: The array you are given as input is formatted as:
;	array[0] = count of numbers
;	array[1] = first number
;	array[2] = second number
;	etc.
; EX: int array[5] = {4, 100, 77, 85, 104}
;-------------------------------------------------------


;------------Sum----------------
; Function finds the sum of an array of 4 byte numbers
; 	   '-> must be given at least one number
; Input: R0 holds a pointer to an array
;		 array[0] is the count of input numbers
; 		 all input numbers follow in array[1], array[2], etc.
; Output: R0 is the sum of the numbers 

Sum
	PUSH {R2-R9}
	MOV  R1, #4	; R1 IS DELTA	
	MOV  R3, #0	; R3 IS THE SUM					
	LDR  R2, [R0] ; 					
	MOV R4,R2; R4 IS THE SIZE				

num	LDR  R2, [R0, R1]						
	ADD  R3, R2								
	ADD  R1, #4 
	LSR  R6,R1,#2;
	CMP  R6, R4			
	BGT  ans								
	B 	 num							
	
ans MOV  R0, R3	
	MOV  R1,R4;
	POP  {R2-R9}
	BX LR
			
;------------Average------------
; Function finds the average of an array of numbers
; 		 '-> must be given at least one number
; Input: R0 holds a pointer to an array
;		 array[0] is the count of input numbers
; 		 all input numbers follow in array[1], array[2], etc.
; Output: R0 is the average of the numbers (rounded down)

Average
	
	PUSH {R1-R4,LR}
	BL 	 Sum
	SDIV R0,R0, R1;	
	POP {R1-R4,LR}
	BX 	 LR
	
	
;-------------------------------------------------------	
	ALIGN
	END
	