# Mapa de Registos:
# 
	.data
	.eqv	read_int,5
	.eqv	print_int10,1
	.eqv	print_string,4
	.eqv	SIZE,10
	.align	2
lista:	.space	40
vir:	.asciiz " ; "
	.text
	.globl	main

main:	la	$t0,lista	# $t0 = &(array[0])
	la	$t2,lista
	li	$a0,SIZE	#
	li	$t4,0		# i = 0
	li	$t5,0		# j = 0
	li	$t6,SIZE	#
	subi	$t6,$t6,1	# $t6 = SIZE - 1
	sll	$t3,$a0,2	# $t3 = size * 4
	addu	$t3,$t3,$t0	# $t1 = &(array[size])

for:	bgeu	$t0,$t3,for2	# while( p < &array[size])
	la	$v0,read_int	#
	syscall			# $v0 = read_int()
	sw	$v0,0($t0)	# *p = $v0
	addiu	$t0,$t0,4	# p++
	j	for		# }

for2:	bge	$t4,$t6,rs	# for(i = 0; i < SIZE-1; i++){
	addi	$t5,$t4,1	# j = i + 1

fors:	bge	$t5,$t6,endfr2 #
	sll	$t7,$t4,2	# $t7 = i * 4 
	sll	$t8,$t5,2	# $t8 = j * 4 
	addu	$t7,$t7,$t2	# $t7 = &lista[i]
	addu	$t8,$t8,$t2	# $t8 = &lista[j]
	lw	$t9,0($t7)	# aux = lista[i]
	lw	$t1,0($t8)	# aux = lista[j]
	blt	$t9,$t1,endfrs	
	sw	$t9,0($t8)	# lista[i] = lista[j]
	sw	$t1,0($t7)	# lista[j] = aux
	
endfrs: addi	$t5,$t5,1	# j++
	j	fors

endfr2: addi $t4,$t4,1
	j 	for2

rs:	li	$t5,0 		# i = 0

for3:	bgt	$t5,SIZE,end
	sll	$t7,$t5,2
	addu	$t7,$t7,$t2
	lw	$t8,0($t7)
	or	$a0,$t8,$0
	la	$v0,print_int10
	syscall
	la	$a0,vir
	la	$v0,print_string
	syscall
	addi	$t5,$t5,1
	j	for3

end: 	jr	$ra

	


	
	
	
	
