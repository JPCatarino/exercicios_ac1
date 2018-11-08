	.data
	.eqv	print_int10,1
	.eqv	read_int,5
	.eqv	print_string,4
	.eqv	SIZE,10
str1:	.asciiz	"\nIntroduza um numero: " 
str2:	.asciiz	"\narray["
str3:	.asciiz	"] : "	
	.align	2
lista:	.space	40	
	.text
	.globl	main
	
main:		la	$t7,lista		# $t7 = &(array[0])
		la	$t8,SIZE		# $t8 = SIZE
		li	$t0,0			# i = 0

for_ins:	bge	$t0,$t8,seq_sort	# for(i = 0; i < size; i++){
		sll	$t1,$t0,2		#	temp = i *4
		addu	$t1,$t7,$t1		#	temp = $(array[i])
		la	$a0,str1		#
		li	$v0,print_string	# 
		syscall				# 	print_string(" Instroduza")
		li	$v0,read_int		#
		syscall				#
		sw	$v0,0($t1)		#	lista[i] = read_int()
		addi	$t0,$t0,1		# i++
		j	for_ins
		
seq_sort:	li	$t0,0			# i = 0
		subi	$t9,$t8,1		# $t9 = SIZE - 1 

seq_for1:	bge	$t0,$t9,print_arr	# for(i = 0; i < size - 1; i++){
		addi	$t1,$t0,1		# 	j = i + 1

seq_for2:	bge	$t1,$t8,end_s_for	# 	for( j = i+1; j < SIZE; k++){
		sll	$t3,$t0,2		#	
		addu	$t3,$t7,$t3		#		temp = &(lista[i])
		sll	$t4,$t1,2		#	
		addu	$t4,$t7,$t4		#		temp2 = &(lista[j])
		lw	$t5,0($t3)		# 		$t5 = array[i]
		lw	$t6,0($t4)		#		$t6 = array[j]
		ble	$t5,$t6,end_s_for2	#		if(lista[i] > lista[j]){
		sw	$t6,0($t3)		#			array[i] = array[j]
		sw	$t5,0($t4)		#			array[j] = array[i]
						#		}
end_s_for2:	addi	$t1,$t1,1		# 		j++
		j	seq_for2		#	}
						#
end_s_for:	addi	$t0,$t0,1		# 	i++
		j	seq_for1		#  }

print_arr:	li	$t0,0			# i = 0
		
print_for:	bge	$t0,$t8,end		# for(i = 0; i < SIZE; i++){
		la	$a0,str2		# 
		li	$v0,print_string	#
		syscall				#
		or	$a0,$t0,$0		#
		li	$v0,print_int10		#
		syscall				#
		la	$a0,str3		#
		li	$v0,print_string	#
		syscall				#
		sll	$t1,$t0,2		#
		addu	$t1,$t7,$t1		#
		lw	$a0,0($t1)		#
		li	$v0,print_int10		#
		syscall				#
		addi	$t0,$t0,1		#
		j	print_for		#
		
end:		jr	$ra 
		
			
		