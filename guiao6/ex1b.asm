	
	.data
	.eqv	print_int10,1
frase:	.asciiz "Arquitetura de Computadores I"
s:	.word	frase
	.text
	.globl	main
	
main:		addi	$sp,$sp,-4	
		sw	$ra,0($sp)	# $sp = $ra
		la	$a0,frase	# $a0 = &s[0]
		jal	strlen		# strlen(*s)
		lw	$ra,0($sp)	# $ra = $sp
		addi	$sp,$sp,4	# pop($ra)
		move	$a0,$v0		# $a0 = $v0
		li	$v0,print_int10
		syscall			# print(strlen(*s))
		jr	$ra
		

strlen:		li	$t1,0		# len = 0
while:		lb	$t0,0($a0)	# while(*s++ != '\0')
		addiu	$a0,$a0,1	#
		beq	$t0,'\0',endw	# {
		addi	$t1,$t1,1	# 	len ++
		j	while		# }
endw:		move	$v0,$t1		# return len;
		jr	$ra		#