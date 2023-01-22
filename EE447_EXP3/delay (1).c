void delay(int n)
{
    int i, j;
    for(i = 0 ; i < n; i++)	// here n value defines how many msec delay we want
        for(j = 0; j < 3180; j++) // to give 1msec of delay because we use 16Mhz clock
            {} 
}