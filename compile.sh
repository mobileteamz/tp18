#nasm -felf64 main.asm
#ld main.o

nasm main2.asm -f elf64
gcc main2.o -no-pie
./a.out