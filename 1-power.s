# Purpose: Program to illustrate how functions works
# 	   This program will compute the value of 2^3 + 5^2 + 3^2
#
#
# Everything in the main program is stored in registers,
# so the data section doesn't have anything.

.section .data

.section .text

.globl _start
	
_start:			
			# First function call
	pushl $3	# push the second argument
	pushl $2 	# push the first argument
	call power	# call function `power`
			# pointer in %eip (address of the next instruction) is pushed to stack
			# value of %eip changed to address of power
	
	addl $8, %esp	# Move the stack pointer back clearing the earlier passed in parameters
	
	pushl %eax	# save the first answer before calling the next function

			# Second function call
	pushl $2	# push the second argument
	pushl $5 	# push the first argument
	call power	# call the function again
	
	addl $8, %esp	# move the stack pointer back clearing the passed in parameters

	pushl %eax	# push the second answer onto stack

			# Third function call
	pushl $2	# push the second argument
	pushl $3 	# push the first argument
	call power
	addl $8, %esp	# point back to second answer

	popl %ebx	# the third answer is already in %eax
			# pop the second answer from the stack onto %ebx

	addl %eax, %ebx	# add them together and store the result in %ebx
	popl %eax	# pop the first answer into %eax
	addl %eax, %ebx	# add it into the sum of the other two

	movl $1, %eax	# syscall number for exit	
	int $0x80	


# Purpose: 	Calculates the value of a number raised to a power.
#
# Input: 	First argument: the base number
#	 	Second argument: The power to raise it to
#
# Output: 	Will give the result as a return value
# Notes:	The power must be 1 or greater
#
# Variables: 	%ebx - holds the base number
# 		%ecx - holds the power
#
# 		-4(%ebp) - holds the current result (base pointer addressing mode)
#	
# 		%eax is used for temporary storage

.type power, @function  	# tells linker to treat power as a function
power:
	pushl %ebp		# save the old base pointer
	movl %esp, %ebp		# Make current stack pointer the current base pointer
				# Used to easily access the parameters passed in
	
	subl $4, %esp		# make room for our local storage (1 word 4 bytes long)

	movl 8(%ebp), %ebx	# put the first argument in %ebx (using base pointer addressing mode)
	movl 12(%ebp), %ecx 	# put the second argument in %ecx

	movl %ebx, -4(%ebp)	# store the current result

power_loop_start:
	cmpl $1, %ecx		# if power is 1, we are done
	je end_power
	movl -4(%ebp), %eax	# move current result to %eax
	imull %ebx, %eax	# multiply current result by base number
	movl %eax, -4(%ebp)	# store current result

	decl %ecx		# decrease the power
	jmp power_loop_start	# run the next power

end_power:
	movl -4(%ebp), %eax	# move final value to %eax
	movl %ebp, %esp		# restore stack pointer
	popl %ebp		# restore base pointer
	ret			# return address popped off stack and into %eip
