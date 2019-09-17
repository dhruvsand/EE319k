//Exam2.c
//YOUR NAME:
//DHRUV SANDESARA
//   '-> DO NOT FORGET TO PUT YOUR NAME IN THE 
//       CODE ON THE EXAM OR IT WILL BE -5 POINTS!!!!
//Date Modified:

#include <stdint.h>
#include "Exam2.h"
int strLen (char* string); //prototype for ASM function

				// EDIT THIS FILE!
/**************************************************
 * INSTRUCTIONS:
 *		Implement the following function fix
 * 		The grader will display in UART1 when 
 * 			you run your code in the debugger
 **************************************************
 * NOTE: the sentence struct looks like this:
 *			 (the struct is actually defined in Exam2.h)
 * 	typedef struct sentence{
 *			char words[100];	//NULL-terminated string of words (a sentence)
 *			char remove[10];	//NULL-terminated string to remove from sentence
 *			int num_removed;	//number of edits, has -1 if nothing has been removed yet
 * 	} Sentence;
**************************************************/

/********************** fix ***********************  
 * Removes all instances of the remove string from the words string
 * Function updates the words string in struct
 * 					does not change the remove string
 * 					stores the number of edits in num_removed
 * INPUT: Sentence*  A pointer to a sentence structure (defined in comments above)
 * OUTPUT: void   	 BUT words string is updated with the edited string
 *									 num_removed has the number of times remove was taken out of words */
 void fix(Sentence* edit){
	 uint32_t i=0,a=0,match=0,temp=0,temp2=0;;
	 int32_t length=0;

	 
	 
	 while (((*edit).words[i]!=0)&&(i<100))
		 {	
				while (((*edit).remove[a]!=0)&&(a<10)){
					match=1;
					if((*edit).remove[a]!=(*edit).words[i+a]){
						match=0;
						break;
					}
						length++;
					a++;
	 
				}
				
				
				
				if(match){
					temp=i;
					while(((*edit).words[temp]!=0)){
						
						
						(*edit).words[temp]= (*edit).words[temp+length];
						
						temp++;
						
					}
					temp2++;
						
					
					}
					else{
						i++;
					}
	 		match=0;
			a=0;
			length=0;		
	 
	 }
		 

	(*edit).num_removed= temp2;
	 
	 
		// your code here
}
 
/* fix TESTCASES: (there are 7 testcases for fix) 
 * 	for each test, row one is the struct at input
 *								 row two is what the struct should look like when you return
 * 		(1) {{"Alice was not here."}, {"not "}, -1}
 *				{{"Alice was here."}, 		{"not "},  1}
 *		(2)	{{"Winter Summer is coming."}, {"Winter "}, -1}
 *				{{"Summer is coming."}, 			 {"Winter "},  1}
 *		(3) {{"Oatmeal raisin cookies are the bestest."}, {"est."}, -1}
 *				{{"Oatmeal raisin cookies are the best"}, 		 {"est."},  1}
 *		(4) {{"Vvickie ivs mvakinvg mvore vvvtest cvvasvvesv..v."}, {"v"}, -1}
 *				{{"Vickie is making more test cases..."}, 							{"v"}, 14}
 *		(5) {{"Puppies"}, {""}, -1}
 *				{{"Puppies"}, {""}, 0}
 *		(6) {{""}, {"a"}, -1}
 *				{{""}, {"a"},  0}
 *		(7) {{"SOSOk SO SOSthiSOSs iS SOSthe laSOst oneS0S!SOS"}, {"SOS"}, -1}
 *				{{"Ok SO this iS the laSOst oneS0S!"}, 								{"SOS"},  5}
 */ 

