# Purpose - calculate the square of a number

.section .data

.section .text

.globl _start
.globl square

_start:
	pushl $7 		# we want to get the square of 7
	call square		# call square
	addl $4, %esp		# scrub off the value pushed on stack
	movl %eax, %ebx		# result will be return value of program
	movl $1, %eax		# prepare to make exit system call
	int $0x80		# exit

square:
	pushl %ebp		# push old base pointer value onto stack
	movl %esp, %ebp		# make %ebp point to current stack frame
	movl 8(%ebp), %eax	# copy parameter to %eax
	imull 8(%ebp), %eax	# multiply by itself
	movl %ebp, %esp		# restore stack pointer
	popl %ebp		# restore base pointer to previous value
	ret
	