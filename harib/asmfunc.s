; .arch i486
.code32

# .text # リンカで .text はバイナリに突っ込まれる
.global _io_hlt # _io_hlt を露出させないとリンカが bootpack.c での呼び出しとくっつけられない
_io_hlt: # void _io_hlt()
    hlt
    ret

.global _io_load_eflags
_io_load_eflags: # int _io_load_eflags()
    pushf # Push eFLAGS Register onto the Stack
    pop %eax
    ret

.global _io_store_eflags
_io_store_eflags: # void _io_store_eflags(int eflags)
    mov 4(%esp), %eax
    push %eax
    popf # Pop Stack into eFLAGS Register
    ret

.global _io_cli
_io_cli: # void _io_cli()
    cli # Clear Interrupt Flag
    ret

.global _io_out8
_io_out8: # void _io_out8(int port, int data)
    mov 4(%esp), %edx
    mov 8(%esp), %al
    out %al, %dx # OUT DX, AL: Output to Port
    ret

; .global _write_mem8
; _write_mem8: # void _write_mem8(int addr, int data)
;     mov 4(%esp), %ecx # addr
;     mov 8(%esp), %al # data
;     mov %al, (%ecx)
;     ret
