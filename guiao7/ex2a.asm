# Mapa de registos
# n:		$a0 -> $s0
# b:		$a1 -> $s1
# s:		$a2 -> $s2
# p:		$s3 
# digit:	$t0
# sub-rotina intermédia

itoa:		subu	$sp,$sp,20	#reservar espaço na stack
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
		la	$a0,$s2		# 
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
		addi	$a0,$a0,'7'	#	v+7
end_to:		move	$v0,$a0		# return v
		jr	$ra		# ditto
