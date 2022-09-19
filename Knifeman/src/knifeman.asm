;
;   KNIFEMAN
;   build - 
;       dasm knifeman.asm -f3 -v0 -sKNIFEMAN_PAL.sym -lKNIFEMAN_PAL.lst -DREGION=0 -oKNIFEMAN_PAL.a26
;       dasm knifeman.asm -f3 -v0 -sKNIFEMAN_NTSC.sym -lKNIFEMAN_NTSC.lst -DREGION=1 -oKNIFEMAN_NTSC.a26 
;
    processor 6502
        include "../../shared/vcs.h"  
        include "../../shared/macro.h"
        include "../../shared/constants.asm"

;
;    Region Constants  
;

#if REGION = PAL
ScreenLines = #224
#endif
#if REGION = NTSC
ScreenLines = #192
#endif

;
;   Memory
;
    SEG.U VARS
    ORG $80             

GameMode    ds 1        ; GameMode (0 : Titlescreen, 1 : Victim, 2 : Killer, 3 : 2 Player)
Temp1       ds 1
Temp2       ds 1

; ROM
    SEG CODE        
    ; ORG $F800       ; 2K ROM starts at $F800, 4K ROM starts at $F000
    ORG $F000     ; 4K ROM

Reset:
    CLEAN_START   

Main:
    jsr VerticalSync    ; 
    jsr VerticalBlank   ; 
    jsr Kernel          ; 
    jsr OverScan        ; 
    jmp Main            ; 

VerticalSync:
    lda #2          
    ldx #49   
    sta WSYNC       ; wsync = 2
    sta VSYNC       ; wsync = 2
    stx TIM64T      ; Put 49 in timer
    sta WSYNC       ; wsync = 2
    sta WSYNC       ; wsync = 2
    lda #0    
    sta WSYNC       ; wsync = 0
    sta VSYNC       ; wsync = 0
    rts        

VerticalBlank:      
    rts       
vbLoop:
    sta WSYNC
    dex      
    bne vbLoop
    rts       

Kernel:
    sta WSYNC       ; Wait for TV SYNC
    lda INTIM       
    bne Kernel      ; Wait for timer...
    sta VBLANK      ; Turn off Vblank
    ldx #ScreenLines
    ldy #0          ; Y = 0
KernelLoop:
    stx WSYNC       ; Wait for scanline
    stx COLUBK      ; BG Col = x
    lda Titlescreen,Y   ; Load Titlescreen[y]
    sta PF0
    sta PF1         ; Store in pf1
    sta PF2         ; Store PF2 = x
    iny             ; ++y
    dex             ; --x
    bne KernelLoop  ; loop if (x != 0)
    rts             ;   return

OverScan:
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    lda #2      ; LoaD Accumulator with 2 so D1=1
    sta VBLANK  ; STore Accumulator to VBLANK, D1=1 turns image output off
    lda #32     ; set timer for 27 scanlines, 32 = ((27 * 76) / 64)
    sta TIM64T  ; set timer to go off in 27 scanlines

; game logic will go here
OSwait:
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    lda INTIM   ; Check the timer
    bne OSwait  ; Branch if its Not Equal to 0
    rts         ; ReTurn from Subroutine

osLoop:
    sta WSYNC   ; Wait for SYNC (halts CPU until end of scanline)
    dex         ; DEcrement X by 1
    bne osLoop  ; Branch if Not Equal to 0
    rts         ; ReTurn from Subroutine

    align 256
Titlescreen:
    .byte %01000010 ; H
    .byte %01000010
    .byte %01111110
    .byte %01000010
    .byte %01000010 
    .byte %00000000
    .byte %01111110 ; E
    .byte %01000000
    .byte %01111100
    .byte %01000000
    .byte %01111110
    .byte %00000000
    .byte %01000000 ; L
    .byte %01000000
    .byte %01000000
    .byte %01000000
    .byte %01111110
    .byte %00000000
    .byte %01000000 ; L
    .byte %01000000
    .byte %01000000
    .byte %01000000
    .byte %01111110
    .byte %00000000
    .byte %00011000 ; O
    .byte %00100100
    .byte %01000010
    .byte %00100100
    .byte %00011000
    .byte %00000000
;===============================================================================
; Define End of Cartridge
;===============================================================================
    ORG $FFFA        ; set address to 6507 Interrupt Vectors 
    .WORD Reset ; NMI
    .WORD Reset ; RESET
    .WORD Reset ; IRQ