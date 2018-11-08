strrev:		subu	$sp,$sp,16		# reserva espa�o na stack
		sw	$ra,  0($sp)		# guarda endere�o de retorno
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
		addu	$sp,$sp,16		# liberta espa�o da stack
		jr	$ra			# termina subrotina
		
exchange:	lb	$t0,0($a0)		# $t0 = c1		
		lb	$t1,0($a1)		# $t1 = c2			
		sb	$t0,0($a1)		# c2 = c1
		sb	$t1,0($a0)		# c1 = c2
		jr	$ra