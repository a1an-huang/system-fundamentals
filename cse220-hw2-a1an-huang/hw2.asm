########### Alan Huang ############
########### alanhuang ################
########### 113443530 ################

###################################
##### DO NOT ADD A DATA SECTION ###
###################################

.text
.globl substr
substr:
 	li $v0, 0 #default output
 	add $t0 $0, $a0 #starting address
 	li $t2, 0 #counter
 	find_length:
 		lbu $t1, 0($t0) 
 		beqz $t1, check_bounds
 		addi, $t2, $t2, 1 #add to counter
 		addi, $t0, $t0, 1 #traverse
 		j find_length
 	check_bounds:
 	bltz $a1, out_of_bounds
 	bltz $a2, out_of_bounds
 	bgt $a2, $t2, out_of_bounds
 	li $t2, 0 #counter
 	add $t0 $0, $a0
 	loop:
 		bgt $t2, $a2, done
 		lbu $t1, 0($t0)
 		bge $t2, $a1, check_upper
 		j traverse_string
 		check_upper:
 			beq $t2, $a2, set_null
 			j append_char
 			set_null:
 				sb $0, 0($a0)
 				j traverse_string
 			append_char:
 			 	sb $t1, 0($a0)
 				addi $a0, $a0, 1
 		traverse_string:
 			addi $t2, $t2, 1
 			addi $t0, $t0, 1
 		j loop
out_of_bounds:
	li $v0, -1
done:
	jr $ra
	
