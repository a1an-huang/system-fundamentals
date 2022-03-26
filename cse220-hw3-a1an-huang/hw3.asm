######### Alan Huang ##########
######### 113443530 ##########
######### 113443530 ##########

######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########
######## DO NOT ADD A DATA SECTION ##########

.text
.globl initialize
initialize:
	addi $sp $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $a0, 8($sp)
	sw $a1, 12($sp)
	sw $s2, 16($sp)
	sw $s3, 20($sp)
	
	move $s2, $a1
	move $t0, $a1
	
	li $v0, 13	
	li $a1, 0				#read file
	syscall
	move $s0, $v0
	
	li $t4, 0
	li $t5, 2
	
	rowcol_loop:
		beq $t4, $t5, rowcol_fin	#stops after checking row and col values
		
		li $v0, 14			#read from file
		move $a0, $s0
		move $a1, $t0
		li $a2, 1			#store into buffer
		syscall
		
		lbu $t1, 0($t0)
		li $t2, '\r'
		li $t3, '\n'
		beq $t1, $t2, rowcol_done 	#checking for /r & /n
		beq $t1, $t3, rowcol_done
		
		
		li $t2, '0'
		li $t3, '9'
		
		bgt $t1, $t2, check_less	#checking if row or col is less than 1 or greater than 9
		j init_error
		check_less:
			ble $t1, $t3, rowcol_cont
			j init_error
		
		rowcol_cont:
			addi $t1, $t1, -48
			sw $t1, 0($t0)
			move $s1, $t1		#col val
			addi $t4, $t4, 1       #only increment checking the row or col size   
			addi $t0, $t0, 4	#increment addr by 4 since its a word
		rowcol_done:			#doesnt incr addr if its /r or /n
		j rowcol_loop
	rowcol_fin:
		li $t4, 0			#counter
		lbu $s3, 0($s2)               	#row val
		mul $t5, $s3, $s1  		#total elem in matrix
		
	matrix_loop:
		beq $t4, $t5, init_verified
		
		li $v0, 14			#read from file 
		move $a0, $s0
		move $a1, $t0
		li $a2, 1			#store into buffer
		syscall
		
		lbu $t1, 0($t0)
		li $t2, '\r'
		li $t3, '\n'
		beq $t1, $t2, mtr_done 	#checking for /r & /n
		beq $t1, $t3, mtr_done
		
		li $t2, '0'
		li $t3, '9'
		bge $t1, $t2, check_upper	#checks if val greater or equal to 0
		j init_error
		check_upper:
		addi $t4, $t4, 1		#incr counter by 1
		ble $t1, $t3, matrix_done	#checks if val less than or equal to 9
		j init_error
		matrix_done:
			addi $t1, $t1, -48
			sb $t1, 0($t0)
			addi $t0, $t0, 4	#incr addr by 4 since its a word
		mtr_done:			#doesnt incr addr if its /r or /n
		j matrix_loop
init_error:
	li $v0, -1				#error while initializing
	move $t0, $s2
	li $t2, 1
	li $t3, 83
	li $t4, 0
	addi $t5, $t5, 2
	bge $t5, $t2, error_less
	j error_loop
	error_less:
	ble $t5, $t3, error_loop2
	error_loop:				#sets values to 0 if error is the val of row/wcol
		lbu $t1, 0($t0)
		beqz $t1, init_done
		sw $0, 0($t0)
		addi $t0, $t0, 4
	j error_loop
	error_loop2:				#sets values to 0 if error is part of the matrix
		beq $t4, $t5, init_done
		sw $0, 0($t0)
		addi $t0, $t0, 4
		addi $t4, $t4, 1
	j error_loop2
init_verified:
	li $v0, 1				#initialized normally
init_done:
	lw $s3, 20($sp)
	lw $s2, 16($sp)
	lw $a1, 12($sp)
	lw $a0, 8($sp)
	lw $s1, 4($sp)
	lw $s0, 0($sp)
	addi $sp, $sp, 24 
	jr $ra

