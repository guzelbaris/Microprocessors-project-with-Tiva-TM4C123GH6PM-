#include  "TM4C123GH6PM.h"
void SysTick_Handler(void)
{
int direction=0; // Direction value will come from push buttons 
	// for now to see clockwise direction turning we setted direction value as 0
	if(direction==1){		// clockwise direction
		delay(1);			// 1 msec delay to allow the systick arrange itself
		if(GPIOB->DATA==0){	//note that in clock wise direction Full step output 4 follow Full step output 1 
			GPIOB->DATA = 0x01; 
		}
		else
   GPIOB->DATA=GPIOB->DATA  << 1; // logical binary left shift to arrange output step from 4 to 1
  }
	else if(direction==0){	// counter clock wise direction
		delay(1);				// 1 msec delay to allow the systick arrange itself
		if(GPIOB->DATA==0){		// note that in counter clock wise direction Full step output 1 follow Full step output 4 
			GPIOB->DATA = 0x08; 
		}
		else
   GPIOB->DATA=GPIOB->DATA  >> 1; // logical binary right shift to arrange output step from 1 to 4
	}
}