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

	movl $hello_world_string, %esi  # copy address to register esi
	movl $destination, %edi

	movsb
	movsw
	movsl

	# - Setting/clearing the DF flag

	std #  set the DF flag
	cld #  clear the DF flag


	# - Using Rep

	movl $hello_world_string, %esi
	movl $destination_using_rep, %edi
	movl $12, %ecx  # set string length in ecx
	rep movsb
	std

	# - Loading string from memory into eax register

	cld
	leal hello_world_string, %esi
	lodsb
	movb $0, %al

	dec %esi
	lodsw
	movw $0, %ax

	subl $2, %esi  # make esi point back to original string
	lodsl

	# - Storing strings from eax to memory

	leal destination_using_stos, %edi
	stosb
	stosw
	stosl

	# - Comparing strings

	cld
	leal hello_world_string, %esi
	leal H3110, %edi
	cmpsb

	dec %esi
	dec %edi
	cmpsw

	subl $2, %esi
	subl $2, %edi
	cmpsl

	# exit()
	movl $1, %eax
	movl $0, %ebx
	int $0x80
