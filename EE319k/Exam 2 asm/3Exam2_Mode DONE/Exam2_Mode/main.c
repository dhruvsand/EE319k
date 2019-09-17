// main.c
// Runs on LM3S1968
// Grading engine for Exam2_Mode
// Do not modify any part of this file


// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"

unsigned char TestData1[100];
#define COUNT1 4
struct TestCase1{
  unsigned char buf[10]; 
  long Correct;   // proper result of Max()
  long Score;     // points to add if Max() correct
};
typedef const struct TestCase1 TestCase1Type;
TestCase1Type Tests1[COUNT1]={
{{1,2,3,4,5,6,7,8,9,10},           9,10},
{{1,2,100,12,13,14,15,16,17,18},   2,10},
{{200,2,3,10,100,12,13,14,15,16},  0,10},
{{0,2,200,8,100,12,201,14,15,199}, 6,10}};
struct TestCase2{
  char buf[30]; 
  long Correct;   // proper result of Mode()
  long Score;     // points to add if Mode() correct
};
typedef const struct TestCase2 TestCase2Type;
#define COUNT2 4
TestCase2Type Tests2[COUNT2]={
{{0,-1}, 0, 5},
{{0,1,2,1,2,1,1,2,2,1,2,2,1,1,-1 }, 1, 5},
{{6,7,7,7,6,9,8,8,7,7,7,7,4,3,7,7,9,7,7,7,-1 }, 7, 10},
{{2,3,4,7,6,9,9,8,7,7,9,7,4,3,7,7,9,7,7,9,9,9,9,9,9,-1}, 9, 10}};
//test code
void Clear(unsigned char *buffer);
unsigned long Max(const unsigned char *buffer);
unsigned long Mode(const char *buffer);
int main(void){ 
  unsigned long result,n,score;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART
  UART_OutCRLF();

  UART_OutString("Exam2_Mode\n\r");
  UART_OutString("Test of Clear\n\r");
  for(n = 0; n < 100; n++){
    TestData1[n] = n+2;
  }
  Clear(&TestData1[50]); // clears spots 50 to 59
  result = 1;
  for(n = 0; n < 49; n++){
    if(TestData1[n]!=(n+2)){
      if(result) UART_OutString("Clear wrote above buffer"); 
      result = 0;
    }
  }
  for(n = 50; n < 59; n++){
    if(TestData1[n]){
      if(result){
        UART_OutString("Data at index "); UART_OutUDec(n-50);
        UART_OutString(" is not clear");
      }
      result = 0;
    }
  }
  for(n = 60; n < 99; n++){
    if(TestData1[n]!=(n+2)){
      if(result) UART_OutString("Clear wrote below buffer"); 
      result = 0;
    }
  }
  if(result){
    score += 30;
    UART_OutString("Yes, Score = ");
  }else{
    UART_OutString(", Score = ");
  } 
  UART_OutUDec(score);  UART_OutCRLF();

  UART_OutString("Test of Max\n\r");
  for(n = 0; n < COUNT1 ; n++){
    result = Max(Tests1[n].buf);
    UART_OutString("Your="); UART_OutUDec(result);  
    if(result == Tests1[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests1[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("Test of Mode\n\r");
  for(n = 0; n < COUNT2 ; n++){
    result = Mode(Tests2[n].buf);
    UART_OutString("Your = "); UART_OutUDec(result);  
    if(result == Tests2[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests2[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("End of Exam2_Mode\n\r");
  while(1){
  }
}
