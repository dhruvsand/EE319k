.ORIG x3000 ; 			STARTING THE PROGRAM


OUTPUT1	AND R0, R0, #0;		TO CHECK THE READING STATUS
	AND R1, R1, #0;		TO GET ADRRESS WHERE TO READ FROM
	AND R2, R2, #0;		FOR INCREMENTING THE ABOVE ADRESS
	ADD R2, R2, #-1; 	FOR INCREMENTING ADDRESS WHERE READING DATA IS STORED
	AND R3, R3, #0; 	FOR OUTPUTING THE DATA WE WANT THE USER TO READ
	LD R3,NEWLINE; 		FOR THE NEWLINE

LOOPNEWLINE1	LDI R0, DSR;   FOR OUTPUTTING THE FIRST ENTER TO GET FROM DISPLAY 3 TO THE NEXT INPUT
	BRZP LOOPNEWLINE1;
	STI R3,DDR;

LOOPNEWLINE2	LDI R0, DSR;	FOR THE GAPLINE
	BRZP LOOPNEWLINE2;
	STI R3,DDR;


L1	LDI R0, DSR; 		CHECKING THE DISPLAY IS READY OR NOT
	BRZP L1;

	ADD R2,R2,#1;		FOR INCREMENTING THE ADRESSES
	LEA R1,PROMPT1;		LOADING THE ADRESS OF THE PROMPT
	ADD R1,R1,R2;		ACTUALLY INCREMENTING THE ADRESS
	LDR R3,R1,#0;		DOING TILL WE REACH THE X000 OF THE .STRINGZ
	BRZ INPUT1;		IF WE REACH THE END GET OUT OF THE LOOP TO THE NEXT STEP
	STI R3,DDR;		DISPLAY THE CONTENTS OF THE ADRESS
	BR L1;			GO BACK TO THE START OF THE LOOP FOR NEXT CHARACTER







INPUT1 	AND R0, R0, #0;		TO CHECK THE WRITING STATUS
	LD R1, DATA1;		TO GET ADRRESS WHERE TO READ FROM
	AND R2, R2, #0;		FOR INCREMENTING THE ABOVE ADRESS
	ADD R2, R2, #-1; 	FOR INCREMENTING ADDRESS WHERE READING DATA IS STORED
	AND R3, R3, #0;		
	AND R7,R7,#0;
	LD R4,NEWLINE;		THIS WILL BE USEFUL TO CHECK WHETHER THE USER INPUTED AN ENTER
	NOT R4,R4;
	ADD R4,R4,#1;

L2	LDI R0,KBSR;		CHECKING IF THE USER TYPED ANYTHING
	BRZP L2;

	ADD R2,R2,#1;		TO INCREMENT THE MEMORY VALUES
	LD R1, DATA1
	ADD R1,R1,R2;
	LDI R3,KBDR; 		R3 HAS THE DATA THAT WE WILL STORE
	LDI R5,KBDR;		R5 HAS A DUPLICATE COPY TO MANIPULATE IT TO CHECK IF IT IS AN ENTER

L10	LDI R7, DSR;		CHECKING IF OK TO DISPLAY
	BRZP L10;
	STI R3,DDR;
	AND R7,R7,#0;
	STR R7,R1,#0;
	ADD R5,R5,R4;
	ADD R6,R2,R5;
	BRZ ENDOUTPUT;		EXITING IF THE FIRST CHARACTER IS ENTER
	ADD R5,R5,#0;
	BRZ OUTPUT2; 		GOING TO NEXT STEP IF AN ENTER WAS PRESSED LATE AFTER ALL THE INPUTS
	
	STR R3,R1,#0;		STORING THE ACTUAL DATA
	AND R7,R7,#0;
	STR R7,R1,#1;		STORING X0000 IN THE NEXT SPACE INCASE ENTER IS PRESSED AND WE DONT GET TO THIS STEP 
	BR L2

	


	
OUTPUT2 	AND R0, R0, #0;	TO CHECK THE READING STATUS
	AND R1, R1, #0;		TO GET ADRRESS WHERE TO READ FROM
	AND R2, R2, #0;		FOR INCREMENTING THE ABOVE ADRESS
	ADD R2, R2, #-1; 	FOR INCREMENTING ADDRESS WHERE READING DATA IS STORED
	AND R3, R3, #0;


L3	LDI R0, DSR;		CKCKING IF OK TO DISPLAY
	BRZP L3;

	ADD R2,R2,#1;		TO INCREMETING THE ADRESES
	LEA R1,PROMPT2;		LOADING WHERE TO READ FROM
	ADD R1,R1,R2;		INCREMETING THE READING ADRESSES
	LDR R3,R1,#0;		CKECKING IF WE REACH THE END OF THE OUTPUT
	BRZ INPUT2;
	STI R3,DDR;		DISPLAYING THE CHARACTER
	BR L3;			GOING TO DISPLAY THE NEXT CHARACTER









