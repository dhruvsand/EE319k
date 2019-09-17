// main.c
// Runs on LM3S1968 using the simulator
// Grading engine for Exam2_StringCompare Practice Exam
// Do not modify any part of this file
// Exam2 given March 2013

// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"

#define COUNT1 5
struct TestCase1{
  unsigned char buf[30];       // input to Size()
  unsigned long Correct;   // proper result of Size()
  long Score;              // points to add if Size() correct
};
typedef const struct TestCase1 TestCase1Type;
TestCase1Type Tests1[COUNT1]={
{"cat",3,5},
{"Ramesh is great.",16,5},     
{"EE319K Exam2 was hard!",22,5},
{"My TA is nice,",14,5},
{"",0, 5}};


struct TestCase2{
  unsigned char first,second; 
  long Correct;   // proper result of Compare()
  long Score;     // points to add if Compare() correct
};
typedef const struct TestCase2 TestCase2Type;
#define COUNT2 5
TestCase2Type Tests2[COUNT2]={
{'a','b',1, 5},
{'a','B',-1, 5},
{'a','a', 0, 5},
{200,199 ,-1, 5},
{200,201 , 1, 5}};



struct TestCase3{
  unsigned char buf1[30];  // input to StringCompare()
  unsigned char buf2[30];  // input to StringCompare()
  long Correct;   // proper result of StringCompare()
  long Score;     // points to add if StringCompare() correct
};
typedef const struct TestCase3 TestCase3Type;
#define COUNT3 7
TestCase3Type Tests3[COUNT3]={
{"cat","dog",+1 ,5},  
{"cattle","cobra",+1 ,5},
{"hose","horse",-1,5},
{"cat","cattle",+1 ,10}, 
{"cattle","cat",-1,10},
{"horse","horse",0,10},
{"","",0,5}}; 




//prototypes to student code
unsigned long Size(const unsigned char *buffer);
unsigned char Compare(unsigned char first, unsigned char second);
long StringCompare(const unsigned char *buffer1,const unsigned char *buffer2);
int main(void){ long result2;
  unsigned long result,n,score;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART

  UART_OutString("\n\rExam2_StringCompare\n\r");
  UART_OutString("Test of Size\n\r");
  for(n = 0; n < COUNT1 ; n++){
    result = Size(Tests1[n].buf);
    if(result == Tests1[n].Correct){
      UART_OutString(" Yes, Your= "); 
      score = score + Tests1[n].Score;
    }else{
      UART_OutString(" No, Correct= ");
      UART_OutUDec(Tests1[n].Correct);  
      UART_OutString(", Your= "); 
    }
    UART_OutUDec(result);  
    UART_OutString(", Score = "); UART_OutUDec(score);  UART_OutCRLF();
  }

  UART_OutString("Test of Compare\n\r");
  for(n = 0; n < COUNT2 ; n++){
    result2 = Compare(Tests2[n].first,Tests2[n].second);
    if(result2 == Tests2[n].Correct){
      UART_OutString(" Yes, Your= "); 
      score = score + Tests2[n].Score;
    }else{
      UART_OutString(" No, Correct= ");
      UART_OutSDec(Tests2[n].Correct);  
      UART_OutString(", Your= "); 
    }
    UART_OutSDec(result2);  
    UART_OutString(", Score = "); UART_OutUDec(score);  UART_OutCRLF();
  }
  
  UART_OutString("Test of StringCompare\n\r");
  for(n = 0; n < COUNT3 ; n++){
    result2 = StringCompare(Tests3[n].buf1,Tests3[n].buf2);
    if(result2 == Tests3[n].Correct){
      UART_OutString(" Yes, Your= "); 
      score = score + Tests3[n].Score;
    }else{
      UART_OutString(" No, Correct= ");
      UART_OutSDec(Tests3[n].Correct);  
      UART_OutString(", Your= "); 
    }
    UART_OutSDec(result2);  
    UART_OutString(", Score = "); UART_OutUDec(score);  UART_OutCRLF();

  }
  

  UART_OutString("End of Exam2_StringCompare\n\r");
  while(1){
  }
}
