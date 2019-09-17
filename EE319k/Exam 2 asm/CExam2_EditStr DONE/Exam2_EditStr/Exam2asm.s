; Exam2asm.s
; YOUR NAME:
; DHRUV SANDESARA
;
;   '-> DO NOT FORGET TO PUT YOUR NAME IN THE 
;       CODE ON THE EXAM OR IT WILL BE -5 POINTS!!!!
; Date Modified:
	EXPORT   strLen
	EXPORT   Check
	
	AREA    |.text|, CODE, READONLY, ALIGN=2
	PRESERVE8
    THUMB
		
		; EDIT THIS FILE!
;-------------------------- INSTRUCTIONS ------------------------
; Implement the following functions strLen and Check
; The grader will display in UART1 when you run your code in the debugger

;--------------- strLen ---------------
; Finds the length of a char string
; INPUT: R0 is pointer to a null-terminated char string
; OUTPUT: the number of chars in string
; TESTCASES: (there are 6 testcases for strLen)
;  	"" 				Should Return: 0 
;	"hi!" 			Should Return: 3 
;	"@!#$%^&*()" 	Should Return: 10 
;	"trick 0 you" 	Should Return: 11 
;	"funny/b/b  /n" Should Return: 13
;   "This is a long string of words to test your strLen function :)" Should Return: 62
 
strLen	
	PUSH {R1-R4}
	MOV R1,#0;
	MOV R2,#0;
STRLOOP
	LDRB R1,[R0]
	CMP R1,#0;
	BEQ STRDONE;
	ADD R2,#1;
	ADD R0,#1;
	B STRLOOP
	
STRDONE 
	MOV R0,R2;
	
	POP {R1-R4}
	BX LR
	; your code here
		
;--------------- Check ---------------
; Function checks if two char strings are equal
; INPUT: R0 holds a pointer to the first null-terminated char string
;		 R1 holds a pointer to the second null-terminated char string
; OUTPUT: 1 if strings are equal
;		  0 if strings are not equal
; TESTCASES: (there are 7 testcases for Check)
; 	(1) Should Output: 1	"" 
;	    					""
; 	(2) Should Output: 1	"The University of Texas at Austin" 
;							"The University of Texas at Austin"
; 	(3)	Should Output: 1	"123456789" 
;							"123456789" 
; 	(4)	Should Output: 0	"this is same" 
;							"this is not same" 
; 	(5) Should Output: 0	"what if there is no space"
;							"whatifthereisnospace"
; 	(6) Should Output: 0	"how about a space at the end" 
;							"how about a space at the end " 
; 	(7) Should Output: 1	"!@#$%^ ^ &*()__--" 
;							"!@#$%^ ^ &*()__--" 	

Check
	;your code here
	PUSH {R2-R8,LR}
CHECKLOOP
	LDRB R2,[R0]
	LDRB R3,[R1]
	CMP R2,R3;
	BNE NOTEQUAL
	CMP R2,#0;
	BEQ EQUAL;
	ADD R0,#1;
	ADD R1,#1;
	B CHECKLOOP;
	
	
EQUAL
	MOV R0,#1;
    B CHECKDONE	
NOTEQUAL
	MOV R0,#0;
CHECKDONE	
	POP {R2-R8,LR}
	BX LR
	
;-------------------------------------------------------
; End of file Exam2asm.s
	ALIGN
	END