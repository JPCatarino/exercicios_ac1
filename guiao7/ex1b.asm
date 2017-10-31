	.data
	.eqv	print_int10,1
str1:	.asciiz "2016 e 2020 sao anos bissextos"
	.text
	.globl 	main
	
main:	addi	$sp,$sp,4
	sw	$ra,0($sp)
	la	$a0,str1
	jal	atoi
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	move	$a0,$v0
	li	$v0,print_int10
	syscall
	jr	$ra
	
	
	
# Mapa de Registos
# res  :	$v0
# s    :	$a0
# *s   :	$t0
# digit:	$t1
# Sub-rotina terminal: não devem ser usados registos $sx
atoi:	li	$v0,0		# res = 0;
while:	lb	$t0,0($a0)	# while(*s >=...)
	blt	$t0,'0',ret	# 
	bgt	$t0,'9',ret	# {
	sub	$t1,$t0,'0'	# 	digit = *S - '0'
	addiu	$a0,$a0,1	# 	s++
	mul	$v0,$v0,10	# 	res = 10 * res
	add	$v0,$v0,$t1	# 	res = 10 * res + digit
	j	while		# }
ret:	jr	$ra	