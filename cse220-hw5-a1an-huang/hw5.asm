############## Alan Huang ##############
############## 113443530 #################
############## alanhuang ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_term
create_term:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $t0, 20($sp)

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
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $t0, 20($sp)
	addi $sp, $sp, 24
		
  jr $ra

.globl create_polynomial
create_polynomial:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0
	move $s1, $a0
	move $s3, $a0
	li $s4, 0
	li $t9, 0 			#counter
	li $t7, 0
	li $t8, 0
	
	lw $t1, 0($a0)
	beqz $t1, check_exp				#checks for 0, -1
	j create_poly
	check_exp:
		lw $t1, 4($a0)
		li $t2, -1
		beq $t1, $t2, create_poly_err
	create_poly:
		move $t0, $a0
		
	check_exp_val:
		lw $t1, 0($t0)				#checks if its term is 0	
		beqz $t1, check_exp2
		li $t6, 0				#total term val
		lw $t1, 4($t0)
		addi $t2, $t0, 8
		j combine_term
		check_exp2:
			lw $t1, 4($t0)			#check if exponent is -1
			li $t2, -1
			beq $t1, $t2, create_poly_terms
			addi $t7, $t7, 1
			addi $t0, $t0, 8 		#next val in arr since the term is 0
			j check_exp_val
		combine_term:
			lw $t3, 0($t2)			#base case if its last term 0, -1
			beqz $t3, check_exp3
			lw $t3, 4($t2)
			j check_equal
			check_exp3:
				lw $t4, 4($t2)
				li $t5, -1
				beq $t4, $t5, combterm_done
				addi $t2, $t2, 8
				j combine_term
			check_equal:
				beq $t3, $t1, add_terms		#check if exp are equal
				j checkeq_done
				add_terms:
					addi $t8, $t8, 1
					lw $t4, 0($t0)
					lw $t5, 0($t2)
					add $t4, $t4, $t5
					sw $t4, 0($t0)
					sw $0, 0($t2)
			checkeq_done:
				addi $t2, $t2, 8
				j combine_term
		combterm_done:
			addi $t0, $t0, 8
		j check_exp_val
		
	create_poly_terms:
		bne $t8, $t7,create_poly_err
		lw $t2, 0($s0)
		beqz $t2, check_exp4
		lw $t3, 4($s0)
		j create_pol
		check_exp4:
			lw $t3, 4($s0)
			li $t4, -1
			beq $t3, $t4, null_found
			addi $s0, $s0, 8
			j create_poly_terms
		create_pol:
			move $a0, $t2
			move $a1, $t3
			jal create_term
			addi $t9, $t9, 1
			li $t6, -1
			beq $v0, $t6, create_poly_err
			move $s2, $v0
			beq $0, $s4, first_term
			j not_first
			first_term:
				sw $0, 8($s2)
				move $s3, $s2
				move $s4, $s2
				j create_pol_done
			not_first:
			
			sw $s2, 8($s3)
			
			move $s3, $s2
		create_pol_done:
		addi $s0, $s0, 8
		j create_poly_terms
		
	null_found:
		beq $s4, $0, create_poly_err
		
		li $a0, 8
		li $v0, 9
		
		syscall
		
		sw $s4, 0($v0)
		sw $t9, 4($v0)
		
		j create_poly_done
		

create_poly_err:
	li $v0, 0
		
create_poly_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24	
  jr $ra

.globl sort_polynomial
sort_polynomial:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0
	
	beqz $a0, sort_done
	
	lw $s1, 4($s0)		#num of terms
	lw $t0, 0($s0)		#pointer
	
	li $t2, 1
	outer_sort:
		bgt $t2, $s1, sort_done
		lw $t1, 4($t0)		#exp
		lw $t4, 8($t0)
		move $t3, $t2
		addi $t3, $t3, 1
		inner_sort:
			bgt $t3, $s1, inner_done
			lw $t5, 4($t4)
			bgt $t5, $t1, inner_swap
			j not_greater
			inner_swap:
			lw $t6, 0($t0)
			lw $t7, 0($t4)
			lw $t1, 4($t0)
			
			sw $t6, 0($t4)
			sw $t7, 0($t0)
			sw $t1, 4($t4)
			sw $t5, 4($t0)
			lw $t1, 4($t0)
			not_greater:
				lw $t4, 8($t4)
				addi $t3, $t3, 1
		j inner_sort
		inner_done:
			addi $t2, $t2, 1
			lw $t0, 8($t0)
	j outer_sort
	
sort_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24	
  jr $ra

