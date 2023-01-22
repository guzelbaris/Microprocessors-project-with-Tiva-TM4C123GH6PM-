;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		sdata, DATA, READONLY
			THUMB
ADRESS 		EQU 		0x20000700
NUM			DCD			2113
;***************************************************************
; Program section - Main Code for Preliminary Work 1 - Q2
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		main, READONLY, CODE
			THUMB
			EXTERN 		OutStr 			;Subroutine - external reference source
			EXTERN 		CONVRT			;CONVRT subroutine - for conversion
			EXTERN 		InChar 			
			EXPORT 		__main
				
__main 		PROC

					
LOOP1		MOV32		R4,#NUM	
			LDR			R4,[R4]
			MOV32		R5,#ADRESS
			BL			InChar 			;Enter Character to Terminal
			BL			CONVRT
			B			LOOP1
			
			
			ENDP						; End of the program
			ALIGN
			END