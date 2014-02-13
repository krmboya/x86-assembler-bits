# Purpose: Program to illustrate how functions works
# 	   This program will compute the value of 2^3 + 5^2
#
#
# Everything in the main program is stored in registers,
# so the data section doesn't have anything.

.section .data

.section .text

.globl _start
_start:
	push $3		# push the second argument
	push $2 	# push the first argument
	call power	# call the function
			# pointer in %eip (return address) is pushed to stack
			# value of %eip changed to address of power
	addl $8, %esp	# move the stack pointer back
	
	push %eax	# save the first answer before calling the next function

	push $2		# push the second argument
	push $5 	# push the first argument
	call power	# call the function
	addl $8, %esp	# move the stack pointer back

	popl %ebx	# the second answer is already in %eax
			# pop the first answer from the stack onto %ebx

	addl %eax, %ebx	# add them together and store the result in %ebx

	movl $1, %eax	# exit (%ebx is returned)
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

.type power, @function
power:
	pushl %ebp		# save the old base pointer
	movl %esp, %ebp		# make stack pointer the base pointer
	subl $4, %esp		# make room for our local storage

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
