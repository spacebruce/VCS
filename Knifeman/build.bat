cd src
dasm knifeman.asm -f3 -v0 -sKNIFEMAN_PAL.sym -lKNIFEMAN_PAL.lst -DREGION=0 -oKNIFEMAN_PAL.a26
dasm knifeman.asm -f3 -v0 -sKNIFEMAN_NTSC.sym -lKNIFEMAN_NTSC.lst -DREGION=1 -oKNIFEMAN_NTSC.a26 
move KNIFEMAN_* ../build
cd ..