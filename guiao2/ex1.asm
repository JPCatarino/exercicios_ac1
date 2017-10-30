	.data
	.text
	.globl	main

main:	ori $t0,$0,0xE543	# substituir com o necessário
	ori $t1,$0,0xF0F0	# ditto
	and $t2,$t0,$t1		# $t2 = $t0 & $t1
	or  $t3,$t0,$t1		# $t3 = $t0 || $t1
	nor $t4,$t0,$t1		# $t4 = ~($t0 || $t1)
	xor $t5,$t0,$t1		# $t5 = $t0 ^ $t1
	
	nor $t1,$t0,$t0		#INVERSE GATE 
	
	jr $ra			# EOP  
