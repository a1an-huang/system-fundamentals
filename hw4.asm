############## Alan Huang ##############
############## 113443530 #################
############## alanhuang ################

############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
############################ DO NOT CREATE A .data SECTION ############################
.text:
.globl create_person
create_person:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	lbu $s1, 0($a0)					#total nodes
	lbu $s2, 8($a0)					#size of node
	
	addi $s0, $a0, 24 				#addr for set of nodes
	addi $s3, $a0, 16				#addr for curr num of node
	
	lbu $t1, 0($s3)					#curr amount of nodes
	beq $s1, $t1, full_node_set			#total node equals current node return err
	
	mul $t2, $t1, $s2				#nodes occupied
	
	addi $t0, $a0, 24
	add $t0, $t0, $t2				#start addr of first empty node
	move $a0, $t0					#move start addr of node into a0
	
	addi $t1, $t1, 1					#incr curr node by 1
	sb $t1, 0($s3)
	
	li $t3, 0					#counter
	create_person_loop:
		beq $t3, $s2, create_person_done
		sb $0, 0($t0)				#create person store 0 for node size
		addi $t0, $t0, 1
		addi $t3, $t3, 1
	j create_person_loop
full_node_set:
	li $v0, -1					
	j create_done
create_person_done:
	
	move $v0, $a0
create_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20
	
	jr $ra

.globl add_person_property
add_person_property:
	addi $sp, $sp, -20
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	
	#check if prop_name is equal to "NAME"
	lbu $t0, 0($a2)
	li $t1, 'N'
	bne $t0, $t1, invalid_person_prop
	lbu $t0, 1($a2)
	li $t1, 'A'
	bne $t0, $t1, invalid_person_prop
	lbu $t0, 2($a2)
	li $t1, 'M'
	bne $t0, $t1, invalid_person_prop
	lbu $t0, 3($a2)
	li $t1, 'E'
	bne $t0, $t1, invalid_person_prop
	lbu $t0, 4($a2)
	bnez $t0, invalid_person_prop
	
	move $t0, $a0						
	addi $t0, $t0, 24					#start of network nodes
	lbu $t1, 16($a0)						#curr node
	lbu $s1, 8($a0)						#size of the node
	li $t2, 0						#counter
	#checks if person exist 
	blt $a1, $t0,invalid_person_prop
	check_exist:
		bgt $t2, $t1, invalid_person_prop
		beq $a1, $t0, person_exist	
		addi $t2, $t2, 1
		add $t0, $t0, $s1
		j check_exist
	person_exist:
	move $t0, $a3
	li $t2, 0						#counter 
	prop_length:
		lbu $t1, 0($t0)
		beqz $t1, check_len
		addi $t2, $t2, 1
		addi $t0, $t0, 1
	j prop_length
	check_len:
		bgt $t2, $s1, invalid_person_prop
	move $t0, $a3
    
    	lbu $s0, 0($a0)                      	 		#total nodes
    
    	addi $t2, $a0, 24                  	  		#starting addr of net work
    	move $s3, $t2
    	li $t4, 0                      	  			#counter
    	dupe_prop_val:
        		beq $t4, $s0, add_person
        		move $t0, $a3
        		lbu $t1, 0($t0)
        		lbu $t3, 0($t2)
        		bne $t1, $t3, dupe_next_node
      		check_dupe:
       			beqz $t1, invalid_person_prop                #dupe found
           		addi $t0, $t0, 1
           		addi $t2, $t2, 1
            		lbu $t1, 0($t0)
            		lbu $t3, 0($t2)
           		bne $t1, $t3, dupe_next_node
        		j check_dupe
        		dupe_next_node:
       		addi $t4, $t4, 1
        		mul $t5, $t4, $s1
        		add $t2, $s3, $t5
    	j dupe_prop_val
	add_person:
	move $t0, $a1				#addr for addr prop is going to be placed
	move $t1, $a3				#addr for prop val
	li $t2, 0 				#counter
	adding_per:
		bge $t2, $s1, person_added
		lbu $t3, 0($t1)
		beqz $t3, add_zero
		sb $t3, 0($t0)
		addi $t1, $t1, 1
		j add_comp
		add_zero:
			sb $0, 0($t0)
		add_comp:
			addi $t0, $t0, 1
			addi $t2, $t2, 1
	j adding_per
