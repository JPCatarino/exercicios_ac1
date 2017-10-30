# Mapa de Registos
#  $t0 - mdor
#  $t1 - mdo
#  $t2 - res
#  $t3 - i
#  $t4 - controlo

	.data
str1:	.asciiz "Introduza dois numeros: "
str2:	.asciiz "\nResultado:"
	.eqv	print_string,4
	.eqv	read_int,5
	.eqv	print_int10,1
	.text
	.globl 	main
	
main:	la 	$a0,str1			#
	li	$v0,print_string		#
	syscall					# print_string("Introduza..")
	ori	$v0,$0,read_int			#
	syscall					# read_int()
	or 	$t0,$v0,$0			# mdor = read_int()
	andi	$t0,$t0,0x0F			# mdor = mdor & 0x0F
	ori	$v0,$0,read_int			#
	syscall					# read_int()
	or	$t1,$v0,$0			# mdo = read_int()
	andi	$t1,$t1,0x0F			# mdo = mdo & 0x0F
	la	$a0,str2			# 
	li	$v0,print_string		#
	syscall					# print_string("Resultado: ")
	li 	$t2,0				# res = 0
	li 	$t3,0				# i = 0

while:	beq 	$t0,0,endwhl			# while ( mdor != 0
	bge	$t3,4,endwhl
	addi    $t3,$t3,1			# && i < 4))
if:	andi   	$t4,$t0,0x00000001		# 
	beq	$t4,0,endif			# if(mdor != 0) 
	add 	$t2,$t2,$t1			# res = res + mos
	
endif:	sll	$t1,$t1,1			# mdo = mdo << 1
	srl	$t0,$t0,1			# mdor = mdor >> 1
	j	while

	
endwhl: addi    $t3,$t3,1
	or	$a0,$0,$t2
	li	$v0,print_int10
	syscall					# print_int(res)
	jr	$ra	
	
	
	
	
