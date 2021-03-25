# data segment
.data 
promptX: .asciiz "Enter a 32-bit integer, X: "
promptY: .asciiz "Enter a 32-bit integer, Y: "
result: .asciiz  "The difference of X and Y (X - Y) is "

#text segment
.text
main:

#prompt for input X
	li $v0, 4
	la $a0, promptX
	syscall
	
#read input int for X
	li $v0, 5 
	syscall
	move	 $t0, $v0
	
#prompt for input Y
	li $v0, 4
	la $a0, promptY
	syscall
	
#read input int for Y
	li $v0, 5 
	syscall
	move $t1, $v0
		
#calculate the difference of X & Y
	sub 	$s0, $t0, $t1
	
#print the result heading
	li $v0, 4
	la $a0, result
	syscall

#print the result integer
	move $a0, $s0
	li $v0, 1
	syscall
	
#exit
	li $v0, 10
	syscall