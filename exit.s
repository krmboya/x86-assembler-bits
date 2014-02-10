# Purpose: Simple program that returns status code back to the Linux kernel

# Input: None

# Output: returns a status code. This can be viewed by typing
#
#         echo $?
#
#         after running the program

# Variables:
# 	    %eax holds the system call number
# 	    %ebx holds the return status

.section .data

.section .text
.globl _start
_start:
	movl $1, %eax	# this is the Linux kernel system call number for exiting a program

	movl $0, %ebx	# this is the status number to return to the operating system (required by the exit system call)

	int $0x80 	# wakes up the kernel to run the system call specified in %eax
	
	   