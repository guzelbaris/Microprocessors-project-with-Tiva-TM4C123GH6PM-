#include "TM4C123GH6PM.h"
#include <stdio.h>
#define sample (*((volatile signed long *)(0x20000400)))

extern void init_func(void);
extern void OutStr(char*); 	

int main(void) {
 init_func();
	char info[50];
	int a=0;
	float b;
  // Start sampling sequence on sequencer 3
  ADC0->PSSI |= (1 << 3);


  // Wait for sampling to complete on sequencer 3
  while((ADC0->RIS & 0x8) == 0) {}
  // Read the value of the oldest sample from the FIFO register
		while(1){
			a = (int)(ADC0->SSFIFO3 & 0x0FFF);
			b = (a*1.65)/2048.0;
			sprintf(info," result: %.2f  \n%c", b, 0x4);
		  OutStr(info);
				if(b >= 1.65){
		GPIOF->DATA  = 0x02;  
				}					/* turn on green LED*/
		else if(b < 1.65){
		GPIOF->DATA  = 0x00;              /* turn off green LED*/
		}
  // Tell the ADC that you are ready for it to continue sampling
  ADC0->ISC |= (1 << 3);
			delay(160);

	}
}