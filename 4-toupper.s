# Purpose - Converts an input file to an output file with all letters converted to uppercase
#
# Processing - 	1. open the input file
#		2. open the output file
# 		3. While we are not at the end of the input file
# 			a. read part of the file into memory buffer
# 			b. go through each byte of the input 
# 				-if byte is lowercase letter, convert to uppercase letter
# 			c. write memory buffer to output file

.section .data

#### CONSTANTS ######

# system call numbers
	.equ SYS_OPEN, 5
	.equ SYS_WRITE, 4
	.equ SYS_READ, 3
	.equ SYS_CLOSE, 6
	.equ SYS_EXIT, 1

# options for open syscall
# /usr/include/asm/fcntl.h

	.equ O_RDONLY, 0
	.equ O_CREAT_WRONLY_TRUNC, 03101

# standard file descriptors
	.equ STDIN, 0
	.equ STDOUT, 1
	.equ STDERR, 2

# system call interrupt
	.equ LINUX_SYSCALL, 0x80

	.equ END_OF_FILE, 0  # Return value of read which means we have hit EOF
	.equ NUMBER_ARGUMENTS, 2

.section .bss
# Buffer - this is where data is loaded into from input file, and written from into output file.
# 	Should never exceed 16,000 for various reasons.
# 	Doesn't occupy space in the executable

	.equ BUFFER_SIZE, 500
	.lcomm BUFFER_DATA, BUFFER_SIZE

.section .text
	
	# stack positions
	.equ ST_SIZE_RESERVE, 8
	.equ ST_FD_IN, -4
	.equ ST_FD_OUT, -8
	.equ ST_ARGC, 0  # number of arguments
	.equ ST_ARGV_0, 4  # name of program
	.equ ST_ARGV_1, 8  # input file name
	.equ ST_ARGV_2, 12  # output file name

.globl _start
_start:
	## intitialize program ##
	# save stack pointer
	movl %esp, %ebp

	# allocate space for file descriptors on stack
	subl $ST_SIZE_RESERVE, %esp

open_files:
open_fd_in:
	## open input file ##
	# open syscall
	movl $SYS_OPEN, %eax
	# address of input file name into %ebx
	movl ST_ARGV_1(%ebp), %ebx
	# read-only flag
	movl $O_RDONLY, %ecx
	# this really doesn't matter for reading (permission set)
	movl $0666, %edx
	# call Linux
	int $LINUX_SYSCALL

store_fd_in:
	# save the given file descriptor
	movl %eax, ST_FD_IN(%ebp)

open_fd_out:
	## open output file##

	# open the file
	movl $SYS_OPEN, %eax
	# address of output filename onto %ebx
	movl ST_ARGV_2(%ebp), %ebx
	# flags for writing to the file
	movl $O_CREAT_WRONLY_TRUNC, %ecx
	# permission set for new file (if it is created)
	movl $0666, %edx
	# call linux
	int $LINUX_SYSCALL

store_fd_out:
	# store file descriptor here
	movl %eax, ST_FD_OUT(%ebp)

	## begin main loop ##
read_loop_begin:

	## read in a block from the input file ##
	movl $SYS_READ, %eax
	# get the input file descriptor
	movl ST_FD_IN(%ebp), %ebx
	# the location to read into
	movl $BUFFER_DATA, %ecx
	# the size of the buffer
	movl $BUFFER_SIZE, %edx
	int $LINUX_SYSCALL
	# size of the buffer read is returned in %eax

	## Exit if we've reached the end ##
	# check for end of file marker
	cmpl $END_OF_FILE, %eax
	# if found or on error goto the end
	jle end_loop

continue_read_loop:
	## convert the block to upper case ##
	pushl $BUFFER_DATA	# location of buffer
	pushl %eax		# size of the input
	call convert_to_upper
	popl %eax		# get the input size back
	addl $4, %esp		# scrub off location of buffer from stack

	## write the block out to the output file ##

	# size of the buffer
	movl %eax, %edx
	movl $SYS_WRITE, %eax
	# file to use
	movl ST_FD_OUT(%ebp), %ebx
	# location of buffer start
	movl $BUFFER_DATA, %ecx
	int $LINUX_SYSCALL

	## continue the loop
	jmp read_loop_begin
	
end_loop:
	## close the files ##
	movl $SYS_CLOSE, %eax
	movl ST_FD_OUT(%ebp), %ebx
	int $LINUX_SYSCALL

	movl $SYS_CLOSE, %eax
	movl ST_FD_IN(%ebp), %ebx
	int $LINUX_SYSCALL

	## EXIT ##
	movl $SYS_EXIT, %eax
	movl $0, %ebx
	int $LINUX_SYSCALL


	# Purpose - this function does the actual conversion of block to uppercase
	#
	# Input - The first parameter is the location of the block to convert
	#	The second parameter is the length of the buffer
	#
	# Output - The current buffer is overwritten with the upper-classified version
	#
	# Variables:
	# 	%eax - the beginning of the buffer
	# 	%ebx - the length of the buffer
	# 	%edi - current buffer offset
	# 	%cl - the current byte being examined (first part of %ecx)

	## CONSTANTS ##
	# The lower boundary of our search
	.equ LOWERCASE_A, 'a'
	# the upper boundary of our search
	.equ LOWERCASE_Z, 'z'
	# conversion between lowercase and uppercase
	.equ UPPER_CONVERSION, 'A' - 'a'

	## stack stuff ##
	.equ ST_BUFFER_LEN, 8  	# length of the buffer
	.equ ST_BUFFER, 12	# actual buffer

convert_to_upper:	
	pushl %ebp
	movl %esp, %ebp

	## set up variables ##
	movl ST_BUFFER(%ebp), %eax
	movl ST_BUFFER_LEN(%ebp), %ebx
	movl $0, %edi

	# if a buffer with zero length was given, exit
	cmpl $0, %ebx
	je end_convert_loop

convert_loop:
	# get the current byte
	movb (%eax, %edi,1), %cl

	# go to the next byte unless between 'a' and 'z'
	cmpb $LOWERCASE_A, %cl
	jl next_byte
	cmpb $LOWERCASE_Z, %cl
	jg next_byte

	# otherwise, convert the byte to uppercase
	addb $UPPER_CONVERSION, %cl
	# and store it back
	movb %cl, (%eax, %edi, 1)

next_byte:
	incl %edi		# increment index
	cmpl %edi, %ebx		# continue until we've reached the end
	jne convert_loop

end_convert_loop:
	# no return value, just leave
	movl %ebp, %esp
	popl %ebp
	ret
