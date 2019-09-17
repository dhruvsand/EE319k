// main.c
// Runs on LM3S1968
// Grading engine for Exam2_Moore
// Do not modify any part of this file


// U0Rx (VCP receive) connected to PA0
// U0Tx (VCP transmit) connected to PA1

#include "PLL.h"
#include "UART.h"
#define GPIO_PORTV_DATA_R       (*((volatile unsigned long *)0x40007404))
#define GPIO_PORTV_DIR_R        (*((volatile unsigned long *)0x40007400))

#define IN  8    // PV3
#define IN2 2    // PV1
#define OUT 16   // PV6,5,4
#define COUNT1 13
struct TestCase1{
  unsigned long input;
  unsigned long extraInput;
  unsigned long correctOutput;
  long points;     // points to add if correct
};
typedef const struct TestCase1 TestCase1Type;
TestCase1Type Tests1[COUNT1]={
{0*IN+1*IN2+0,0x00,2*OUT,2},      //first one, output not checked
{1*IN+1*IN2+0,0x00,2*OUT,2},    
{1*IN+0*IN2+0,0x00,2*OUT,2},      //should be in Go
{1*IN+1*IN2+0,0x00,2*OUT,2},    
{0*IN+0*IN2+0,0x00,3*OUT,2},    
{1*IN+0*IN2+0,0x00,3*OUT,2},      //should be in Danger
{0*IN+1*IN2+0,0x00,3*OUT,3},      //should be in Go
{0*IN+1*IN2+0,0x01,4*OUT+0x01,4}, //should be in Danger
{1*IN+1*IN2+0,0x05,3*OUT+0x05,4},    
{0*IN+0*IN2+0,0x81,4*OUT+0x81,4}, //should be in Stop
{0*IN+0*IN2+0,0x80,4*OUT+0x80,5}, //should be in Go
{1*IN+0*IN2+0,0x84,2*OUT+0x84,5}, //should be in Danger
{1*IN+1*IN2+0,0x85,3*OUT+0x85,5}};   

  
unsigned long i;
//test code
void YourFSMInit(void);
void YourFSMOutput(unsigned long data);
unsigned long YourFSMInput(void);
void YourFSMController(void);

unsigned long score;
int main(void){ 
  unsigned long result,n; int friendly,correct;
  score = 0;
  PLL_Init();

  UART_Init();              // initialize UART
  UART_OutCRLF();

  UART_OutString("Exam2_Moore\n\r");
  UART_OutString("Test of YourFSMInit\n\r");
  GPIO_PORTV_DIR_R = 0;
  YourFSMInit();
  if((GPIO_PORTV_DIR_R&0x7A)==0x70){
    UART_OutString("Your bits set correctly\n\r");
    score += 5;
  }else{
    UART_OutString("You did not make PV6-4 out, PV3,PV1 in\n\r");
  }  
  if((GPIO_PORTV_DIR_R&0x85)==0x00){
    score += 5;
  }else{
    UART_OutString("You inappropriately set direction bits 7, 2, or 0\n\r");
  }
  GPIO_PORTV_DIR_R = 0xFF;
  YourFSMInit();
  if((GPIO_PORTV_DIR_R&0x7A)==0x70){
    score += 5;
  }
  if((GPIO_PORTV_DIR_R&0x85)==0x85){
    score += 5;
  }else{
    UART_OutString("You inappropriately cleared direction bits 7, 2, or 0\n\r");
  }
  UART_OutString("Score = "); UART_OutUDec(score);  UART_OutCRLF();
 
  UART_OutString("Test of YourFSMOutput\n\r");
  correct = 1; friendly = 1;
  for(n=0;n<8;n++){
    GPIO_PORTV_DATA_R = 0; // other bits zero
    YourFSMOutput(n);      // call your function
    if((GPIO_PORTV_DATA_R&0x70)!=(n<<4)){
      UART_OutString("You did not properly output ");
      UART_OutUDec(n);  
      UART_OutString(" to PV6-4\n\r");
      correct = 0; 
    }
    if((GPIO_PORTV_DATA_R&0x8F)!=0){
      friendly = 0; 
    }
    GPIO_PORTV_DATA_R = 0xFF; // other bits one
    YourFSMOutput(n);      // call your function
    if((GPIO_PORTV_DATA_R&0x8F)!=0x8F){
      friendly = 0; 
    }
  }  
  if(correct){
    score +=10;
  }
  if(friendly&&correct){
    score += 10;
  } 
  if(!friendly){
    UART_OutString("YourFSMOutput not friendly\n\r");
  }
  UART_OutString("Score = "); UART_OutUDec(score);  UART_OutCRLF();

    UART_OutString("Test of YourFSMInput\n\r");
  correct = 1; friendly = 1;
  for(n=0;n<4;n++){
    GPIO_PORTV_DATA_R = 0; // other bits zero
    if(n&1)GPIO_PORTV_DATA_R |= 0x02; // PV1
    if(n&2)GPIO_PORTV_DATA_R |= 0x08; // PV3
    result = YourFSMInput();      // call your function
    if(result != n){
      UART_OutString("You did not properly input ");
      UART_OutUDec(n);  
      UART_OutString(" from PV3,PV1\n\r");
      correct = 0; 
    }
    GPIO_PORTV_DATA_R = 0x85; // other bits one
    if(n&1)GPIO_PORTV_DATA_R |= 0x02; // PV1
    if(n&2)GPIO_PORTV_DATA_R |= 0x08; // PV3
    result = YourFSMInput();      // call your function
    if(result != n){
      UART_OutString("You did not properly input ");
      UART_OutUDec(n);  
      UART_OutString(" from PV3,PV1\n\r");
      correct = 0; 
    }
  }  
  if(correct){
    score +=20;
  }
  UART_OutString("Score = "); UART_OutUDec(score);  UART_OutCRLF();

  UART_OutString("Start of YourFSMController\n\r");
  i = 0;
  YourFSMController();  // never returns
  while(1){
  }
}
void MyGrader(void){unsigned long state,in;
//   UART_OutString("Should be in state ");
    state = (Tests1[i].correctOutput&0x70)>>4;
//   switch(state){
//     case 2: UART_OutString("Stop  "); break;
//     case 3: UART_OutString("Go    "); break;
//     case 4: UART_OutString("Danger"); break;
//     default: UART_OutString("Valvano has a Bug"); break;
//   }
  if(i>0){
    if((GPIO_PORTV_DATA_R&0x70)==(Tests1[i].correctOutput&0x70)){
        score += Tests1[i].points;
        UART_OutString("correct; ");
    }else{
      UART_OutString("Your out = "); UART_OutUDec((GPIO_PORTV_DATA_R&0x70)>>4);  
      UART_OutString(", expecting = "); UART_OutUDec(state);  
      UART_OutString("; ");
    }
  }
  switch (Tests1[i].input){
    case 0: in = 0; break;
    case 2: in = 1; break;
    case 8: in = 2; break;
    case 0x0A: in = 3; break;
    default: UART_OutString("Valvano has a Bug; "); in=0; break;
  }    
  if(i>=(COUNT1-1)){
    UART_OutString("\n\rScore = "); UART_OutUDec(score);  
    UART_OutString("; End of Exam2_Moore\n\r");
    while(1){
    }
  }    
  GPIO_PORTV_DATA_R = Tests1[i].input+Tests1[i].extraInput;
  UART_OutString("Next input will be "); UART_OutUDec(in);  
  UART_OutString("; Score = "); UART_OutUDec(score);  
  UART_OutCRLF();
  i = i+1;
}
