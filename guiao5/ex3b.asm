# Mapa de registos
#  p 		: $t0
#  *p		: $t1
#  lista + size : $t2
#  size		: $t3
#  houve_troca	: $t4
#  i		: $t5
#  lista	: $t6
#  lista + 1	: $t7

	.data
	.eqv	FALSE,0
	.eqv	TRUE,1
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
	la	$t6,lista
	li	$a0,SIZE	#
	sll	$t3,$a0,2	# $t3 = size * 4
	addu	$t3,$t3,$t0	# $t1 = &(array[size])

for:	bgeu	$t0,$t3,do	# while( p < &array[size])
	la	$v0,read_int	#
	syscall			# $v0 = read_int()
	sw	$v0,0($t0)	# *p = $v0
	addiu	$t0,$t0,4	# p++
	j	for		# }
	
do: 	li	$t4,FALSE	# do { houve_troca = FALSWE;	
	li	$t5,0		# i = 0;	

while:	bge	$t5,9,endbub	# while( i < SIZE - 1){

if:	sll	$t7,$t5,2	# $t7 = i * 4 
	addu	$t7,$t7,$t6	# $t7 = &lista[i]
	lw	$t8,0($t7)	# $t8 = lista[i]	
	lw	$t9,4($t7)	# $t9 = lista[i+1]
	bge	$t8,$t9,endif	# if(lista[i] > lista [i + 1]){
	sw	$t8,4($t7)	# lista [i + 1] = &t8
	sw	$t9,0($t7)	# lista [i] = $t9
	li	$t4, TRUE	# $t4 =TRUE }

endif:	addi	$t5,$t5,1	# i++ }
	j	while
endbub:	beq	$t4,TRUE,do	# while( houve_troca == TRUE )
	li	$t5,0 		# i = 0

for2:	bgt	$t5,9,end
	sll	$t7,$t5,2
	addu	$t7,$t7,$t6
	lw	$t8,0($t7)
	or	$a0,$t8,$0
	la	$v0,print_int10
	syscall
	la	$a0,vir
	la	$v0,print_string
	syscall
	addi	$t5,$t5,1
	j	for2

end: 	jr	$ra
		