invalid_person_prop:
	li $v0, 0
	j add_person_prop_done
person_added:
	li $v0, 1
add_person_prop_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	addi $sp, $sp, 20
	jr $ra

.globl get_person
get_person:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s0, $a1						#load addr of the name into s0
	
	move $t0, $a0
	
	lb $s1, 0($a0)						#total num of nodes
	lb $s2, 8($a0)						#size of each node
	
	addi $t0, $t0, 24					#start of set of nodes
	
	li $t3, 0						#counter
	get_person_loop:
		beq $t3, $s1, not_found				#checked all the nodes
		
		move $s3, $t0					#set addr to start of the node addr
		
		move $s0, $a1
		lbu $t4, 0($s0)
		lbu $t1, 0($t0)
		li $t5, 0
		beq $t4, $t1, check_name				#check first char of each node					#char counter
		j next_node
		check_name:
			addi $t5, $t5, 1				#inc char counter
			addi $s0, $s0, 1				#incr name addr
			addi $t0, $t0, 1				#incr node addr
			
			lbu $t4, 0($s0)
			lbu $t1, 0($t0)
		
			beqz $t4, check_found			#when char reaches null point means name is found
			j go_next_char
			check_found:
				beq $t5, $s2, name_found		
				beqz $t1, name_found
				j next_node
			go_next_char:	
			bne $t4, $t1, next_node			#if char aren't equal name is not the same check next node
		j check_name	
		next_node:
			add $t0, $t0, $s2			#incr node
			sub $t0, $t0, $t5
			addi $t3, $t3, 1				#incr counter
	j get_person_loop

not_found:		
	li $v0, 0						#set v0 when name isnt found
	j get_person_done
name_found: 
	move $v0, $s3						#set v0 to start of node addr when name is found
get_person_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24	
 	jr $ra

.globl add_relation
add_relation:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	move $s0, $a0
	move $s1, $a1
	move $s2, $a2
	jal get_person
	beqz $v0, relation_err
	move $s3, $v0				#addr name 1
	move $a1, $s2
	jal get_person
	beqz $v0, relation_err
	move $s4, $v0				#addr name 2
	move $a1, $s1
	move $a2, $s2
	lbu $t0, 20($a0)				#curr node 
	lbu $t1, 4($a0)
	
	beq $t0, $t1, relation_err		#curr amount of edges equal total edges
	
	move $t0, $a0 				#start addr of network
	lbu $s1, 20($a0)				#curr num of edge
	
	lbu $t2, 0($t0)				#total nodes
	lbu $t1, 8($t0)				#node size
	mul $t1, $t1, $t2			#size of node network
	
	addi $t0, $t0, 24
	add $t0, $t0, $t1			#start of edge network
	move $s2, $t0		
	li $t2, 0
	check_edges:
		beq $t2, $s1, check_same_name
		
		
		lw $t1, 0($t0)
		
		lw $t3, 4($t0)
		
		
		beq $t1, $s3, check_n1
		beq $t3, $s3, check_n2
		j check_same_done
		check_n1:
			beq $t3, $s4, relation_err
			j check_same_done
		check_n2:
			beq $t1, $s4, relation_err
			j check_same_done
		check_same_done:
		addi $t2, $t2, 1
		addi $t0, $t0, 12
	j check_edges
	check_same_name:
		beq $s4, $s3, relation_err
	move $t0, $a0 				#start addr of network
	lbu $s1, 20($t0)				#curr num of edge
	li $t1, 12
	mul $t1, $t1, $s1
	addi $s1, $s1, 1
	sb $s1, 20($t0)				#incr amount of edges  by 1
	add $t0, $s2, $t1			# start of first empty edge node
	sw $s3, 0($t0)
	sw $s4 , 4($t0)
	addi $t0, $t0, 8
	li $t1, 4
	li $t2, 0
	cr_relation:
		beq $t1, $t2,relation_added
		sb $0, 0($t0)
		addi $t0, $t0, 1
		addi $t2, $t2, 1
	j cr_relation
