.MODEL SMALL
.STACK 100H 

.DATA    
     
.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX
    
    MOV AH, 1
    INT 21H
    
    CMP AL, 'Y'
    JE FOUND
    CMP AL, 'y'
    JE FOUND
    JMP NOTFND
    
    FOUND:
        MOV AH, 2
        MOV DL, AL
        INT 21H
    NOTFND:
    
    MOV AH, 04CH
    INT 21H
    
    
    
    MAIN ENDP
END MAIN