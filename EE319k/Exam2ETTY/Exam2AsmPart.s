;Exam2AsmPart.s
; This is the assembly Part of the Exam (See Exam2CPart.c for the C part)
; You have to complete two subroutines related to the FSM here:
; Convert2Index
; ChangeState
    AREA    |.text|, CODE, READONLY, ALIGN=2
        THUMB
        IMPORT  FSM   ; FSM state array 
        EXPORT  ChangeState
        EXPORT  Convert2Index
;******** Convert2Index **********
; Convert the char input R,G,B to an index 0,1,2
; Input: The first passed parameter has char 'R', 'G', or 'B'
; Output: Return the corresponding value 0, 1, or 2 
; Errors: Any input that is not R,G, or B must return 255.
; Notes: R, G, and B have ASCII values 0x52, 0x47, and 0x42 respectively
; TestCases:
; 1. Input is 'R' - Expected Output is 0
; 2. Input is 'G' - Expected Output is 1
; 3. Input is 'B' - Expected Output is 2
; 4. Input is 'X' - Expected Output is 0xFF
Convert2Index
    CMP R0,#0X52;
	BEQ RED;
	CMP R0,#0X47;
	BEQ GREEN;
	CMP R0,#0X42;
	BEQ BLUE;
	
	MOV R0,#255;
	B CONVERTDONE;
RED
	MOV R0,#0;
	B CONVERTDONE;
GREEN
	MOV R0,#1;
	B CONVERTDONE;
BLUE
	MOV R0,#2;
	B CONVERTDONE;
	


CONVERTDONE
		; Replace this line with your solution (multiple lines)
    BX  LR
    
;******** ChangeState **********
; Change State based on current state and input
; Inputs: Input 1 is address of the current state variable (unsigned 32-bit)
;         Input 2 is the input value (unsigned 32-bit)
; Outputs: None
; Notes: The current state whose address is passed has to be updated to the new state
;        This function uses call-by-reference for its first parameter.
;        Make sure to fix the FSM translation before attempting this subroutine    
; Testcases:
;   All 12 combinations of state and input are checked as test cases
ChangeState
;    ADD R0,#8;   SKIP THE OUT AND THE WAIT THINGS AND GO TO THE ARRAY OF NEXT STATES
	PUSH {R1-R4}
	ADD R0,#8; 
	MOV R4,#0x4;
	MUL R1,R1,R4; MULTIPLY BY 4 SINCE THEY ARE 32 BIT VALUES
	ADD R0,R0,R1; ADD THE OFFSET OF THE ARRAY TO GET NEXT STATE POINTER
;	LDR R0,[R0];
	
	POP {R1-R4}
	
	
    BX  LR
    ALIGN                           ; make sure the end of this section is aligned
    END                             ; end of file
