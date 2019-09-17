// main.c
// Runs on LM3S1968
// Grading engine for Exam2_Quad
// Do not modify any part of this file


// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"

#define COUNT1 16
struct TestCase1{
  unsigned long base;
  unsigned long power;
  long Correct;   // proper result of Pow4()
  long Score;     // points to add if Pow4() correct
};
typedef const struct TestCase1 TestCase1Type;
TestCase1Type Tests1[COUNT1]={
  {1, 0,   1, 2},
  {1, 1,   4, 2},
  {1, 2,  16, 2},
  {1, 3,  64, 2},
  {2, 0,   2, 3},
  {2, 1,   8, 3},
  {2, 2,  32, 3},
  {2, 3, 128, 3},
  {3, 0,   3, 3},
  {3, 1,  12, 3},
  {3, 2,  48, 3},
  {3, 3, 192, 3},
  {0, 0,   0, 3},
  {0, 1,   0, 3},
  {0, 2,   0, 3},
  {0, 3,   0, 3}};
struct TestCase2{
  unsigned char buf[4]; 
  long Correct;   // proper result of QuadDec()
  long Score;     // points to add if QuadDec() correct
};
typedef const struct TestCase2 TestCase2Type;
#define COUNT2 6

TestCase2Type Tests2[COUNT2]={
  {{0,1,2,3},27,9},
  {{0,0,0,3},3,9},
  {{1,1,1,1},85,9},
  {{3,3,3,3},255,9},
  {{3,3,0,0},240,10}, 
  {{0,0,0,0},0,10}}; 
//test code
unsigned long QuadDec(const unsigned char *buffer);
unsigned long Pow4(unsigned long base, unsigned long power);
int main(void){ 
  unsigned long result,n,score;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART
  UART_OutCRLF();

  UART_OutString("Exam2_Quad\n\r");
  UART_OutString("Test of Pow4\n\r");
  for(n = 0; n < COUNT1 ; n++){
    result = Pow4(Tests1[n].base,Tests1[n].power);
    UART_OutString("Your="); UART_OutUDec(result);  
    if(result == Tests1[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests1[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("Test of QuadDec\n\r");
  for(n = 0; n < COUNT2 ; n++){
    result = QuadDec(Tests2[n].buf);
    UART_OutString("Your = "); UART_OutUDec(result);  
    if(result == Tests2[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests2[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("End of Exam2_Quad\n\r");
  while(1){



  }
}
