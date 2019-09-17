/*
; Program written by: Dhruv Sandesara djs3967
; Date Created: 
; Last Modified:  
; Brief description of the program: Lab0 in C
; The objective of this system is to implement a Car door signal system
; Hardware connections: Inputs are negative logic; output is positive logic
;  PF0 is right-door input sensor (1 means door is open, 0 means door is closed)
;  PF4 is left-door input sensor (1 means door is open, 0 means door is closed)
;  PF3 is Safe (Green) LED signal - ON when both doors are closed, otherwise OFF
;  PF1 is Unsafe (Red) LED signal - ON when either (or both) doors are open, otherwise OFF
; The specific operation of this system 
;   Turn Unsafe LED signal ON if any or both doors are open, otherwise turn the Safe LED signal ON
;   Only one of the two LEDs must be ON at any time.
; NOTE: Do not use any conditional branches in your solution. 
;       We want you to think of the solution in terms of logical and shift operations
*/
/* Pre-processor directives section */
#include <stdint.h>        // C99 standard 
#include "tm4c123gh6pm.h"  // I/O port device register address
#define Doors  0x11        // PortF pins 4 and 0
#define LEDs   0x0A        // PortF pins 3 and 1

int main(){
  // Declare variables here - All variables must be declared before use
  
  // Initialize port F
  SYSCTL_RCGCGPIO_R |= 0x20; //Turn Clock ON for port F
  volatile int dhruv=442;  //Wait for clock to stabilize
  GPIO_PORTF_LOCK_R = 0x4C4F434B;   // unlock GPIO Port F
  GPIO_PORTF_CR_R = 0x1F;           // allow changes to PF0
  GPIO_PORTF_DIR_R |= LEDs;  // LEDs are outputs so write 1's to DIR
  GPIO_PORTF_DIR_R &=~Doors;  // Doors are inputs so write 0's to DIR
  GPIO_PORTF_AFSEL_R &=~(LEDs+Doors) ; // Turn alternate function OFF for all input and output pins
  GPIO_PORTF_PUR_R |=Doors; // Engage Pull up for negative logic input switches
  GPIO_PORTF_DEN_R |=(LEDs+Doors);  // Digital enable all input and output pins

  //Logic for lab - execute indefinitely
  while (1){
		int left,right,red,green;
  left=(GPIO_PORTF_DATA_R&0x10)>>4;  // Read input from GPIO_PORTF_DATA_R
  right=(GPIO_PORTF_DATA_R&0x1);   // isolate Door states left and right
  red=(left|right);  // arrive at Red light's state based on Doors
  green=(~red)<<3; // Green is complement of Red
  GPIO_PORTF_DATA_R=(red<<1)|green;  // Write output to GPIO_PORTF_DATA_R

  }
}
