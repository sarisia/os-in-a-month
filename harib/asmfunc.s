.code32

# .text # リンカで .text はバイナリに突っ込まれる
.global _io_hlt # _io_hlt を露出させないとリンカが bootpack.c での呼び出しとくっつけられない
_io_hlt:
    hlt
    ret
