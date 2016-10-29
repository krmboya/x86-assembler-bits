	# Print hello world and exit

	.data

hello_world_string:
	.ascii	"Hello, world!"

	.text

	.globl _start

_start:
	# Load all the arguments for write
	movl $4, %eax   		# syscall no for write()
	movl $1, %ebx			# first argument, file descriptor
	movl $hello_world_string, %ecx	# second argument, buffer
	movl $13, %edx			# third argument, string length
	int $0x80

	# Exit gracefully
	movl $1, %eax
	movl $0, %ebx
	int $0x80
