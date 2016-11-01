	# Demo program to show how to use datatypes


	.data

hello_world:
	.ascii "Hello world!"

byte_location:
	.byte 10

int32:
	.int 2

int16:
	.short 3

float:
	.float 10.23

integer_array:
	.int 10,20,30,40,50


	.bss

	.comm large_buffer, 10000


	.text

	.globl _start

_start:

	nop

	# exit syscall
	movl $1, %eax
	movl $0, %ebx
	int $0x80
