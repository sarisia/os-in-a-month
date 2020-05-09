QEMU=qemu-system-i386.exe

all: clean helloos.img

ipl.o: ipl10.s
	as -a -o ipl.o ipl10.s > ipl.lst

ipl.bin: ipl.o ipl.lds
	ld -T ipl.lds --oformat=binary -o ipl.bin ipl.o

asmhead.o: asmhead.s
	as -a -o asmhead.o asmhead.s > asmhead.lst

asmhead.bin: asmhead.o
	ld -T asmhead.lds --oformat=binary -o asmhead.bin asmhead.o

bootpack.s: bootpack.c
	gcc -S -m32 -Os -Wall -o bootpack.s bootpack.c

bootpack.o: bootpack.s
	as --32 -a -o bootpack.o bootpack.s > bootpack.lst

bootpack.hrb: bootpack.o
	ld -m elf_i386 -M --oformat=binary -T bootpack.lds -o bootpack.hrb bootpack.o > bootpack.map

haribote.sys: asmhead.bin bootpack.hrb
	cat asmhead.bin bootpack.hrb > haribote.sys

haribote.img: ipl.bin haribote.sys
# mkfs.fat -F 12 -C helloos.img 1440
# dd if=ipl.bin of=helloos.img conv=notrunc
# mkdir -p mnt
# mount -o loop -t msdos helloos.img ./mnt
# cp haribote.sys ./mnt
# umount ./mnt

# いつか上の手法に戻したい
# 今はメモリマップのズレを考慮しなくていいように mformat, mcopy でイメージを作る
# -v でボリュームラベルを設定したかったがRootDirectoryTableにエントリが1つ出来てしまい
# (問題ないとは思うが) ずれてしまうのでここでは省略

	mformat -f 1440 -C -B ipl.bin -i haribote.img
	mcopy -i haribote.img haribote.sys ::
	
.PHONY: run
run: haribote.img
	$(QEMU) -drive file=haribote.img,if=floppy,format=raw

.PHONY: clean
clean:
	rm -f *.o *.img *.bin *.sys *.lst *.map *.hrb
	rm -f bootpack.s
