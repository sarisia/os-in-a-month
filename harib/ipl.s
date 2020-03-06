# initial program loader    
    .code16

    # ORG は不要 リンカでやる

    jmp entry # .byte 0xeb, 0x4e のかわり？
    .byte 0x90 # ?
    .ascii "SARISIA " # boot sector name
    .word 512 # BPB_BytePerSec
    .byte 1 # BPB_SecPerClus
    .word 1 # BPB_RsvdSecCnt 予約領域セクタ数 ブートセクタ含む
    .byte 2 # BPB_NumFATs
    .word 224 # root directory size
    .word 2880 # drive size
    .byte 0xf0 # BPB_Media
    .word 9 # BPB_FATSz16 (sector)
    .word 18 # sectors per track
    .word 2 # head nums
    .int 0 # partition nums
    .int 2880 # drive size
    .byte 0, 0, 0x29 # BS_DrvNum, BS_Reserved1, BS_BootSig
    .int 0xffffffff # BS_VolID
    .ascii "HELLOOS    " # disk name
    .ascii "FAT12   " # format name
    .skip 18 # BS_BootCode begin

entry:
    # init registers
    mov $0, %ax # ax: 16bit accumulator register
    mov %ax, %ss # ss: 16bit stack segment register
    mov $0x7c00, %sp # sp: 16bit stack pointer
    mov %ax, %ds # ds: 16bit data segment

# harib00a
# call BIOS to read disk
    mov $0x0820, %ax
    mov %ax, %es # es: 16bit extra segment
    mov $0, %ch # ch: 8bit counter high # シリンダ0 (最も外周)
    mov $0, %dh # dh: 8bit data high # ヘッド0 (表)
    mov $2, %cl # cl: 8bit counter low # セクタ2 (セクタ1はIPL、つまりこれ セクタカウントは1から！)

    mov $0x02, %ah # disk read
    mov $1, %al # num of sectors to process
    mov $0, %bx # buffer address?
    mov $0x00, %dl # dl: 8bit data low
    int $0x13 # BIOS: disk
    jc error # bios returns CF=0 if success else CF=1
    
    # jmp error # 本当に動いているか確認したかった

fin:
    hlt # ring level 0???
    jmp fin

error:
    mov $msg, %si
putloop:
    mov (%si), %al # al: 8bit accumulator low
    add $1, %si
    cmp $0, %al # cmp overwrites flag register  # if %al is 0, stop output chars
    je fin
    mov $0x0e, %ah # 8bit ah: accumlator high # bios output char function
    mov 15, %bx # bx: 16bit base register
    int $0x10 # bios interrupt call???
    jmp putloop

msg:
    .ascii "\n\n"
    .ascii "load error!"
    .asciz "\n" # https://sourceware.org/binutils/docs/as/Asciz.html#Asciz

# finalize boot sector
    .org 0x01fe # 0x7dfe ではない
    .byte 0x55, 0xaa # BS_BootSign
