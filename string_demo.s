	.data

hello_world_string:
	.asciz "Hello Assembly world!"
H3110:
	.asciz "H3110"




	.bss

	.lcomm destination, 100
	.lcomm destination_using_rep, 100
	.lcomm destination_using_stos, 100




	.text

	.globl _start

_start:
	nop
	# - Simple copying using movsb, movsw, movsl

	movl $hello_world_string, %esi  # copy source address to esi
	movl $destination, %edi  # copy destination address to edi

	movsb  # move single byte - esi/edi incremented by 1
	movsw  # move 2 bytes  - esi/edi incremented by 2
	movsl  # move 4 bytes  - esi/edi incremented by 4

	# - Setting/clearing the DF flag (Destination Flag) in eflags register

	std #  set the DF flag  - esi/edi will decremented on movsx
	cld #  clear the DF flag  - esi/edi will be incremented


	# - Using Rep (Repeat)

	movl $hello_world_string, %esi
	movl $destination_using_rep, %edi
	movl $21, %ecx  # set string length in ecx
	rep movsb  # repeats movsb no of times specified in %ecx
	std

	# - Loading string from memory into eax register (using loadsx)

	cld
	leal hello_world_string, %esi  # load effective address to %esi
	lodsb  # load single byte into %eax
	movb $0, %al  # reset %eax

	dec %esi  # reset %esi
	lodsw  # load 2 bytes
	movw $0, %ax  # reset %eax

	subl $2, %esi  # make esi point back to original string
	lodsl  # load 4 bytes

	# - Storing strings from eax to memory (using stosx)

	leal destination_using_stos, %edi  # load dest address to edi
	stosb  # copy first byte from %eax
	stosw  # copy first two bytes from %eax
	stosl  # copy first 4 bytes from %eax

	# - Comparing strings

	cld
	leal hello_world_string, %esi  # load source address to esi
	leal H3110, %edi  # load destination address to edi
	cmpsb  # compare the first byte in both (zero flag ZF set in eflags)

	dec %esi  # reset esi
	dec %edi  # reset edi
	cmpsw  # compare first two bytes

	subl $2, %esi
	subl $2, %edi
	cmpsl  # compare first 4 bytes

	# exit(0)
	movl $1, %eax
	movl $0, %ebx
	int $0x80
