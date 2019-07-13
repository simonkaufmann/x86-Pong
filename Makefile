all: boot.iso

clean:
	rm -f boot.img
	rm -f floppy.img
	rm -f boot.iso

boot.iso: floppy.img
	./scripts/create-iso $@ $<

floppy.img: boot.img
	dd if=/dev/zero of=floppy.img bs=1024 count=1440
	dd if=boot.img of=floppy.img seek=0 count=1 conv=notrunc

boot.img: boot.asm
	nasm -f bin -o $@ $<
