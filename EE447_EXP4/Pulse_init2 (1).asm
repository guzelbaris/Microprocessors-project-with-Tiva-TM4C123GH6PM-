/*Pulse_init.h file
Function for creating a pulse train using interrupts
Uses Channel 0, and a 1Mhz Timer clock (_TAPR = 15)
Uses Timer0A to create pulse train on PF2
*/

#include "TM4C123GH6PM.h"
#include <stdio.h>
#define LOW 	0X09
#define HIGH 	0x27
#define OUT (*((volatile unsigned long *)(GPIOB_BASE + 0x010UL)))
void pulse_init(void);
void TIMER0A_Handler (void);
void TIMER3A_Handler (void);
volatile double period;      // Global variables that used in ISR should be volatile
volatile double width;				// Global variables that used in ISR should be volatile
volatile double dc;		
uint32_t rising_current_value = 0;
uint32_t old_rising_value  = 0;
uint32_t falling_current_value = 0;


void pulse_init(void){
	volatile int *NVIC_EN0 = (volatile int*) 0xE000E100;
	volatile int *NVIC_EN1 = (volatile int*) 0xE000E104;
	volatile int *NVIC_PRI4 = (volatile int*) 0xE000E410;
	volatile int *NVIC_PRI8 = (volatile int*) 0xE000E420;

	SYSCTL->RCGCGPIO |= 0x22; // turn on bus clock for GPIOF
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
// PORT B AND F INITIALIZATION
  GPIOF->DIR			|= 0x04;          // set PF2 as output
	GPIOB->DIR			&= ~(1 << 2);     // set PB2 as input
  GPIOF->AFSEL		&= (0xFFFFFFFB);  // Regular port function
	GPIOB->AFSEL		|= 0x04;          // use PB2 alternate function
	GPIOF->PCTL			&= 0xFFFFF0FF;    // No alternate function
	GPIOB->PCTL			&= ~(1 << 2);     // clear out bit-field for pin 2
	GPIOB->PCTL			|= 0x700;         // set bit-field 7 for pin 2 using T3CCP0
	GPIOF->AMSEL		 = 0;             // Disable analog
	GPIOB->AMSEL		 = 0;             // Disable analog
	GPIOF->DEN			|=0x04;           // Enable port digital
	GPIOB->DEN			|=0x04;           // Enable port digital
// TIMER0 AND TIMER3 INITIALIZATION
	SYSCTL->RCGCTIMER	|=0x09;         // Start timer0 AND timer3
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	TIMER0->CTL			&=0xFFFFFFFE;     // Disable timer during setup
	TIMER3->CTL			&=0xFFFFFFFE;     // Disable timer during setup
	TIMER0->CFG			 =0x04;           // Set 16 bit mode
	TIMER3->CFG			 =0x04;           // Set 16 bit mode
	TIMER0->TAMR		 =0x02;           // Set to periodic, count down
	TIMER3->TAMR		|=0x03;           // Capture mode enabled
	TIMER3->TAMR		|=(1<<2)|(1<<4);  // Edge Time mode and counts up enabled
	TIMER0->TAILR		 =LOW-1;          // Set interval load as LOW. This is 16-bit, max of 1-65535. 
	TIMER0->TAPR		 =15;             // Divide the clock by 16 to get 1us. 8-bit Prescaler can reduce the frequency (16MHz) by 1-255.
	TIMER3->TAPR		 =15;             // Divide the clock by 16 to get 1us. 8-bit Prescaler can reduce the frequency (16MHz) by 1-255.
	TIMER0->IMR			 =0x01; 					// Enable timeout interrupt	
  TIMER3->IMR			 =0x4;            // Enable capture mode event interrupt
	TIMER3->CTL			|=0x0C;           // Enable capture rising and falling edges interrupts
	
// Timer0A is interrupt 19
// Interrupt 16-19 are handled by NVIC register PRI4
// Interrupt 19 is controlled by bits 31:29 of PRI4
	*NVIC_PRI4 &=0x00FFFFFF;         // Clear interrupt 19 priority
	*NVIC_PRI4 |=0x40000000;         // Set interrupt 19 priority to 2
// Interrupt 35 is controlled by bits 31:29 of PRI8
	*NVIC_PRI8 &=0xFFFFFF;          //Clear interrupt 35 priority
	*NVIC_PRI8 |=0x60000000;        //Set interrupt 35 priority to 3
// NVIC has to be neabled
// Interrupts 0-31 are handled by NVIC register EN0
// Interrupt 19 is controlled by bit 19
// Interrupt 35 is controlled by bit 35
	*NVIC_EN0 |=0x00080000;
	*NVIC_EN1 |=0x00000008;
	
//Enabling TIMER0 and TIME3
	TIMER0->CTL			 |=0x03; // bit0 to enable and bit 1 to stall on debug
	TIMER3->CTL			 |=0x03; // bit0 to enable and bit 1 to stall on debug

	return;
}

void TIMER0A_Handler (void){

	if(TIMER0->TAILR == LOW){
		TIMER0->TAILR = HIGH;
		GPIOF->DATA  ^= 4;  //toggle PF3 pin
	}
	//TIMER0->ICR |=0x01; //Clear the interrupt
	
	else {
	TIMER0->TAILR = LOW;
		GPIOF->DATA  ^= 4;  //toggle PF3 pin
	}
		
	TIMER0->ICR |= 0x01;
		
}
void TIMER3A_Handler (void){
	if(OUT & 0x04) // Check value at the PB2
	{
		rising_current_value = TIMER3->TAR; 
		while (rising_current_value > old_rising_value){
		period = ((rising_current_value - old_rising_value) & 0x00FFFFFF )* 0.0625; 
	}
		
	}
	else //falling edge
	{	
		falling_current_value = TIMER3->TAR;     
		if (falling_current_value > old_rising_value){
		width = ((falling_current_value - old_rising_value) & 0x00FFFFFF )* 0.0625; 
		}
	}
	
	old_rising_value = rising_current_value;
	TIMER3->ICR |=0x04; //Clear the interrupt
}


