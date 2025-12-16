#! mrasm

.EQU last_value 0x00    ; letzter Messwert RAM Adresse
.EQU last_state 0x01    ; letzter Comparator-state RAM Adresse

.EQU bit4_mask 0x10     ; Konstante um 4. Bit zu masken
.EQU platine 0xF1       ; Adresse um DAC2 und Comparator anzusprechen
.ORG 0x20               ; Programm startpunkt 

;---------------------------------------------------------------------------------

TEMPMESS:
    LD R0, last_value
    LD R1, last_state

LOOP:
    ST platine, R0      ; DAC Wert für R0 prüfen

    LD R2, platine      ; Byte laden um Status-Bit zu lesen
    AND R2, bit4_mask   ; Bit 4 maskieren

    CMP R2, R1          
    JZ NO_SWITCH        ; Case: state hat sich nicht geändert, also +/- 1

SWITCH:                 ; Case: state hat sich geändert, also mache letzten Schritt rückgängig
    CMP R1, bit4_mask   ; und speicher R0
    JZ INC_REVERT
    
    INC R0              
    JMP STORE

INC_REVERT:
    DEC R0
    JMP STORE

NO_SWITCH: 
    CMP R2, 0x10        
    JZ INC_VALUE        ; Case: Inkrementiere, da U_dac < U_sens
    
    DEC R0              ; Case: Dekrementiere, da U_dac >= U_sens
    JMP UPDATE

INC_VALUE:
    INC R0

UPDATE:
    MOV R1, R2          ; R1 = R2
    JMP LOOP

STORE:  
    ST last_value, R0   ; Speichern des finalen R0 Wertes in Adresse 0x00
    ST last_state, R2
    
    RET
