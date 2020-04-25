QEMU=qemu-system-i386.exe

all: clean helloos.img

ipl.o: ipl.s
	as -a -o ipl.o ipl.s > ipl.lst

ipl.bin: ipl.o ipl.lds
	ld -T ipl.lds --oformat=binary -o ipl.bin ipl.o

haribote.o: haribote.s
	as -a -o haribote.o haribote.s > haribote.lst

haribote.sys: haribote.o
	ld -T haribote.lds --oformat=binary -o haribote.sys haribote.o

helloos.img: ipl.bin haribote.sys
	mkfs.fat -F 12 -C helloos.img 1440
	dd if=ipl.bin of=helloos.img conv=notrunc
	mkdir -p mnt
	mount -o loop -t msdos helloos.img ./mnt
	cp haribote.sys ./mnt
	umount ./mnt
	
.PHONY: run
run: helloos.img
	$(QEMU) -fda helloos.img

.PHONY: clean
clean:
	rm -f *.o *.img *.bin
