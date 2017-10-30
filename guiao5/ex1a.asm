# Mapa de Registos
#  i 	     - $t0
#  lista     - $t1
#  lista + i - $t2

	.data
	.eqv	SIZE,5
str1:	.asciiz "\nIntroduza um numero: "
	.align 	2
lista:	.space	20	# SIZE * 4
	.eqv	read_int,5
	.eqv	print_string,4
	.text
	.globl	main

main:	li	$t0,0			#i = 0
while:	bge	$t0,SIZE,endw		# while(i < SIZE) {
	la	$a0,str1		# 	print_string("Introduza...")
	la	$v0,print_string	#
	syscall				#	
	li	$v0,read_int		#	$v0 = read_int()
	syscall				#	$t1 = lista ( ou &lista[0]
	la	$t1,lista		#
	sll	$t2,$t0,2		#	$t2 = &lista[i]
	addu	$t2,$t2,$t1		#	lista[i] = read_int()
	sw	$v0,0($t2)		#	i++
	addi	$t0,$t0,1		
	j 	while			# }
endw:	jr 	$ra