relation_err:
	li $v0, 0
	j add_relation_done
relation_added:
	li $v0, 1
add_relation_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
	jr $ra
  

.globl add_relation_property
add_relation_property:
	lw $t0, 0($sp)
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	move $s0, $t0
	li $t0, 1
	bne $s0, $t0, add_rel_prop_error					#the relation prop val is not 1

	
	lbu $t0, 0($a3)
	li $t1, 'F'
	bne $t0, $t1, add_rel_prop_error
	lbu $t0, 1($a3)
	li $t1, 'R'
	bne $t0, $t1, add_rel_prop_error
	lbu $t0, 2($a3)
	li $t1, 'I'
	bne $t0, $t1, add_rel_prop_error
	lbu $t0, 3($a3)
	li $t1, 'E'
	bne $t0, $t1, add_rel_prop_error
	lbu $t0, 4($a3)
	li $t1, 'N'
	bne $t0, $t1, add_rel_prop_error
	lbu $t0, 5($a3)
	li $t1, 'D'
	bne $t0, $t1, add_rel_prop_error
	lbu $t0, 6($a3)
	bnez $t0, add_rel_prop_error
	
	
	move $s1, $a1
	move $s2, $a2
	jal get_person
	beqz $v0, relation_err
	move $s3, $v0				#addr name 1
	move $a1, $s2
	jal get_person
	beqz $v0, relation_err
	move $s4, $v0				#addr name 2
	move $a1, $s1
	move $a2, $s2
	
	move $t0, $a0
	lbu $t2, 0($t0)				#total nodes
	lbu $t1, 8($t0)				#node size
	mul $t1, $t1, $t2			#size of node network
	
	addi $t0, $t0, 24
	add $t0, $t0, $t1			#start of edge network
	move $s0, $t0
	
	lbu $s1, 20($a0)				#curr num of edges
	li $t2, 0 				#counter
	
	check_relations:
		beq $s1, $t2, add_rel_prop_error
		lw $t1, 0($t0)
		beq $t1, $s3, rel_two
		beq $t1, $s4, rel_two
		j next_rel
		rel_two:
			lw $t1, 4($t0)
			beq $t1, $s3, rel_prop_added
			beq $t1, $s4, rel_prop_added
		next_rel:
		addi $t0, $t0, 12
		addi $t2, $t2, 1 
	j check_relations
	
add_rel_prop_error:
	li $v0, 0	
	j add_relation_prop_done
rel_prop_added:
	li $s0, 1
	sw $s0, 8($t0)
	li $v0, 1
add_relation_prop_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24			
  jr $ra






DFS:
	addi $sp, $sp, -24
	sw $t0, 0($sp)
	sw $t1, 4($sp)
	sw $t2, 8($sp)
	sw $t3, 12($sp)
	sw $t4, 16($sp)
	sw $ra, 20($sp)	
	li $t1, 1
	beq $v0, $t1, DFS_found
		move $t0, $s0
		
		li $t2, 0 				#counter
		for_each_edge2:
			beq $t2, $s1, no_friend
			lbu $t1, 0($t0)
			beq $t1, $a2, check_partner
			j edge_done
			check_partner2:
				# check if the partner is an edge
				lbu $t1, 4($t0)
				beq $t1, $s4, DFS_found
				
				move $a1, $a2
				move $a2, $t1
				jal DFS
	
			edge_done2:
				addi $t0, $t0, 12
				addi $t2, $t2, 1
		j for_each_edge2
	
