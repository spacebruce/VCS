; Graphics 
    align 256
Hello:    ;31 bytes
    .byte %00000000 ; empty
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
    
World:
    .byte %00000000 ; empty
    .byte %10000001 ; W
    .byte %10000001 ; 
    .byte %01000010 
    .byte %01011010
    .byte %00100100
    .byte %00000000
    .byte %00011000 ; O
    .byte %00100100
    .byte %01000010
    .byte %00100100
    .byte %00011000
    .byte %00000000
    .byte %11111110 ; R
    .byte %10000001
    .byte %11111110
    .byte %11100000
    .byte %10000111
    .byte %00000000
    .byte %01000000 ; L
    .byte %01000000
    .byte %01000000
    .byte %01000000
    .byte %01111110
    .byte %00000000
    .byte %11111110 ; D
    .byte %10000001
    .byte %10000001
    .byte %10000001
    .byte %11111110
    .byte %00000000

.PlayerSprite:  ;   8 bytes
    .byte %00011000
    .byte %00111100
    .byte %01111110
    .byte %11111111
    .byte %11111111
    .byte %01111110
    .byte %00111100
    .byte %00011000
.KillerSprite:  ;   8 bytes
    .byte %01111110
    .byte %10000001
    .byte %10100101
    .byte %10100101
    .byte %10000001
    .byte %10111101
    .byte %10000001
    .byte %01111110