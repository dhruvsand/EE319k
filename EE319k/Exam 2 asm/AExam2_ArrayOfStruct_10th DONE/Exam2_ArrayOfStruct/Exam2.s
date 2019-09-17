; ****Your name goes here*******
; -5 points if you do not add your name
; DHRUV SANDESARA
; 70 MINS
; This is Exam2_ArrayofStruct 
; EE319K Fall 2014 exam2, November 6, 2014
; You edit this file only  
       AREA   Data, ALIGN=4


       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB

;***************** Linear****************************
; Calculate the result of a linear equation y = 16*x-50  
; Input parameter: x is unsigned 8 bits
; Output parameter: y is unsigned 8 bits
; Error conditions: implement ceiling on overflow
;                   implement floor on underflow
; Test Cases as (Input, Output) pairs: 
; (0,0),(3,0),(4,14),(5,30),(11,126),
; (15,190),(19,254),(20,255),(100,255),(255,255)
; C prototype   uint8_t Linear(uint8_t x){
       EXPORT Linear
Linear
	CMP R0,#4;
	BLT LOWER;
	CMP R0,#19;
	BGT HIGHER;
	LSL R0,#4;
	SUB R0,#50;
	B LINEARDONE;



LOWER
	MOV R0,#0;
	B LINEARDONE;
HIGHER
	MOV R0,#255;
	B LINEARDONE;
  ; put your answer here

LINEARDONE
       ; replace this line with your solution
       BX  LR

;******************Swap**************************
; You are given an 11-element 16-bit array.
; Your function should swap the order of the data in the array
; Input: pointer to array
; Output: none
; Error conditions: none
; Test Cases:
; 1. buf before: -5, 4, 7, 0,-1, 3, 4,-8, 2, 9, 9  
;    buf after:  9, 9, 2,-8, 4, 3,-1, 0, 7, 4,-5   
; 2. buf before: 1, 2, 3, 4, 5, 6, 7, 8, 9, 10,11
;    buf after:  11,10, 9, 8, 7, 6, 5, 4, 3, 2, 1
; 3. buf before: 1000,2,3,4,5,-1000,7,10000,9,10,0 
;    buf after:  0,10,9,10000,7,-1000,5,4,3,2,1000
; C prototype   void Swap(int16_t buf[11]){
       EXPORT Swap
Swap 
; put your answer here
	PUSH {R1-R12}
	MOV R3,R0; R3 IS OUR NEW POINTER
	MOV R4,#0; R4 IS THE OFFSET FOR THE 1ST VALUE
	MOV R6,#20;
SWAPLOOP	
	SUB R5,R6,R4; R5 IS THE ODDSET FOR THE 2ND VALUE
	LDRSH R0,[R3,R4]
	LDRSH R1,[R3,R5]
	MOV R2, R0; R2 IS THE TEMP LOCATION;
	CMP R4,#10
	BEQ SWAPDONE;
	STRH R2,[R3,R5];
	STRH R1,[R3,R4];
	ADD R4,#2;
	B SWAPLOOP;
	
	
SWAPDONE	
	POP {R1-R12}
       BX  LR


;struct LabGrades{
;  int32_t size;
;  int32_t score[10];
;};
;typedef struct LabGrades LabGrades_t;
; *******************Average******************
; You will write this function. 
; The function should take a pointer to a lab grade structure and return the average.
; Average can be calculated only if the size is 1 to 10. 
; Input:  Pointer to a lab grade structure
; Output: Average of the lab grades
; Error conditions: If the size is outside the range of 1 to 10, return 0.
; test data
; size  score                                  Average
; 10  |  90  90  90  90  90  90  90  90  90  90 | 90
; 5   |  90  91  92  93  94                     | 92
; 1   | 100                                     |100
; 5   |  85  90  100 70 -25                     | 64
; 8   |  -4  -5  -6  -7 -10   1   2   5         | -3
; 0   |                                         |  0
; 255 |                                         |  0
; C prototype   int32_t Average(LabGrades_t *pt){ ; debug this code
       EXPORT Average
Average
  ; put your answer here
  PUSH {R1-R8}
  LDR R3,[R0]; R3 IS OUR SIZE
 ; R2 IS OUR SUM
	MOV R2,#0
	MOV R4,R3; R4 IS OUR SIZE TO COPY
  ADD R0,#4;
  CMP R3,#0;
  BEQ AVGERROR
  CMP R3,#10;
  BGT AVGERROR;
  
AVGLOOP
	LDR R1,[R0];
	ADD R2,R2,R1;
	ADD R0,#4;
	ADD R3,#-1;
	CMP R3,#0;
	BEQ AVGNORDONE
	B AVGLOOP
AVGNORDONE
	SDIV R0,R2,R4;
	B AVGDONE
  
AVGERROR
	MOV R0,#0;
	
AVGDONE  
  
       
       POP{R1-R8} ; replace this line with your solution
       BX  LR

; **************ClassAverage****************
;   Find the average of all the lab grades in the class
;   Sum up all grades and divide by the number of grades
;   Do not sum up student averages and divide by the number of students
;   if size is 255, it means end of list
;   When dividing, do not round, simply divide sum/count
; Each Labgrade structure is 44 bytes (4 bytes for size and 40 bytes for 10 grades)
; Input:  array of Grades_t data
; Output: the average lab grade
; Error conditions: if there are no students or no grades, return 0
;------------------------------------------------------------------
;Case 1: six students in the class
;{{5,{84,90,88,70,-25}},    
; {1,{70}},    
; {9,{90,90,90,90,-90,70,10,10,10}},
; {0,{}}, 
; {10,{80,80,80,80,80,80,80,80,80,99}}, 
; {2,{80,82}},
; {255,{}}
;}
;Class Average = 64; (see handout for explanation)
;------------------------------------------------------------------
;Case 2: three students in the class
;{{2,{100,100,}}, 
; {1,{95}}, 
; {2,{90,90}}, 
; {255,{0}}
;}
;Class Average = (100+100+95+90+90)/5 = 475/5 = 95 
;-------------------------------------------------------------------
;Case 3: one student in the class
;{{4    ,{-1,-1,-1,-1}},
; {255,{0}}
;}
;Class Average = -1;
;
;Case 4:    no students at all
;{{255,{0}}
;}
;Class Average = 0; 
;------------------------------------------------------------------
; C prototype   int32_t ClassAverage(LabGrades_t ee319k[]){
       EXPORT ClassAverage
ClassAverage
  ; put your answer here
  PUSH {R1-R7,LR}
  MOV R1,R0; R1 WILL HVAE OUR POINTER;
  MOV R2,#0; R2 WILL CONTAIN OUR SUM;
  MOV R3,#0; R3 WILL CONTAIN OUR COUNT OF TESTS;
  MOV R4,#0; R4 WILL BE OUR DELTA
  MOV R5,#0; WILL BE INNER POINTER
  MOV R6,#0; R6 WILL BE THE INNER COUNT
  LDR R0,[R1]
  CMP R0,#255;
  BEQ CAERROR;
CALOOP  
  LDR R0,[R1]
  CMP R0,#255;
  BEQ CANORDONE;
  ADD R5,R1,#4;
  CMP R0,#0;
  BEQ INNERDONE
  MOV R6,R0; 
CAINNER
	LDR R0,[R5,R4];
	ADD R2,R2,R0;
	ADD R3,#1;
	ADD R4,#4;
	ADD R6,#-1;
	CMP R6,#0;
	BEQ INNERDONE;
	B CAINNER;
	
	

INNERDONE

  ADD R1,#44;
  MOV R4,#0;
  B CALOOP
  
  
  
  
  
CANORDONE
	SDIV R0,R2,R3;
	B CADONE;
  
  
  
CAERROR
	MOV R0,R3;
	
CADONE	

  POP {R1-R7,LR}
	
    ; replace this line with your solution
       BX  LR


       END
           