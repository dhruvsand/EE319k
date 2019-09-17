// File: Exam2CPart.c
// ****Your name goes here*******
// -5 points if you do not add your name
// This is Exam2
// EE319K Spring 2017 exam 2
// This is the C Part of the Exam (See Exam2AsmPart.s for the assembly part)  
#include <stdint.h>
/*
A certain tester for a TV screen flashes the LEDs 
in a random sequence of red (R), green (G),blue (B). 
When the sequence RGB is detected, we want to set an 
output bit, Out, to 1 (after the sequence). 
Otherwise the output bit should be 0.

Here's an Example:
Sequence: BBGBRGBGRGBRGBRRGGBR
Output:   00000001000100100000
The FSM for this problem is given in your handout.
The implementation that follows has bugs in translation from Graph
to Code and the FSMLoop engine. In addition your code calls routines 
that you are responsible for and routines that we provided. 
*/
//Routines provided to you. You have to call them as part of your FSMLoop:
void FsmOutput(uint8_t op); // Displays output in a state to screen
void FsmDelay (uint32_t wt); // Delays for wt units time
char FsmInput(void);      // Call to get input to FSM

//Asembly routines you are responsible for, whose prototypes are below
// Implementation for this subroutine is in assembly
// You are responsible for writing this (See Exam2AsmPArt.s)
void ChangeState (uint32_t *st, uint32_t in);

// Implementation for this subroutine is in assembly
// You are responsible for writing this (See Exam2AsmPArt.s)
uint32_t Convert2Index(char in);

struct State {
  uint32_t Out;
  uint32_t Wait;  
  uint32_t Next[4];
};

typedef const struct State STyp;
#define Init 0
#define R    1
#define RG   2
#define RGB  3
// This is the FSM translation from the Graph (in your handout) - 
//   There may be errors in translation
STyp FSM[4]={
 {0,10,{R,Init,Init}}, //INIT STATE
 {0,10,{R,RG,Init}},			 //R
 {0,10,{R,Init,RGB}},  //RG
 {1,10,{R,Init,Init}}		 //RGB
};

// You have to debug/complete this function. 
// This function implements the FSM engine but has bugs in it
// Input: count tracks how many times the FSMLoop has to run
// Unlike your Lab5, the engine does not run indefinitely
void FSMLoop(uint8_t count){
  uint32_t cs=0, idx;
  char     cin;
	count++;
  
  cs = Init;      // Initialize current state to initial state(Init)
  while(count > 1) {

    FsmOutput(FSM[cs].Out); //1.Call FsmOutput and pass it the output 
                                // in current state
    FsmDelay(FSM[cs].Wait);  //2. Call FsmDelay and pass it the wait time 
                                // in current state
    cin = FsmInput();        //3.Get new input ('R','G','B')  
    idx = Convert2Index(cin);   // Convert input to index into the next state array
		cs = FSM[cs].Next[idx];
//		ChangeState(&idx, cin);     //4. Change state based on current state and input
   count--;               // repeat count times, so decrement count
  }
}

// You do not have to write this function, it is given to you
// StringMatch checks if the two null-terminated strings passed to it
// are the same and returns a 1 if they match and 0 otherwise
uint8_t StringMatch(char A[], char B[]);

struct Rec_t {
  int8_t score;
  char name[80];
};

// You have to write this function.
// Inputs: "students" is an array of student records 
//            terminated by a student record with a score of -1 
//            (all other students have a score 0 <= score <= 100)
//         "name" is a null-terminated array of chars (String) 
// Output: Check if the given array is sorted in ascending order of scores. 
//         If it is not then return a  -1 for student rank;
//         If it is sorted then return the rank of the student 
//         whose name is passed in name. If student is not found then return a 0.
// Notes:  
//        * The student with the best (highest) score has a rank of 1 
//        * No two students have the same score
//        (Hint: Will be last entry if the array is sorted in ascending order).
//        You can call the StringMatch function whose prototype is given above
//Testcases:
// 1. Inputs: students[]:  {{70,"Sue"},{72,"Ed"},{85,"Joe"},{90,"Eddy"},{-1,"End"}}
//            find[]: "Joe"
//    Output: 2 because the list is sorted and Joe is 2nd in class
// 2. Inputs: students[]:  {{70,"Sue"},{85,"Joe"},{90,"Eddy"},{-1,"End"}}
//            find[]: "Sue"
//    Output: 3 because the list is sorted and Sue is 3rd in class
// 3. Inputs: students[]:  {{70,"Jane"},{90,"Eddy"},{-1,"End"}}
//            find[]: "Eddy"
//    Output: 1 because the list is sorted and Eddy is 1st in class 
// 4. Inputs: students[]:  {{70,"Sue"},{85,"Joe"},{90,"Eddy"},{-1,"End"}}
//            find[]: "Joey"
//    Output: 0 because the list is sorted and Joey is not a student
// 5. Inputs: students[]:  {{80,"Jon"},{85,"Joe"},{70,"Eddy"},{55,"Ted"},{40,"Mary"}{-1,"End"}}
//            find[]: "Emmet"
//    Output: -1 because the list is unsorted

int8_t FindRank( struct Rec_t students[], char name[]){
		
	int8_t temp=0,previous;
	uint32_t i=0,index=0,match,length=0;
	
	previous= students[0].score;
		while(students[i].score!=-1){
			temp= students[i].score;
			if (temp<previous)
				return -1;
			
			i++;
			length++;
			
		}
		i=0;
		while(students[i].score!=-1){
			temp= students[i].score;
			index=0;
			match=1;
			while((name[index]!=0)){
			if (students[i].name[index]!=name[index])
				match=0;
			index++;
		}
		
		if (match)
			return (length-i);
		i++;
		}
  
  return(0);
}




