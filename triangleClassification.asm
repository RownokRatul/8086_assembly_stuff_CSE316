.MODEL SMALL

.STACK 100H

.DATA
CR EQU 0DH
LF EQU 0AH
EQL DB 'EQUILATERAL$'
ISO DB 'ISOSCELES$'
SCL DB 'SCALERE$'
X DB ?
Y DB ?
Z DB ?

.CODE

MAIN PROC
	;DATA SEGMENT INITIALIZATION
    MOV AX, @DATA
    MOV DS, AX  
    
    ;INPUT
    MOV AH, 1
    INT 21H
    MOV X, AL
    INT 21H
    MOV Y, AL
    INT 21H
    MOV Z, AL
    
    
    ;COMPARISON
    MOV BH, X
    
    CMP BH, Y
    JE X_E_Y
    JMP X_NE_Y
         
    X_E_Y:
        CMP BH, Z
        JE EQ
        JMP TWO_EQ 
    
    X_NE_Y:
        MOV CH, Y
        CMP CH, Z
        JE TWO_EQ
        CMP BH, Z
        JE TWO_EQ
        JMP NO_EQ
         
         
    EQ:
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        LEA DX, EQL
        MOV AH, 9
        INT 21H
        JMP END_PRG
    
    TWO_EQ:
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        LEA DX, ISO
        MOV AH, 9
        INT 21H
        JMP END_PRG 
        
    NO_EQ:
        MOV AH, 2
        MOV DL, CR
        INT 21H
        MOV DL, LF
        INT 21H
        LEA DX, SCL
        MOV AH, 9
        INT 21H
        JMP END_PRG
        
    
    
    END_PRG:
        
        
    ;DOS EXIT
    MOV AH, 4CH
    INT 21H

MAIN ENDP
END MAIN
