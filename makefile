#
exe= main
src= main.asm
# assembler= nasm

#
# obj= $(patsubst %.asm,%.o,$(src))

default: main

.PHONY: main   
main:
	nasm -f elf -i $(exe).o $(src) && gcc -m32 -o $(exe) $(exe).o

.PHONY: clean
clean:
	rm -f *.o *.lst $(exe) *~ .*.gdb

