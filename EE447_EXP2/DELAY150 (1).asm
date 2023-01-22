;LABEL 		DIRECTIVE 		VALUE 				COMMENT
			AREA routines , CODE, READONLY
			THUMB
			EXPORT DELAY150 
				
DELAY150	PROC
			PUSH		{LR,R1}
				
			LDR 		R1,=0x249EF
LOOP		SUBS		R1,#1	
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			NOP
			BNE			LOOP	
			POP			{LR,R1} 
			BX			LR	
			
			ENDP
			ALIGN	
			END	
				
				
