# Mapa de registos:
# str:	$s0
# val:	$s1
# o main é, neste caso, uma sub rotina intermédia.	
	.data
	.eqv	print_string,4
	.eqv	read_int,5
	.eqv	MAX_STR_SIZE,33
brea:	.asciiz "\n"
	.align	2
str:	.space 	33
	.text
	.globl	main
	
main:	subu	$sp,$sp,12		# reserva espaço na stack
	sw	$s0,0($sp)		# guarda $sx e $ra na stack
	sw	$s1,4($sp)		#
	sw	$ra,8($sp)		#
	
do_m:	li	$v0,read_int		# do {
	syscall				#	
	move	$s1,$v0			#	val = read_int()
	move	$a0,$s1			#	
	li	$a1,2			#
	la	$a2,str			#
	jal	itoa			# itoa ( val, 2 , str )
	move	$a0,$v0			# 
	li	$v0,print_string	# print_string( itoa())
	syscall
	la	$a0,brea		#
	li	$v0,print_string	#
	syscall
	move	$a0,$s1			#
	li	$a1,8			#
	la	$a2,str			#
	jal	itoa			# itoa ( val , 8, str)
	move	$a0,$v0			#
	li	$v0,print_string	# print_string ( itoa())
	syscall
	la	$a0,brea		#
	li	$v0,print_string	#
	syscall
	move	$a0,$s1			#
	li	$a1,16			#
	la	$a2,str			#
	jal	itoa			# itoa( val, 16, str)
	move	$a0,$v0			#
	li	$v0,print_string	#
	syscall				#
	la	$a0,brea		#
	li	$v0,print_string	#
	syscall
	bne	$s1,0,do_m		# while( val != 0)
	lw	$s0,0($sp)		#
	lw	$s1,4($sp)		#
	lw	$ra,8($sp)		#
	addi	$sp,$sp,12		#
	jr	$ra			# 
######################################################################################	
# Mapa de registos
# n:		$a0 -> $s0
# b:		$a1 -> $s1
# s:		$a2 -> $s2
# p:		$s3 
# digit:	$t0
# sub-rotina intermÃ©dia

itoa:		subu	$sp,$sp,20	#reservar espaÃ§o na stack
		sw	$s0,0($sp)	# guardar sx e ra na stack
		sw	$s1,4($sp)	
		sw	$s2,8($sp)
		sw	$s3,12($sp)		
		sw	$ra,16($sp)	
		move	$s0,$a0		# copia n,b e s para registos callee-saved
		move	$s1,$a1		# 
		move	$s2,$a2
		move	$s3,$a2		# p = s
do:					# do{
		rem 	$t0,$s0,$s1	# digit = n % b
		div	$s0,$s0,$s1	# n = n / b
		move	$a0,$t0
		jal	toascii		# toascii(digit)
		sb	$v0,0($s3)	#
		addi	$s3,$s3,1	#
		bgt	$s0,0,do	# while ( n > 0) 
		
end_do:		sb	$0,0($s3)	# *p = '\0'
		move	$a0,$s2		# 
		jal	strrev		# strrev(s)
		lw	$s0,0($sp)	# return sx e ra
		lw	$s1,4($sp)	#
		lw	$s2,8($sp)	# 
		lw	$s3,12($sp)	#
		lw	$ra,16($sp)	#
		addiu	$sp,$sp,20	#
		jr	$ra		#
		
			
# converter  o digito v para o respetivo codigo ascii	

toascii:	addi	$a0,$a0,'0'	# v += 0
ifasc:		ble	$a0,'9',end_to	# if( v > '9' )
		addi	$a0,$a0,7	# v+7
end_to:		move	$v0,$a0		# return v
		jr	$ra		# ditto

################################################################

strrev:		subu	$sp,$sp,16		# reserva espaï¿½o na stack
		sw	$ra,  0($sp)		# guarda endereï¿½o de retorno
		sw	$s0,  4($sp)		# guarda valor dos registos
		sw	$s1,  8($sp)		# $s0, $s1 e $s2
		sw	$s2, 12($sp)		#
		move	$s0, $a0		# registos "callee-saved"
		move	$s1, $a0		# p1 = str
		move	$s2, $a0		# p2 = str
while1:		lb	$t2,0($s2)
		beq	$t2,'\0',subp		# while( *p2 != '\0' ){
		addi	$s2,$s2,1		#	 p2++
		j	while1			# }
		
subp:		subi	$s2,$s2,1		# p2--
					
while2:		lb	$t3,0($s1)
		lb	$t4,0($s2)
		bgt	$s1,$s2,ret		# while(p1 < p2) {
		move	$a0,$s1			# 
		move	$a1,$s2			#
		jal	exchange		#  	exchange(p1,p2)
		addi	$s1,$s1,1		#  	p1++
		addi	$s2,$s2,-1		#  	p2--	
		j	while2			# }

ret:		move	$v0,$s0			# return str
		lw	$ra, 0($sp)		# repoe retorno
		lw	$s0, 4($sp)		# repoe registos
		lw	$s1, 8($sp)		#
		lw	$s2,12($sp)		#
		addu	$sp,$sp,16		# liberta espaï¿½o da stack
		jr	$ra			# termina subrotina
		
exchange:	lb	$t0,0($a0)		# $t0 = c1		
		lb	$t1,0($a1)		# $t1 = c2			
		sb	$t0,0($a1)		# c2 = c1
		sb	$t1,0($a0)		# c1 = c2
		jr	$ra
		
	
	
	
