	.data
	
	.text
	.globl	main
main:	ori $t0,$0,3		# $t0 = x
	ori $t2,$0,8		# $t2 = 8
	add $t1,$t0,$t0		# $t1 = $t0 + $t0 = 2 * $t0
	sub $t1,$t1,$t2		# $t1 = $t1 - $t2 
	jr  $ra			#EOP 