.globl write_file
write_file:
	addi $sp, $sp -16
	sw $s0, 0($sp)
	sw $a0, 4($sp)
	sw $a1, 8($sp)
	sw $s2, 12($sp)
	
	move $t0, $a1
	
	li $v0, 13
	li $a1, 1				#write file
	syscall
	move $s0, $v0
	
	lw $t1, 0($t0)				#get # of rows
	add $t3, $0, $t1			#add val to t3
	addi $t1, $t1, '0'			#convert back to ascii val
	sw $t1, 0($t0)
	
	li $v0, 15				#write to file
	move $a0, $s0
	move $a1, $t0				#val being written
	li $a2, 1				#write to file
	syscall	
	
	li $t1, '\n'
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	
	li $v0, 15				#write to file
	move $a0, $s0
	move $a1, $sp				#newline
	li $a2, 1				#write to file
	syscall
			
	addi $sp, $sp, 4
	
	addi $t0, $t0, 4 
	lw $t2, 0($t0)				#get # of cols
	mul $t3, $t2, $t3			#get size of matrix
	addi $t2, $t2, '0'			#convert back to asci val
	
	sw $t2, 0($t0)
	li $v0, 15				#write to file
	move $a0, $s0
	move $a1, $t0				#val being written
	li $a2, 1				#write to file
	syscall
	
	li $t1, '\n'
	addi $sp, $sp, -4
	sw $t1, 0($sp)
	
	li $v0, 15				#write to file
	move $a0, $s0
	move $a1, $sp				#newline
	li $a2, 1				#write to file
	syscall
			
	addi $sp, $sp, 4
	
	addi $t2, $t2, -48
	addi $t0, $t0, 4
	li $t4, 0 				#counter
	write_loop:
		lw $t1, 0($t0)			#get val
		beq $t4, $t3, write_done
		
		addi $t1, $t1, '0'
		sw $t1, 0($t0)
		li $v0, 15			#write to file
		move $a0, $s0
		move $a1, $t0			#val being written
		li $a2, 1			#write to file
		syscall
		
		
		addi $t4, $t4, 1		#incr counter
			
		div $t4, $t2			#divide counter by num of cols
		mfhi $t5
		beqz $t5, write_nl		#creates newline
		j write_incr
		write_nl:
			li $t1, '\n'
			addi $sp, $sp, -4
			sw $t1, 0($sp)
	
			li $v0, 15		#write to file
			move $a0, $s0
			move $a1, $sp		#newline
			li $a2, 1		#write to file
		
			syscall
			
			addi $sp, $sp, 4
		write_incr:
			addi $t0, $t0, 4	#incr addr
		j write_loop	
write_done:
	lw $s0, 0($sp)
	lw $a0, 4($sp)
	lw $a1, 8($sp)
	lw $s2, 12($sp)
	addi $sp, $sp, 16
	
	li $v0, 16
	syscall
	
	jr $ra

.globl rotate_clkws_90
rotate_clkws_90:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	move $s0, $a0
	move $t0, $s0
	lw $s1, 0($s0)				#row
	lw $s2, 4($s0)				#col
	
	addi $t0, $t0, 8
	move $t6, $s2
	ncol_loop:
		beqz $t6, ncol_done		#col
		
		li $t7, 0
		nrow_loop:
			beq $t7,$s1, nrow_done	#row
			move $t5, $t0
			
			mul $t3, $t7, $s2
			add $t3, $t3, $t6
			addi $t3, $t3, -1
			li $t4, 4
			mul $t3, $t3, $t4
			add $t5, $t5, $t3
			
			lw $t1, 0($t5)
			
			addi $sp, $sp,  -4
			sw $t1, 0($sp)
			
			addi $t7, $t7, 1
			j nrow_loop
		nrow_done:
			addi $t6, $t6, -1
		j ncol_loop
		
	ncol_done:
		lw $t2, 0($s0)				
		lw $t3, 4($s0)
		sw $t3, 0($s0)
		sw $t2, 4($s0)
		
		addi $t0, $s0, 8
		mul $t4, $t2, $t3		#matrix size
		li $t5, 0 			#counter
		nupdate_buffer:
			beq $t5, $t4, ninety_done
			lw $t1, 0($sp)
			addi $sp, $sp , 4
			sw $t1, 0($t0)
			addi $t0, $t0, 4
			addi $t5, $t5, 1
			j nupdate_buffer	
ninety_done:
	li $s3, 1
	beq $a3, $s3, skip_write
	move $s0, $a0
	move $a0, $a1
	move $a1, $s0
	jal write_file
	skip_write:
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20	
	jr $ra

.globl rotate_clkws_180
rotate_clkws_180:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s4, 12($sp)
	sw $s5, 16($sp)
	li $a3, 1
	move $s4, $a0
	move $s5, $a1
	jal rotate_clkws_90
	move $a0, $s4
	move $a1, $s5
	li $a3, 0
	jal rotate_clkws_90
	lw $s5, 16($sp)
	lw $s4, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20	
jr $ra

.globl rotate_clkws_270
rotate_clkws_270:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s4, 12($sp)
	sw $s5, 16($sp)
	move $s4, $a0
	move $s5, $a1
	li $a3, 1
	jal rotate_clkws_90
	move $a0, $s4
	move $a1, $s5
	jal rotate_clkws_180
	lw $s5, 16($sp)
	lw $s4, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20
 jr $ra

