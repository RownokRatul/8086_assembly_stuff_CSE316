.MODEL SMALL

.STACK 100H

.DATA

    CRET EQU 0DH
    LF EQU 0AH 
    MINUS EQU 02DH
    FLAG DB 0
    BASE DW ?
    N DW ?
    DECI DW 0
    TEMP DW ?
    COUNT DB ?


.CODE  

INT_OUTPUT PROC
;TAKES TEMP AS INPUT
;OUTPUTS THE INTEGER
;USES: AX, DX, CX, BX
    PUSH AX
    PUSH BX
    PUSH CX
    PUSH DX
    ;CLEAR DX
    XOR DX, DX
    MOV AX, TEMP
    MOV CX, 10D
    MOV COUNT, 0
    ;IF NEGATIVE
        CMP AX, 0
        JGE _WHILE_OUT
        ;PRUNT MINUS SIGN
        PUSH AX
        MOV AH, 2
        MOV DL, MINUS
        INT 21H
        POP AX
        NEG AX
    _WHILE_OUT: 
        ;DX:AX -> NUM / 10
        XOR DX, DX
        DIV CX
        INC COUNT
        ;CONVERT ASCII AND PRINT
        OR DL, 030H
        PUSH DX
        ;IF QUOTIENT IS ZERO, EXIT LOOP
            CMP AX, 0
            JE END_WHILE_OUT
        JMP _WHILE_OUT

    END_WHILE_OUT:
    ;PRINT REVERSE FROM STACK
    MOV CL, COUNT
    REVERSE_PRINT:
        MOV AH, 2
        POP DX
        INT 21H
        LOOP REVERSE_PRINT
    ;POP AND RETURN
    POP DX
    POP CX
    POP BX
    POP AX
    RET
INT_OUTPUT ENDP

INT_INPUT PROC
;takes input of an integer
;input: null
;uses: ax, CX
;output: BX
    PUSH AX
    PUSH CX
    XOR BX, BX
    XOR CX, CX
    MOV FLAG, 0
    ;initialize ax = bx = CX = FLAG = 0
    ;while true
    _WHILE_IN:
        MOV AH, 1
        INT 21H
        ;if negative
            CMP AL, MINUS
            JNE POS
            OR FLAG, 1
            JMP _WHILE_IN
        POS:     
        ;ELSE if carriage return
            CMP AL, CRET
            JE END_WHILE_IN
        ;else
            ;conver ascii
            AND AL, 0FH
            ;bx = bx*10 + input
            MOV CL, AL
            MOV AX, 10D
            MUL BX
            MOV BX, AX
            ADD BX, CX
            JMP _WHILE_IN
    END_WHILE_IN:
    ;IF FLAG THEN NEGATE
        CMP FLAG, 1
        JNE STORE
        NEG BX
    ;store the number in array
    STORE:
        ;DONE MANUALLY
    POP CX
    POP AX
    ;return
    RET
INT_INPUT ENDP 



;PRINTS A NEW LINE
PRINT_NEWLINE PROC
    PUSH AX
    PUSH DX
    MOV AH, 2
    MOV DL, 0AH
    INT 21H
    MOV DL, 0DH
    INT 21h
    POP DX
    POP AX
    RET
PRINT_NEWLINE ENDP  

PRINT_SPACE PROC
    PUSH AX
    PUSH DX
    MOV AH, 2
    MOV DL, 020H 
    INT 21H
    POP DX
    POP AX
    RET
PRINT_SPACE ENDP 

CONVERT_DECIMAL PROC
;USES AX, BX, CX
;OUTPUT DECI
    MOV BX, 10D
    MOV CX, 1
    MOV AX, N
    _WHILE_DIGIT:
        ;IF AX == 0
            CMP AX, 0
            JE END_WHILE_DIGIT
        XOR DX, DX
        ;DIGIT
        DIV BX
        MOV TEMP, AX
        MOV AX, DX
        XOR DX, DX
        ;MULTIPLY WITH BASE POWER
        MUL CX
        ADD DECI, AX
        XOR DX, DX
        MOV AX, CX
        MUL BASE
        MOV CX, AX
        MOV AX, TEMP
        JMP _WHILE_DIGIT
        
    END_WHILE_DIGIT:
    
    RET    
CONVERT_DECIMAL ENDP

CONVERT_BINARY PROC
;USES AX, BX, CX
    MOV COUNT, 0
    MOV BX, 2
    MOV AX, DECI
    _WHILE: 
        ;IF AX == 0
            CMP AX, 0
            JE END_WHILE
        XOR DX, DX
        DIV BX
        PUSH DX
        INC COUNT
        XOR DX, DX
        JMP _WHILE
        
    END_WHILE:
    CALL PRINT_NEWLINE
    
    _WHILE_BIN_PRINT:
        ;IF COUNT == 0
            CMP COUNT, 0
            JE END_WHILE_BIN_PRINT
        POP DX
        ADD DX, 030H
        MOV AH, 2
        INT 21H    
    
    END_WHILE_BIN_PRINT:
    RET                   
 
CONVERT_BINARY ENDP



MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX
    
    CALL INT_INPUT
    MOV BASE, BX
    CALL PRINT_NEWLINE
    CALL INT_INPUT
    MOV N, BX
    
    CALL CONVERT_DECIMAL
    CALL CONVERT_BINARY
        
    
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
