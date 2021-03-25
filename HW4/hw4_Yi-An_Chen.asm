# data segment
.data
prompt: .asciiz "\nGive me your zip code (0 to stop): "
result: .asciiz "\nThe sum of all digits in your zip code is"
resultIt: .asciiz  "\nITERATIVE: "
resultRe: .asciiz  "\nRECURSIVE: "

# text segment
.text
main:

	# Prompt for input
	li $v0, 4
	la $a0, prompt
	syscall
	
	# Read input zip code integer to $s0
	li $v0, 5 
	syscall
	move $s0, $v0
	
	# If 0, branch exit
	beq $s0, $zero, exit
	
	# Store t-registers
	addi $sp, $sp, -12
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	
	# Move $s0 (zip code) to argument $a0	
	move $a0, $s0
	# Call function int_digits_sum
	jal int_digits_sum
	# Put return value $v0 to $s1
	move $s1, $v0
	
	# Print description
	li $v0, 4
	la $a0, result
	syscall
	li $v0, 4
	la $a0, resultIt
	syscall
	# Print result of int_digits_sum
	move $a0, $s1
	li $v0, 1
	syscall

	# ======================================
	
	# Move $s0 (zip code) to argument $a0
	move $a0, $s0
	# Set argument $a1 to be 0
	add $a1, $zero, $zero
	# Call function rec_digits_sum
	jal rec_digits_sum
	# Put return value $v0 to $s1
	move $s1, $v0

	# Print description
	li $v0, 4
	la $a0, resultRe
	syscall
	# Print result
	move $a0, $s1
	li $v0, 1
	syscall
	
	# Restore t-registers
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	addi $sp, $sp, 12
	
	# Restart the prompt
	j main

	

	

# exit
exit:
	li $v0, 10
	syscall
				
# Use: $t0, $t1, $t2	
int_digits_sum:
	# Move argument $a0 to $t0
	move $t0, $a0
	
	# Save s-registers
	addi $sp, $sp, -8
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	# Set sum to 0 ($s1) and divisor to 10 ($s0)
	addi $s0, $zero, 10
	add $s1, $zero, $zero

# Part 1 of the function int_digits_sum
i1:
	# $t0 divided by 10
	div $t0, $s0
	# $t2 is remainder
	mfhi $t2
	# Add mod to sum
	add $s1, $s1, $t2
	# $t1 is quotient
	mflo $t1
	# branch to Part 2 if $t1 is 0
	beq $t1, $zero, i2
	# Renew dividend to be quotient
	move $t0, $t1
	# Back to Part 1 to start a new loop
	j i1
	
# Part 2 of the function int_digits_sum
i2:	
	# Put sum result to $v0
	move $v0, $s1
	# Restore s-registers
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 8
	jr $ra
	

# Use: t0
rec_digits_sum:
	# Save $ra (return address),  a-registers(arguments) and s-registers
	addi $sp, $sp, -20
	sw $ra, 16($sp)
	sw $a0, 12($sp)
	sw $a1, 8($sp)
	sw $s1, 4($sp)
	sw $s0, 0($sp)
	
	# When $a0 != 0, branch Part 1
	bne $a0, $zero, r1
	# When $a0 = 0
	add $v0, $a0, $a1
	addi $sp, $sp, 20
	jr $ra
	
# Part 1 of the function rec_digits_sum
r1:
	# Set sum to 0 ($s1) and divisor to 10 ($s0)
	addi $s0, $zero, 10
	add $s1, $zero, $zero
	# $a0 divided by 10
	div $a0, $s0
	# $a0 is quotient (as a input for recursive function)
	mflo $a0
	# $a1 is remainder (as a input for recursive function)
	mfhi  $a1
	jal rec_digits_sum
	
	# Restore $ra (return address),  a-registers(arguments) and s-registers
	lw $ra, 16($sp)
	lw $a0, 12($sp)
	lw $a1, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 20
	
	# $v0 = a1 + rec_digits_sum(a0, a1) -> remainder now + return value of recursive function call
	add $v0, $a1, $v0
	jr $ra