.globl mirror
mirror:
	addi $sp, $sp, -20
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	
	move $s0, $a0
	
	lbu $s1, 0($s0)				#row val
	lbu $s2, 4($s0)				#col val
	addi $s0, $s0, 8			#addr is at index 0,0 of the matrix
	
	li $t2, 2
	div $s2, $t2
	mflo $s3
	
	li $t2, 0				#row counter
	mirrorout_loop:
		beq $t2, $s1, mirrorout_done
		move $t0, $s0
		move $t1, $s0
		
		mul $t4, $t2, $s2		#curr row * col
		li $t5, 4
		mul $t4, $t4, $t5
		add $t0, $t0, $t4
		
		mul $t6, $s2, $t5
		add $t1, $t0, $t6
		addi $t1, $t1, -4
		li $t3, 0			#col counter
		mirrorin_loop:
			beq $t3, $s3, mirrorin_done
			lw $t7, 0($t0)
			lw $t8, 0($t1)
			sw $t8, 0($t0)
			sw $t7, 0($t1)
			addi $t0, $t0, 4
			addi $t1, $t1, -4
			addi $t3, $t3, 1
			j mirrorin_loop
		mirrorin_done:
		addi $t2, $t2, 1
		j mirrorout_loop
mirrorout_done:	
	move $s0, $a0
	move $a0, $a1
	move $a1, $s0
	jal write_file
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 20			
	jr $ra

.globl duplicate
duplicate:
	addi $sp, $sp, -24
	sw $ra, 0($sp)
	sw $s0, 4($sp)
	sw $s1, 8($sp)
	sw $s2, 12($sp)
	sw $s3, 16($sp)
	sw $s4, 20($sp)
	
	move $s0, $a0
	
	lbu $s1, 0($s0)				#row val
	lbu $s2, 4($s0)				#col val
	addi $s0, $s0, 8			#addr is at index 0,0 of the matrix

	li $t3, 0				#outer counter
	li $s4, 99
	dup_loop:				
	move $t0, $s0

	beq $t3, $s1, checkfor_dupes		#outer counter is equal to row

	mul $t5, $t3, $s2			#curr row * col
	li $t6, 4
	mul $t5, $t5, $t6			#curr row * col * 4
	add $t0, $t0, $t5			#starting index

	li $t5, 0				#col counter
	li $t7, 0				#val for the row
	outer_val:	#val is in $t7
		beq $t5, $s2, outval_done	#when counter equals col

		lbu $t6, 0($t0)			#gets val from the addr
		sll $t7, $t7, 1			#shifts $t7 by 1 bit left
		add $t7, $t7, $t6		#adds $t7 to $t6

		addi $t0, $t0, 4		#incr addr by 4
		addi $t5, $t5, 1		#incr counter by 1
		j outer_val
	outval_done:
		addi $t4, $t3, 1		#inner counter
		innerdup_loop:
			bge $t4, $s1, outer_done	#inner counter is equal to row
			move $t1, $s0

			mul $t5, $t4, $s2		#curr row * col
			li $t6, 4
			mul $t5, $t5, $t6
			add $t1, $t1, $t5		#starting index

			li $t5, 0
			li $t8, 0			#val for the row
			inner_val:	#val is in $t8
				beq $t5, $s2, innerval_done	#when counter equals col

				lbu $t6, 0($t1)			#gets val from the addr
				sll $t8, $t8, 1			#shifts $t7 by 1 bit left
				add $t8, $t8, $t6		#adds $t7 to $t6

				addi $t1, $t1, 4		#incr addr by 4
				addi $t5, $t5, 1		#incr counter by 1	
				j inner_val
			innerval_done:
				beq $t7, $t8, dupe_found
				j cont_dupe
				dupe_found:
					blt $t4, $s4, less_than
					j cont_dupe
				less_than:
					add $s4, $t4, $0
				cont_dupe:
			addi $t4, $t4, 1			#incr outer counter
		j innerdup_loop
	outer_done:
		addi $t3, $t3, 1		#incr outer counter
	j dup_loop
	
checkfor_dupes:
li $t0, 99
beq $s4, $t0, no_dup
dup_found:
	li $v0, 1
	addi $v1, $s4, 1
	j dup_done
no_dup:
	li $v0, -1
	li $v1, 0
dup_done:
	lw $s4, 20($sp)
	lw $s3, 16($sp)
	lw $s2, 12($sp)
	lw $s1, 8($sp)
	lw $s0, 4($sp)
	lw $ra, 0($sp)
	addi $sp, $sp, 24	
	jr $ra
