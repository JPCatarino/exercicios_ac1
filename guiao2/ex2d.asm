	.data
	.eqv print_int16,34
	.eqv print_char,11
	.text
	.globl main
	
main:	ori  $t0,$0,0x12345678	#valor inicial
	andi $a0,$t0,0xF000	#$a0 = $t0 & 0x0000F000
	srl  $a0,$a0,12		#$a0 = d3
	ori $v0,$0,print_int16  #é substituido por 34
	syscall			#impresso d3
	ori $v0,$0,print_char   #substituido por 11
	ori $a0,$0,' '
	syscall			#é impresso um espaço
	andi $a0,$t0,0x0F00	# $a0 = $t0 & 0x00000F00
	srl $a0,$a0,8		#$a0 = d2 
	ori $v0,$0,print_int16  #é substituido por 34
	syscall			#impresso d2
	ori $v0,$0,print_char   #substituido por 11
	ori $a0,$0,' '
	syscall			#é impresso um espaço
	andi $a0,$t0,0x00F0	#$a0 = $t0 & 0x000000F0
	srl  $a0,$a0,4		#$a0 = d1
	ori  $v0,$0,print_int16  #é substituido por 34
	syscall			#impresso d1
	ori $v0,$0,print_char   #substituido por 11
	ori $a0,$0,' '
	syscall			#é impresso um espaço
	andi $a0,$t0,0x000F	#$a0 = $t0 & 0x0000000F
	ori $v0,$0,print_int16  #é substituido por 34
	syscall			#impresso d0
	jr  $ra			#EOP
	
	
	
	
