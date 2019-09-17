// main.c
// Runs on LM3S1968 using the simulator
// Grading engine for Exam2_Calculus Spring 2013
// Do not modify any part of this file
// Exam2 given March 2013

// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"

#define COUNT1 4
struct TestCase1{
  short buf[20];           // input to Size()
  unsigned long Correct;   // proper result of Size()
  long Score;              // points to add if Size() correct
};
typedef const struct TestCase1 TestCase1Type;
TestCase1Type Tests1[COUNT1]={
{{35,144,25,34,-32768,0,0},                  4,5},
{{9,13,-4,-5,100,-2000,7000,-32768,0,0},     7,5},
{{0,128,0,128,128,-32768,0,0},               5,10},
{{-32768,0,0},                               0,10}};

struct TestCase2{
  short first,second; 
  long Correct;   // proper result of Derivative()
  long Score;     // points to add if Derivative() correct
};
typedef const struct TestCase2 TestCase2Type;
#define COUNT2 4
TestCase2Type Tests2[COUNT2]={
{10,-10,                                 -200,5},
{-10,10,                                  200,5},
{32767,-32767,                        -655340,5},
{-20000,-10000,                        100000,5}};


struct TestCase3{
  short buf[20];  // input to Integration()
  long Correct;   // proper result of Integration()
  long Score;     // points to add if Integration() correct
};
typedef const struct TestCase3 TestCase3Type;
#define COUNT3 5
TestCase3Type Tests3[COUNT3]={
{{35,144,25,36,-32768,0,0},                 24,5},
{{9,13,-4,-5,100,-2000,7000,-32768,0,0},   511,5},
{{20000,25000,25000,30000,20000,25000,25000,30000,20000,25000,25000,30000,20000,25000,25000,30000,-32768,0,0},   40000,5},
{{-20000,-25000,-25000,-30000,-20000,-25000,-25000,-30000,-20000,-25000,-25000,-30000,-20000,-25000,-25000,-30000,-32768,0,0},  -40000,5},
{{-32768,0,0},                               0, 5}};

struct TestCase4{
  short buf[20];  // input to MaxDerivative()
  long Correct;   // proper result of MaxDerivative()
  long Score;     // points to add if MaxDerivative() correct
};
typedef const struct TestCase4 TestCase4Type;
#define COUNT4 6
TestCase4Type Tests4[COUNT4]={
{{35,144,25,36,-32768,0,0},               1090,5},
{{9,13,-4,-5,100,-2000,7000,-32768,0,0}, 90000,2},
{{4,2,0,-4,-5,-9,-12,-32768,0,0},          -10,5},
{{10,0,-32768,0,0},                       -100,3},
{{10,-32768,0,0},                   0x80000000,5},
{{-32768,0,0},                      0x80000000,5}};

struct TestCase5{
  unsigned long n1,n2,n3,n4,n5,n6; 
  unsigned long Correct;   // proper result of Ave6()
  long Score;     // points to add if Ave6() correct
};
typedef const struct TestCase5 TestCase5Type;
#define COUNT5 5
TestCase5Type Tests5[COUNT5]={
{1,2,3,5,6,7,                               4,1},
{0x80000000,0,0,0x80000000,0,0,    0xFFFFFFFF,1},
{0x90000000,0,0xE0000000,0,0,0,    0xFFFFFFFF,1},
{0xC0000000,0,0,0,0xF0000000,0,    0xFFFFFFFF,1},
{0xA0000000,1,0xB0000000,0,0,0,    0xFFFFFFFF,1}};

//prototypes to student code
unsigned long Size(const short *buffer);
long Derivative(short first, short second);
long Integration(const short *buffer);
long MaxDerivative(const short *buffer);
unsigned long Ave6(unsigned long n1,unsigned long n2,unsigned long n3,unsigned long n4,unsigned long n5,unsigned long n6);
int main(void){ long result2;
  unsigned long result,n,score;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART

  UART_OutString("\n\rExam2_Calculus\n\r");
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

  UART_OutString("Test of Derivative\n\r");
  for(n = 0; n < COUNT2 ; n++){
    result2 = Derivative(Tests2[n].first,Tests2[n].second);
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
  
  UART_OutString("Test of Integration\n\r");
  for(n = 0; n < COUNT3 ; n++){
    result2 = Integration(Tests3[n].buf);
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
  
  UART_OutString("Test of MaxDerivative\n\r");
  for(n = 0; n < COUNT4 ; n++){
    result2 = MaxDerivative(Tests4[n].buf);
    if(result2 == Tests4[n].Correct){
      UART_OutString(" Yes, Your= "); 
      score = score + Tests4[n].Score;
    }else{
      UART_OutString(" No, Correct= ");
      if(Tests4[n].Correct==0x80000000){
        UART_OutString("0x80000000"); 
      } else{
        UART_OutSDec(Tests4[n].Correct);
      }      
      UART_OutString(", Your= "); 
    }
    if(result2==0x80000000){
      UART_OutString("0x80000000"); 
    } else{
      UART_OutSDec(result2);
    }      
    UART_OutString(", Score = "); UART_OutUDec(score);  UART_OutCRLF();

  }
  
  UART_OutString("Test of Ave6 (extra credit)\n\r");
  for(n = 0; n < COUNT5 ; n++){
    result = Ave6(Tests5[n].n1,Tests5[n].n2,Tests5[n].n3,Tests5[n].n4,Tests5[n].n5,Tests5[n].n6);
    if(result == Tests5[n].Correct){
      UART_OutString(" Yes, Your= "); 
      score = score + Tests5[n].Score;
    }else{
      UART_OutString(" No, Correct= ");
      if(Tests5[n].Correct==0xFFFFFFFF){
        UART_OutString("0xFFFFFFFF");  
      } else{
        UART_OutUDec(Tests5[n].Correct);
      }      
      UART_OutString(", Your= "); 
    }
    if(result==0xFFFFFFFF){
      UART_OutString("0xFFFFFFFF"); 
    } else{
      UART_OutUDec(result);
    }      
    UART_OutString(", Score = "); UART_OutUDec(score);  UART_OutCRLF();

  }
  UART_OutString("End of Exam2_Calculus, Spring 2013\n\r");
  while(1){
  }
}
