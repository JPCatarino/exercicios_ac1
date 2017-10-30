# Mapa de registos:
# size 		- $t0	
# i    		- $t1
# j    		- $t2
# aux2		- $t3
# aux3		- $t4	
# aux		- $t5
# aux4		- $t6
# marker	- $s0
# dup_counter	- $s1
# flag		- $s2
# aux5		- $s3


	
		.data
		.eqv	read_int,5
		.eqv	print_int10,1
		.eqv	print_string,4
str1:		.asciiz	"Numero de elementos do array: "
str2:		.asciiz "Elem["
str3:		.asciiz "]  :  "
str4:		.asciiz "\nO numero de repetidos e: "
str5:		.asciiz "\nOs elementos repetidos sao: "
str6:		.asciiz "\nNao ha elementos repetidos"
str7:		.asciiz ", "
str8:		.asciiz "\n"
		.align	2
array:		.space	50
		.align 	2
mark_array:	.space	50
		.align	2
dup_array:	.space  25
		.text
		.globl	main
	
main:		li	$t0,0			# int size
		li	$t1,0			# int i
		li	$t2,0			# int j
		li	$t3,0			# int aux2
		li	$t4,0			# int aux3
		li	$t5,0			# int aux
		li	$t6,0			# int aux4
		li	$s0,1			# int marker
		li	$s1,0			# int dup_counter
		li	$s2,0			# int flag
		la	$t7,array		# $t7 = &(array[0])
		la	$t8,mark_array		# $t8 = &(mark_array[0])
		la	$t9,dup_array		# $t9 = $(dup_array[0])
		la	$a0,str1
		li	$v0,print_string
		syscall				# print_string("numero de ele")
		la	$v0,read_int
		syscall
		or	$t0,$v0,$0		# size = read_int()
		
for:		bge	$t1,$t0,mark		# for(i=0;i < size;i++){
		la	$a0,str2
		li	$v0,print_string
		syscall				# print_string("Elem[")
		or	$a0,$t1,$0			
		li	$v0,print_int10		
		syscall				# print_int10(i)
		la	$a0,str3		
		li	$v0,print_string
		syscall				# print_string("]  :  ")
		sll	$t5,$t1,2		# aux = i * 4
		addu	$t5,$t7,$t5		# aux = &array[i]
		li	$v0,read_int	
		syscall				
		sw	$v0,0($t5)		# array[i] = read_int()
		sll	$t5,$t1,2		# aux = i * 4
		addu	$t5,$t8,$t5		# aux = mark_array[i]
		sw	$0,0($t5)		# mark_array[i] = 0 
		addi	$t1,$t1,1		# i++
		j	for
						# marca elementos repetidos
mark:		li	$t5,0			# aux = 0
		li	$t1,0			# i   = 0
	
m_for:		bge	$t1,$t0,cont		# for(i = 0, i < size, i++)

m_for2:		bge	$t2,$t0,end_mfor	# for(j = 0, marker = 1, j < size, j++){
		
m_if:		sll	$t5,$t1,2		# aux = i * 4
		addu	$t5,$t7,$t5		# aux = &array[i]
		sll	$t3,$t2,2		# aux2 = j*4
		addu	$t3,$t7,$t3		# aux2 = &array[j]
		lw	$t4,0($t5)		# aux3 = array[i]
		lw	$t6,0($t3)		# aux4 = array[j]
		bne	$t4,$t6,end_mfor2	# if(array[i] == array[j]){
		sll	$t3,$t2,2		# aux2 = j*4
		addu	$t3,$t8,$t3		# aux2 = &array[j]
		sw	$s0,0($t3)		# mark_array[j] = marker
		addi	$s0,$s0,1		# marker++ }

end_mfor2:	addi	$t2,$t2,1		# j++
		j	m_for2			# }

end_mfor:	addi	$t1,$t1,1		# i++
		li	$t2,0			# j = 0
		li	$s0,1			# marker = 1
		j	m_for			# }
						# Constroi array de repetidos
cont:		li	$t1,0			# i = 0
		li	$t4,0			# aux3 = 0

for_arr:	bge	$t1,$t0,ord		# for(i = 0, dup_counter = 0; i < size ; i++)
		sll	$t3,$t1,2		# aux2 = i * 4
		addu	$t3,$t8,$t3		# aux2 = &mark_array[i]
		lw	$t4,0($t3)		# aux3 = mark_array[i]
		bne	$t4,2,end_for_arr	# if ( mark_array[i] == 2)
		sll	$t3,$s1,2		# aux2 = dup_counter * 4
		addu	$t3,$t9,$t3		# aux2 = $dup_array[dup_counter]
		sll	$t5,$t1,2		# aux = i * 4
		addu	$t5,$t7,$t5		# aux = $array[i]
		lw	$s3,0($t5)		# aux5 = array[i]
		sw	$s3,0($t3)		# dup_array[dup_counter] = array[i]
		addi	$s1,$s1,1		# dup_counter++

end_for_arr:	addi	$t1,$t1,1		# i++
		j	for_arr			# }
						# ordena array de repetidos
ord:		subi	$t2,$s1,1		# j = dup_counter-1

dord:		li	$s2,0			# do{flag = 0
		li	$t1,0			# i = 0
		
ford:		bge	$t1,$t2,endford		# for(i = 0, i < j, i++){
		sll	$t3,$t1,2		# aux2 = i * 4
		addu	$t3,$t9,$t3		# aux2 = $dup_array[i]
		lw	$t5,0($t3)		# aux = dup_array[i]
		lw	$s3,4($t3)		# aux5 = dup_array[i+1]
		ble	$t5,$s3,endford		# if ( dup_array[i] > dup_array[i+1] ){
		sw	$s3,0($t3)		# dup_array[i] = dup_array[i + 1]
		sw	$t5,4($t3)		# dup_array[i + 1] = aux
		li	$s2,1			# flag == 1
		addi	$t1,$t1,1		# i++
		j 	ford			# }
						# }
endford:	subi	$t2,$t2,1		# j-- }
		beq	$s2,1,dord		# while ( flag == 1)
						# imprime elem repetidos
print:		ble	$s1,0,else		# if( dup_counter > 0) {
		la	$a0,str4		#
		li	$v0,print_string	#
		syscall				# print_string(" o numero de repetidos...")
		or	$a0,$0,$s1		#
		li	$v0,print_int10		#
		syscall				# print_int10(dup_counter)
		la	$a0,str5		#
		li	$v0,print_string	#
		syscall				# print_string("os elementos repetidos...")
		li	$t1,0			# i = 0

for_print:	bge	$t1,$s1,endprint	# for ( i = 0; i < dup_counter; i++){
		beq	$t1,0,printing		# if (i!=0){

print_vir:	la	$a0,str7		#
		li	$v0,print_string	#
		syscall				# print_string(", ")

printing:	sll	$t3,$t1,2		# i = i * 4
		addu	$t3,$t9,$t3		# $dup_array[i]
		lw	$a0,0($t3)		# $a0 = dup_array[i]
		li	$v0,print_int10		#
		syscall				# print_int10(dup_array[i])
		addi	$t1,$t1,1		# i++
		j	for_print		# }
						#}
else:		la	$a0,str6		# else{
		li	$v0,print_string	#
		syscall				# print_string("nao há elementos repe..")
						# }
endprint:	la	$a0,str8		#
		li	$v0,print_string	# 
		syscall				# print_string("\n")
		jr	$ra			# return 0

		
