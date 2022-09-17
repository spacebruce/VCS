cd src
dasm knifeman.asm -f3 -v0 -sKNIFEMAN.sym -lKNIFEMAN.lst -oKNIFEMAN.a26
move KNIFEMAN.a26 ../build
move KNIFEMAN.sym ../build
move KNIFEMAN.lst ../build
cd ..