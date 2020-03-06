QEMU=qemu-system-i386.exe

all: helloos.img

ipl.o: ipl.s
	as -a -o ipl.o ipl.s > ipl.lst

ipl.bin: ipl.o ipl.lds
	ld -T ipl.lds --oformat=binary -o ipl.bin ipl.o

helloos.img: ipl.bin
	dd if=/dev/zero of=helloos.img bs=1K count=1440
	dd if=ipl.bin of=helloos.img conv=notrunc
	
run: helloos.img
	$(QEMU) -fda helloos.img

clean:
	rm -f *.o *.img *.bin
