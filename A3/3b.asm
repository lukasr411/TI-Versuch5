#! mrasm

LD R0, 0xEF
LDSP R0
CLR R0

MAIN:
    CALL GET_TEMP
    ST (0xFE), R0
    LD R1, (0xFC)
    CMP R0, R1
    JCS LESS_FC
    JR GREATER_EQ_FC

    LESS_FC:
        LD R1, 0
        ST (0xF0), R1
        ST (0xFF), R1
        JR MAIN

    GREATER_EQ_FC:
        LD R1, (0xFD)
        CMP R0, R1
        JCS LESS_FD
        JR GREATER_EQ_FD

    LESS_FD:
        LD R1, 0xFE
        ST (0xF0), R1
        ST (0xFF), R1
        JR MAIN

    GREATER_EQ_FD:
        LD R1, 0xFF
        ST (0xF0), R1
        ST (0xFF), R1
        JR MAIN

GET_TEMP:
    LOOP:
      ST (0xF1), R0
      LD R1, (0xF1)
      LD R2, 0x10
      AND R1, R2

      CMP R1, 0
      JZS LEQ

      INC R0
      ST (0xF1), R0
      LD R1, (0xF1)
      AND R1, R2
      CMP R1, 0x10
      JZS LOOP
      RET

      LEQ:
        CMP R0, 0
        JZS END
        DEC R0
        ST (0xF1), R0
        LD R1, (0xF1)
        AND R1, R2
        CMP R1, 0
        JZS LOOP
        INC R0
      END:
        RET
