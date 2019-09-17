;This is Exam2_Mode
;Your name goes here
;DHRUV SANDESARA
;35 MINS
;You edit this file only
       AREA   Data
Array1 SPACE  10

       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
;***** Clear subroutine*********************
;Input:   R0 has a pointer to an array of 8-bit numbers that should be initialized
;Output:  No formal return parameter 
;Make all ten entries of the array equal to zero
;Each element of the array is stored in one 8-bit byte, located at sequential memory addresses.
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
      EXPORT Clear
Clear 
; put your code here
	MOV R1,#0;
	MOV R2,#10;
	PUSH {R1,R2}
	
LOOP
	STRB R1,[R0];
	ADD R0,#1;
	SUB R2,#1;
	CMP R2,#0;
	BNE LOOP;
	POP {R1,R2}

       BX    LR

;***** Max subroutine*********************
;Input:   R0 has a pointer to an array of ten 8-bit unsigned numbers 
;Output:  R0 is the index of the largest value (0 to 9) 
;Find the index of the maximum element in the array  
;Case1 DCB 1,2,3,4,5,6,7,8,9,10            ; returns R0=9 (the max value is 10)
;Case2 DCB 1,2,100,12,13,14,15,16,17,18    ; returns R0=2 (the max value is 100)
;Case3 DCB 200,2,3,10,100,12,13,14,15,16   ; returns R0=0 (the max value is 200)
;Case4 DCB 0,2,200,8,100,12,201,14,15,199  ; returns R0=6 (the max value is 201)
;Each element of the array is stored in one 8-bit byte, located at sequential memory addresses.
;There will be at least one nonzero value. 
;The answer will be unique, do not worry about the max being at two or more indices
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
      EXPORT Max
Max 
; put your code here
	PUSH {R1-R8}
 LDRB R1,[R0];
 MOV R2,#0; R2 IS THE POINTER TO WHERE THE GREATEST NUMBER IS 
 MOV R3,#0; R3 IS THE COUNTER OF HOW MANY ELEMENTS ARE DONE
 MOV R4,R1; R4 IS THE GREATEST NUMBER
MAXLOOP
	LDRB R1,[R0]
	CMP R4,R1;
	BHS MAXSKIP
	MOV R2,R3;
	MOV R4,R1;
MAXSKIP
	ADD R0,#1;
	ADD R3,#1;
	CMP R3,#10;
	BLT MAXLOOP
	MOV R0,R2;
 
 
 
 
 
 POP{R1-R8}
      BX   LR

;***** Mode subroutine *********************
;Inputs: R0 pointer to a variable length string
;        all data values are 0 to 9
;        -1 is the termination code (not data)
;Output: R0 contains the mode 
;        value (0 to 9) that occurs the most frequently
;Invariables: You must not permanently modify registers R4 to R11
;String1 DCB 0,-1                            ; mode is 0
;String2 DCB 0,1,2,1,2,1,1,2,2,1,2,2,1,1,-1  ; mode is 1
;String3 DCB 6,7,7,7,6,9,8,8,7,7,7,7,4,3
;        DCB 7,7,9,7,7,7,-1                  ; mode is 7
;String4 DCB 2,3,4,7,6,9,9,8,7,7,9,7,4,3
;        DCB 7,7,9,7,7,9,9,9,9,9,9,-1        ; mode is 9

      EXPORT Mode
Mode  
; put your code here

 PUSH {R1-R8}
 MOV R1,#0;R1 HAS THE DATAS
 MOV R2,#0; R2 HAS THE TEMPORARY COUNT
 MOV R3,#0; R3 HAS THE PERMANANT COUNT
 MOV R4,#0; R4 HAS THE DATA THAT WE ARE CURRENTLY CONSIDERING
 MOV R5,#0; R5 IS THE PERMANANT MODE
 MOV R6,R0; R6 HAS THE COPY OF R0 SO THAT R0 DOES NOT GET CHANGED;
 
OUTERLOOP
	LDRB R1,[R0];
	CMP R1,#0XFF;  JUST TO SEE IF WE HAVE REACHED THE END OF STUFF
	BEQ OUTERDONE
	MOV R4,R1; CONSIDERING THE BEGENNING ELEMENT
	MOV R2,#0; REINITIALIZE IT TO 0
	ADD R2,#1; THE FIRST TIME IT OCCURS
	MOV R6,R0; R6 IS THE ONE THAT WE WILL CHANGE IN THE INNER LOOP
	ADD R6,#1;
INNERLOOP
	LDRB R1,[R6]
	CMP R1,#0XFF; CHECK IF WE REACHED THE INNERDONE
	BEQ INNERDONE;
	CMP R1,R4; IF EQUAL INCREMENT COUNT
	BNE SKIPINNER
	ADD R2,#0
 
SKIPINNER
	ADD R6,#1;
 B INNERLOOP
INNERDONE
 CMP R2,R3; CHECKING IF THE ELEMT WE CONSIDERED OCCURED FREQUENTLY
 BLT SKIPCHANGE
 MOV R3,R2; IF SO CHANGE THE PERMENANT FREQUENCE
 MOV R5,R4; CHANGE THE MODE THAT WE CONSIDERED
SKIPCHANGE
	ADD R0,#1; CHANGE THE POITER FOR THE NEXT LOOP
	
	
 B OUTERLOOP
OUTERDONE
	MOV R0,R5;
      
      POP {R1-R8}
      BX    LR
      
      ALIGN
      END
      
