;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
SYSCTL_RCGC2 		EQU 		0x400FE108
GPIO_PORTB_DIR	 	EQU 		0x40005400
GPIO_PORTB_AFSEL 	EQU 		0x40005420
GPIO_PORTB_PUR 		EQU 		0x40005510
GPIO_PORTB_DEN	 	EQU 		0x4000551C

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
            EXPORT 		init_portB
init_portB	PROC
			PUSH 		{R0,R1,LR}
			
;Enable the clock signal
			LDR			R0,=SYSCTL_RCGC2
			LDR			R1,[R0]
			ORR			R1,#0x12		
			STR			R1,[R0]
			NOP
			NOP
			NOP
			
; 
			LDR			R0,=GPIO_PORTB_DIR
			LDR			R1,[R0]
			BIC			R1, #0xF0		; clear bit 7-4 for inputs
			ORR			R1, #0x0F		; clear bit 3-0 for outputs
			STR			R1,[R0]
			

			LDR			R0,=GPIO_PORTB_AFSEL
			LDR			R1,[R0]
			BIC			R1,#0xFF
			STR			R1,[R0]
			
; pull up resistors for the switches
			LDR			R0,=GPIO_PORTB_PUR
			MOV			R1,#0xF0 
			STR			R1,[R0]
			

			LDR			R0,=GPIO_PORTB_DEN	 ; Enable digital
			LDR			R1,[R0]
			ORR			R1,#0xFF
			STR			R1,[R0]		
			
			POP 		{R0,R1,LR}
			
			BX			LR
			
			ENDP
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			ALIGN
            END
