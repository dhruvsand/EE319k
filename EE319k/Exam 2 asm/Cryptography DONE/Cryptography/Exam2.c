// ****Your name goes here*******
// -5 points if you do not add your name

// This is Exam2_Substitution Cipher 
// EE319K Fall 2015 exam2
// You edit this file only  
#include <stdint.h>

//******************eORd**************************
// Checks whether a given 2-character string matches
// one of two patterns "-e" or "-d" and returns an appropriate result
// Input: A two character array
// Output: 1 if input is "-e"; -1 if input is "-d"; 0 otherwise
// Note: The passed array is fixed length (2 chars)
// Testcases:
//1. flag[2] = "-e" Return value = 1
//2. flag[2] = "-d" Return value = -1
//3. flag[2] = "--" Return value = 0
//4. flag[3] = "-E" Return value = 0
int8_t eORd(char flag[2]){
	if(flag[0]!='-')
		return 0;
	if(flag[1]=='e')
		return 1;
	if(flag[1]=='d')
		return -1;
	
	return 0;
}
// The following struct and typedef are used in the subroutines below
struct CipherRec {
  char code;
  char encode;
};
typedef struct CipherRec Cipher; 

//******************SubChar**************************
// Return the substitution for the given input character
// The second argument flag tells whether the input
// character is a code or encode. Lookup the CodeBook
// passed as the third argument and return the substitution
// Inputs: tosub: The character whose substitution is to be found
//         flag: "-e"/"-d" to encrypt or decrypt
//         CB[29]: Is an array of Cipher structs each
//                 struct has a code/encode character pair
// Output: The returned character is the substitution found in the
//         CodeBook. If there is no substitution then return the character '*'
// Notes: The CodeBook has 29 entries: 26 lowercase letters and the 
//        three characters: comma: ',' blank: ' ' and period: '.'
// Test Cases:
// 1. tosub='o' flag="-e"  --- Return Value='i'
// 2. tosub=' ' flag="-d"  --- Return Value='n'
// 3. tosub=' ' flag="-e"  --- Return Value='b'
// 4. tosub='w' flag="-d"  --- Return Value='w'
// 5. tosub='c' flag="-e"  --- Return Value='q'
// 6. tosub='2' flag="-e"  --- Return Value='*'

char SubChar(char tosub, char flag[2], Cipher CB[29]){
  // put your answer here
	int8_t f= 	eORd(flag);
	uint32_t i=0;
	
	if(((tosub<'a')||(tosub>'z'))&&(tosub!=',')&&(tosub!=' ')&&(tosub!='.'))
		return '*';
	
	
	
	if(f==1){//encode
		for(i=0;i<29;i++){
			if(tosub==CB[i].code) 
				break;
			
			
		}
		return CB[i].encode;
		
	}
	if(f==-1){//encode
		for(i=0;i<29;i++){
			if(tosub==CB[i].encode) 
				break;
			
			
		}
		return CB[i].code;
		
	}
	
	
	
	
	
	return '*';
}


//******************StringSwap**************************
// Given a null-terminated string this subroutine
// swaps the first half of the characters with the
// the second half. If the input string is "abcd" then
// it is modified in place to "cdab"; If the input string
// is of an odd length then the middle character stays put:
// That is, "abcde" is modified to "decab"
// Input: instring is a null-terminated string
// Output: None. However instring is modified in place
// Note: There are no errors to check for. all acii characters 
//       are valid as a part of instring
// Testcases
// 1. instring="yes or no" --- modified-instring="r nooyes "
// 2. instring="i think i can" --- modified-instring=" i canki thin"
// 3. instring="hello hello", --- modified-instring="hello hello"
// 4. instring="Aced this Exam", --- modified-instring="is ExamAced th"
// 5. instring="The answer is 42", --- modified-instring="er is 42The answ"
void StringSwap(char *instring){
  // put your answer here
	uint32_t length=0,i,half=0,mod=0;
	char * incopy=instring;
	uint8_t temp=0;
	
	
	while(*incopy!=0){
		
		length++;
		incopy++;
	}
	mod =length%2;
	
	if(mod==1){
		half=(length)/2;
	
	for(i=0;i<half;i++){
		temp = *(instring +i);
		*(instring +i)= *(instring + half+1 +i);
		*(instring + half+1 +i)=temp;
	}
	
	
	return;
		
		
		
	}
	else{
	half=(length)/2;
	
	for(i=0;i<half;i++){
		temp = *(instring +i);
		*(instring +i)= *(instring + half +i);
		*(instring + half +i)=temp;
	}
	
	
	return;}
}

//******************Crypt**************************
// This subroutine is an extension of the SubChar routine
// Given a null-terminated string and to encrypt of decrypt
// it replaces each character in the string with its
// substitution by looking up the CodeBook. This substitution
// is done in place so the original string is modified.
// To add a little more obfuscation, the modified string is 
// transformed by calling the above StringSwap routine
// Inputs: instring: A null-terminated input string
//         flag: "-e"/"-d" to encrypt or decrypt
//         CB[29]: Is an array of Cipher structs each
//                 struct has a code/encode character pair
// Outputs: The returned value is 0 if the input string was valid
//          otherwise it is -1 (i.e., string has invalid characters)
//          The input string is modified with the appropriate substitutions
//            for each character in the string
//          If the string has invalid characters then do NOT modify the
//          input string. (see cases 6 and 7)
// Test Cases:
// 1. instring="yes or no" flag="-e" --- Return value=0 modified-instring="db iixo,b"
// 2. instring=",bjare uliboddb" flag="-d" 
//        --- Return value=0 modified-instring="to err is human"
// 3. instring="hello hello" flag="-e" 
//        --- Return value=0 modified-instring="jossibjossi"
// 4. instring="ebsilbikbka pblju,bqse,,bu," flag="-d" 
//        --- Return value=0 modified-instring="this class is a lot of fun."
// 5. instring="ee319k is hard" flag="-e" 
//        --- Return value=-1 modified-instring="ee319k is hard"
// 6. instring="This is Easy" flag="-e" 
//        --- Return value=-1 modified-instring="This is Easy"
int8_t Crypt(char *instring, char flag[2], Cipher *CB){
		uint32_t length=0,i=0;
	char * incopy=instring;
//	uint8_t temp=0;
	
	
	while(*incopy!=0){
		
		length++;
		incopy++;
	}
	
	
	
	
	for (i=0;i<length;i++){
		if((SubChar(*(instring+i),flag, CB))=='*')
			return -1;
	
	
	
	}
	for (i=0;i<length;i++){
		*(instring+i)=SubChar(*(instring+i),flag, CB);
			
	
	
	
	}
	StringSwap(instring);
	
	
	
	
	
	
	return 0;																			
}

