#nasm -felf64 main.asm
#ld main.o

nasm BCDtoDEC.asm -f elf64
gcc BCDtoDEC.o -no-pie
./a.out

# nasm main.asm -f elf64
# gcc main.o -no-pie
# ./a.out