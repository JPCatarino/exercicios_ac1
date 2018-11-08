
insert:		li	$t0,0			# i = 0
		ble	$a2,$a3,else_ins	# if( pos > size ){
		li	$v0,1			# 
		jr	$ra			# return 1;

else_ins:	subi	$t0,$a3,1		# i = size - 1

for_ins:	blt	$t0,$a2,end_for_ins	# 
		sll	$t2,$t0,2		#
		addu	$t2,$a0,$t2		# array[i]
		lw	$t1,0($t2)		#
		sw	$t1,4($t2)		#
		subi	$t0,$t0,1		# i--
		j	for_ins			#
	
end_for_ins:	sll	$t2,$a2,2	#
		addu	$t2,$a0,$t2	# $t2 = array[pos]
		sw	$a1,0($t2)	# array[pos] = value
		li	$v0,0		# $v0 = 0
		jr	$ra		# return 0;
		
print_array:	la	$t3,($a0)
		add	$t0,$t3,$a1	# int *p = a + n

for_print:	bge	$t3,$t0,end_for	#  for(; a < p; a++) {
		lw	$t1,0($t3)	#  a
		ori	$a0,$t1,$0	#
		li	$v0,print_int10
		syscall
		la	$a0,vir		
		li	$v0,print_string
		syscall			#
		addi	$t3,$t3,4	#

end_for:	jr	$ra		#
		
		