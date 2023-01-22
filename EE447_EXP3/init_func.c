#include  "TM4C123GH6PM.h"
void init_func(void){
	SYSCTL->RCGCGPIO |= 0x02; // Turn on bus clock for GPIOB
  GPIOB->DIR       |= 0x0F; // Set Pb0-Pb3
  GPIOB->DEN       |= 0x0F;  // Enable PF3 pin as a digital pin
	SysTick->LOAD = 15999; // one msecond delay relaod value note 15999999=1sec
	SysTick->CTRL = 7 ; // enable counter, interrupt and select system bus clock 
	SysTick->VAL  = 0; //initialize current value register
}