;***************************************************************
; Subroutine section - Convert Code for Preliminary Work 1 - Q1
;***************************************************************
;LABEL		DIRECTIVE	VALUE					COMMENT
			AREA 		routines, CODE, READONLY
			THUMB
			EXPORT 		CONVRT					;Export CONVRT function
			IMPORT		OutStr	
CTEN		EQU			0xA						;Constant 10 to convert hexadecimal to decimal
												;and also to find reminder				
CONVRT 		PROC								;Initial decleration of CONVRT function
	        PUSH		{R0-R3,R5,R6,LR}		;Push R0,R1,R2,R3,R5,R6,LR values to stack
			MOV			R0, #0					;Counter decleration to find reminder
			MOV			R1, #CTEN				;Constant 10 to find number of digits
			MOV			R2,R4					;To hold original number in R4
			
DataRead	UDIV		R3,R2,R1				;R3=R2/R1 note that this is an unsigned integer division
			MUL			R3,R3,R1				;R3=R3*10
			SUB			R3,R2,R3				;R3=R2-R3 stored last digit in R2
			PUSH		{R3}					;Push R3 value in stack
			ADD			R0,#1					;Counter value incremented by 1 this value will be used DataWrite
			UDIV		R2,R2,R1				;R2=R2/R1 Unsigned integer division, reminder part deleted from R4
			CMP			R2,#0					;Check whether R4 is zero or not
			BNE 		DataRead				;If R4 is not equal to zero program goes back to DataRead
			
DataWrite	POP			{R2}					;Pop R2 value from stack
			ADD			R2,#48					;Add decimal 48 to number because correponding pair of number in ASCII									;0=48 - 1=49 - 2=58 the list goes like that
			STRB		R2,[R5],#1				;Store last byte of R2 to the location R5+R1(offset)
			SUBS		R0,#1					;Decrement counter by 1	
			BNE 		DataWrite				;Check zero flag if not equal to zero program goes back to DataWrite
			MOV			R2,#0x04				;move 04 to R2
			STRB		R2,[R5]					;End Byte presentation
			POP			{R0-R3,R5,R6}
			MOV			R0,R5
			BL			OutStr
			POP			{LR}
			BX			LR
			ENDP
			END
												
												
												
												
												
												
												