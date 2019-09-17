/* main.c for Homework 6
Dhruv Sandesara djs3967
;
;
;
;
;
;
;
;
;
;
;
;
;
;
; 32-bit entry in the Time Buffer
Brief description of the program The LED toggles at 8
Hz and a varying duty-cycle Repeat the functionality
from Lab2-3 but now we want you to insert debugging
instruments which gather data (state and timing) to
verify that the system is functioning as expected.
Hardware connections (External: One button and one
LED) PE1 is Button input (1 means pressed, 0 means
not pressed) PE0 is LED output (1 activates external
LED on protoboard) PF2 is Blue LED on Launchpad used
as a heartbeat
Instrumentation data to be gathered is as
follows: After Button(PE1) press collect one state
and time entry. After Buttin(PE1) release, collect 7
state and time entries on each change in state of the
LED(PE0): An entry is one 8-bit entry in the Data
Buffer and one
The Data Buffer entry (byte) content has: Lower
nibble is state of LED (PE0) Higher nibble is state
of Button (PE1)
;
;
;
; The Time Buffer entry (32-bit) has:
; ; ; ; ; ; */

// ***** 1. Pre-processor Directives Section *****
#include <stdint.h>
#include "tm4c123gh6pm.h"
// ***** 2. Global Declarations Section *****
// FUNCTION PROTOTYPES: Each subroutine defined void
void DisableInterrupts(void); // Disable interrupts void
void EnableInterrupts(void); // Enable interrupts void
void TExaS_Init(void); // ***** 3. Subroutines Section
 void Ports_Init(void) {
volatile unsigned long delay; SYSCTL_RCGC2_R =
0x30; delay = SYSCTL_RCGC2_R;
//Init PortE GPIO_PORTE_DIR_R &= 0xFD;
GPIO_PORTE_DIR_R |=0x1; GPIO_PORTE_AFSEL_R &= 0xFC;
GPIO_PORTE_DEN_R |= 0x3;
//Init PortF GPIO_PORTF_DIR_R &= 0xFD;
GPIO_PORTF_DIR_R |=0x4; GPIO_PORTF_AFSEL_R &= 0xFB;
GPIO_PORTF_DEN_R |= 0x4; GPIO_PORTF_PUR_R &= 0xFB;
}
// Initialize SysTick with busy wait running at bus
 void SysTick_Init(void)
{
NVIC_ST_CTRL_R = 0;
NVIC_ST_RELOAD_R = 0x00FFFFFF; NVIC_ST_CURRENT_R = 0;
NVIC_ST_CTRL_R = 0x00000005;
}
uint32_t Delaytime = 116548;
// Delay for the count units (ms)
void Delay(uint8_t count)
{
uint8_t i;
for(i = count; i > 0; i--)
{
Delaytime = 116548;
while (Delaytime > 0)
{
Delaytime--;
}
} }
// -UUU- Declare your debug dump arrays and indexes
// arrays here uint8_t
uint32_t DataBuffer[50]; uint32_t TimeBuffer[50];
void DebugInit(void)
{ uint32_t p;
for (p = 0; p < 50; p++)
{ TimeBuffer[p] = 0xFFFFFFFF;
DataBuffer[p] = 0xFF;
}
}
void ToggleLEDOn(void)
{
GPIO_PORTF_DATA_R |= 0x4;
GPIO_PORTE_DATA_R |= 0x1;
}
void ToggleLEDOff(void)
{ GPIO_PORTF_DATA_R &= ~(0x4);
GPIO_PORTE_DATA_R &= ~(0x1); }
uint32_t intree = 0;
void Debug_Capture(void)
{
if(intree == 50)
{ return;
} else {
DataBuffer[intree] = ((GPIO_PORTE_DATA_R & 0x1)) |
((GPIO_PORTE_DATA_R & 0x2)<<3);
intree++; }
}
uint8_t onTrack = 1;
uint8_t Pushtrack = 0;
uint8_t offTrack = 4;
uint8_t onCapture = 0;
uint8_t offCapture = 0;
uint8_t onAllow = 1;
int main(void)
{ TExaS_Init(); Ports_Init(); // initialize ports
SysTick_Init(); // initialize SysTick
EnableInterrupts(); //Enable interrupts
DebugInit();
while(1)
{ if ((GPIO_PORTE_DATA_R & 0x2)==2)
{
Pushtrack = 1;
if (onAllow == 1)
{
onCapture = 1;
onAllow--;
} }
else if(Pushtrack == 1)
{ onAllow++;
onTrack++;
offTrack--;
offCapture = 7;
Pushtrack = 0;
if (onTrack == 6)
TimeBuffer[intree] = NVIC_ST_CURRENT_R;
}
{ onTrack = 0;
offTrack = 5;
}
if(onTrack > 0)
{
ToggleLEDOn();
}
if(onCapture == 1)
{
onCapture = 0;
Debug_Capture();
}
if (offCapture > 0)
{
Debug_Capture();
offCapture--;
}
Delay(onTrack);
if (offTrack > 0)
{
ToggleLEDOff();
}
if (offCapture > 0)
{
Debug_Capture();
offCapture--;
}
Delay(offTrack);
}
}
