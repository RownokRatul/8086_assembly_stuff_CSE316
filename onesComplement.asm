;1'S COMPLEMENT

.MODEL SMALL
.STACK 100H

.DATA
    C DB ?
    
.CODE
MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    
    MOV AH, 1
    INT 21H
    MOV C, AL
    
    NEG C
    SUB C, 01H
    
    MOV AH, 2
    MOV DL, C
    INT 21H
    
    MOV AH, 4CH
    INT 21H
    
MAIN ENDP
END MAIN
    
    