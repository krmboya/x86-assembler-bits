	.data

hello_world:
	.asciz "hello, world!"

call_demo:
	.asciz "Call works!"


	.text

	.globl _start

_start:
	nop
	call call_me
	# write hello world
	movl $4, %eax  # syscall number for write
	movl $1, %ebx  # fd for stdout
	movl $hello_world, %ecx  # address of buffer
	movl $13, %edx  # no of bytes to write
	int $0x80


exit_program:
	movl $1, %eax
	movl $10, %ebx
	int $0x80

call_me:
	movl $4, %eax
	movl $1, %ebx
	movl $call_demo, %ecx
	movl $11, %edx
	int $0x80
	ret

	
