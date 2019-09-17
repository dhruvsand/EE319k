;This is Exam2_Sum32
;DHRUV SANDESARA
;TO TAKE 35 MINS
;Your name goes here
;You edit this file only
       AREA   Data, ALIGN=4


       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
;***** Size subroutine*********************
;Determines the number of elements in a variable-length array
;Input:   R0 has a pointer to the array of 32-bit numbers
;Output:  R0 is returned as the number of data elements in the array 
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
;Test cases
;Array1 DCD 3,1,2,3                         ;size = 3
;Array2 DCD 0xA0000000,1...                 ;size = 0xA0000000
;Array3 DCD 0                               ;size = 0
      EXPORT Size
Size 
; put your code here
	LDR R0,[R0];
  

      
      BX    LR

;***** Count subroutine*********************
;Determine the number of times that a data value occurs in a given array
;Inputs:  R0 has a pointer to the array of 32-bit numbers
;         R1 is the data value
;Output:  R0 is the number of times the data value occurs in the array
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
;Test cases
;Array1 DCD 3,1,2,3             ;Data=4   Count=0 (4 occurs 0 times)
;Array2 DCD 5,12,13,4,12,3      ;Data=12  Count=2 (12 occurs twice)
;Array3 DCD 12,1,1,1,2,1,1,2,1,2,1,2,1,1,1      ;Data=1  Count=8 (1 occurs 8 times)
;Array4 DCD 9,300,300,300,300,300,300,300,300,300  ;Data=300  Count=9 (300 occurs 9 times)
;Array5 DCD 7,500000,10,500000,10,500000,0,0 ;Data=500000   Count=3 (500000 occurs 3 times)
;Array6 DCD 0           ;Data=0 Count=0 (0 does not occur in the empty array)
      EXPORT Count
Count 
; put your code here
		PUSH {R2-R4,LR}
		MOV R2,R0; R2 HAS THE POINTER
		MOV R3,#0; R3 HAS THE COUNT
	BL Size ; R0 HAS THE SIZE
	ADD R2,#4;
COUNTLOOP	
	LDR R4,[R2]; R4 HAS THE DATA
	CMP R0,#0; R0 HAS THE SIZE
	BEQ COUNTDONE
	CMP R1,R4;
	BNE COUNTSKIP
	ADD R3,#1;
	
COUNTSKIP
	ADD R2,#4;
	ADD R0,#-1;
	B COUNTLOOP;
	
	
COUNTDONE
	MOV R0,R3;
	
	POP {R2-R4,LR}
     
      BX   LR
DATA	  
	DCD 	0x7FFFFFFF;  

;***** Sum subroutine *********************
;Add up all values in the array
;Inputs:  R0 has a pointer to the array of 32-bit signed numbers
;Output:  R0 is the sum of all the values
;  set R0 to 0x7FFFFFFF if there is any overflow during calculations
;Invariables: You must not permanently modify registers R4 to R11
;test cases
;Array1 DCD 3,1,2,3              ;Sum=1+2+3=6
;Array2 DCD 5,-12,-13,-4,-12,-3  ;Sum=-12-13-4-12-3=-44
;Array3 DCD 14,1,1,1,2,1,1,2,1,2,1,2,1,1,1         ;Sum=18
;Array4 DCD 4,0xD0000000,0xC0000000,0xE0000000,0   ;Sum=0x7FFFFFFF
;Array5 DCD 4,0x30000000,0x40000000,0x20000000,0   ;Sum=0x7FFFFFFF
;Array6 DCD 0           ;Sum=0 (empty array)
      EXPORT Sum
Sum  
; put your code here
	PUSH {R1-R7,LR}
	MOV R1,R0; r1 is now the pointer of where the stuff is 
	LDR R2,[R0]; R2 HAS THE COUNT
	ADD R0,#4;
	MOV R3,#0; R3 HAS THE SUM OF COUNT
SUMLOOP
	LDR R1,[R0]; R1 HAS THE DATA
	CMP R2,#0;
	BEQ SUMNORMALDONE;
	ADDS R3,R1
	BVS OVERFLOW
	ADD R0,#4;
	ADD R2,#-1;
	B SUMLOOP
	
	
OVERFLOW
	LDR R0,=DATA;
	LDR R0,[R0]
	B SUMDONE
	
SUMNORMALDONE
	MOV R0,R3;
	B SUMDONE
SUMDONE	
     POP {R1-R7,LR}
      
      BX    LR
      
      ALIGN
      END
      
