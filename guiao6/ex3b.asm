	.data
	.eqv	print_string,4
	.eqv	print_int10,1
	.eqv	STR_MAX_SIZE,30
	.align  2
str2:	.space  4			# 4 * 8 = 32 bits
str:	.asciiz "ITED - orievA ed edadisrevinU"
strb:	.asciiz " String too long "
	.text
	.globl	main
	
main:		addi	$sp,$sp,-4	
		sw	$ra,0($sp)	# $sp = $ra
		la	$a0,str		# $a0 = &s[0]
		jal	strlen		# strlen(*s)
		lw	$ra,0($sp)	# $ra = $sp
		addi	$sp,$sp,4	# pop($ra)
		move	$t0,$v0		# $t0 = $v0	
	
	
#################################################################################	
	
strlen:		li	$t1,0		# len = 0
while:		lb	$t0,0($a0)	# while(*s++ != '\0')
		addiu	$a0,$a0,1	#
		beq	$t0,'\0',endw	# {
		addi	$t1,$t1,1	# 	len ++
		j	while		# }
endw:		move	$v0,$t1		# return len;
		jr	$ra		#
#################################################################################		
strcopy:	li	$t3,0		# i = 0
		move	$t0,$a0		# $t0 = dst
		move	$t1,$a1		# $t1 = src
		
do_strc:	addu	$t4,$t0,$t3	# dest[i]
		addu	$t5,$t1,$t3	# src[i]
		lw	$t5,0($t4)	# dest[i] = src[i]
		addi	$t3,$t3,1	# i++
		addu	$t5,$t1,$t3	# src[i]
		bne	$t5,'\0',end_do # while(src[i++] != \0)
		j	do
		
end_do:		move $v0,$t0
		jr   $ra		
#############################################################################		
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