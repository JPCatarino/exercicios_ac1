# Mapa de Registos
# dst     - $a0 -> $s0
# src     - $a1 -> $s1
# pos 	  - $a2 -> $s2
# p       - $a0 ->$s3
# len_dst - $s4
# len_src - $s5
# i	  - $t2

insert:		subi	$sp,$sp,28		# salvaguardar registos
		sw	$s0,0 ($sp)		#
		sw	$s1,4 ($sp)		#
		sw	$s2,8 ($sp)		#
		sw	$s3,12($sp)		#
		sw	$s4,16($sp)		#
		sw	$s5,20($sp)		#
		sw	$ra,24($sp)		#
		move	$s0,$a0			#
		move	$s1,$a1			#
		move	$s2,$a2			#
		move	$s3,$a0			# char *p = dst
		or	$a0,$s0,$0		#
		jal	strlen			#
		move	$s4,$v0			# len_dst = strlen(dst)
		or	$a0,$s1,$0		#
		jal	strlen			#
		move	$s5,$v0			# len_src = strlen(src)
	
if_in:		bgt	$s2,$s4,end_in		# if(pos <= len_dst){
		or	$t2,$s4			# 	i = len_dst
if_for1_in:	blt	$t2,$s2,end_for1_i	# 	for( i = len_dst; i >= pos; i--){
		addu	$t3,$t2,$s5		# 		$t3 = i + len_src
		addu	$t3,$s0,$t3		# 		$t3 = dst[i + len_src]
		addu	$t4,$s0,$t2		# 		$t4 = dst[i]
		lb	$t5,0($t4)		#
		sb	$t5,0($t3)		# 		dst[i + len_src] = dst [i];
		subi	$t2,$t2,1		# 		i--
		j	if_for1_in		#	}
		
end_for1_i:	li	$t2,0			# 	i = 0

if_for2_in:	bge	$t2,$s5,end_in		# 	for(i = 0; i< len_src; i++){
		addu	$t3,$t2,$s2		# 		i+pos
		addu	$t3,$s0,$t3		# 		dst[i + pos]
		addu	$t4,$s1,$t2		# 		src[i]
		lb	$t5,0($t4)		# 		temp = src[i]
		sb	$t5,0($t3)		# 		dst [ i + pos] = src[i]	
		addi	$t2,$t2,1		#		i ++
		j	if_for2_in		#	}
						# }
end_in:		move	$v0,$s3
		lw	$s0,0 ($sp)		# retornar registos
		lw	$s1,4 ($sp)		#
		lw	$s2,8 ($sp)		#
		lw	$s3,12($sp)		#
		lw	$s4,16($sp)		#
		lw	$s5,20($sp)		#
		lw	$ra,24($sp)		#
		addu	$sp,$sp,28		# 
		jr	$ra			# return *p
		
########################################################################################	
	
read_str:	subi	$sp,$sp,12		# salvaguardar registos
		sw	$s0,0($sp)		#
		sw	$s1,4($sp)		#
		sw	$ra,8($sp)		#
		move	$s0,$a0			#
		move	$s1,$a1			#
		li	$v0,read_string		#
		syscall				# read_string(s, size)
		or	$a0,$s0,$0		#
		jal	strlen			#
		move	$t0,$v0			# len = strlen(s)
		subiu	$t1,$t0,1		# $t1 = len - 1
		addu	$t1,$s0,$t1		# s[len -1 ]
		lw	$t2,0($t1)		#
		
if_read:	bne	$t2,0x0A,end_read	# if( s[len - 1] == 0x0A){
		li	$t3,'\0'		#
		sb	$t3,0($t1)		# s[len -1 ] = '\0'
		
end_read:	lw	$s0,0($sp)		# repor registos
		lw	$s1,4($sp)		#
		lw	$ra,8($sp)		#
		addi	$sp,$sp,12		#
		jr	$ra			#
		
	









#########################################################################################################
strlen:		li	$t1,0		# len = 0
while:		lb	$t0,0($a0)	# while(*s++ != '\0')
		addiu	$a0,$a0,1	#
		beq	$t0,'\0',endw	# {
		addi	$t1,$t1,1	# 	len ++
		j	while		# }
endw:		move	$v0,$t1		# return len;
		jr	$ra		#
