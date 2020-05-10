.code32

# .text # リンカで .text はバイナリに突っ込まれる
.global _io_hlt # _io_hlt を露出させないとリンカが bootpack.c での呼び出しとくっつけられない
_io_hlt:
    hlt
    ret

; .global _write_mem8
; _write_mem8:
;     mov 4(%esp), %ecx # addr
;     mov 8(%esp), %al # data
;     mov %al, (%ecx)
;     ret
