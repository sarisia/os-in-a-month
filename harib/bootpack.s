	.file	"bootpack.c"
	.text
	.globl	set_palette
	.type	set_palette, @function
set_palette:
.LFB2:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$28, %esp
	.cfi_offset 7, -12
	.cfi_offset 6, -16
	.cfi_offset 3, -20
	movl	8(%ebp), %ebx
	movl	12(%ebp), %eax
	movl	16(%ebp), %edi
	movl	%eax, -28(%ebp)
	call	_io_load_eflags
	movl	%eax, %esi
	call	_io_cli
	pushl	%ecx
	pushl	%ecx
	pushl	%ebx
	pushl	$968
	call	_io_out8
.L5:
	addl	$16, %esp
	cmpl	-28(%ebp), %ebx
	jge	.L7
	pushl	%eax
	pushl	%eax
	addl	$3, %edi
	movb	-3(%edi), %al
	incl	%ebx
	shrb	$2, %al
	movzbl	%al, %eax
	pushl	%eax
	pushl	$968
	call	_io_out8
	movb	-2(%edi), %al
	popl	%edx
	popl	%ecx
	shrb	$2, %al
	movzbl	%al, %eax
	pushl	%eax
	pushl	$968
	call	_io_out8
	popl	%eax
	movb	-1(%edi), %al
	popl	%edx
	shrb	$2, %al
	movzbl	%al, %eax
	pushl	%eax
	pushl	$968
	call	_io_out8
	jmp	.L5
.L7:
	movl	%esi, 8(%ebp)
	leal	-12(%ebp), %esp
	popl	%ebx
	.cfi_restore 3
	popl	%esi
	.cfi_restore 6
	popl	%edi
	.cfi_restore 7
	popl	%ebp
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	jmp	_io_store_eflags
	.cfi_endproc
.LFE2:
	.size	set_palette, .-set_palette
	.globl	init_palette
	.type	init_palette, @function
init_palette:
.LFB1:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$12, %esp
	pushl	$table_rgb.1434
	pushl	$15
	pushl	$0
	call	set_palette
	addl	$16, %esp
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE1:
	.size	init_palette, .-init_palette
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
	subl	$8, %esp
	call	init_palette
	movl	$655360, %eax
.L11:
	movb	%al, %dl
	incl	%eax
	andl	$15, %edx
	movb	%dl, -1(%eax)
	cmpl	$720896, %eax
	jne	.L11
.L12:
	call	_io_hlt
	jmp	.L12
	.cfi_endproc
.LFE0:
	.size	HariMain, .-HariMain
	.data
	.align 32
	.type	table_rgb.1434, @object
	.size	table_rgb.1434, 48
table_rgb.1434:
	.byte	0
	.byte	0
	.byte	0
	.byte	-1
	.byte	0
	.byte	0
	.byte	0
	.byte	-1
	.byte	0
	.byte	-1
	.byte	-1
	.byte	0
	.byte	0
	.byte	0
	.byte	-1
	.byte	-1
	.byte	0
	.byte	-1
	.byte	0
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-1
	.byte	-58
	.byte	-58
	.byte	-58
	.byte	-124
	.byte	0
	.byte	0
	.byte	0
	.byte	-124
	.byte	0
	.byte	-124
	.byte	-124
	.byte	0
	.byte	0
	.byte	0
	.byte	-124
	.byte	-124
	.byte	0
	.byte	-124
	.byte	0
	.byte	-124
	.byte	-124
	.byte	-124
	.byte	-124
	.byte	-124
	.ident	"GCC: (Ubuntu 7.4.0-1ubuntu1~18.04.1) 7.4.0"
	.section	.note.GNU-stack,"",@progbits
