#include "TM4C123GH6PM.h"
#include <stdio.h>

void init_func(void) {
	  // Enable clock for GPIO Port E
     SYSCTL->RCGCGPIO |= 0x10;
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	
	SYSCTL->RCGCGPIO |= 0x20; 		// turn on bus clock for GPIOF 
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
  GPIOF->DIR       |= 0x02; 						// set RED pin as a digital output pin 
  GPIOF->DEN       |= 0x02;
	
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");

	
		// Enable ADC0 clock
     SYSCTL->RCGCADC |= 0x1;

	
	while(SYSCTL->PRADC != 0x1){
			__ASM("NOP");
	}

	
  // Configure PE3 as input for ADC
  GPIOE->AFSEL |= (1 << 3);
  GPIOE->DIR &= ~(1 << 3);
  GPIOE->AMSEL &= (1 << 3);
	GPIOE->DEN	&= 0xF7;


  // Disable sequencer 3
  ADC0->ACTSS &= ~(1 << 3);

  // Configure software triggering for sequencer
  ADC0->EMUX &= 0x0FFF;

  // Select AIN0 for the first sample
  ADC0->SSMUX3 &= 0x0;

  // Enable interrupts and set sequencer to stop after one sample
  ADC0->SSCTL3 |= 0x4;

  // Configure sample rate to 125 ksps
  ADC0->PC |=0x7;

  // Enable the ATD system
  ADC0->ACTSS |= (1 << 3);
}