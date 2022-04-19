############################ CHANGE THIS FILE AS YOU DEEM FIT ############################
############################ Add more names if needed ####################################
############################ Change network if needed ####################################
.data

Name1: .asciiz "Jane"
Name2: .asciiz "Joey"
Name3: .asciiz "Alit"
Name4: .asciiz "Veen"
Name5: .asciiz "Stan"

prop: .asciiz "NAME"
val: .asciiz "Haanda"
val2: .asciiz "alibaba"

.align 2
Network:
  .word 5   #total_nodes
  .word 10   #total_edges
  .word 12   #size_of_node
  .word 12  #size_of_edge
  .word 0   #curr_num_of_nodes
  .word 0   #curr_num_of_edges
   # set of nodes
  .byte 'A' 2 3 4 5 'B' 7 8 9 10 11 12 'B' 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 'A'
   # set of edges
  .word 'B' 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 
.text
main:
	la $a0, Network
	jal create_person
	la $a0, Network
	addi $a1, $a0, 24
	la $a2, prop
	la $a3, val
  	move $s0, $v0		# return person
  	jal add_person_property
	la $a0, Network
	addi $a1, $a0, 36
	la $a2, prop
	la $a3, val2
  	move $s0, $v0		# return person
  	jal add_person_property
  	la $a0, Network
  	la $a1, val2
  	jal get_person
  	
  	#write test code



exit:
	li $v0, 10
	syscall
.include "hw4.asm"
