################# Change args and n to test hw1.asm with different inputs #################
.data
args: .asciiz "F" "FF80000a"
n: .word 2

.text
main:
 lw $a0, n
 la $a1, args
 j hw_main

.include "hw1.asm"