DFS_notfound:
 li $v0, 0
 j DFS_done
DFS_found:
 li $v0, 1
DFS_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
jr $ra



.globl is_a_distant_friend
is_a_distant_friend:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	li $v0, 0
distant_freiend_done:
	addi $sp, $sp, -24
	sw $s0, 0($sp)
	sw $s1, 4($sp)
	sw $s2, 8($sp)
	sw $s3, 12($sp)
	sw $s4, 16($sp)
	sw $ra, 20($sp)
	
	move $s1, $a1
	move $s2, $a2
	jal get_person
	beqz $v0, distant_friend_err2
	move $s3, $v0				#addr name 1
	move $a1, $s2
	jal get_person
	beqz $v0, distant_friend_err2
	move $s4, $v0				#addr name 2
	move $a1, $s1
	move $a2, $s2
	
	move $t0, $a0
	lbu $t2, 0($t0)				#total nodes
	lbu $t1, 8($t0)				#node size
	mul $t1, $t1, $t2			#size of node network
	
	addi $t0, $t0, 24
	add $t0, $t0, $t1			#start of edge network
	move $s0, $t0
	
	lbu $s1, 20($a0)				#curr num of edges
	li $t2, 0 				#counter
	
	save_relations:
		beq $t2, $s1, relations_saved
		addi $sp, $sp, -4
		lw $t1, 8($t0)
		sw $t1, 0($sp)
		addi $t0, $t0,12
		addi $t2, $t2, 1
		j save_relations
	relations_saved:
		move $t0, $s0
		
		li $t2, 0 				#counter
		for_each_edge:
			beq $t2, $s1, no_friend
			lbu $t1, 0($t0)
			beq $t1, $s3, check_partner
			j edge_done
			check_partner:
				# check if the partner is an edge
				lbu $t1, 4($t0)
				beq $t1, $s4, friends_not_dis
				
				move $a1, $s3
				move $a2, $t1
				jal DFS
				bnez $v0, found_friend
	
			edge_done:
				addi $t0, $t0, 12
				addi $t2, $t2, 1
		j for_each_edge
		no_friend:
			move $t0, $s0
			li $t1, 12
			mul $t1, $s1, $t1
			add $t0, $t1, $t0
			
			li $t2, 0				#counter
			original_relations:
				beq $t2,$s1, distant_friend_err
				lw $t1, 0($sp)
				addi $sp, $sp, 4
				sw $t1, 8($t0)
				addi $t0, $t0, -12
				addi, $t2, $t2, 1
			j original_relations
		friends_not_dis:
			move $t0, $s0
			li $t1, 12
			mul $t1, $s1, $t1
			add $t0, $t1, $t0
			
			li $t2, 0 				#counter
			original_relations2:
				beq $t2,$s1, distant_friend_err2
				lw $t1, 0($sp)
				addi $sp, $sp, 4
				sw $t1, 8($t0)
				addi $t0, $t0, -12
				addi, $t2, $t2, 1
			j original_relations2
		found_friend:
			move $t0, $s0
			li $t1, 12
			mul $t1, $s1, $t1
			add $t0, $t1, $t0
			
			li $t2, 0				#counter
			original_relations3:
				beq $t2,$s1, distant_friend
				lw $t1, 0($sp)
				addi $sp, $sp, 4
				sw $t1, 8($t0)
				addi $t0, $t0, -12
				addi, $t2, $t2, 1
			j original_relations3
	
distant_friend:
	li $v0, 1
	j distant_friend_done
distant_friend_err:
	li $v0, 0
	j distant_friend_done
distant_friend_err2:
	li $v0, -1
distant_friend_done:
	lw $s0, 0($sp)
	lw $s1, 4($sp)
	lw $s2, 8($sp)
	lw $s3, 12($sp)
	lw $s4, 16($sp)
	lw $ra, 20($sp)
	addi $sp, $sp, 24
 jr $ra
  
