void _io_hlt(void);
// void _write_mem8(int addr, int data);

void HariMain(void) {
    char *p = (char *)0xa0000;

    for (int i = 0; i <= 0xffff; i++) {
        *(p + i) = i & 0xf;
    }

    for (;;) {
        _io_hlt();
    }
}
