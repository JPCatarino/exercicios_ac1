# Mapa de registos:
#  $t0 - p
#  $t1 - *p
	.data
	.eqv	SIZE,20
	.eqv	read_string,8
	.eqv	print_string,4
ini:	.asciiz "Introduza uma string: "
str:	.space	20
	.text
	.globl  main

main:	la	$a0,ini
	li	$v0,print_string	# print_string("introduza...")
	syscall
	la	$a0,str			# $a0 = &str[0]
	li	$a1,SIZE		# $a1 = SIZE
	li	$v0,read_string
	syscall
	or	$t0,$a0,$0
        la	$t0,str

whl:	lb	$t1,0($t0)
        beq	$t1,0x00,endw		# while(*p != '\0'){
        subi	$t1,$t1,0x61
        addi	$t1,$t1,0x41		# *p = *p - 'a'
        sb	$t1,0($t0)
        addiu	$t0,$t0,1		# p++
        j 	whl			# }
        
endw:	la	$t0,str
	la	$t2,0($t0)
	or	$a0,$t0,$0
	li	$v0,print_string
	syscall				# print_string(str)
	jr	$ra
        
