#include "TM4C123GH6PM.h"
#include <stdio.h>
#define sample (*((volatile unsigned long *)(0x20000400)))
	
extern void init_func(void);
int main(void) {
 init_func();

  // Start sampling sequence on sequencer 3
  ADC0->PSSI |= (1 << 3);


  // Wait for sampling to complete on sequencer 3
  while((ADC0->RIS & 0x8) == 0) {}
  // Read the value of the oldest sample from the FIFO register
		while(1){
			sample = (ADC0->SSFIFO3 & 0x0FFF) - 2048;

  // Tell the ADC that you are ready for it to continue sampling
  ADC0->ISC |= (1 << 3);

	}
}