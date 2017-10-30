	.data
array:	.word 	7692,23,5,234
	.eqv	print_int10,1
	.eqv	SIZE,4
	.text
	.globl	main

main:	li 	$t3,0			# soma = 0
	la	$t0,array		# p = array
	li	$t4,SIZE		#
	sub	$t4,$t4,1		# $t4 = 3
	sll	$t4,$t4,2		#
	li	$t1,0			# i = 0
while:	bgt	$t1,$t4,endw		# while( i <= size)
	add	$t5,$t0,$t1
	lw	$t2,0($t5)
	add	$t3,$t3,$t2
	addiu	$t1,$t1,4		# p++
	j	while			# }
endw:	or 	$a0,$t3,$0
	ori 	$v0,$0,print_int10	# print_int10(soma)
	syscall
	
	jr	$ra
	