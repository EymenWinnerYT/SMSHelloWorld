
    
    ORG $0000
    DI
    IM 1
    JP Start

    ORG $0038
    RETI

    ORG $0066
    RETN

Start:
    ;Allocate stack
    LD SP, $DF00

    ;Initialize VDP
    LD HL, VDPData
    LD B, 22
    LD C, $BF
    OTIR

    ;Clear VRAM
    LD A, $00
    OUT ($BF), A
    LD A, $40
    OUT ($BF), A

    LD DE, 16384
ClearVRAMLoop:
    XOR A
    OUT ($BE), A
    DEC DE
    LD A, D
    OR E
    JR NZ, ClearVRAMLoop

    ;Set palette
    LD A, $00
    OUT ($BF), A
    LD A, $C0
    OUT ($BF), A
    LD HL, ColorPalette
    LD B, 32
    DEC C
    OTIR

    ;Load tiles
    LD A, $20
    OUT ($BF), A
    LD A, $40
    OUT ($BF), A

    LD HL, TilePattern
    LD DE, 8192

LoadTilesLoop:
    LD A, (HL)
    OUT ($BE), A
    INC HL
    DEC DE
    LD A, D
    OR E
    JR NZ, LoadTilesLoop

    CALL WaitForVBlank

    LD D, 1        ;X
    LD E, 1        ;Y
    LD HL, Msg
    CALL PrintString

    HALT

PrintString:
    SLA D
    SLA E
    CALL PrintStringSetCrsr
PrintStringStart:
    LD A, (HL)
    CP 255
    JR Z, PrintStringDone
    LD A, C
    OUT ($BF), A
    LD A, B
    OUT ($BF), A
    LD A, (HL)
    SUB 31
    OUT ($BE), A
    INC HL
    INC BC
    INC BC
    JR PrintStringStart

PrintStringSetCrsr:
    ;Calculate cursor position
    LD B, $00
    LD C, E
    SLA C
    RL B
    SLA C
    RL B
    SLA C
    RL B
    SLA C
    RL B
    SLA C
    RL B
    
    ;Add X
    PUSH HL
    PUSH DE
    LD HL, BC
    LD E, D
    LD D, $00
    ADD HL, DE
    LD DE, $7800
    ADD HL, DE
    LD BC, HL
    POP DE
    POP HL

PrintStringDone:
    RET

WaitForVBlank:
    IN A, ($BF)
    BIT 7, A
    JR Z, WaitForVBlank
    RET

WaitForVBlankEnd:
    IN A, ($BF)
    BIT 7, A
    JR NZ, WaitForVBlankEnd
    RET

Msg:
    DB "HELLO WORLD!", 255

ColorPalette:
    ;Tilemap palette
    DB $39
    DB $3F
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    ;Sprite palette
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00
    DB $00

VDPData:
    DB $24, $80
    DB $40, $81
    DB $FF, $82
    DB $FF, $83
    DB $FF, $84
    DB $FF, $85
    DB $FF, $86
    DB $FF, $87
    DB $00, $88
    DB $00, $89
    DB $FF, $8A

TilePattern:
    incbin "TileMap.bin"

    ORG $7FF0
    DB "TMR SEGA"
    DB 0,0
    DB 0,0      ;Checksum here (will written by cscalc.py)
    DB 0,0,0
    DB $4C
