//Exam2.h
//Created By: Vickie Fridge
//Date Modified: April 4, 2017

typedef struct sentence{
		char words[100];	//NULL-terminated string of words (a sentence)
		char remove[10];	//NULL-terminated string to remove from sentence
		int num_removed;	//number of strings removed, has -1 if not removed yet
} Sentence;
 
/*************** fix *************** 
 * Removes all instances of the string remove from
 * 	the string words
 * INPUT: Sentence* -> pointer to structure in comments above
 * OUTPUT: void BUT words is updated with the edited string
 *									num_removed has the number of times remove was taken out of words
 */
void fix(Sentence* edit);
