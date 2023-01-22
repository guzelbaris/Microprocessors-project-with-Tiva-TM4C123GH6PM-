#include  "TM4C123GH6PM.h"
extern void delay(int); 
extern void init_func(void);

int main()
{

	init_func(); 
	GPIOB->DATA=0x01;
		while (1)
	{
		//do nothing here
	}
}
