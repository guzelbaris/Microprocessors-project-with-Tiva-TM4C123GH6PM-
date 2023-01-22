;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		sdata, DATA, READONLY
			THUMB
ADRESS 		EQU 		0x20000700
DATA 		EQU 		0x0
;***************************************************************
; Program section - Main Code for Preliminary Work 1 - Q1
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
			AREA 		main, READONLY, CODE
			THUMB
			EXTERN 		OutStr 			;Subroutine - external reference source
			EXTERN 		CONVRT			;CONVRT subroutine - for conversion
			EXPORT 		__main			; Export main function
				
__main 		PROC
			MOV32		R5,#ADRESS		; Initial decleration address stored in R5
			MOV32		R4,#DATA		; Data value stored in R4
			BL			CONVRT			; link for our external subroutine CONVRT
done		B			done		

			ENDP						; End of the program
			ALIGN
			END

