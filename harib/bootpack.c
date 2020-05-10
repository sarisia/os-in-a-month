void _io_hlt(void);
int _io_load_eflags();
void _io_store_eflags(int eflags);
void _io_cli();
void _io_out8(int port, int data);
// void _write_mem8(int addr, int data);

void init_palette();
void set_palette(int start, int len, unsigned char *table);

void HariMain(void) {
    init_palette();

    char *p = (char *)0xa0000;

    for (int i = 0; i <= 0xffff; i++) {
        p[i] = i & 0xf;
    }

    while (1) {
        _io_hlt();
    }
}

void init_palette() {
    static unsigned char table_rgb[3*16] = {
        0x00, 0x00, 0x00, /*  0:黒 */
		0xff, 0x00, 0x00, /*  1:明るい赤 */
		0x00, 0xff, 0x00, /*  2:明るい緑 */
		0xff, 0xff, 0x00, /*  3:明るい黄色 */
		0x00, 0x00, 0xff, /*  4:明るい青 */
		0xff, 0x00, 0xff, /*  5:明るい紫 */
		0x00, 0xff, 0xff, /*  6:明るい水色 */
		0xff, 0xff, 0xff, /*  7:白 */
		0xc6, 0xc6, 0xc6, /*  8:明るい灰色 */
		0x84, 0x00, 0x00, /*  9:暗い赤 */
		0x00, 0x84, 0x00, /* 10:暗い緑 */
		0x84, 0x84, 0x00, /* 11:暗い黄色 */
		0x00, 0x00, 0x84, /* 12:暗い青 */
		0x84, 0x00, 0x84, /* 13:暗い紫 */
		0x00, 0x84, 0x84, /* 14:暗い水色 */
		0x84, 0x84, 0x84, /* 15:暗い灰色 */
    };
    set_palette(0, 15, table_rgb);
}

void set_palette(int start, int len, unsigned char *table) {
    int eflags = _io_load_eflags();
    _io_cli(); // clear interrupt flag
    _io_out8(0x03c8, start);

    for (int i = start; i < len; ++i) {
        _io_out8(0x03c8, table[0] / 4);
        _io_out8(0x03c8, table[1] / 4);
        _io_out8(0x03c8, table[2] / 4);
        table += 3;
    }

    _io_store_eflags(eflags);
}
