/* Documenetation section
  Runs on LM4F120 and TM4C123
  Compute the Dot-product of two vectors in N dimensions
*/
/* Pre-processor directive section*/
#include <stdint.h>
#include "UART.h"  //We will call routines in UART to write out to console
#define N 5

/* Global Variables  - Declare and initialize two Vectors */
int8_t VectorA[N] = {-1,2,3,-2,4}; 
int8_t VectorB[N] = {2,-4,2,-3,-1};
int8_t product=0,count=4;

int main(){
  
  UART_Init(); // Initialize UART to serve as console for output
  
  UART_OutString("Cross Product is: ");
	
  while (count>-1){
		product+=(VectorA[count]*VectorB[count]);
		count--;
	}
		
	
 UART_OutSDec(product); //Call appropraite UART routine to display the DotProduct on console
  
  UART_OutCRLF(); // Newline
  while(1){} // Run indefinitely so UART output can be seen
}
