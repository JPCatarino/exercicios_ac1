		.data
		.eqv	read_int,5
		.eqv	print_int10,1
		.eqv	print_string,4
str1:		.asciiz	"\nIndique o dividendo: "
str2:		.asciiz	"\nIndique o divisor: "
str3:		.asciiz "\nResultado: "
		.text
		.globl  main

main:		la	$a0,str1
		li	$v0,print_string
		syscall				# print_string( "Indique")
		li	$v0,read_int		#
		syscall				#
		move	$t0,$v0			# dividendo = read_int()
		la	$a0,str2		# 
		li	$v0,print_string	#
		syscall				# print_string( " indique")
		li	$v0,read_int		#
		syscall				# divisor = read_int()
		move	$t1,$v0			# 
		subi	$sp,$sp,4		# salvar $ra na stack
		sw	$ra,0($sp)		#
		move	$a0,$t0			#
		move	$a1,$t1			# 
		jal	divi			#
		lw	$ra,0($sp)		# 
		addi	$sp,$sp,4			# restaurar stack
		move	$t0,$v0			#
		la	$a0,str3		#
		li	$v0,print_string	#
		syscall				# resultado
		or	$a0,$t0,$0		# 
		li	$v0,print_int10		#
		syscall				#
		jr	$ra
		


# Mapa de Registos
# $t0 - i
# $t1 - bit
# $t2 - quociente
# $t3 - resto
# $t4 - divisor
# $t5 - dividendo

divi:		sll	$t4,$a1,16		# divisor = divisor << 16;
		andi	$t5,$a0,0xFFFF		# dividendo = dividendo & 0xFFFF
		sll	$t5,$t5,1		# dividendo = (dividendo & 0xFFFF) << 1;	
		li	$t0,0			# i = 0

for_div:	bge	$t0,16,end_div		# for( i = 0; i < 16, i++){
		li	$t1,0			#	bit = 0
						#
if_div:		blt	$t5,$t4,end_for_d	# 	if(dividendo >= divisor){
		subu	$t5,$t5,$t4		# 		dividendo = dividendo - divisor;
		li	$t1,1			# 		bit = 1;
						#	}	
end_for_d:	sll	$t5,$t5,1		# 	dividendo << 1
		or	$t5,$t5,$t1		# 	dividendo = (dividendo << 1) | bit;
		addiu	$t0,$t0,1		# 	i++
		j 	for_div			#  }
						#
end_div:	#srl	$t5,$t5,1		# dividendo >> 1
		andi	$t3,$t5,0xFFFF		#
	#	sll	$t5,$t5,1		# dividendo << 1
	#	addu	$t2,$t5,0xFFFF		# quociente = dividendo & 0xFFFF
	#	or	$v0,$t3,$t2		# resto | quociente
		move	$v0,$t3
		jr	$ra			#
