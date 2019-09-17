// main.c
// Runs on LM3S1968
// Grading engine for Exam2_Sum32
// Do not modify any part of this file
// This Exam2 never given 

// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"

#define COUNT1 3
struct TestCase1{
  long buf[20]; 
  long Correct;   // proper result of Size()
  long Score;     // points to add if Size() correct
};
typedef const struct TestCase1 TestCase1Type;
TestCase1Type Tests1[COUNT1]={
{{3,1,2,3},           3,10},
{{0xA0000000,1,0,0},  0xA0000000,10},
{{0},                 0,10}};

struct TestCase2{
  long buf[30]; 
  long data;
  long Correct;   // proper result of Count()
  long Score;     // points to add if Count() correct
};
typedef const struct TestCase2 TestCase2Type;
#define COUNT2 6
TestCase2Type Tests2[COUNT2]={
{{3,1,2,3,4},4,                               0,5},
{{5,12,13,4,12,3,12},12,                      2,5},
{{12,1,1,1,2,1,1,2,1,2,1,2,1,1,1},1,          8,5},
{{9,300,300,300,300,300,300,300,300,300,300},300, 9,5},
{{7,500000,10,500000,10,500000,0,0,500000},500000, 3,5},
{{0,0,0},0,                                   0,10}};

struct TestCase3{
  long buf[20]; 
  long Correct;   // proper result of Sum()
  long Score;     // points to add if Sum() correct
};
typedef const struct TestCase3 TestCase3Type;
#define COUNT3 6
TestCase3Type Tests3[COUNT3]={
{{3,1,2,3,5,6,0,0},                            6,5},
{{5,-12,-13,-4,-12,-3,6,7,0,0},                -44,5},
{{14,1,1,1,2,1,1,2,1,2,1,2,1,1,1,5,6,0,0},     18,5},
{{4,0xD0000000,0xC0000000,0xE0000000,0,5,6,0}, 0x7FFFFFFF, 5},
{{4,0x30000000,0x40000000,0x20000000,0},       0x7FFFFFFF,5},
{{0,4,5,0},                                    0,10}};


//test code
unsigned long Size(const  long *buffer);
unsigned long Count(const  long *buffer, long value);
long Sum(const  long *buffer);
int main(void){ long result2;
  unsigned long result,n,score;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART
  UART_OutCRLF();

  UART_OutString("Exam2_Sum\n\r");
  UART_OutString("Test of Size\n\r");
  for(n = 0; n < COUNT1 ; n++){
    result = Size(Tests1[n].buf);
    UART_OutString("Your="); UART_OutUDec(result);  
    if(result == Tests1[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests1[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }

  UART_OutString("Test of Count\n\r");
  for(n = 0; n < COUNT2 ; n++){
    result = Count(Tests2[n].buf,Tests2[n].data);
    UART_OutString("Your="); UART_OutUDec(result);  
    if(result == Tests2[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests2[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("Test of Sum\n\r");
  for(n = 0; n < COUNT3 ; n++){
    result2 = Sum(Tests3[n].buf);
    UART_OutString("Your = "); UART_OutSDec(result2);  
    if(result2 == Tests3[n].Correct){
      UART_OutString("  Yes, Score = ");
      score = score + Tests3[n].Score;
    }else{
      UART_OutString("  No, Score = ");
    }
    UART_OutUDec(score);  UART_OutCRLF();
  }
  UART_OutString("End of Exam2_Sum, Practice\n\r");
  while(1){
  }
}
