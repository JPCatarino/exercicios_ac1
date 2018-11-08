	.data
	.eqv	read_string,8
	.eqv	print_string,4
	.eqv	print_int10,1
str1:	.asciiz	"Enter string: "
str2:	.asciiz "len: "
	.align 2
buf:	.space 50	
	.text
	.globl main

main:	subi	$sp,$sp,4
	sw	$ra,0($sp)
	la	$a0,str1
	li	$v0,print_string
	syscall			
	la	$a0,buf
	la	$a1,50
	li	$v0,read_string
	syscall	
	la	$a0,buf
	jal	strlen
	move	$t0,$v0
	la	$a0,str2
	li	$v0,print_string
	syscall
	move	$a0,$t0
	li	$v0,print_int10
	syscall
	lw	$ra,0($sp)
	addi	$sp,$sp,4
	jr	$ra







#######################strlen recursiva###########################################################
strlen:	lb	$t0,0($a0)	# $t0 = *s
	beq	$t0,'\0',else	# if(*s != '\0') {
	subu	$sp,$sp,4	#	reserva espaço na stack
	sw	$ra,0($sp)	#	salvaguarda $ra
	addiu	$a0,$a0,1	#
	jal	strlen		#	strlen(s + 1)
	addi	$v0,$v0,1	#	return(1 + strlen(s+1)
	lw	$ra,0($sp)	#	repoe o valor de $ra
	addu	$sp,$sp,4	#	liberta stack
	jr	$ra		# }

else:	li	$v0,0		# return 0
	jr	$ra		#
