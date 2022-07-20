.data
prompt:	.asciiz "Enter upper bound: "
prompt2:	.asciiz "Enter lower bound: "
nl:	.asciiz "\n"

	.text
	.ent main
	.globl main
	
main:	#adjust the stack
	addiu $sp, $sp, -16
	sw $ra, 12($sp)		# push ra
	sw $s0, 8($sp)		# push hi
	sw $s1, 4($sp)		# push lo
	sw $s2, 0($sp)		# push i


	# ask the user for the lower bound
	li $v0, 4		# print_string
	la $a0, prompt2		# a0 = "Enter lower bound"
	syscall

	# read in the lower bound
	li $v0, 5		# read_int
	syscall
	move $s1, $v0		# s1 = lo

	# ask the user for the upper bound
	li $v0, 4		# print_string
	la $a0, prompt		# a0 = "Enter upper bound"
	syscall

	# read in the upper bound
	li $v0, 5		# read_int
	syscall
	move $s0, $v0		# s0 = hi

	li $s2, 1		# i = 1



	move $s2, $s1		#int i = lo

for:	bgt $s2, $s0, exitFor	# exit if i > hi


	li $v0, 11		# print_string
	move $a0, $s2		# a0 = Ascii value of i
	syscall

	li $v0, 4		# print_string
	la $a0, nl		# a0 = "\n"
	syscall

	# increment i
	addi $s2, $s2, 1	# i += 1
	j for

exitFor:# re-adjust the stack
	lw $s2, 0($sp)		# pop i
	lw $s1, 4($sp)		# pop lo
	lw $s0, 8($sp)		# pop hi
	lw $ra, 12($sp)		# pop ra
	addiu $sp, $sp, 16

	li $v0, 0
	jr $ra
	.end main
