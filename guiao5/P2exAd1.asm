# Mapa de Registos
#  array:	$t0
#  i:		$t1
#  array + 1:	$t2
#  array[i]:	$a0
#

	.data
array:	.word	str1,str2,str3
str1:	.asciiz	"Array"
str2:	.asciiz "de"
str3:	.asciiz	"ponteiros"
	.eqv	print_string,4
	.eqv	print_char,11
	.eqv	SIZE,3
	
	.text
	.globl	main

main:	la	$t0,array		# $t0 = &(array[0]);
	li	$t1,0			# i = 0;
	la	$t9,SIZE
for:	bge	$t1,$t9,endw		# for(I = 0; i < SIZE ; i++){
	sll	$t2,$t1,2
	addu	$t2,$t0,$t2
	lw	$a0,0($t2)	
	li	$v0,print_string	
	syscall	
	addi	$t1,$t1,1		#
	j	for

endw:	jr	$ra
	