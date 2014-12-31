# Purpose: This program finds the maximum number in a set of numbers
#
# Variables: The registers have the following uses:
#  %edi - Holds the index of the data being examined
#  %ebx - Largest data item found so far
#  %eax - Current data item
#
# The following memory locations are used:
#
# data_items - contains the item data. A 0 is used to terminate the data
#

.section .data

data_items:  	# These are the data items
	.long 3, 67, 34, 255, 45, 75, 54, 34, 44, 33, 22, 11, 66, 0

.section .text
	
.globl _start

_start:	
	movl $0, %edi			# move 0 to the index register
					# (immediate and register addressing modes resp.)
	movl data_items(,%edi,4), %eax	# load the first byte of data
					# (1st operand is indexed-addressing mode)
	movl %eax, %ebx			# since this is the first item,
					# %eax is the biggest item so far

start_loop:				# start loop
	cmpl $0, %eax			# check if we've reached the end
	je loop_exit			# status is read from the %eflags register
					# if equal, exit since end has been reached
	incl %edi			# increment index
	movl data_items(,%edi,4), %eax 	# load next value, uses indexed addressing mode
	cmpl %ebx, %eax			# compare value with largest
	jle   start_loop		# Checks the %eflags register
					# jump to beginning of loop if current isn't larger
	movl %eax, %ebx			# make current value the largest
	jmp start_loop			# jump to beginning of loop

loop_exit:
	# %ebx is the status code for the exit system call
	# and it already has a maximum number
	movl $1, %eax			# 1 is the exit system call
	int $0x80