.globl encrypt_block
encrypt_block:
	addi $sp, $sp, -32
	sw $t5, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $t3, 16($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	li $t2, 0
	li $t3, 0
	li $t4, 0 #counter
	li $t5, 4
	loop1:
		beq $t4, $t5,done1
		lbu $t0, 0($a0)
		lbu $t1, 0($a1)
		sll $t2, $t2, 8
		sll $t3, $t3, 8
		add $t2, $t2, $t0
		add $t3, $t3, $t1
		addi $t4, $t4, 1
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		j loop1
done1:
	xor $t7, $t2, $t3
	addi $v0, $t7, 0
	lw $t5, 28($sp)
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 32
	jr $ra

.globl add_block
add_block:
	addi $sp, $sp, -32
	sw $t5, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $t3, 16($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	li $t1, 4
	mul $t0, $a1, $t1
	add $t0, $t0, $a0
	li $t2, 0
	li $t3, 4
	loop2:
		beq $t2, $t3, done2
		li $t5, 0x000000FF
		and $t4, $a2 ,$t5
		sb $t4, 0($t0)
		srl $a2, $a2, 8
		addi $t2, $t2, 1
		addi $t0, $t0, 1
	j loop2
done2:
	lw $t5, 28($sp)
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 32
 	jr $ra

.globl gen_key
gen_key:
	addi $sp , $sp, -28
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $t3, 16($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	li $t1, 4
	mul $t0, $a1, $t1
	add $t0, $t0, $a0
	li $t3, 0
	
	for6:
		beq $t3, $t1, done6
		addi $a1, $0, 127
		addi $v0, $0, 42
		syscall
		
		
		sb $a0, 0($t0)
		addi $t3, $t3, 1
		addi $t0, $t0, 1
		j for6
	done6:
	lw $t0, 0($sp)
	lw $t1, 4($sp)
	lw $t2, 8($sp)
	lw $t3, 16($sp)
	lw $s1, 20($sp)
	lw $s0, 24($sp)
	
	addi $sp , $sp, 28
jr $ra

.globl encrypt
encrypt:
	#padding extra chrs if nchar%4 != 0
	addi $sp, $sp, -12
	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	li $t0, 4
	div $a3, $t0
	mfhi $t1
	mflo $t2
	addi $t4, $t2, 1	
	mul $t2, $t2, $t0
	add $t2, $t2, $t1
	sub $t1, $t0, $t1
	add $t2, $t2, $a0
	li $t3, 0
	loop4:
		beq $t3, $t1, done4
		lbu $t0, 0($t2)
		
		addi $a1, $0, 255
		addi $v0, $0, 42
		syscall
		
		
		sb $a0, 0($t2)
		
		addi $t3, $t3, 1
		addi $t2, $t2, 1
		j loop4
	done4:
		sb $0, 0($t2)
	
 		lw $a2, 0($sp)
 		lw $a1, 4($sp)
 		lw $a0, 8($sp)
 		addi $sp, $sp, 12
	#gen key starting at base addr
 	addi $sp, $sp, -32
 	sw $t4, 28($sp)
 	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $t2, 16($sp)
 	sw $ra, 12($sp)
 	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
	add $s1, $t4, $0
 	li $s0, 0 #counter
 	addi $t2,$a1, 0
 	for5:	
 		beq $s0, $s1, done5
 		move $a0, $t2
 		li $a1, 0 
 		addi $a1, $s0, 0
 		jal gen_key
 		
		addi $s0, $s0, 1
 		j for5
 	done5:
 		lw $t4, 28($sp)
 		lw $s0, 24($sp)
		lw $s1, 20($sp)
		lw $t2, 16($sp)
 		lw $ra, 12($sp)
 		lw $a0, 8($sp)
		lw $a1, 4($sp)
		lw $a2, 0($sp)
 		addi $sp, $sp, 32
 	addi $sp, $sp, -32
     sw $t4, 28($sp)
     sw $s0, 24($sp)
    sw $s1, 20($sp)
    sw $s3, 16($sp)
     sw $ra, 12($sp)
     sw $a0, 8($sp)
    sw $a1, 4($sp)
    sw $a2, 0($sp)
     li $s0, 0
     addi $t0, $a0, 0 
     addi $t1, $a1, 0 
     addi $t2, $a2, 0
     addi $s1, $t4, 0
     for7:
        beq $s0, $s1, done7
        move $a0, $t0
        move $a1, $t1
        jal encrypt_block
        move $a0, $t2
        move $a1, $s0
        move $a2, $t7
        jal add_block
        addi $s0, $s0, 1
        addi $t0, $t0, 4
        addi $t1, $t1, 4

         j for7
     done7:
        lw $t4, 28($sp)
       	lw $s0, 24($sp)
       	lw $s1, 20($sp)
       	lw $s3, 16($sp)
        lw $ra, 12($sp)
        lw $a0, 8($sp)
        lw $a1, 4($sp)
        lw $a2, 0($sp)
        addi $sp, $sp, 32
     
	
		
 	jr $ra

.globl decrypt_block
decrypt_block:
	addi $sp, $sp, -32
	sw $s3, 28($sp)
	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $t3, 16($sp)
	sw $t2, 8($sp)
	sw $t1, 4($sp)
	sw $t0, 0($sp)
	li $t2, 0
	li $t3, 0
	li $t4, 0 #counter
	li $t5, 4
	loop3:
		beq $t4, $t5,done3
		lbu $t0, 0($a0)
		lbu $t1, 0($a1)
		sll $t2, $t2, 8
		srl $t3, $t3, 8
		add $t2, $t2, $t0
		sll $t1, $t1, 24
		add $t3, $t3, $t1
		addi $t4, $t4, 1
		addi $a0, $a0, 1
		addi $a1, $a1, 1
		j loop3
done3:
	xor $t7, $t2, $t3
	addi $v0, $t7, 0
	lw $s3, 28($sp)
	lw $s0, 24($sp)
	lw $s1, 20($sp)
	lw $t3, 16($sp)
	lw $t2, 8($sp)
	lw $t1, 4($sp)
	lw $t0, 0($sp)
	addi $sp, $sp, 32
 	jr $ra
.globl decrypt
decrypt:
    addi $sp, $sp, -32
 	sw $s3, 28($sp)
 	sw $s0, 24($sp)
	sw $s1, 20($sp)
	sw $t2, 16($sp)
 	sw $ra, 12($sp)
 	sw $a0, 8($sp)
	sw $a1, 4($sp)
	sw $a2, 0($sp)
    li $t0, 4
    div $a2, $t0
    mflo $s1
    li $s0, 0
    addi $t1, $a0,0
    addi $t2, $a1,0
    addi $t3, $a3,0
    for8:
        beq $s0, $s1, done8
        move $a0, $t1
        move $a1, $t2
        jal decrypt_block
        move $a0, $t3
        move $a1, $s0
        move $a2, $t7
        jal add_block
        addi $s0, $s0, 1
    	 addi $t1, $t1, 4
        addi $t2, $t2, 4
        j for8
    done8:
    	lw $s3, 28($sp)
       	lw $s0, 24($sp)
       	lw $s1, 20($sp)
       	lw $t3, 16($sp)
        lw $ra, 12($sp)
        lw $a0, 8($sp)
        lw $a1, 4($sp)
        lw $a2, 0($sp)
        addi $sp, $sp, 32
	
 jr $ra

