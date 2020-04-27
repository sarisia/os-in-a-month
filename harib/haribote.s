    .code16

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

fin:
    hlt
    jmp fin
