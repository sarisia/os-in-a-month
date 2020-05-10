void _io_hlt(void);
// void _write_mem8(int addr, int data);

void HariMain(void) {
    char *p;
    for (int i = 0xa0000; i <= 0xaffff; i++) {
        p = (char *)i;
        *p = i & 0xf;
    }

    for (;;) {
        _io_hlt();
    }
}
