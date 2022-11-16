.MODEL SMALL
.STACK 100H

.DATA
    MSG DB 'ENTER CHAR: $'
    MSG2 DB ' OUTPUT CHAR: $'
    X DB ?

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 9
    LEA DX, MSG
    INT 21H
    
    MOV AH, 1
    INT 21H
    MOV X, AL
    ;INPUT COMPLETES
    
    MOV BH, X
    SUB BH, 41H
    ADD BH, BH
    ADD BH, 10
    SUB X, BH
    ;ALGORITHM COMPLETES
    ;X - (X - 'A')*2 + 10
    
    
    MOV AH, 9
    LEA DX, MSG2
    INT 21H
    
    MOV AH, 2
    MOV DL, 31H
    INT 21H
    ;1 PRINTS
    
    MOV AH, 2
    MOV DL, X
    INT 21H  
    ;SECOND NUMBER CALCULATED PRINTS
    
    
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN