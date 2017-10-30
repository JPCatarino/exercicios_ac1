# Mapa de registos:
#  $t0 - value
#  $t1 - bit
#  $t2 - i 
#  $t4 - flag

	.data
str1:	.asciiz "Introduza um numero: "
str2:	.asciiz "\nO valor em binario e': "
	.eqv 	print_string,4
	.eqv	read_int,5
	.eqv	print_char,11
	.text
	.globl 	main
main:	la   	$a0,str1
	li   	$v0,print_string
	syscall				# print_string(str1)
	ori	$v0,read_int		#
	syscall				# ler inteiro
	or	$t0,$v0,$0		# value = read_int()
	la	$a0,str2		#
	li	$v0,print_string	#
	syscall				# print_string(str2)
	li	$t2,0			# i = 0
	li	$t4,0			# flag = 0
for:	bge 	$t2,32,endfor		# i < 32) {
	srl	$t1,$t0,31		# bit = value >> 31
	bge	$t4,1,if		# if ( flag == 1 || bit != 0)
	bne	$t1,0,if		#
	j	endif			#
if:	li	$t4,1			# flag = 1
	addi	$t3,$t1,0x30		# $t3 = '0' + bit
	or	$a0,$0,$t3		# 
	li	$v0,print_char		#
	syscall				# print_char(0x30 + bit)
	j	endif
space:	li	$a0,' '
	li	$v0,print_char
	syscall
	j	for
endif:  addi    $t2,$t2,1		# i++
	sll  	$t0,$t0,1	 	# value = value << 1 
	rem	$t3,$t2,4		# $t3 = $t2 % 4
	beq	$t3,0,space
	j    	for
endfor: jr	$ra	
