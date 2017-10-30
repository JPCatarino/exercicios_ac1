# Mapa de registos:
# $t0 - value
# $t1 - i
# $t3 - digito

	.data
str1:	.asciiz "Introduza um numero: "
str2:   .asciiz "\nO valor em hexadecimal: "
	.eqv 	print_string,4
	.eqv	read_int,5
	.eqv	print_char,11
	.text
	.globl 	main
main:	la    	$a0,str1			#
	li    	$v0,print_string		#
	syscall					# print_string("introduza ...")
	ori   	$v0,read_int			#
	syscall					# read_int()
	or    	$t0,$v0,$0			# 
	la    	$a0,str2			#
	li     	$v0,print_string		#
	syscall					# print_string("O valor...")
	li	$t1,8				# i = 8
while:	andi 	$t2,$t0,0xE00000		# while((value & 0xE0000000) == 0 && (i > 0))
	bne  	$t2,0,do			#
	ble  	$t1,0,do			#
	sll  	$t0,$t0,3			# value = value << 3
	subi 	$t1,$t1,1			# i--
	j    	while				# loop
do:	andi 	$t2,$t0,0xE00000		# value & 0xE00000
	srl  	$t3,$t2,21			# value & 0xE0000000 >> 28
	or   	$t2,$0,$t3			# digito = value & 0xE0000000 >> 28
	bgt  	$t3,8,else			# if(digito <= 9)
	add  	$a0,$t3,0x30			# digito + '0'
	li   	$v0,print_char			# 
	syscall					# print_char(digito + '0')
	j    	endif				
else:	add  	$a0,$t3,0x30			# digito = digito + 0
	add  	$a0,$a0,7			# digito = digito + 0 + 7
	li   	$v0,print_char			# print_char(digito + 0 + 7)
	syscall
	j    	endif
endif:  sll  	$t0,$t0,3			# value = value << 3
	subi 	$t1,$t1,1			# i--
	bgt	$t1,0,do			# while(i > 0)
 	jr 	$ra