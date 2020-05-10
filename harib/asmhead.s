    .code16

    .set BOTPAK, 0x00280000 # bootpack load destination
    .set DSKCAC, 0x00100000 # disk cache
    .set DSKCAC0, 0x00008000 # disc cache (real mode)

    # BOOT_INFO
    .set CYLS, 0x0ff0
    .set LEDS, 0x0ff1
    .set VMODE, 0x0ff2 # bit color
    .set SCRNX, 0x0ff4 # resolution X
    .set SCRNY, 0x0ff6 # resolution Y
    .set VRAM, 0x0ff8 # start of graphic buffer

    mov $0x00, %ah # AT BIOS: ビデオモード設定
    mov $0x13, %al # mode: VGA 320x200 8bit color packed pixel (?)
    int $0x10

    # set video configs to BOOT_INFO
    movb $8, VMODE
    movw $320, SCRNX
    movw $200, SCRNY
    movl $0x000a0000, VRAM

    # get keyboard state from BIOS
    mov $0x02, %ah
    int $0x16
    mov %al, LEDS

# ここからの解説は後回しらしい また来る
    # prevent PIC from interrupt
    # in PC/AT specification, do this before CLI
    # or get hanged up
    # we do PIC initialize later
    mov $0xff, %al
    out %al, $0x21 # out: write %AL to serial port
    nop
    out %al, $0xa1

    # set A20GATE to make memory over 1MB accessible from CPU
    call waitkbdout
    mov $0xd1, %al
    out %al, $0x64
    call waitkbdout
    mov $0xdf, %al # enable A20
    out %al, $0x60
    call waitkbdout

# enable protect mode
    # .arch i486 とかにすれば変な命令に対して警告してくれるようにもなる
    .code32 # instrset i486p
    lgdt (GDTR0) # LGDT GDTR m: load global descriptor table register
    mov %cr0, %eax # cr0: control register 0
    and $0x7fffffff, %eax # set bit31 to 0
    or $0x00000001, %eax # set bit0 to 1
    mov %eax, %cr0
    jmp pipelineflush

pipelineflush:
    mov $1*8, %ax # これ大丈夫？
    mov %ax, %ds
    mov %ax, %es
    mov %ax, %fs
    mov %ax, %gs
    mov %ax, %ss

    # transfer bootpack
    mov bootpack, %esi # from
    mov BOTPAK, %edi # to
    mov $512*1024/4, %ecx # 1024 sector
    call memcpy

    # transfer disc data
    # boot sector
    mov $0x7c00, %esi # from
    mov DSKCAC, %edi # to
    mov $512/4, %ecx
    call memcpy

    # all remained
    mov DSKCAC0+512, %esi # from
    mov DSKCAC+512, %edi # to
    mov $0, %ecx
    movb (CYLS), %cl # ecx -> ch と cl
    imul $512*18*2/4, %ecx # imul: signed multiply
    sub $512/4, %ecx # subtract ipl size
    call memcpy

# asmhead done, start bootpack
    mov BOTPAK, %ebx
    mov 16(%ebx), %ecx
    add $3, %ecx
    shr $2, %ecx # shr: shift right 2 == div 4
    jz skip # nothing to transfer
    mov 20(%ebx), %esi # from
    add %ebx, %esi
    mov 12(%ebx), %edi
    call memcpy
skip:
    mov 12(%ebx), %esp # stack initial value
    # GDTで設定したセグメントの1bへジャンプ
    # 1b には hrb 形式でのエントリーポイントがある
    # $2*8 -> RPL=0 (ring 0), TI=0 (GDT), index=0x10 (entry 2)
    ljmp $2*8, $0x0000001b # Immediate form long jumps

waitkbdout:
    in $0x64, %al # in AL imm8: input from port
    and $0x02, %al
    jnz waitkbdout
    ret

memcpy:
    mov (%esi), %eax
    add $4, %esi
    mov %eax, (%edi)
    add $4, %edi
    sub $1, %ecx
    jnz memcpy
    ret

    .align 16 # location counter を16の倍数まで進める (zero padding)
GDT0:
    .skip 8 # intel needs null descriptor
    # 64 bit per entry (segment descriptor)
    .word 0xffff, 0x0000, 0x9200, 0x00cf # r/w able segment 32bit
    .word 0xffff, 0x0000, 0x9a28, 0x0047 # executable segment 32bit (bootpack)
    .word 0
GDTR0:
    .word 8*3-1 # 1 引けってたしかに書いてある
    .int GDT0 # .int == .long (32bit)

    .align 16
bootpack:
