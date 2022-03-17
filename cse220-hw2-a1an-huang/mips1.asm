.data

 plaintext: .asciiz "0123456"
 buf: .space 4
 ciphertext: .space 16
 key: .asciiz "g&/]!#oxalo**qst"
 origtext: .space 16

.text:
 la $a0, plaintext
 li $a1, 8
 li $a2, 20	
 la $a3,ciphertext
 jal substr

 li $v0, 10
 syscall
 .include "hw2.asm"
