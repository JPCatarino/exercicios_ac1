# Mapa de registos:
# str: $a0 -> $s0 (argumento é passado em $a0)
# p1:  $s1   (registo callee-saved)
# p2:  $s2   (registo callee-saved)

strrev:		subu	$sp,$sp,16		# reserva espaço na stack
		sw	$ra,  0($sp)		# guarda endereço de retorno
		sw	$s0,  4($sp)		# guarda valor dos registos
		sw	$s1,  8($sp)		# $s0, $s1 e $s2
		sw	$s2, 12($sp)		#
		move	$s0, $a0		# registos "callee-saved"
		move	$s1, $a0		# p1 = str
		move	$s2, $a0		# p2 = str
while1:		bne	$s2,'\0',subp					# while( *p2 != '\0' ){
		addi	$s2,$s2,1		#	 p2++
		j	while1			# }
		
subp:		subi	$s2,$s2,1		# p2--
					
while2:		bgt	$s1,$s2,ret		# while(p1 < p2) {
		move	$a0,$s1			# 
		move	$a1,$s2			#
		jal	exchange		#  	exchange(p1,p2)
		addi	$s1,$s1,1		#  	p1++
		subi	$s2,$s2,1		#  	p2--	
		j	while2			# }

ret:		move	$v0,$s0			# return str
		lw	$ra, 0($sp)		# repoe retorno
		lw	$s0, 4($sp)		# repoe registos
		lw	$s1, 8($sp)		#
		lw	$s2,12($sp)		#
		addu	$sp,$sp,16		# liberta espaço da stack
		jr	$ra			# termina subrotina
		
exchange:	move	$t0,$a0			# aux = $c1
		move	$a0,$a1			# c1 = c2
		move	$a1,$t0			# c2 = aux
		jr	$ra
		
			