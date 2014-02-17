# Purpose - Given a number, this program computes it's factorial
#
# Shows how to call a function recursively

.section .data

.section .text

.globl _start
.globl factorial 		# would be useful if we want to share this function among other programs
	
_start:
	pushl $4		# we want to get the factorial of 4
	call factorial		# run the factorial function
	addl $4, %esp		# scrub the parameter pushed onto stack
	movl %eax, %ebx		# move answer to %ebx so as to return answer as exit status
				# function return values are always stored in %eax
	movl $1, %eax		# prepare to exit
	int $0x80		

# Purpose - Computes the factorial of the given parameter
#
# Input - a number whose factorial to compute
# Output - The factorial of the parameter
#
# 
#		
.type factorial, @function
factorial:
	pushl %ebp		# push old base pointer onto stack
	movl %esp, %ebp		# point to current stack frame
	movl 8(%ebp), %eax	# move argument to %eax
	cmpl $1, %eax		# check if base case
	je end_factorial
	decl %eax		# else, decrement by 1
	pushl %eax		# push for next call
	call factorial
	movl 8(%ebp), %ebx	# %eax has return value, so reload parameter onto %ebx
	imull %ebx, %eax	# multiply factorial of parameter - 1 by parameter
				# answer stored in %eax 

end_factorial:
	movl %ebp, %esp		# restore stack pointer
	popl %ebp
	ret
