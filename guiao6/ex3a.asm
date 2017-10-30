# Mapa de Registos
# dest 		: $a0 -> $t0 -> return to $v0 
# src  		: $a1 -> $t1
# i    		: $t3
# dest[i] 	: $t4
# src[i]	: $t5

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