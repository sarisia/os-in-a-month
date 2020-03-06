QEMU=qemu-system-i386.exe

helloos.img: helloos.s
	as -o _helloos.img helloos.s
	objcopy -O binary _helloos.img helloos.img

run: helloos.img
	$(QEMU) -fda helloos.img
