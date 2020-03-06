QEMU=qemu-system-i386.exe

all: helloos.img

helloos.o: helloos.s
	as -o helloos.o helloos.s

helloos.img: helloos.o helloos.lds
	ld -T helloos.lds --oformat=binary -o helloos.img helloos.o
	
run: helloos.img
	$(QEMU) -fda helloos.img

clean:
	rm *.o *.img
