################# Alan Huang #################
################# alanhuang #################
################# 113443530 #################

################# DO NOT CHANGE THE DATA SECTION #################

.data
arg1_addr: .word 0
arg2_addr: .word 0
num_args: .word 0
invalid_arg_msg: .asciiz "One of the arguments is invalid\n"
args_err_msg: .asciiz "Program requires exactly two arguments\n"
invalid_hand_msg: .asciiz "Loot Hand Invalid\n"
newline: .asciiz "\n"
zero: .asciiz "Zero\n"
nan: .asciiz "NaN\n"
inf_pos: .asciiz "+Inf\n"
inf_neg: .asciiz "-Inf\n"
mantissa: .asciiz ""

.text
.globl hw_main
hw_main:
    sw $a0, num_args
    sw $a1, arg1_addr
    addi $t0, $a1, 2
    sw $t0, arg2_addr
    j start_coding_here

start_coding_here: # CHECKS IF THERE ARE TWO ARGUMENTS
	li $at, 0
	li $v0, 0
	li $v1, 0
	li $a0, 0
	li $a2, 0
	li $a3, 0
	li $t0, 0
	li $t1, 0
	li $t2, 0
	li $t3, 0
	li $t4, 0
	li $t5, 0
	li $t6, 0
	li $t7, 0
	li $s0, 0
	li $s1, 0
	li $s2, 0
	li $s3, 0
	li $s4, 0
	li $s5, 0
	li $s6, 0
	li $s7, 0
	li $t8, 0
	li $t9, 0
	li $k0, 0
	li $k1, 0
	li $gp, 0
	li $sp, 0
	li $fp, 0
	li $ra, 0
	lw $a0, num_args
	addi $s0, $0, 2   #stores value 2 in $s0
	bne $s0, $a0, args_error # checks if number of args($a0) is equal to 2($s0), jumps to label args_error if not equal
	j validate_arg # jumps to label validate_args
	
args_error: # PRINTS THE ARGS_ERR_MSG AND EXITS PROGRAM
	la $a0, args_err_msg # loads the astart dress of args_err_msg into $a0
	addi $v0, $0, 4 # command for printing string
    	syscall
    	
    	addi $v0, $0, 10 #exit program
    	syscall
    	
validate_arg: # CHECKS IF THE SECOND CHAR IS THE NULL TERMINATOR
	lw $t0, arg1_addr # loads the start adress of arg1 into $t1
	lbu $t1, 1($t0) # loads the next byte
	bnez $t1,invalid_arg # if it is null terminator jump to validate_addr1
	j validate_addr1 # jump to invalid_arg if the second byte isnt null terminator
		
validate_addr1: # CHECKS IF ADDR1 STARTS WITH THE SPECIFIED CHARS
	lw $t0, arg1_addr # 1oads the start adress of arg1 into $t1
	lbu $t1, 0($t0) # loads the first character
	case_D: #Checks if the character is D
		li $t0, 68 # loads D into $s0 
		beq $t1,$t0 , validate_addr2 # checks if $t0 and $t1 is equal, jump to validate_addr2 if they are equal
		j case_O
	case_O:
		li $t0, 79
		beq $t1,$t0 , validate_hex
		j case_S
	case_S:
		li $t0, 83
		beq $t1,$t0 , validate_hex
		j case_T
	case_T:
		li $t0, 84
		beq $t1,$t0 , validate_hex
		j case_I
	case_I:
		li $t0, 73
		beq $t1,$t0 , validate_hex
		j case_F
	case_F:
		li $t0, 70
		beq $t1,$t0 , validate_hex
		j case_L
	case_L:	
		li $t0, 76
		beq $t1,$t0 , loot_game
	default: # return error if non of the cases pass
		j invalid_arg # jumps to invalid_arg
validate_addr2: # CHECKS IF ADDR2 STARTS WITH THE SPECIFIED CHARS
	li $a0, 0 #sets arg0 back to 0
	lw $t0, arg2_addr # loads the start adress of arg1 into $t1
	for2:
		lbu $t1, 0($t0) # loads the first character into t1
		beqz $t1, convert_decimal # jumps to convert_decimal when it reachs the end of the string
		case_dash:
			li $t2, 45 # loads character - into $t0
			beq $t1,$t2 ,done2	# checks if $t0 and $t1 are equal, jumps to done if they are
		case_0:
			li $t2, 48
			beq $t1,$t2 ,done2
		case_1:
			li $t2, 49
			beq $t1,$t2 ,done2
		case_2:
			li $t2, 50
			beq $t1,$t2 ,done2
		case_3:
			li $t2, 51
			beq $t1,$t2 ,done2
		case_4:
			li $t2, 52
			beq $t1,$t2 ,done2
		case_5:
			li $t2, 53
			beq $t1,$t2 ,done2
		case_6:
			li $t2, 54
			beq $t1,$t2 ,done2
		case_7:
			li $t2, 55
			beq $t1,$t2 ,done2
		case_8:
			li $t2, 56
			beq $t1,$t2 ,done2
		case_9:
			li $t2, 57
			beq $t1,$t2 ,done2
		default2:
			j invalid_arg # if none of the cases go through jump to invalid_arg
		done2:
		addi $t0, $t0, 1 # iterates through the string
		j for2 # jumps back to the start of the for loop
		
