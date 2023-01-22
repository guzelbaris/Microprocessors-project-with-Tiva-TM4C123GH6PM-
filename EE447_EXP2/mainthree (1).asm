;***************************************************************
; mainthree.s
;***************************************************************
; EQU Directives
; These directives do not allocate memory
;***************************************************************
;SYMBOL				DIRECTIVE	VALUE			COMMENT
PB_INP 				EQU 		0x4000503C		; data register for inputs
PB_OUT 				EQU 		0x400053C0		; data register for outputs 
number				EQU			20				; DELAY150 loop time
FO					EQU			0xF0			; 1111_0000
OF					EQU			0x0F			; 0000_1111

;***************************************************************
; Program section
;***************************************************************
;LABEL		DIRECTIVE	VALUE			COMMENT
            AREA 		main, READONLY, CODE
            THUMB
			EXTERN 		init_portB
			EXTERN		DELAY150
			EXPORT 		__main
			EXTERN 		OutChar	
__main 		PROC
			BL			init_portB		;Initialize port B
			MOV			R5,#2			;2 for shift operations
			MOV			R10,#3			;short time delay for debouncing
start		LDR 		R1, =PB_OUT		;ARM input
press_check LDR			R2, =PB_INP		;KEYPAD input
			MOV			R6, #0			;Initialization
			STR			R6, [R2]		;R2=R6
			LDR 		R0, [R1]		;R0 = ARM input
			AND			R0, #FO			
			CMP 		R0, #FO			;Comparison
			MOV			R3, R0          ;R3:Temporary data
			BEQ			press_check
			BL			DELAY150			
			LDR 		R0, [R1]		
			AND			R0, #FO			
			CMP 		R0, #FO
			MOV			R9, R0          ;R9:Temporary data
			BEQ			press_check
			CMP 		R3, R9          ;DEBOUNCING
			BEQ 		row_det         ;DEBOUNCING
			BNE			press_check		;DEBOUNCING	
row_det 	MOV 		R4, #0xEF       ; Determinin the row
			
shift		UDIV		R4,R5           ;Divide R4 value with 2
			STR			R4, [R2]
Shortdelay	CMP			R10,#0
			NOP
			SUBS		R10,#1
			BNE			exit
			B			Shortdelay
exit		MOV			R10,#3
			LDR 		R0, [R1]
			AND			R0, #FO
			CMP 		R0, #FO
			MOV			R3, R0           
			BEQ			shift           ;According to button pressed or not
			B			go_to
			
go_to		LSR 		R0, #4    		;Divide by sixteen
			MVN			R0, R0			;Take coloumn number
			AND			R0, #OF
			MVN			R4, R4          ;Take row number
			AND 		R4, #OF			;By using and reset 7-4 bits

; Check Corresponding Row Number
			MOV 		R7, #0			;Row counter
row_n       UDIV		R0, R5			;Divide R0 value with 2
			CMP			R0, #0x0
			BEQ			mov_column
			ADD			R7, #1			;Number of the corresponding row
			BNE			row_n
mov_column	MOV 		R8, #0			;Column counter
column_n	UDIV		R4, R5			;Divide R4 value with 2
			CMP			R4, #0x0
			BEQ			Conc
			ADD			R8, #1			;Number of the corresponding column
			BNE			column_n
			
Conc		MOV			R9, #4			; TO MULTIPLY ROW BY 4 --> BUTTON ID = ROW*4 + COLUMN
			MUL			R7, R7, R9
			ADD			R9, R8, R7  	; Store value of the pressed button at R8
			CMP			R9, #0x9
			ADDLS 		R0, R9, #0x30
			ADDHI		R0, R9, #0x37
			BL			OutChar			

check_r		LDR			R2, =PB_INP		;Check if the pressed buton is released or not
			MOV			R6, #0x00
			STR			R6, [R2]
			
			BL			DELAY150		
			
checker1    LDR 		R1, =PB_OUT	
			LDR 		R0, [R1]
			AND			R0, #FO
			CMP 		R0, #FO
			BNE			check_r
			BL			DELAY150
			BEQ			checker2
					
checker2    LDR 		R1, =PB_OUT	
			LDR 		R0, [R1]
			AND			R0, #FO
			CMP 		R0, #FO
			BNE			checker1
			BL			DELAY150
			BEQ			start			;Turn to beginning		
			ENDP
			ALIGN
			END
				