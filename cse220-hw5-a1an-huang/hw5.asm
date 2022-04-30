############## FULL NAME ##############
############## SBUID #################
############## NETID ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term
create_term:
	move $t0, $a0
	
	beq $t0, $0, create_term_err 		#coefficent is 0
	blt $a1, $0, create_term_err		#exponent less than 0
	
	li $a0, 12				#allocate mem for heap
	li $v0, 9
	syscall					#addr of allocated heap in v0
	
	sw $t0, 0($v0)				#store coefficent at addr
	sw $a1, 4($v0)				#store exponent at addr + 4
	sw $0, 8($v0)				#store 0 for last 4 bytes
	j create_done
	
create_term_err:
	li $v0, -1 
	j create_done
create_done:	
  jr $ra

.globl create_polynomial
create_polynomial:
  jr $ra

.globl sort_polynomial
sort_polynomial:
  jr $ra

.globl add_polynomial
add_polynomial:
  jr $ra

.globl mult_polynomial
mult_polynomial:
  jr $ra
