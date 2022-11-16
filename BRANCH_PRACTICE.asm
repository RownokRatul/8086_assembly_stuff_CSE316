.MODEL SMALL
.STACK 100H

.DATA
    MSG DB 'ENTER NUMBER: $' 
    X DB ?
    Y DB ?

.CODE

MAIN PROC
    MOV AX, @DATA
    MOV DS, AX 
    
    ;INPUT QUERY
    MOV AH, 9
    LEA DX, MSG
    INT 21H 
    
    MOV AH, 1
    INT 21H
    MOV X, AL
    
    MOV AH, 2
    MOV DL, 0DH
    INT 21H
    
    MOV AH, 2
    MOV DL, 0AH
    INT 21H    
    ;INPUT ENDS
    
    MOV AH, 9
    LEA DX, MSG
    INT 21H     
    
    MOV AH, 1
    INT 21H
    MOV Y, AL 
              
    MOV CL, X
    CMP CL, Y
    JL ELSE
    IF:   
        MOV DL, X
        MOV AH, 2
        INT 21H
        JMP END_IF
    
    ELSE: 
        MOV DL, Y
        MOV AH, 2
        INT 21H
    
    END_IF:
        
    MOV AH, 04CH
    INT 21H
    
    MAIN ENDP
END MAIN
        
   