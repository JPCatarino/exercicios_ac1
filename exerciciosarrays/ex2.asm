# Mapa de registos:
# size 		- $t0	
# i    		- $t1
# aux    	- $t2
# flag		- $t3
# marker	- $t4	
# dup_counter	- $t5
# *p1		- $t6
# *p2		- $t7
# *p3		- $t8

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
		la	$a0,str1
		li	$v0,print_string
		syscall				# print_string("numero de ele")
		la	$v0,read_int
		syscall
		or	$t0,$v0,$0		# size = read_int()
		la	$t6,array		# *p1 = &(array[0])
		la	$t7,mark_array		# *p2 = &(mark_array[0])
		sll	$t9,$t0,2		# $t9 = size * 4
		addu	$t9,$t9,$t6		# $(array[size])
						# le o valores do array
forread:	bge	$t6,$t9,mark		# for(p1 = array, i = 0; p1 < array + size; p1++, i++){
		la	$a0,str2
		li	$v0,print_string
		syscall				# print_string("Elem[")
		or	$a0,$t1,$0			
		li	$v0,print_int10		
		syscall				# print_int10(i)
		la	$a0,str3		
		li	$v0,print_string
		syscall				# print_string("]  :  ")	
		li	$v0,read_int		
		syscall				
		sw	$v0,0($t6)		# *p = read_int()
		sw	$0,0($t7)		# *p2++ = 0
		addu	$t7,$t7,4		# *p2++
		addu	$t6,$t6,4		# p1++
		addiu	$t1,$t1,1		# i++
		j	forread			# }
						# marca elementos repetidos
mark:		la	$t6,array		# *p1 = &(array[0])
		

f_mark:		bge	$t6,$t9,const		# for(p1 = array; p1 < array + size; p1++){
		li	$t4,1			# marker = 1
		la	$t8,mark_array		# p3 = mark_array
		la	$t7,array		# p2 = array
		
f2_mark:	bge	$t7,$t9,endfmark	# for(p2 = array; p2 < array + size; p2++){
		
f2_mark_if:	lw	$t2,0($t6)		#
		lw	$t3,0($t7)		#
		bne	$t2,$t3,endf2mark	# if( *p1 == *p2) {
		sw	$t4,0($t8)		# *p3 = marker++	
		addiu	$t4,$t4,1		# marker++	}

endf2mark:	addu	$t8,$t8,4		# p3++
		addu	$t7,$t7,4		# p2++
		j	f2_mark			# }
		
endfmark:	addu	$t6,$t6,4		# p1++
		j	f_mark			# }
						# constroi array de repetidos
const:		la	$t6,mark_array		# p1 = &(mark_array[0])
		la	$t7,array		# p2 = &(array[0])
		la	$t8,dup_array		# p3 = &(dup_array[0])
		li	$t5,0			# dup_counter = 0
		sll	$t9,$t0,2		# $t9 = size * 4
		addu	$t9,$t9,$t6		# $t9 = &(mark_array[size])
		

for_const:	bge	$t6,$t9,ord		# for(p1 = mark_array, dup_counter = 0; p1 < mark_array + size; p1++,p2++){
		lw	$t3,0($t6)		# $t3 = *p1
		bne	$t3,2,end_for_c		# if(*p1 == 2){
		lw	$t1,0($t7)		# $t1 = *p2
		sw	$t1,0($t8)		# *p3 = *p2
		addu	$t8,$t8,4		# *p3++
		addiu	$t5,$t5,1		# dup_counter++
						# }
end_for_c:	addu	$t6,$t6,4		# p1++
		addu	$t7,$t7,4		# p2++
		j	for_const		# }
						# ordena array de repetidos
ord:		subi	$t3,$t5,1		# dup_counter--
		sll	$t3,$t3,2		#
		la	$t2,dup_array 		#
		addu	$t7,$t3,$t2		# p2 = dup_array + dup_counter - 1 
		
do_ord:		li	$t3,0			# flag = 0
		la	$t6,dup_array		# p1 = dup_array
		
		
ford:		bge	$t6,$t7,end_dord
		lw	$t1,0($t6)		# $t1 = *p1
		lw	$t4,4($t6)		# $t4 = *p1+1
		ble	$t1,$t4,end_ford	# if(*p1 > *(p1+1)) {
		sw	$t4,0($t6)		# *p1 = *p1 + 1
		sw	$t1,4($t6)		# *p1+1 = *p1
		li	$t3,1			# flag = 1
						# }
end_ford:	addu	$t6,$t6,4		# p1++
		j	ford			# }

end_dord:	subu	$t7,$t7,4		# p2--
		beq	$t3,1,do_ord		# }
						# imprime elementos repetidos
print_arr:	ble	$t5,0,else_arr		# if(dup_counter > 0) {
		la	$a0,str4		#
		li	$v0,print_string	#
		syscall				# print_string(" O numero de ")
		or	$a0,$0,$t5		#
		li	$v0,print_int10		#
		syscall				# print_int10(dup_counter)
		la	$a0,str5		#
		li	$v0,print_string	#
		syscall				# print_string("os elementos repetidos...")
		la	$t6,dup_array		# p1 = dup_array
		la	$t7,dup_array		# $t7 = dup_array
		sll	$t8,$t5,2		#
		addu	$t3,$t8,$t6		# $t3 = dup_counter + dup_array
		
for_print:	bge	$t6,$t3,end_prog	# for(p1 = dup_array; p1 < dup_array + dup_counter; p1++)
		beq	$t6,$t7,cont_for	# if(p1 != dup_array)
		la	$a0,str7		#
		li	$v0,print_string	#
		syscall				# print_string(",")
		
cont_for:	lw	$a0,0($t6)		# $t1 = *p1
		li	$v0,print_int10		#
		syscall				# print_int10(*p1)
		
end_for:	addiu	$t6,$t6,4		# p1++
		j	for_print		# }

else_arr:	la 	$a0,str6		# else{
		li	$v0,print_string	#
		syscall				# print_string(" não há elementos")
		
end_prog:	la	$a0,str8		#
		li	$v0,print_string	#
		syscall				# print_string("\n")
		jr	$ra

		

		

		
			
