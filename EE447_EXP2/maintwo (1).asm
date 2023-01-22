;***************************************************************
; maintwo.s
;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
PB_INP 				EQU 		0x4000503C		; data register for inputs
PB_OUT 				EQU 		0x400053C0		; data register for outputs 
number				EQU			20
;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			EXTERN		DELAY150
			EXTERN		init_portB
            EXPORT 		__main
__main 		PROC
			BL 			init_portB		; initialize PORTB
loop		
			MOV			R9,#number
			MOV32 		R0, #PB_OUT				
			LDR 		R1, [R0] 		 
			MVN			R1, R1			
			AND 		R2,R1,#0xF0 	
			LSR			R2, R2, #4	
			MVN 		R3, R2	
										 
			MOV32		R0, #PB_INP	
			STR			R3, [R0]
			B			delay
delay		CMP			R9,#0
			BEQ			loop
			SUB			R9,R9,#1
			BL			DELAY150
			BL 			delay
			
			ENDP
;***************************************************************
; End of the program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			ALIGN
            END
