#! mrasm


.ORG 0
    CLR R0

LOOP: 
    CLR R0
    LD R0, (0xFF)
    LD R1, (0xFE)
    ADD R0, R1
    ST (0xFE), R0 
    jr LOOP
