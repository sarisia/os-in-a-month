    .code16

    mov $0x00, %ah # AT BIOS: ビデオモード設定
    mov $0x13, %al # mode: VGA 320x200 8bit color packed pixel (?)
    int $0x10

fin:
    hlt
    jmp fin
