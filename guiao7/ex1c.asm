	.data
	.eqv	print_int10,1
str1:	.asciiz "101101 sao anos bissextos"
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
atoi:		li	$v0,0		# res = 0;
		li	$t5,0		# binary = 0
		li	$t6,0		# i = 0
		li	$t7,2		# shiftam = 2
while:		lb	$t0,0($a0)	# while(*s >=...)
		blt	$t0,'0',ret	# 
		bgt	$t0,'1',ret	# {
		sub	$t1,$t0,'0'	# 	digit = *S - '0'
		addiu	$a0,$a0,1	# 	s++
		mul	$t5,$t5,10	# 	binary = 10 * binary
		add	$t5,$t5,$t1	# 	binary = 10 * binary + digit
		j	while		# }
	
bin2dec:	ble	$t5,0,ret	# while( res != 0 ) {
		rem	$t4,$t5,10	# 	remainder = binary % 10
		div	$t5,$t5,10	#	res = res/10 
		beq	$t6,0,onesum	#	if( i != 0){
		sll	$t7,$t2,2	#
		mul	$t8,$t4,$t7	#
		addu	$v0,$v0,$t7	# res = decimalnum + remainde * pow(2)
		addi	$t6,$t6,1	#
		j	bin2dec

onesum:		addu	$v0,$v0,$t4	# res = decimalnum + reminder * 1
		j	bin2dec
		
		
ret:	jr	$ra	