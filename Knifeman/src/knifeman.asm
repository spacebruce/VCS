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

VictimX     ds 2        ;   8.8 fractional   
VictimY     ds 2
VictimRoom  ds 1

KillerX     ds 2
KillerY     ds 2
KillerRoom  ds 1

;Rendering
LineY       ds 1

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
    bne Kernel      ; Hold on timer
    sta VBLANK      ; Turn off Vblank
    ldx #ScreenLines
    stx LineY
    ldx #12
    stx Temp1
    ldy #0
    sty Temp2
KernelLoop:
    stx WSYNC       ; Wait for scanline
    stx COLUBK
    ldx Temp1
    ldy Temp2       ;   Y position in sprite
    dex
    bne AddLine
    ldx #6
    iny
    sty Temp2
AddLine:
    stx Temp1
    lda Hello,Y   ; Load Titlescreen[y]
    sta GRP1
    lda World,Y
    sta GRP0
    nop
    nop
    nop
    nop
    nop
    sta GRP0
    sta HMOVE
    ldx LineY       ;   
    dex
    stx LineY
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

; ==========
; 
; ==========

    include "sprites.asm"

;===============================================================================
; Define End of Cartridge
;===============================================================================
    ORG $FFFA        ; set address to 6507 Interrupt Vectors 
    .WORD Reset ; NMI
    .WORD Reset ; RESET
    .WORD Reset ; IRQ