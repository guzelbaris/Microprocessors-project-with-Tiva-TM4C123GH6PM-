;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		sdata, DATA, READONLY
			THUMB
ADRESS 		EQU 		0x20000700
DTEN		EQU			0xA
NUM			DCD			2113
;***************************************************************
; Program section - Main Code for Preliminary Work 1 - Q4
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		main, READONLY, CODE
			THUMB
			EXTERN 		OutStr 			;Subroutine - external reference source
			EXTERN 		CONVRT			;CONVRT subroutine - for conversion
			EXTERN 		InChar 			
			EXPORT 		__main
				
__main 		PROC
	
start		BL 			InChar
			MOV32		R2,#DTEN		;Decimal 10 move to R2
			MOV32		R5, #ADRESS		;Initial adress for R5
			SUB			R1,R0,#0x30		;From ASCII to Integer
			BL 			InChar			
			SUB			R0,#0x30		
			MOV			R6,#0x0
			ADD			R6,R2,R0
			MUL			R1,R1,R6
			MOV			R7, R5
			
			MOV			R8, #0x1
			MOV			R4, R8
			BL			CONVRT
			MOV			R10, #0x1
			MOV			R4, R10
			BL			CONVRT
			SUB			R1, #0x1

mfibon		SUBS		R1, #0x1
			BEQ			goto
			ADD			R8,R8
			ADD			R3, R10, R8
			MOV			R4, R3
			BL			CONVRT
			MOV			R8, R10
			MOV			R10, R3
			B			mfibon
			
goto		MOV			R9, #0x04
			STRB		R9, [R5]
			MOV			R0, R7
			BL			OutStr
			B 			start
			
			ENDP
;***************************************************************
; End of the program  section
;***************************************************************
;LABEL      DIRECTIVE       VALUE                           COMMENT
            ALIGN
            END