INPUT2 	AND R0, R0, #0;		TO CHECK THE WRITING STATUS
	LD R1, DATA2;		TO GET ADRRESS WHERE TO READ FROM
	AND R2, R2, #0;		FOR INCREMENTING THE ABOVE ADRESS
	ADD R2, R2, #-1; 	FOR INCREMENTING ADDRESS WHERE READING DATA IS STORED
	AND R3, R3, #0;
	AND R7,R7,#0;
	LD R4,NEWLINE;
	NOT R4,R4;
	ADD R4,R4,#1;		IN ORDER TO CHECKI IF THE USER INPUTS AN ENTER

L20	LDI R0,KBSR;		CEKING IF USER TYPED AN ENTER
	BRZP L20;

	ADD R2,R2,#1;		TO INCREMENT THE STORING ADRESSES
	LD R1, DATA2;		LOADING INTIAL ADRESS
	ADD R1,R1,R2;		GETING THE ACTUAL INCREMENTED ADRESS
	LDI R3,KBDR;		R3 HAS THE DATA THAT WE WILL STORE
	LDI R5,KBDR;		R5 HAS DUPLICATE COPY TO MANIPULATE

L11	LDI R7, DSR;		CHECKING IF OK TO DISPLAY
	BRZP L11;
	STI R3,DDR;		DISPLAYING THE DATA
	AND R7,R7,#0;		CLEARING THE NEXT ADRESS INCASE THE USER TYPES IN ENTER AND WE DONT GET TO THIS PART
	STR R7,R1,#0;
	ADD R5,R5,R4;		SEEING IF THE USER ENTERED AN ENTER
	ADD R6,R2,R5;		IF THE FIRST CHARACTER WAS ENTER THAN B IS ALWAYS A SUBSTRING SO WE CAN SKIP THE CALCULATION STEPS
	BRZ SPECIALCASE;	GOING TO THE ABOVE MENTIONED SPECIAL CASE        
	ADD R5,R5,#0;		IF THE CHARACTER IS ENTER IN GENERAL GOING TO THE CALCULATION STEP
	BRZ CALCULATE;          
	
	STR R3,R1,#0;		STORING IN MEMORY
	AND R7,R7,#0;		STORING THE NEXT MEMORY LOCATION AS X0000 IN CASE WE DONT GET TO DO THIS IF USER ENTERS ENTER
	STR R7,R1,#1;
	BR L20

SPECIALCASE LEA R6,YES;		SPECIAL CASE FOR DISPLAYING YES
	BR DISPLAY3;
	


CALCULATE LD R0,DATA2; 		DUPLICATE ADRESS TO MANIPULATE THE B STRING STARTTNG ADRESS INCASE WE NEED TO START COMPARING ALL OVER AGAIN
	LD R1,DATA1;		ADRESS OF STRING A
	AND R2,R2,#0;		R2 IS TO STORE WHETER IT IS A SUBTRTING OR NOT
	LD R3,DATA2;		R3 IS ADRESS OF STRING B
	AND R6,R6,#0;		R6 TO CHECK IF THE CHARACTERS MATCH OR NOT
	AND R7,R7,#0;		R7 IS FOR SPECIAL CASES WITH DUPLICATE CHARACTERS BACK TO BACK
	

LOOP	LDR R4,R1,#0;		R4 HAS THE CHARACTER FROM STRING A
	BRZ SPECIALCASE2;	IF WE REACH ZERO FROM STRING A WE WANT TO DO A SPECIAL CASE 
	LDR R5,R3,#0;
	BRZ OUTPUT3;		TO SEE IF WE HAVE REACHED THE END OF STRING B
	NOT R5,R5;
	ADD R5,R5,#1;		INVERTING THE CHARATER TO SEE IF THE MATCH
	
	ADD R6,R4,R5;
	BRNP CASE1;		IF THE DONT MATCH
	BRZ CASE2;		IF THEY MATCH

SPECIALCASE2 	LDR R5,R3,#0;	IN THE SPECIAL CSE IF B HAD REACHED ZERO ALSO THEN KEEP THE STATUS OF R2 INTACT
		BRZ OUTPUT3;
		AND R2,R2,#0;	OTHERWISE THE B IS NOT A SUBTRING OF A
		BR OUTPUT3;



CASE1	ADD R2,R2,#0;
	BRZ SKIPCASE2;		IF THERE WAS A MATCH STARTING TO BE FOUND BUT NOT FOLLOWED THROUGH WE WANT THE POINTER IN STRING A TO GO BACK TO ITS ORIGINAL SPOT PLUS 1
	AND R1,R1,#0;
	ADD R1,R1,R7;		R2 IS WHERE THIS POINTER WAS

SKIPCASE2	ADD R1,R1,#1;	IF THERE WAS NOT MATCH FOUND EARLIER THEN JUST KEEP GOING ONTO THE NEXT CHARACTER
	AND R2,R2,#0;		CHANGING STATUS REGISTER TO NO MATCH AGAIN
	AND R3,R3,#0;
	ADD R3,R3,R0;		GETTING STRING B POINTER BACK TO BEGENNING INCASE IT WAS CHANGES IF A MATCH WAS FOUND
	BR LOOP;

