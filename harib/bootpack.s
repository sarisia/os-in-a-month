	.file	"bootpack.c"
	.text
	.globl	HariMain
	.type	HariMain, @function
HariMain:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%ebx
	pushl	%edx
	.cfi_offset 3, -12
	movl	$655360, %ebx
.L2:
	pushl	%eax
	pushl	%eax
	movl	%ebx, %eax
	andl	$15, %eax
	pushl	%eax
	pushl	%ebx
	incl	%ebx
	call	_write_mem8
	addl	$16, %esp
	cmpl	$720896, %ebx
	jne	.L2
.L3:
	call	_io_hlt
	jmp	.L3
	.cfi_endproc
.LFE0:
	.size	HariMain, .-HariMain
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
