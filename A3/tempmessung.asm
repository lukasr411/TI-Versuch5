#! mrasm

.EQU last_value 0        ; letzter Messwert RAM Adresse
.EQU last_state 1        ; letzter Comparator-state RAM Adresse

.EQU buffer_register 2   ; Register zwischenspeichern
.EQU bit4_mask 16        ; Konstante um 4. Bit zu masken
.EQU platine 241         ; Adresse um DAC2 und Comparator anzusprechen
.EQU zero 0
;-------------------------------------------------------------------------------------------

TEMPMESS:
    LD R0, zero
    ST (last_value), R0

    LD R1, zero
    ST (last_state), R1

LOOP:
    ST (platine), R0            ; DAC Wert für R0 prüfen
    ST (buffer_register), R0    ; R0 zwischenspeichern um R0 für AND vergleich zu nutzen
    
    LD R0, bit4_mask            ; R0 = bitmaske
    LD R2, (platine)            ; Byte laden um Status-Bit zu lesen
    AND R2, R0                  ; R2 = R2 AND R0 

    LD R0, (buffer_register)    ; Vorherigen R0 Wert aus zwischenspeicher holen
    
    CMP R2, R1          
    JZS NO_SWITCH                ; Case: state hat sich nicht geändert, also +/- 1

SWITCH:                 ; Case: state hat sich geändert, also mache letzten Schritt rückgängig
    CMP R1, bit4_mask   ; und speicher R0
    JZS INC_REVERT
    
    INC R0              
    JMP STORE

INC_REVERT:
    DEC R0
    JMP STORE

NO_SWITCH: 
    CMP R2, bit4_mask       
    JZS INC_VALUE        ; Case: Inkrementiere, da U_dac < U_sens
    
    DEC R0              ; Case: Dekrementiere, da U_dac >= U_sens
    JMP UPDATE

INC_VALUE:
    INC R0

UPDATE:
    MOV R1, R2          ; R1 = R2
    JMP LOOP

STORE:  
    ST (last_value), R0   ; Speichern des finalen R0 Wertes in Adresse 0x00
    ST (last_state), R2
    
    JMP LOOP
