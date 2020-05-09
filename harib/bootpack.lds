SECTIONS {
    .harihead : {
        LONG(0x310000) /* bootpack.hrb からそのまま持ってきた */
        LONG(0x69726148) /* "Hari" */
        LONG(0)
        LONG(0x310000)
        LONG(0)
        LONG(0x34)
        LONG(0xe9000000)
        LONG(HariMain - 0x20)
        LONG(0x310000)
    }
    .text : { *(.text) } /* .text in all files */

    /DISCARD/ : { *(.eh_frame) }
}
