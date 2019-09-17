;*****Your name goes here*******
; DHRUV SANDESARA
;55 MINS
; -5 points if you do not add your name

;This is Exam2_StringCompare 
;EE319K Practice exam
;You edit this file only
       AREA   Data, ALIGN=4


       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB

;***************** Size****************************
; Determines the length of an ASCII string.  
; Input parameter: R0 points to null-terminated string
; Output parameter: R0 equals the length
; Error conditions: if string is empty, return R0=0 
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Test cases
;String1 DCB "cat",0                         ;size=3
;String2 DCB "Ramesh is great.",0            ;size=16
;String3 DCB "EE319K Exam2 was hard!",0      ;size=22
;String4 DCB "My TA is nice,",0              ;size=14
;String5 DCB 0                               ;size=0
      EXPORT Size
Size 
; put your code here
	PUSH{R1-R8}
	MOV R2,#0;
SIZELOOP	
	LDRB R1,[R0]
	CMP R1,#0;
	BEQ SIZEDONE 
	ADD R2,#1;
	ADD R0,#1;
	B SIZELOOP

SIZEDONE
	MOV R0,R2;
	POP {R1-R8}
      BX    LR

;***************** Compare****************************
; Compare two ASCII characters
; Input parameter:  R0 is the first and 
;                   R1 is the second 8-bit ASCII character.
; Output parameter: R0 = -1 if the first is greater than the second, 
;                   R0 = 0 if the first equals the second, and 
;                   R0 = +1 if the first is less than the second
; Error conditions: none
 
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Error conditions: none
;Test cases
;Try1    DCB 'a','b'           ;Compare = +1 because 'a' < 'b'
;Try2    DCB 'a','B'           ;Compare = -1 because 'A' > 'b'
;Try3    DCB 'a','a'           ;Compare = 0  because 'a' == 'a'
;Try4    DCB 200,199           ;Compare = -1 because 200 > 199
;Try5    DCB 200,201           ;Compare = 1 because 200 < 201
      EXPORT Compare
Compare 
	PUSH {R1-R2}
; put your code here
	CMP R0,R1;
	BGT GREATER
	BLT LESSTHAN 
	BEQ EQUAL
	B DONE
GREATER 
	MOV R0,#-1;
	B DONE;
LESSTHAN
	MOV R0,#1;
	B DONE
	
EQUAL
	MOV R0,#0;


DONE 
	POP {R1-R2}
      
      BX   LR

;*********StringCompare********************************
; Compares two ASCII strings, null-terminated
; Input parameter: A pointer to the first string is passed into your program in R0.
;                  A pointer to the second string is passed into your program in R1.
; Output parameter: The result is returned in the R0
;    +1 if the first string is alphabetically before the second
;     0 if the two strings are equal
;    -1 if the first string is alphabetically after the second
; Error conditions: none
;Invariables: You must not permanently modify registers R4 to R11, and LR
;Test cases
;First1  DCB 'cat',0     ; +1 because first letter 'c'< 'd'
;Second1 DCB 'dog',0    
;First2  DCB 'cattle',0     ; +1 because second letter 'a'< 'o' 
;Second2 DCB 'cobra',0   ;(length doesn't matter)
;First3  DCB 'hose',0    ; -1 because third letter 's'> 'r' 
;Second3 DCB 'horse',0   ; (length doesn't matter)
;First4  DCB 'cat',0     ; +1 because all letters of the first string match, 
;Second4 DCB 'cattle',0  ; but the first string is shorter (length does matter)
;First5  DCB 'cattle',0  ;-1 because all letters of the second string match, 
;Second5 DCB 'cat',0     ; but the second string is shorter (length does matter)
;First6  DCB 'horse',0
;Second6 DCB 'horse',0   ; 0 because the strings are equal
;First7  DCB 0
;Second7 DCB 0           ; 0 because the strings are equal and empty

      EXPORT StringCompare
StringCompare  
; put your code here
	PUSH{R2-R8,LR}
	MOV R2,R0; R2 HAS POINTER FOR THE FIRST STRING
	MOV R3,R1; R3 HAS THE POINTER FOR THE SECOND STRING
LOOP	
	LDRB R0,[R2];
	LDRB R1,[R3];
	CMP R0,#0;
	BEQ CHECK2ND;
	CMP R1,#0;
	BEQ CHECK1ST
	
	BL Compare
	
	CMP R0,#0;
	BNE STRINGCOMPAREDONE;
	ADD R2,#1;
	ADD R3,#1;
	B LOOP;
	
	
	
	
	
CHECK2ND
	CMP R1,#0;
	BEQ BOTHEQUAL
	B GREATER2;
	
CHECK1ST
	CMP R0,#0;
	BEQ BOTHEQUAL
	B GREATER1;	
	
	
	
GREATER1
	MOV R0,#-1;
	B STRINGCOMPAREDONE

GREATER2
	MOV R0,#1;
	B STRINGCOMPAREDONE

BOTHEQUAL
	MOV R0,#0;
	B STRINGCOMPAREDONE
	
	
STRINGCOMPAREDONE	
	POP{R2-R8,LR}
		
      BX  LR

      ALIGN
      END
      
