    .code16

    # ORG は不要 リンカでやる

    jmp entry # .byte 0xeb, 0x4e のかわり？
    .byte 0x90 # ?
    .ascii "SARISIA " # boot sector name
    .word 512 # sector size
    .byte 1 # cluster size (1 sector)
    .word 1 # FAT entry point?
    .byte 2 # FAT nums
    .word 224 # root directory size
    .word 2880 # drive size
    .byte 0xf0 # media type
    .word 9 # FAT size
    .word 18 # sectors per track
    .word 2 # head nums
    .int 0 # partition nums
    .int 2880 # drive size
    .byte 0, 0, 0x29 # ?
    .int 0xffffffff # ?
    .ascii "HELLOOS    " # disk name
    .ascii "FAT12   " # format name
    .skip 18 # ?

entry:
    # init registers
    mov $0, %ax # ax: 16bit accumulator register
    mov %ax, %ss # ss: 16bit stack segment register
    mov $0x7c00, %sp # sp: 16bit stack pointer
    mov %ax, %ds # ds: 16bit data segment
    mov %ax, %es # es: 16bit extra segment

    mov $msg, %si # si: 16bit source index
putloop:
    mov (%si), %al # al: 8bit accumulator low
    add $1, %si
    cmp $0, %al # cmp overwrites flag register  # if %al is 0, stop output chars
    je fin
    mov $0x0e, %ah # 8bit ah: accumlator high # bios output char function
    mov 15, %bx # bx: 16bit base register
    int $0x10 # bios interrupt call???
    jmp putloop
fin:
    hlt # ring level 0???
    jmp fin

msg:
    .ascii "\n\n"
    .ascii "hello, sarisia"
    .asciz "\n" # https://sourceware.org/binutils/docs/as/Asciz.html#Asciz

    .org 0x01fe # 0x7dfe ではない
    .byte 0x55, 0xaa

# ?????
    .byte 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    .skip 4600
    .byte 0xf0, 0xff, 0xff, 0x00, 0x00, 0x00, 0x00, 0x00
    .skip 1469432
