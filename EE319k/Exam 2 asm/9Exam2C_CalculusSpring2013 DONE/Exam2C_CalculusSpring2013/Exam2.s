;*****Your name goes here*******
; -5 points if you do not add your name
; DHRUV SANDESARA;
; 60 MINS
;This is Exam2_Calculus 
;EE319K Spring 2013
;March 28, 2013
;You edit this file only


DATAERR EQU 0X80000000
       AREA   Data, ALIGN=4


       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB

;***** Size subroutine*********************
;Determines the number of elements in a variable-length array
;Each element of the array is a 16-bit signed number
;The array has a termination code of -32768
;The -32768 is not a data point in the array
;Input:   R0 has a pointer to the array of 16-bit numbers
;Output:  R0 is returned as the number of data elements in the array 
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Error conditions: none
;Test cases
;Array0 DCW 35,144,25,36,-32768              ;size = 4
;Array1 DCW 9,13,-4,-5,100,-2000,7000,-32768 ;size = 7
;Array2 DCW 0,128,0,128,128,-32768           ;size = 5
;Array3 DCW -32768                           ;size = 0
      EXPORT Size
DATA
	DCW -32768
		  
Size 
; put your code here
	PUSH {R1-R8};
	LDR R2,=DATA
	LDRSH R2,[R2];
	MOV R3,#0;
	
SIZELOOP
	LDRSH R1,[R0];
	CMP R1,R2;
	BEQ SIZEDONE;
	ADD R3,#1;
	ADD R0,#2;
	B SIZELOOP;
	
	
	
SIZEDONE
	MOV R0,R3;
	
	POP {R1-R8}
      
      
      BX    LR

;***** Derivative subroutine*********************
;Calculates the derivative between two points
;Assumes the two points were measured 0.1 sec apart
;Inputs:  R0 is the first data value
;         R1 is the second data value
;R0 and R1 can vary from -32767 to +32767
;Output:  return R0 = (second-first)*10
;the output value can vary from -655340 to +655340
;overflow can not happen in this function
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Error conditions: none
;Test cases
;R0=10,     R1=-10    yields R0 = -200
;R0=-10,    R1=10     yields R0 = 200
;R0=32767,  R1=-32767 yields R0 = -655340
;R0=-20000, R1=-10000 yields R0 = 100000
      EXPORT Derivative
Derivative
    
; put your code here
	SUB R0,R1,R0
	MOV R1,#10;
	MUL R0,R0,R1;

      
      
      BX   LR

;***** Integration subroutine *********************
;Determines the integral of elements in a variable-length array
;Assumes the points in the array were measured 0.1 sec apart
;Each element of the array is a 16-bit signed number
;The array has a termination code of -32768
;The -32768 is not a data point in the array
;Input:   R0 has a pointer to the array of 16-bit numbers
;Output:  return R0 is returned as the integral of data elements in the array 
;The integral is the sum of all data points divided by 10
;First calculate the sum, and then divide the sum by 10
;Do not worry about overflow during the additions
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Error conditions: none
;Test cases
;Array4 DCW 35,144,25,36,-32768              ;I = (35+144+25+36)/10 = 24
;Array5 DCW 9,13,-4,-5,100,-2000,7000,-32768 ;I = (9+13-4-5+100-2000+7000)/10 = 511
;Array6 DCW 20000,25000,25000,30000,20000,25000,25000,30000,20000,25000,25000,30000,20000,25000,25000,30000,-32768                  ;I = 40000
;Array7 DCW -20000,-25000,-25000,-30000,-20000,-25000,-25000,-30000,-20000,-25000,-25000,-30000,-20000,-25000,-25000,-30000,-32768  ;I = -40000
;Array8 DCW -32768                           ;I = 0
DATA2
	DCW -32768
      EXPORT Integration
Integration  
; put your code here
    PUSH {R1-R8};
	LDR R2,=DATA2;
	LDRSH R2,[R2];
	MOV R3,#0;
	MOV R4,#10;
	
INTLOOP
	LDRSH R1,[R0];
	CMP R1,R2;
	BEQ INTDONE;
	ADD R3,R1;
	ADD R0,#2;
	B INTLOOP;
	
	
	
INTDONE
	SDIV R3,R3,R4;
	MOV R0,R3;
	
	POP {R1-R8}
      
      
      
      BX    LR
DATA3
	DCW -32768 
;DATAERR
;	DCD 0X80000000;