CASE2	ADD R2,R2,#0
	BRP SKIPCASE;		CHECKING IF THIS DISCOVERY IS A NEW ONE OR ARE WE CONTINUING FROM PREVIOUS TIME
	
	AND R7,R7,#0;		INCASE IT IS NEW ARCHIVE THE POINTER IN STRING A SO THAT IF THIS MATCH DOES NOT FOLLOW THROUGH THEN WE CAN GO BACK TO WHERE IT WAS
	ADD R7,R1,R7;
	
SKIPCASE ADD R3,R3,#1;		INCASE THIS IS A NEWFIND INCREMENT BOTH STRING TO THE NEXT CHARACTER AND THEN TEST AGAIN IF THEY ALSO MATCH
	ADD R1,R1,#1;
	AND R2,R2,#0;
	ADD R2,R2,#1;		MAKING THE R2 A MATCH INCASE WE TERMINATE IN THE NEXT STEP
	BR LOOP;



OUTPUT3	AND R6,R6,#0; 		CLEARING R6 WHERE THE ADRESS OF THE PROMPT WILL BE STORED
	ADD R2,R2,#0;		
	BRZ CASE; 		IF R2 HAD ZERO MEANING NO MATCH
	LEA R6,YES;		IF R2 HAD A MATCH
	BR DISPLAY3;
CASE	LEA R6,NO;		IF NOT A MATCH
	BR DISPLAY3;




DISPLAY3	AND R0, R0, #0;	TO CHECK THE READING STATUS
	AND R1, R1, #0;		TO GET ADRRESS WHERE TO READ FROM R6
	ADD R1,R6,R1;
	AND R2, R2, #0;		FOR INCREMENTING THE ABOVE ADRESS
	ADD R2, R2, #-1;	FOR INCREMENTING ADDRESS WHERE READING DATA IS STORED
	AND R3, R3, #0;


L333	LDI R0, DSR; 		CHECKING IF OK TO DISPLAY
	BRZP L333;

	ADD R2,R2,#1;		TO INCREMENT THE ADRESSES
	AND R1, R1, #0;		TO GET ADRRESS WHERE TO READ FROM R6 YES OR NO
	ADD R1,R6,R1;
	ADD R1,R1,R2;		INCREMENTING THE ADRESSES
	LDR R3,R1,#0;		TAKING THE CHARACTERFROM THE PROMPT TO OUTPUT
	BRZ OUTPUT1;		IF ZERO GOING BACK TO BEGENNING OF THE LOOP
	STI R3,DDR;		DISPLAYING THE CHARACTER
	BR L333;




ENDOUTPUT	AND R0, R0, #0;	TO CHECK THE READING STATUS
	AND R1, R1, #0;		TO GET ADRRESS WHERE TO READ FROM
	AND R2, R2, #0;		FOR INCREMENTING THE ABOVE ADRESS
	ADD R2, R2, #-1;	FOR INCREMENTING ADDRESS WHERE READING DATA IS STORED
	AND R3, R3, #0; 	FOR OUTPUTING THE DATA WE WANT THE USER TO READ


L111	LDI R0, DSR;		CHECKING IF DISPLAY IS READY
	BRZP L111;

	ADD R2,R2,#1;		TO INCREMENT THE VALUES
	LEA R1,EXITPROMPT;	GETTING ADRESS OF WHERE THE DATA IS STORED
	ADD R1,R1,R2;		INCREMENTING ADRESS
	LDR R3,R1,#0;		GETTING THE CHARACTERS
	BRZ EXIT;		IF IT IS ZERO ENDING THE PROGRAM
	STI R3,DDR;		DISPLAYING IT
	BR L111;	

EXIT HALT;			HALTING THE PROGRAM


DATA1	.FILL	X4000;		STARTING ADRESS OF STRING A
DATA2	.FILL	X4100;		STARTING ADRESS OF STRING B
DSR	.FILL	XFE04; 		DISPLAY STATUS REGISTER ADRESS
DDR	.FILL	XFE06;		DISPLAY DATA REGISTER ADRESS
KBSR	.FILL	XFE00;		KEYBOARD STATUS REGISTER ADRESS
KBDR	.FILL	XFE02;		KEYBOARD DATA REGISTER ADRESS
NEWLINE	.FILL	X000A;		ASCII OF NEWLINE

EXITPROMPT	.STRINGZ	"Exiting";		EXITPROMPT	
PROMPT1	.STRINGZ	"Please enter string A: ";	OUTPUT1 PROMPT
PROMPT2	.STRINGZ	"Please enter string B: ";	OUTPUT2 PROMPT
YES	.STRINGZ	"B is a substring of A!";	YES PROMPT
NO	.STRINGZ	"B is not a substring of A!";	NO PROMPT

.END;							ENDING THE ASSEMBLER