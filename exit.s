# Purpose: Simple program that returns status code back to the Linux kernel
	
# Demonstrates assembly language program structure and the exit linux system call

# Input: None

# Output: returns a status code. This can be viewed by typing
#
#         echo $?
#
#         after running the program

# Variables:
# 	    %eax holds the system call number
# 	    %ebx holds the return status

	
.section .data		# Data section

.section .text		# Code section
	
.globl _start 		# instruct assembler `_start` is an important symbol
			# not discarded after assembly
			# `_start` is a special symbol used by linker
	
_start:			# _start label
			# A label tells the assembler to make its symbol's value
			# the address of the next instruction/data after it
	
	movl $1, %eax	# this is the Linux kernel system call number for exiting a program

	movl $0, %ebx	# this is the status number to return to the operating system (required by the exit system call)

	int $0x80 	# wakes up the kernel to run the system call specified in %eax
