.MODEL SMALL

.STACK 100H

.DATA
    CRET EQU 0DH
    MINUS EQU 02DH
    N DB ?
    ARR DW 128 DUP(?)
    FLAG DB 0
    COUNT DB 0
    TEMP DW ?
    HI DB ?
    LO DB ?
    NOTFND DB 'NOT FOUND$'
    ENTERMSG DB 'ENTER SIZE OF ARRAY$'
    ARRAYMSG DB 'ARRAY : $'
    SORTEDMSG DB 'AFTER SORT : $'
    SEARCHMSG DB 'ENTER THE NUMBER TO SEARCH : $'
    FOUNDMSG DB 'NUMBER FOUND IN INDEX : $'

.CODE 

;PRINTS A SPACE
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

;INPUT AN ARRAY OF N ELEMENT
INPUT_ARRAY PROC
;USES SI, CX
    PUSH CX
    XOR CX, CX
    LEA SI, ARR
    MOV CL, N
    JCXZ END_NEXT
    _NEXT:
        CALL INT_INPUT
        MOV WORD PTR [SI], BX
        CALL PRINT_NEWLINE
        ADD SI, 2
        LOOP _NEXT
    
    END_NEXT:
    POP CX
    RET
INPUT_ARRAY ENDP

;PRINT ARRAY ELEMENTS
PRINT_ARRAY PROC
;OUTPUTS ALL ELEMENTS OF ARRAY
;USES SI, CX, AX
    PUSH AX
    PUSH CX
    XOR CX, CX
    MOV CL, N
    LEA SI, ARR
    JCXZ END_NEXT_EL
    _NEXT_EL:
        MOV AX, [SI]
        MOV TEMP, AX
        CALL INT_OUTPUT
        CALL PRINT_SPACE
        ADD SI, 2
        LOOP _NEXT_EL

    END_NEXT_EL:
    POP CX
    POP AX
    RET
PRINT_ARRAY ENDP

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

;PRINTS NOT FOUND MESSAGE
PRINT_NOTFOUND PROC
    PUSH AX
    PUSH DX
    MOV AH, 9
    LEA DX, NOTFND
    INT 21H
    POP AX
    POP DX
    RET

PRINT_NOTFOUND ENDP
 
;declaration of input proc
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

;declaration of out proc
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

;swaps consecutive array elements
SWAP PROC
;swaps between [SI] and [SI-2]
;[SI] MUST BE POINTING TO VALID SWAP ADDRESS
;uses SI, BX, CX
    PUSH BX
    PUSH CX
    MOV CX, [SI-2]
    MOV BX, [SI]
    MOV [SI], CX
    MOV [SI-2], BX
    POP CX
    POP BX
    RET
SWAP ENDP

;ARRAY ELEMENT PUSH RIGHT
PUSH_RIGHT PROC
;PUSH [DI] TO [DI+2]
;USES BX
    PUSH BX
    MOV BX, [DI]
    MOV [DI+2], BX
    POP BX
    RET
PUSH_RIGHT ENDP

;SORTS THE ARR
INSERTION_SORT PROC
;OUTPUT: ARR IS SORTED
;USES: CX, BX, AX, SI, DI
    PUSH AX
    PUSH BX
    PUSH CX
    XOR CX, CX
    MOV CL, N
    MOV COUNT, 0
    LEA SI, ARR
    ;FOR i from 1 to n
    _FOR_1_N:
        XOR BX, BX
        MOV BL, COUNT
        MOV AX, [SI]
        MOV DI, SI
        ;WHILE ARR[DI] < ARR[SI] AND BX > 0
        _COMP_LOOP:
            CMP BX, 0
            JE END_COMP_LOOP
            CMP AX, [DI-2]
            JGE END_COMP_LOOP
            DEC BX
            SUB DI, 2
            CALL PUSH_RIGHT
            JMP _COMP_LOOP
    
        END_COMP_LOOP:
        ;ARR[DI] = ARR[SI]
        MOV [DI], AX
        INC COUNT
        ADD SI, 2
        LOOP _FOR_1_N
    POP CX
    POP BX
    POP AX
    RET
INSERTION_SORT ENDP

;BINARY SEARCH ON ARR
BINARY_SEARCH PROC
;INPUT: TEMP
;OUTPUT: OFFSET INDEX OF THE ELEMENT
;USES: BX, SI, AX
    PUSH AX
    PUSH BX
    MOV FLAG, 0
    MOV LO, 0
    MOV AL, N
    MOV HI, AL
    DEC HI
    ;SEARCH ON ADDRESS SI+0 TO SI+2*(N-1)
    LEA SI, ARR
    _WHILE_SEARCH: 
        ;IF LO > HI END
            MOV AL, HI
            CMP LO, AL
            JG END_WHILE_SEARCH
        ;ELSE 
            ; CX = (HI+LO) / 2
            XOR BX, BX
            ADD BL, HI
            ADD BL, LO
            SHR BX, 1
            ;CONVERT CX TO WORD ADDRESS 2*CX
            SHL BX, 1
            ;IF [SI+CX] == TEMP
                MOV AX, [SI+BX]
                CMP AX, TEMP
                JE _FOUND
                JL _LESS
                JMP _GREATER
                ;FOUND, SET FLAG AND END LOOP
                _FOUND: 
                    OR FLAG, 1
                    SHR BX, 1
                    JMP END_WHILE_SEARCH
                ;CONVERT CX TO INDEX, LO = CX+1
                _LESS:
                    SHR BX, 1
                    MOV LO, BL
                    INC LO
                    JMP _WHILE_SEARCH
                ;CONVERT CX TO INDEX, HI = CX-1
                _GREATER: 
                    SHR BX, 1
                    MOV HI, BL
                    DEC HI
                    JMP _WHILE_SEARCH

    
    END_WHILE_SEARCH:
        CMP FLAG, 1
        JE PRINT_IDX
        JMP PRINT_NOTFND
    PRINT_IDX:
        MOV TEMP, BX
        INC TEMP
        CALL PRINT_NEWLINE
        MOV AH, 9
        LEA DX, FOUNDMSG
        INT 21H
        CALL INT_OUTPUT
        JMP END_PRINT
    PRINT_NOTFND:
        CALL PRINT_NEWLINE
        CALL PRINT_NOTFOUND
        JMP END_PRINT
    END_PRINT:
    
    POP CX
    POP AX
    RET
BINARY_SEARCH ENDP
      
MAIN PROC
    ;move data into data register
    MOV AX, @DATA
    MOV DS, AX

    CALL INT_INPUT
    MOV N, BL
    ;IF N <= 0
        CMP N, 0
        JLE END_MAIN
    ;ELSE
    ;INPUT ARRAY
    CALL PRINT_NEWLINE
    CALL INPUT_ARRAY
    CALL PRINT_NEWLINE
    ;SHOW UNSORTED ARRAY
    MOV AH, 9
    LEA DX, ARRAYMSG
    INT 21H
    CALL PRINT_ARRAY
    ;SORT ARRAY
    CALL INSERTION_SORT
    ;SHOW SORTED ARRAY
    CALL PRINT_NEWLINE
    LEA DX, SORTEDMSG
    INT 21H
    CALL PRINT_ARRAY
    CALL PRINT_NEWLINE
    ;TAKE INPUT FOR BINARY SEARCH
    LEA DX, SEARCHMSG
    INT 21H
    CALL INT_INPUT
    ;BINARY SEARCH
    MOV TEMP, BX
    CALL BINARY_SEARCH
    
    END_MAIN:
        MOV AH, 04CH
        INT 21H
    
    MAIN ENDP
END MAIN
    
    
    


            
          