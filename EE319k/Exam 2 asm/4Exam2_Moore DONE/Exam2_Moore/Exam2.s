;This is Exam2_Moore
;Your name goes here
;You edit this file only
       AREA   Data
; your globals go here


       AREA    |.text|, CODE, READONLY, ALIGN=2
       THUMB
;use these definitions (Port V is not a real Port)
GPIO_PORTV_DATA_R  EQU 0x40007404
GPIO_PORTV_DIR_R   EQU 0x40007400
GPIO_PORTV_AFSEL_R EQU 0x40007420
GPIO_PORTV_DEN_R   EQU 0x4000751C
SYSCTL_RCGC2_R     EQU 0x400FE108
SYSCTL_RCGC2_GPIOV EQU 0x00200000   ; port V Clock Gating Control
; ********* YourFSMInit ***************
; Part a) put your initialization here
;modify this function so it initializes the direction register of Port V, be friendly
;PV6,PV5,PV4 are outputs 
;PV3,PV1 are inputs
;initialize global variables 
;initial state is Stop
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
      EXPORT YourFSMInit
YourFSMInit 
    LDR R1, =SYSCTL_RCGC2_R         ; Clock register
    LDR R0, [R1]      
    ORR R0, R0, #SYSCTL_RCGC2_GPIOV ; clock to Port V
    STR R0, [R1]        
    NOP
    NOP                             ; allow time to finish activating
    ; regular port function
    LDR R1, =GPIO_PORTV_AFSEL_R     ; Alternative function register
    LDR R0, [R1]    
    BIC R0, R0, #0x7A               ; PV6,PV5,PV4,PV3,PV1 disable alt funct 
    STR R0, [R1]   
    ; enable digital port
    LDR R1, =GPIO_PORTV_DEN_R       ; data enable register
    LDR R0, [R1]           
    ORR R0, R0, #0x7A               ; PV6,PV5,PV4,PV3,PV1 enable digital I/O 
    STR R0, [R1]        
  ; put your code here
	LDR R1,=GPIO_PORTV_DIR_R
	LDR R0,[R1];
	ORR R0,R0,#0X70;
	BIC R0,R0,#0XA;
	STR R0,[R1]
    

       BX    LR

;*********YourFSMOutput*********************
; Part b) 3-bit output to Port V, be friendly
; Input: call by value in Reg R0 (0 to 7)
; Do not change the values of PV7,3,2,1,0
; There are 8 possibilities
;  R0  |  PV6 PV5 PV4
;   0  |   0   0   0
;   1  |   0   0   1
;   2  |   0   1   0
;   3  |   0   1   1
;   4  |   1   0   0
;   5  |   1   0   1
;   6  |   1   1   0
;   7  |   1   1   1
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
      EXPORT YourFSMOutput
YourFSMOutput 
; put your code here
	PUSH {R1-R4}
	LDR R1,=GPIO_PORTV_DATA_R
	LDR R2,[R1];
	AND R2,R2,#0X8F;
	LSL R0,R0,#4;
	ORR R2,R2,R0;
	STR R2,[R1];
	POP {R1-R4}
      
      BX   LR

;**********YourFSMInput****************
; Part c) 2-bit input from Port V bits PV3 PV1
; Input: none
; Output: return by value in Reg R0 (0 to 3)
; PV3 PV1 | R0 
;  0   0  | 0
;  0   1  | 1
;  1   0  | 2
;  1   1  | 3
;Invariables: You must not permanently modify registers R4 to R11
;Error conditions: none
      EXPORT YourFSMInput
YourFSMInput  
; put your code here
	PUSH {R1-R4}
	LDR R1,=GPIO_PORTV_DATA_R
	LDR R2,[R1];
	AND R2,R2,#0X0F;
	MOV R3,R2;
	BIC R2,R2,#0X7;
	LSR R2,R2,#2;
	MOV R0,#0;
	ADD R0,R2;
	BIC R3,R3,#0XD;
	LSR R3,R3,#1;
	ADD R0,R0,R3;
	
	
	POP {R1-R4}

      BX    LR
      
;  put your graph data structure here

FSM 
	DCB 2, 1,0,1,0;
	DCB 3, 1,2,2,1;
	DCB 4, 0,1,0,2;
       ALIGN 4

       EXPORT YourFSMController
       IMPORT MyGrader 
YourFSMController
      ;your initialization
       BL  YourFSMInit
	   PUSH {R1-R8}
	   LDR R4,=FSM; R1 IS THE TOP OF THE LABEL
	   MOV R5,#0; R2 WILL BE OUR DELTA
	   
loop 
       BL  MyGrader  ;do not move or remove this line
; Part d) put your output-input-next engine here
;the Grader will check outputs and make inputs happen
;1. output to PTV bits 6,4,3 (be friendly)
;2. input from PTV bits 3,1
;3. next
		LDR R4,=FSM;
		MOV R1,#0;
		MOV R6,#5;
		MUL R5,R5,R6;
		ADD R1,R4,R5;
		LDRB R0,[R1]; THIS FIST ACCESS IS THE OUTPUT
		BL YourFSMOutput;
		BL YourFSMInput; GET THE INPUTS IN R0;
		MOV R5,R0; R5 NOW HAS THE DELTA
		ADD R1,R1,R5;
		ADD R1,R1,#1;
		LDRB R5,[R1];
		
	

       B  loop    ;do not remove this line
      
      ALIGN
      END
      
