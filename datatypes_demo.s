	# Demo program to show how to use datatypes


	.data  # initialized data segment

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


	.bss  # uninitialized data segment

	.comm large_buffer, 10000


	.text  # program code segment

	.globl _start

_start:

	nop

	# - Move immediate value into register
	movl $10, %eax

	# - Move immediate value into memory location
	movw $50, int16

	# - Move data between registers
	movl %eax, %ebx

	# - Move data from memory to register
	movl int32, %eax

	# - Move data from register to memory
	movb $3, %al
	movb %al, byte_location

	# - Move data into indexed memory location
	# Location is decided by base_address(offset, index, datasize)
	# offset and index must be registers, datasize can be a numberic value

	movl $0, %ecx
	movl $2, %edi
	movl $22, integer_array(%ecx, %edi, 4)

	# - Indirect addressing using registers
	movl $int32, %eax
	movl (%eax), %ebx

	movl $9, (%eax)
	
	# exit syscall
	movl $1, %eax
	movl $0, %ebx
	int $0x80
