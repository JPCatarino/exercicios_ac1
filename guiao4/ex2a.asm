# Mapa de registos
# num:	$t0
# p: 	$t1
# *p:	$t2
	.data
	.eqv	SIZE,20
	.eqv	read_string,8
	.eqv	print_int10,1
str:	.space 	20
	.text
	.globl  main

main:  la 	$a0,str			# $a0 = &str[0]
       li 	$a1,SIZE		# $a1 = SIZE
       li	$v0,read_string
       syscall
       or	$t1,$a0,$0
       la	$t1,str			# p = str;
while: 					# while(*p != '\0')
       lb	$t2,0($t1)
       beq	$t2,0x00,endw
       blt	$t2,0x30,endif    	# if(srt [i] >= '0' $$
       bgt	$t2,0x39,endif	   	# str[i] <= 9
       addi	$t0,$t0,1		# num++
endif: 
       addiu 	$t1,$t1,1		# p++
       j	while
endw:  or	$a0,$t0,$0
       li	$v0,print_int10
       syscall
       jr	$ra
       	
       		
       