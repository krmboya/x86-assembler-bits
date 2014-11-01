;;; Intel syntax
section		.text		; program text section
global		_start		; tell the linker the entry point

_start:

	mov	edx, len	; message length
	mov	ecx, msg	; message to write
	mov 	ebx, 1		; file descriptor (stdout)
	mov 	eax, 4		; system call number (sys_write)
	int	0x80		; call kernel

section		.data

msg	db 'Hello, World!', 0xa	; message
len	equ $ - msg		; length of the message
	