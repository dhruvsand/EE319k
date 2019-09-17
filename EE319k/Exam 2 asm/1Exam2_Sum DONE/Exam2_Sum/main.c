// main.c
// Runs on LM3S1968
// Grading engine
// Do not modify any part of this file


// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"

#define COUNT 8
struct TestCase{
signed char Buffer[12];    // input buffer 
long CorrectSize;   // proper result of Size()
long SizeScore;     // points to add if Size() correct
long CorrectSum;    // proper result of Sum()
long SumScore;      // points to add if Sum() correct
};
typedef const struct TestCase TestCaseType;
#define MAX 0x7FFFFFFF
TestCaseType Tests[COUNT]={
{ {1,2,3,0,2,3}, 3, 4, 6, 4},
{ {1,2,3,4,5,6,7,8,0,2}, 8, 4, 36, 4},
{ {100,120,100,0,1}, 3, 8, 320, 8},
{ {100,100,100,100,100,0,2}, 5, 8, 500, 8},
{ {0,1,2,3,0}, 0, 7, 0, 7},
{ {1,2,-3,0,4,5}, 3, 6, MAX, 6},
{ {1,-2,3,4,5,6,0}, 6, 6, MAX, 6},
{ {0,1,3,4}, 0, 7, 0, 7}};

//test code
long Size(const signed char *buffer);
long Sum(const signed char *buffer);
int main(void){ 
  unsigned long result,n,score;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART
  UART_OutCRLF();


  UART_OutString("Test of Size\n\r");
  for(n = 0; n < COUNT ; n++){
    result =   Size(Tests[n].Buffer);
    UART_OutString("Your="); UART_OutUDec(result);  
    if(result == Tests[n].CorrectSize){
      UART_OutString("  Yes, Score = ");
      score = score + Tests[n].SizeScore;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("Test of Sum\n\r");
  for(n = 0; n < COUNT ; n++){
    result =   Sum(Tests[n].Buffer);
    UART_OutString("Your = "); UART_OutUDec(result);  
    if(result == Tests[n].CorrectSum){
      UART_OutString("  Yes, Score = ");
      score = score + Tests[n].SumScore;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("End of Exam2\n\r");
  while(1){



  }
}
