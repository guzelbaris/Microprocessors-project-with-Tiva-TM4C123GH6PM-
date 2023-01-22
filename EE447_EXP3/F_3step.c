#include  "TM4C123GH6PM.h"
#define IN (*((volatile unsigned long *)(GPIOB_BASE + 0x3C0UL)))
#define OUT (*((volatile unsigned long *)(GPIOB_BASE + 0x03CUL)))
extern void GPIOB_Handler(void);
extern void SysTick_Handler(void);
extern void delay(int); 

void GPIOB_Handler(void)
{
	if(IN==0xE0){		// clockwise direction
		delay(100);
		if(IN==0xF0){	// detect release
			OUT = 0x08; 
	}
			GPIOB->IM |= 0x0F;
		GPIOB->ICR |= 0xF0;
  }
	else if(IN==0xD0){	// counter clock wise direction
		delay(100);
		if(IN==0xF0){			// detect release
		OUT=0x01;
}
		GPIOB->IM |= 0x0F;
	GPIOB->ICR |= 0xF0;

}
	}
void SysTick_Handler(void){
	if(OUT==1){		// note that in counter clock wise direction Full step output 1 follow Full step output 4 
			OUT = 0x08; 
		}
		else
   OUT=OUT  >> 1; // logical binary right shift to arrange output step from 1 to 4
		GPIOB->IM &= 0x0F;
		if(OUT==8){		// note that in counter clock wise direction Full step output 1 follow Full step output 4 
			OUT = 0x01; 
		}
		else
   OUT=OUT  << 1; // logical binary right shift to arrange output step from 1 to 4
		GPIOB->IM &= 0x0F;

	GPIOB->IM |= 0xF0;
	GPIOB->ICR |= 0xF0;
}