ASM=atasm

all: getaway.xex

getaway.xex: src/getaway.asm src/getaway.dat src/playfield.dat
	atasm -Isrc -ogetaway.xex src/getaway.asm -Lgetaway.var -ggetaway.lst

clean:
	rm getaway.xex getaway.var getaway.lst
