		.data
		.eqv	print_int10,1
		.eqv	print_string,4
		.eqv	read_int,5
str1:		.asciiz "Pos: "
str2:		.asciiz "Num: "
str3:		.asciiz "Sum: "
		.align	2
int_arr:	.space	50
		.text
		.globl	main

main:		subi	$sp,$sp,4	
		sw	$ra,0($sp)
		la	$t9,int_arr
		la	$a0,str1
		li	$v0,print_string
		syscall
		li	$v0,read_int
		syscall
		move	$t0,$v0			# $t0 = pos
		li	$t1,0			# i = 0
array_f:	beq	$t1,$t0,cont		# for(i = 0, i < pos, i++){
		la	$a0,str2		#
		li	$v0,print_string	# 
		syscall				#
		li	$v0,read_int		#
		syscall				#
		sll	$t3,$t1,2		#
		addu	$t3,$t9,$t3		#
		sw	$v0,0($t3)		#
		addi	$t1,$t1,1		#
		j	array_f			#
cont:		la	$a0,int_arr
		move	$a1,$t0		
		jal	soma	
		move	$t4,$v0			#
		la	$a0,str3		#
		li	$v0,print_string	#
		syscall				#
		move	$a0,$t4			#
		li	$v0,print_int10		#
		syscall				#
		lw	$ra,0($sp)		#
		addi	$sp,$sp,4
		jr	$ra
		

#####################################################################################################

soma:	lb	$t0,0($a0)		# $t0 = array[0]
	beq	$a1,$0,else		# if( nelem != 0){
	subi	$sp,$sp,4		#	guardar registo
	sw	$ra,0($sp)		#	
	addi	$a0,$a0,4		#	array + 1
	subi	$a1,$a1,1		#	nelem -1
	jal	soma			#
	lw	$t2,0($a0)		#
	addu	$v0,$v0,$t2		#	
	lw	$ra,0($sp)		#
	addi	$sp,$sp,4		#
	jr	$ra			#
	
else:	li	$v0,0			#
	jr	$ra			#
	