invalid_arg:
	la $a0, invalid_arg_msg #loads start address of invalid_arg_msg into $a0
	addi $v0, $0, 4	 #command for printing a string
    	syscall
    	
    	addi $v0, $0, 10 #exits program
    	syscall	
    	
convert_decimal: # CONVERTS THE STRING TO A DECIMAL NUMBER

	lw $t0, arg2_addr # loads the word of arg2 into $t0
	li $s7, 0
	li $s6, 1
	for3:
		lbu, $t1, 0($t0) # loads the first character into t1
		beqz $t1, print_value # jumps to decode when it reaches the end of the string
		case_dash2:
			li $t3, 45 # loads character - into $t3
			beq $t1,$t3 ,is_neg # checks if $t1 is -, jumps to is_neg if it is
			j check_neg
		is_neg:
			li $s7 , 1 # boolean variable for negative nums
			j done3
		check_neg:
			beq $s7,$s6,to_neg 
			j case_digit
			to_neg:
				addi $s0, $zero, 10
				addi $t1, $t1, -48
				mul $a0, $a0 ,$s0
				sub $a0, $a0, $t1
				j done3
		case_digit:
			addi $s0, $zero, 10
			addi $t1, $t1, -48 # converts ascii to dec
			mul $a0, $a0 ,$s0 # multiplies the num by 10
			add $a0, $a0, $t1 # adds the $t1 and $t2
		done3:
			addi $t0, $t0, 1 # traverses to next char
		j for3
		
validate_hex: #checks if it is a vlid hexidecimal num
	lw $t4, arg1_addr
	lw $t0, arg2_addr # loads arg 2 into $t0
	lbu, $t5, 0($t4)
	op_F:
		li $t6, 'F'
		beq $t5, $t6, for4
	li $s0, '0' # sets $s0 to 0
	lbu $t1, 0($t0) 
	bne $t1, $s0, invalid_arg
	lbu $t1, 1($t0)
	li $s0, 120
	bne $t1, $s0, invalid_arg
	li $s0, 2 #moving two indexs up to skip 0x
	add $t0, $t0, $s0
	li $t2, 0 # counter 
	for4:
		lbu, $t1, 0($t0)
		beqz $t1, check_hex_length
		is_dig:
			li $t3, 48
			bltu $t1, $t3,invalid_arg# checks if the num is less than 0
			li $t3, 57
			bgtu $t1, $t3, check_chars # check if the num is greater than 9
			j valid_hexchar
		check_chars:
			li $t3, 65
			bltu $t1, $t3,invalid_arg# checks if the char is less than A
			li $t3, 70
			bgtu $t1, $t3, invalid_arg # check if the char is greater than F 
		valid_hexchar:
			addi $t0, $t0, 1 #move to next 
			addi $t2, $t2, 1 # add one to the counter
		j for4
	check_hex_length:
	li $t4, 8 #loads 8 into $t4
	beq $t5, $t6, f_length
	bgtu $t2, $t4,invalid_arg #jumps to invalid_arg_msg if there is more than 8 in the hexstring 
	j hex_to_bin
	f_length:
	bne $t2, $t4, invalid_arg
hex_to_bin:
	lw $t4, arg1_addr
	lw $t0, arg2_addr
	lbu, $t5, 0($t4)
	op_F3:
		li $t6, 'F'
		beq $t5, $t6, for5
	addi $t0, $t0, 2
	li $a3, 0 # store binary here
	for5:
		lbu, $t1, 0($t0)
		beqz $t1 , oper_check
		li $s0, 57
		sll $a3, $a3, 4
		ble $t1, $s0, digit_convert 
		li $t2, 0
		letter_convert:
			li $s0, 'A'
			sub $t2, $t1, $s0 #this replaces
			addi $t2, $t2, 10
			add $a3, $a3, $t2
			j done5
		digit_convert:
			li $s0, '0'
			sub $t2, $t1, $s0
			add $a3, $a3, $t2
		done5:
		addi $t0, $t0, 1
		j for5
oper_check:	 #use AND
	lw $t0, arg1_addr
	lbu, $t1, 0($t0)
	op_O:
		li $t0, 'O'
		beq $t0, $t1, op_code
	op_S:
		li $t0, 'S'
		beq $t0, $t1, source_register
	op_T:
		li $t0, 'T'
		beq $t0, $t1, destination_register
	op_I:
		li $t0, 'I'
		beq $t0, $t1, immediate
	op_F2:
		li $t0, 'F'
		beq $t0, $t1, floating_point
op_code:
	# gets the firs 5 bits of $a3 & store into $a0
	li $t1, 0xFC000000 
	and $t0, $a3, $t1 # gets the first 6 bits and mask the rest
	srl $a0, $t0, 26
	j print_value
source_register:
	li $t1, 0x03E00000 
	and $t0, $a3, $t1
	srl $a0, $t0, 21
	j print_value
destination_register:
	li $t1, 0x001F0000 
	and $t0, $a3, $t1
	srl $a0, $t0, 16
	j print_value

