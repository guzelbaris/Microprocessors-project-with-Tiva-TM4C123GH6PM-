#include  "TM4C123GH6PM.h"
extern void delay(int); 

#define OUT (*((volatile unsigned long *)(GPIOB_BASE + 0x03CUL)))
	void init_func(void){
	SYSCTL->RCGCGPIO |= 0x02; // Turn on bus clock for GPIOB
	__ASM("NOP");
	__ASM("NOP");
	__ASM("NOP");
  GPIOB->DIR       |= 0x0F; // Set Pb0-Pb3 as outputs
	GPIOB->DIR       &= 0x0F; // Set Pb4-Pb7 as inputs
  GPIOB->DEN       |= 0xFF;  // Enable pins as a digital pin
	GPIOB->AFSEL     &= 0x00; // Set Pb4-Pb7 as inputs
	GPIOB->PUR				= 0xF0;
	GPIOB->AMSEL     &= 0x00; // Set Pb4-Pb7 as inputs
	GPIOB->PCTL &= 0xFFFF;
	GPIOB->IS &= 0x0F;
	GPIOB->IBE |= 0xF0;
	GPIOB->IM |= 0xF0;
	GPIOB->ICR |= 0xF0;
	NVIC->IP[1] = 3 << 5;
	NVIC->ISER[0] |= (1<<1);
	SysTick->LOAD = 159999999; // one msecond delay relaod value note 15999999=1sec
	SysTick->CTRL = 7 ; // enable counter, interrupt and select system bus clock 
	SysTick->VAL  = 0; //initialize current value register
}

int main()
{
	init_func(); 
	OUT = 0x01;
		while (1)
	{
		//do nothing here
	}
}