;***** MaxDerivative subroutine *********************
;Determines the maximum derivative of elements in a variable-length array
;Assumes the points in the array were measured 0.1 sec apart
;Each element of the array is a 16-bit signed number
;The array has a termination code of -32768
;The -32768 is not a data point in the array
;An array of n elements has n-1 derivatives.
;Each derivative is calculated using adjacent elements: (second-first)*10
;Input:   R0 has a pointer to the array of 16-bit numbers
;Output:  R0 is returned as the maximum derivative of data elements in the array 
;The integral is the sum of all data points divided by 10
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Error conditions: return 0x80000000 if the array has zero or one element
;Test cases
;Array9  DCW 35,144,25,36,-32768              ;derivatives are 1090,-1190,110; max is 1090
;Array10 DCW 9,13,-4,-5,100,-2000,7000,-32768 ;derivatives are 40,-170,-10,1050,-21000,90000; max is 90000
;Array11 DCW 4,2,0,-4,-5,-9,-12,-32768        ;derivatives are -20,-20,-40,-10,-40,-30; max is -10
;Array12 DCW 10,0,-32768                      ;derivative is -100; max is -100
;Array13 DCW 10,-32768                        ;error case, return 0x80000000
;Array14 DCW -32768                           ;error case, return 0x80000000
      EXPORT MaxDerivative

	
MaxDerivative  
	PUSH {R1-R7,LR};
	LDR R2,=DATA3;
	LDRSH R2,[R2];
	MOV R3,R0;
	MOV R4,#0;
	MOV R5,#10;
	
	
	LDRSH R0,[R3];
	LDRSH R1,[R3,#2];
	CMP R0,R2;
	BEQ ERROR
	CMP R1,R2;
	BEQ ERROR;
	SUB R4,R1,R0;
	MUL R4,R4,R5;
	MOV R6,R4;
	
MAXLOOP
	LDRSH R0,[R3];
	LDRSH R1,[R3,#2];
	CMP R1,R2;
	BEQ MAXNORMALDONE;
	SUB R4,R1,R0;
	MUL R4,R4,R5;
	CMP R4,R6;
	BLT MAXSKIP
	MOV R6,R4;
MAXSKIP
	ADD R3,#2;
	B MAXLOOP;
	
	
	
MAXNORMALDONE
	MOV R0,R6;
	B MAXDONE
	
ERROR
	LDR R0,=DATAERR;
	;LDR R0,[R0]
MAXDONE
	POP {R1-R7,LR};
   
      BX    LR
      
;***** Ave6 subroutine *********************
;Determines the average of six 32-bit unsigned numbers
;Average is (n1+n2+n3+n4+n5+n6)/6
;Do not worry about rounding (perform simple integer division)
;Do worry about overflow during the addition steps
;Input:   R0 is n1
;         R1 is n2
;         R2 is n3
;         R3 is n4
;         top of stack is n5
;         next to top of stack is n6
;Output:  R0 is returned as the average of the six numbers 
;Invariables: You must not permanently modify registers R4 to R11, and LR
;You will need to access the stack, but do not permanently add or remove items from stack         
;Error conditions: return 0xFFFFFFFF on overflow
;Test cases
; 1,2,3,5,6,7                       has an average of 4
; 0x80000000,0x80000000,0,0,0,0     overflow output = 0xFFFFFFFF
; 0x90000000,0,0xE0000000,0,0,0     overflow output = 0xFFFFFFFF
; 0xC0000000,0,0,0,0,0xF0000000,0   overflow output = 0xFFFFFFFF
; 0xA0000000,1,0xB0000000,0,0,0     overflow output = 0xFFFFFFFF
      EXPORT Ave6
Ave6  
; put your code here
	ADDS R0,R0,R1;
	BCS OVERFLOWERROR
	MOV R1,#6;
	ADDS R0,R0,R2;
	BCS OVERFLOWERROR
	ADDS R0,R0,R3;
	BCS OVERFLOWERROR
	
	MOV R2,SP;
	LDR R3,[R2];
	
	
	ADDS R0,R0,R3;
	BCS OVERFLOWERROR
	
	LDR R3,[R2,#4];
	ADDS R0,R0,R3;
	UDIV R0,R0,R1;
	BCS OVERFLOWERROR
	
	
	B AVE6DONE
 
OVERFLOWERROR
	MOV R0,#-1
	
AVE6DONE
      
      BX    LR
      ALIGN
      END
      