immediate:
	li $t1, 0x00008000
	and $t0, $a3, $t1
	addi $s1, $t0, 0
	srl $t0, $t0, 15
	li $s0, 1
	beq $t0, $s0, neg_imm
		li $t1, 0x0000FFFF
		and $t0, $a3, $t1
		add $a0, $t0, $0
		j print_value
	neg_imm:
		li $t1, 0x00007FFF
		and $t0, $a3, $t1
		sub $a0, $t0, $s1
		j print_value
		
floating_point:
	check_zero:
		li $t0, 0x00000000
		beq $a3, $t0, zero_msg
		li $t0, 0x80000000
		beq $a3, $t0, zero_msg
	check_inf:
		li $t0, 0xFF800000
		beq $a3, $t0, neg_inf_msg
		li $t0, 0x7F800000
		beq $a3, $t0, pos_inf_msg
	check_nan:
		li $t0, 0x7F800001
		bge $a3, $t0, check_less_nan
		j check_nan2
		check_less_nan:
			li $t0, 0x7FFFFFFF
			ble $a3, $t0, print_nan_msg
	check_nan2:
		li $t0, 0xFF800001
		bge $a3, $t0, check_less_nan2
		j non_special
		check_less_nan2:
			li $t0, 0xFFFFFFFF
			ble $a3, $t0, print_nan_msg
	non_special:
		li $t1, 0x80000000
		and $t0, $a3, $t1 
		srl $t0, $t0, 31
		li $t1, 1
		li $s7, 0
		beq $t0, $t1, neg_fnum
		j exponent
		neg_fnum:	
			li $s7, 1
		exponent:
			li $t1, 0x7F800000
			and $t0, $a3, $t1 
			srl $a0, $t0, 23
			addi $t3, $0, 127
			sub $a0, $a0, $t3
		int_to_mantissa:
			la $t3, mantissa
			li $t1, 0x007FFFFF
			and $t0, $a3, $t1
			sll $t0, $t0,9  
			addi $s0, $0, 1
			beq $s7 , $s0, neg_man
			j pos_man
			neg_man:
				li $t4, '-'
				sb $t4 , 0($t3)
				addi $t3, $t3, 1
			pos_man:
				li $t4, '1'
				sb $t4 , 0($t3)
				addi $t3, $t3, 1
				li $t4, '.'
				sb $t4 , 0($t3)
				addi $t3, $t3, 1
				li $t2, 0 #counter
				for6:
					li $t4, 23
					beq $t2, $t4, done6
					li $t1, 0x80000000
					and $t5, $t0, $t1
					srl $t5, $t5, 31
					sll $t0, $t0, 1
					addi $t5, $t5, 48
					sb $t5, 0($t3)
					addi $t3, $t3, 1
					addi $t2, $t2, 1
					j for6
				done6:
					la $a1, mantissa
		j exit	
	
zero_msg:
	la $a0, zero
	addi $v0, $0, 4
	syscall
	
	j print_value
neg_inf_msg:
	la $a0, inf_neg
	addi $v0, $0, 4
	syscall
	
	j print_value
pos_inf_msg:
	la $a0, inf_pos
	addi $v0, $0, 4
	syscall
	
	j print_value
print_nan_msg:
	la $a0, nan
	addi $v0, $0, 4
	syscall
	
	j print_value
loot_game:
	lw $t0, arg2_addr
	li $s0, 0
	li $s1, 0
	li $s3, 6
	for7:
		lbu $t1, 0($t0)
		beqz $t1, total_ships
		li $s4, 0
		add $s4, $s0, $s1
		bgt $s4, $s3, invalid_hand
		li $t2, 'M'
		beq $t1, $t2, check_merchant
		li $t2, 'P'
		beq $t1, $t2, check_pirate
		j invalid_hand
		check_merchant:
			addi $t0, $t0, 1
			lbu $t1, 0($t0)
			li $t5, '0'
			sub $t6, $t1, $t5
			li $t3, 3
			li $t4, 8
			blt $t6, $t3, invalid_hand
			bgt $t6, $t4, invalid_hand
			addi $s0, $s0, 1
			j done7
		check_pirate:
			addi $t0, $t0, 1
			lbu $t1, 0($t0)
			li $t5, '0'
			sub $t6, $t1, $t5
			li $t3, 1
			li $t4, 4
			blt $t6, $t3, invalid_hand
			bgt $t6, $t4, invalid_hand
			addi $s1, $s1, 1
		done7:
			addi $t0, $t0, 1
		j for7
total_ships:
	sll $s0, $s0, 3
	add $a0, $s0, $s1
	j print_value
invalid_hand:
	la $a0, invalid_hand_msg
	addi $v0, $0, 4
    	syscall	
    	
    	addi $v0, $0, 10 #exits program
    	syscall	
print_value:
	addi $v0, $0, 1
    	syscall	
	li $t0, 0
	addi $t0, $a0, 0 
	la $a0, newline
	addi $v0, $0, 4
    	syscall	
    	li $a0, 0
	addi $a0, $t0, 0
exit:
	addi $v0, $0, 10 #exits program
    	syscall	
