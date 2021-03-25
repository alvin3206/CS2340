# data segment
.data 
buffer: .space 23 # Buffer can contain 23 chars + null char 
prompt: .asciiz "\nEnter a 8 hexadecimal digits (0~9, A~F): "
errChar: .asciiz "\nError: Inputs contains invalid characters.\n"
errLength: .asciiz "\nError: Inputs lengths not 8 digits.\n"
errOpcode: .asciiz "\nError: Opcode is not recognized.\n"
result: .asciiz  "The opcode in decimal is  "

# text segment
.text
main:

# prompt for input
	li $v0, 4
	la $a0, prompt
	syscall
	
# read input string
	li $v0, 8 # read string
	la $a0, buffer  # load byte space into address
	li $a1, 23
	syscall
	move $t0, $a0 # t0 = string address
	move $t1, $a1 # t1 = 23, buffer length
	
# save t0, t1 on stack
	addi $sp, $sp, -8
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	
# s0 = i, as a counter for iteration
	add $s0, $zero, $zero # reset s0 to 0
	
# iterate chars of string	
iterStr:
	add  $t5, $t0, $s0 # address of inputString[i] in t5
	lbu $t2, 0($t5) # t2 = inputString[i]
	beq $t2, $zero, opcodeCheck # null, terminator
	beq $t2, 10, opcodeCheck # \n, newline
	addi $t2, $t2, -48 # A:65, F:70, a:97, f:102, 0:48, 9:57 -> A:17, F:22, a:48, f:54, 0:0, 9:9
	ble $t2, -1, errorChar # character likes: !#()
	jal upperCase
checker:
	jal checkIndex
	addi $s0, $s0, 1 
	j iterStr
	
# non decimal character
upperCase:
	ble  $t2, 9, checker # if 0 <= t2 <= 9, continue to checker
	addi $t2, $t2, -7 # A:17, F:22, a:48, f:54 -> A:10, F:15, a:42, f:47
	ble $t2, 9, errorChar # character likes: <=>?@
	bge $t2, 16, lowerCase
	jr $ra # go to checker
	
lowerCase:
	addi $t2, $t2, -32 # a:42, f:47 -> a:10, f:15
	ble $t2, 9, errorChar # character likes: GHI]\[^
	bge $t2, 16, errorChar # character likes: ghi~{}
	jr $ra # go to checker

# check 0 & 1 index
checkIndex:
	beq  $s0, 0, storeOp0 # if s0 position is at first char, go to storeOp0
	beq $s0, 1, storeOp1 # if s0 position is at second char, go to storeOp1
	jr $ra

# store first character
storeOp0:
	move $t3, $t2
	jr $ra
	
# store second character	
storeOp1:
	move $t4, $t2
	jr $ra
	
# Container invalid characters
errorChar:
	li $v0, 4
	la $a0, errChar
	syscall
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	j main
	
# String length not equal to 8	
errorLength:
	beq $s0, $zero, exit # if empty, exit
	li $v0, 4
	la $a0, errLength
	syscall
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	j main
	
# Opcode isn't recognized
errorOpcode:
	li $v0, 4
	la $a0, errOpcode
	syscall
	
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	j main

# check and convert opcode
opcodeCheck:
	ble $s0, 7, errorLength # check s0 (length), \n and 00 is already excluded
	bge $s0, 9, errorLength # check s0 (length), \n and 00 is already excluded
	sll $t3, $t3, 4 # shift left 4 bits
	or  $t6, $t3, $t4 # use "or" to combine two 4-bit to one 8-bit
	srl $t6, $t6, 2 # shift right 2 bits to get first 6 bits of the 8 bits
	beq $t6, 0, opcodePrint # check opcode is 0
	beq $t6, 35, opcodePrint # check opcode is 35 (lw)
	beq $t6, 43, opcodePrint # check opcode is 45 (sw)
	j errorOpcode # not match to above cases


# print string & opcode
opcodePrint:
	# print description
	li $v0, 4
	la $a0, result
	syscall
	# print opcode
	move $a0, $t6
	li $v0, 1
	syscall

# exit
exit:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	addi $sp, $sp, 8
	li $v0, 10
	syscall