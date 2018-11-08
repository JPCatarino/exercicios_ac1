# Mapa de Registos		
# $t0   -  i
# $t1   -  array_size
# $t2	-  insert_value
# $t3   -  array
# $t4   -  insert_pos
		
		
		.data
		.eqv	read_int,5
		.eqv	print_int10,1
		.eqv	print_string,4
vir:		.asciiz ", "
str1:		.asciiz "Size of array : "
str2:		.asciiz	"array["
str3:		.asciiz "] = "
str4:		.asciiz "Enter the value to be inserted: "
str5:		.asciiz "Enter the position :"
str6:		.asciiz "\nOriginal array:"
str7:		.asciiz "\nModified array: "
		.align  2
array:		.space  50 
		.text
		.globl  main
		
main:		la	$a0,str1
		li	$v0,print_string
		syscall				# print_string("Size of...")
		li	$v0,read_int
		syscall				# read_int()
		or	$t1,$v0,$0		# array_size = read_int()
		li	$t0,0			# i = 0
		la	$t3,array

for_main:	bge	$t0,$t1,end_for_m	# for(i = 0; i < array_size; i++){
		la	$a0,str2		#
		li	$v0,print_string	#
		syscall				# print_string("array[")
		or	$a0,$t0,$0			# 
		li	$v0,print_int10		#
		syscall				# print_int10(i)
		la	$a0,str3		#
		li	$v0,print_string	#
		syscall				# print_string(" ] = ")
		sll	$t4,$t0,2		#
		addu	$t4,$t3,$t4		# &(array[i])
		li	$v0,read_int		#
		syscall				#
		sw	$v0,0($t4)		# array[i] = read_int()
		addi	$t0,$t0,1		# i++
		j	for_main		# }

end_for_m:	la	$a0,str4		#
		li	$v0,print_string	#
		syscall				# print_string(" Enter the value ")
		li	$v0,read_int		#
		syscall				#
		or	$t2,$v0,$0		# insert_value = read_int()
		la	$a0,str5		#
		li	$v0,print_string	#
		syscall				# print_string("Enter the pos:")
		li	$v0,read_int		#
		syscall				#
		or	$t4,$v0,$0		# insert_pos = read_int()
		la	$a0,str6		#
		li	$v0,print_string	#
		syscall				# print_string("ogar")
		move	$s0,$t3			# passar apra registos s
		move	$s1,$t2			# salvar na stack
		move	$s2,$t4			#
		move	$s3,$t1			# 
		subi	$sp,$sp,20		#
		sw	$s0,0($sp)		#
		sw	$s1,4($sp)		#
		sw	$s2,8($sp)		#
		sw	$s3,12($sp)		#
		sw	$ra,16($sp)		#	
		move	$a0,$s0			#
		move	$a1,$s3			#
		jal	print_array		# print_array(array,array_size)
		lw	$s0,0($sp)		#
		lw	$s1,4($sp)		#
		lw	$s2,8($sp)		#
		lw	$s3,12($sp)		#
		lw	$ra,16($sp)		#
		addi	$sp,$sp,20		#
		sw	$s0,0($sp)		#
		sw	$s1,4($sp)		#
		sw	$s2,8($sp)		#
		sw	$s3,12($sp)		#
		sw	$ra,16($sp)		#	
		move	$a0,$s0			#
		move	$a1,$s1			#
		move	$a2,$s2			#
		move	$a3,$s3			#
		jal	insert			# insert(array, insert_value, isnert_pos, array_size)
		lw	$s0,0($sp)		#
		lw	$s1,4($sp)		#
		lw	$s2,8($sp)		#
		lw	$s3,12($sp)		#
		lw	$ra,16($sp)		#
		addi	$sp,$sp,20
		la	$a0,str7		#
		li	$v0,print_string	#
		syscall				# print_string("modi")
		subi	$sp,$sp,4		#
		sw	$ra,0($sp)
		move	$a0,$s0			#
		move	$a1,$s3			#
		jal	print_array		# print(array)
		lw	$ra,0($sp)		#
		addi	$sp,$sp,4		#
		jr	$ra










insert:		li	$t0,0			# i = 0
		ble	$a2,$a3,else_ins	# if( pos > size ){
		li	$v0,1			# 
		jr	$ra			# return 1;

else_ins:	subi	$t0,$a3,1		# i = size - 1

for_ins:	blt	$t0,$a2,end_for_ins	# 
		sll	$t2,$t0,2		#
		addu	$t2,$a0,$t2		# array[i]
		lw	$t1,0($t2)		#
		sw	$t1,4($t2)		#
		subi	$t0,$t0,1		# i--
		j	for_ins			#
	
end_for_ins:	sll	$t2,$a2,2	#
		addu	$t2,$a0,$t2	# $t2 = array[pos]
		sw	$a1,0($t2)	# array[pos] = value
		li	$v0,0		# $v0 = 0
		jr	$ra		# return 0;
		
print_array:	la	$t3,($a0)
		sll	$t5,$a1,2
		add	$t0,$t3,$t5	# int *p = a + n

for_print:	bge	$t3,$t0,end_for	#  for(; a < p; a++) {
		lw	$t1,0($t3)	#  a
		or	$a0,$t1,$0	#
		li	$v0,print_int10
		syscall
		la	$a0,vir		
		li	$v0,print_string
		syscall			#
		addi	$t3,$t3,4	#
		j	for_print

end_for:	jr	$ra		#
		
		