.globl add_polynomial
add_polynomial:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s4, $a0
	
	beqz $a0, return_q
	beqz $a1, return_p
	
	lw $t0, 0($a0)
	lw $t1, 0($a1)
	
	beqz $t0, return_q
	beqz $t1, return_p
	
	j neither_null
	return_q:				#returns sorted q poly
		beqz $a1, both_null
		beqz $t1, both_null
		move $a0, $s1
		jal sort_polynomial
		move $s4, $a0
		j add_poly_done
	return_p:				#returns sorted p value
		move $a0, $s0
		jal sort_polynomial
		move $s4, $a0
		j add_poly_done
	neither_null:
		lw $s2, 4($s0)			#terms in p
		lw $s3, 4($s1)			#terms in q
		add $t3, $s2, $s3 		#total terms
		
		addi $t3, $t3, 1
		
		li $t4, 8			#total terms * 2 * 4 (2 *4) space for term and exp
		mul $t3, $t3, $t4
		
		move $a0, $t3			#allocate space in heap
		li $v0, 9
		syscall
		
		move $t0, $v0			#start of heap
		move $a0, $v0
		
		lw $t1, 0($s0)			#start of p
		lw $t2, 0($s1)			#start of q
		
		add_pheap:
			beqz $s2, p_adddone
			lw $t3, 0($t1)
			lw $t4, 4($t1)
			
			sw $t3, 0($t0)
			sw $t4, 4($t0)
			
			lw $t1, 8($t1)
			addi $s2, $s2, -1
			addi $t0, $t0, 8
		j add_pheap
		
		p_adddone:
		add_qheap:
			beqz $s3, q_adddone
			lw $t3, 0($t2)
			lw $t4, 4($t2)
			
			sw $t3, 0($t0)
			sw $t4, 4($t0)
			
			lw $t2, 8($t2)
			addi $s3, $s3, -1
			addi $t0, $t0, 8
		j add_qheap
		
		q_adddone:
			li $t3, 0
			li $t4, -1
			
			sw $t3, 0($t0)
			sw $t4, 4($t0)
			
			jal create_polynomial
			
			move $a0, $s0
			beqz $v0, both_null
			
			move $a0, $v0
			
			jal sort_polynomial
			
			move $s4, $a0
			j add_poly_done
both_null:
	li $a0, 8
	li $v0, 9
	syscall 
	move $a0, $v0
	
	move $s4, $a0
	sw $0, 0($a0)
	sw $0, 4($a0)
add_poly_done:
	move $v0, $s4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
  jr $ra

.globl mult_polynomial
mult_polynomial:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a0
	move $s1, $a1
	move $s4, $a0
	
	beqz $a0, both_null2
	beqz $a1, both_null2
	
	lw $t0, 0($a0)
	lw $t1, 0($a1)
	
	beqz $t0, both_null2
	beqz $t1, both_null2
	
	j neither_null2
	return_q2:				#returns sorted q poly
		beqz $a1, both_null2
		beqz $t1, both_null2
		move $a0, $s1
		jal sort_polynomial
		move $s4, $a0
		j mul_poly_done
	return_p2:				#returns sorted p value
		move $a0, $s0
		jal sort_polynomial
		move $s4, $a0
		j mul_poly_done
	neither_null2:
		lw $s2, 4($s0)			#terms in p
		lw $s3, 4($s1)			#terms in q
		mul $t3, $s2, $s3 		#total terms
		
		addi $t3, $t3, 1
		
		li $t4, 8			#total terms * 2 * 4 (2 *4) space for term and exp
		mul $t3, $t3, $t4
		
		move $a0, $t3			#allocate space in heap
		li $v0, 9
		syscall
		
		move $t0, $v0			#start of heap
		move $a0, $v0
		
		lw $t1, 0($s0)			#start of p
		lw $t2, 0($s1)			#start of q
		
		mul_outer:
			beqz $s2, mul_out_done
			lw $t3, 0($t1)
			lw $t4, 4($t1)
			move $t5, $s3
			move $t6, $t2
			mul_inner:
				beqz $t5, mul_inner_done
				
				lw $t7, 0($t6)
				lw $t8, 4($t6)
				j mul_normexp
				beqz $t4, zero_exp
				beqz $t8, zero_exp
				
				mul_normexp: 
					mul $t7, $t3, $t7
					add $t8, $t4, $t8
					
					sw $t7, 0($t0)
					sw $t8, 4($t0)
					j normexp_done
				zero_exp:
					mul $t7, $t3, $t7
					li $t8, 0
					
					sw $t7, 0($t0)
					sw $t8, 4($t0)
				normexp_done:
				lw $t6, 8($t6)
				addi $t5, $t5, -1
				addi $t0, $t0, 8
			j mul_inner
			mul_inner_done:
				lw $t1, 8($t1)
				addi $s2, $s2, -1
		j mul_outer
		
		mul_out_done:
			li $t3, 0
			li $t4, -1
			
			sw $t3, 0($t0)
			sw $t4, 4($t0)
			
			jal create_polynomial
			
			move $a0, $s0
			beqz $v0, both_null
			
			move $a0, $v0
			
			jal sort_polynomial
			
			move $s4, $a0
			j mul_poly_done
		
		
both_null2:
	li $a0, 8
	li $v0, 9
	syscall 
	move $a0, $v0
	
	move $s4, $a0
	sw $0, 0($a0)
	sw $0, 4($a0)
mul_poly_done:
	move $v0, $s4
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
  jr $ra
