# Mapa de Registos:
# i		- $t0
# size		- $t1
# dup_counter   - $t2
# marker	- $t4
#
# array		- $t7
# mark_array	- $t8
# dup_array	- $t9	
		
		.data
		.eqv	read_string,8
		.eqv	print_int10,1
		.eqv	print_string,4
		.eqv	print_char,11
		.eqv	MAX_SIZE,100
str1:		.asciiz	"Frase: "
str2:		.asciiz "\nO numero de repetidos e: "
str3:		.asciiz "\nOs elementos repetidos sao: "
str4:		.asciiz "\nNao ha elementos repetidos"
str5:		.asciiz ", "
str6:		.asciiz "\n"
		.align	2
array:		.space	100
		.align 	2
mark_array:	.space	100
		.align	2
dup_array:	.space  50
		.text
		.globl	main

main:		la	$a0,str1			# 
		li	$v0,print_string		#
		syscall					# print_string("frase")
		la	$a0,array			#
		li	$a1,MAX_SIZE			#
		subi	$a1,$a1,1			#
		li	$v0,read_string			#
		syscall					# read_string(array,MAX_SIZE)
		li	$t0,0				# i =0				
		la	$t7,array			# &(array[0]
							# calcula a dimensao, inicializa mark_array e converte em minusculas
for_min:	addu	$t2,$t7,$t0			# $t2 = &array[i]
		lb	$t3,0($t2)			# $t3 = array[i]
		beq	$t3,'\0',end_for_mi		# for(i=0;array[i] != '\0';i++){
		
ifor_min:	blt	$t3,'a',end_ifor_mi		# if(array[i] >= 'a' && array[i] <= 'z'){
		bgt	$t3,'z',end_ifor_mi		# 
		subi	$t3,$t3,0x20			# 
		sb	$t3,0($t2)			# array[i] -= 0x20}
		
end_ifor_mi:	la	$t8,mark_array			# $t8 = &(mark_array[0])
		sll	$t3,$t0,2			#
		addu	$t3,$t8,$t3			# $t3 = &(mark_array[i])
		sw	$0,0($t3)			# mark_array[i] = 0
		addi	$t0,$t0,1			# i++
		j 	for_min				# }

end_for_mi:	move	$t1,$t0				# size = i
		la	$t0,0				# i = 0
							# marca elementos repetidos
for_mark:	bge	$t0,$t1,const			# for(i=0; i < size; i++){
		li	$t3,0				# j = 0
		li	$t4,1				# marker = 1
							# 
for2_mark:	bge	$t3,$t1,end_for_ma		# for(j=0,marker=1;j<size;j++){
		la	$t7,array			# 
		addu	$t5,$t7,$t0			# 
		addu	$t6,$t7,$t3			#
		lb	$t8,0($t5)			# $t8 = array[i]
		lb	$t9,0($t6)			# $t9 = array[j]
		
ifor2_ma:	bne	$t8,$t9,end_for2_ma		# if(array[i] == array[j]){
		la	$t8,mark_array			# 
		sll	$t5,$t3,2			#
		addu	$t8,$t8,$t5			#
		sw	$t4,0($t8)			# mark_array[j] = marker
		addi	$t4,$t4,1			# marker++
							#}
end_for2_ma:	addi	$t3,$t3,1			# j++
		j	for2_mark			#}

end_for_ma:	addi	$t0,$t0,1			# i++
		j	for_mark			# }
							# constroi array de repetidos
const:		li	$t0,0				# i = 0 
		li	$t2,0				# dup_counter = 0 
		
for_const:	bge	$t0,$t1,ord_arr			# for(i=0, dup_counter = 0; i < size; i++){
		la	$t6,array			# 
		la	$t7,mark_array			#
		sll	$t3,$t0,2			#
		addu	$t7,$t7,$t3			# &(mark_array[i]
		addu	$t6,$t6,$t0			# &(array[i])
		lb	$t8,0($t6)			# $t8 = array[i]
		lw	$t9,0($t7)			# $t9 = mark_array[i]

ifor_const:	bne	$t9,2,end_for_co		# if(mark_array[i] == 2 && array[i] != ' '){
		beq	$t8,' ',end_for_co		#
		la	$t9,dup_array			# 
		addu	$t7,$t9,$t2			#
		sb	$t8,0($t7)			# dup_array[dup_counter] = array[i]
		addi	$t2,$t2,1			# dup_counter++ }
		
end_for_co:	addi	$t0,$t0,1			# i++
		j	for_const			# }
							# ordena array de repetidos
ord_arr:	subi	$t3,$t2,1			# j = dup_counter-1
		
dord_arr:	li	$t4,0				# flag = 0
		li	$t0,0				# i = 0

ford_arr:	bge	$t0,$t3,end_dord		# for(i=0;i < j;i++){
		la	$t8,dup_array			#
		addu	$t8,$t8,$t0			#
		lb	$t7,0($t8)			# $t7 = dup_array[i]
		lb	$t9,1($t8)			# $t9 = dup_array[i+1]
		
		
iford_arr:	ble	$t7,$t9,end_ford		# if(dup_array[i] > dup_array[i+1]
		sb	$t9,0($t8)			# dup_array[i] = dup_array[i+1]
		sb	$t7,1($t8)			# dup_Array[i+1] = dup_array[i] 
		la	$t4,1
		
end_ford:	addi	$t0,$t0,1			# i++
		j	ford_arr			# }

end_dord:	subi	$t3,$t3,1			# j--
		bne	$t4,1,print_arr			# }while(flag == 1)
		j	dord_arr			# 
							# Imprime elementos repetidos
print_arr:	ble	$t2,0,else			# if(dup_counter > 0)
		la	$a0,str2			#
		li	$v0,print_string		#
		syscall					# print_string("O numero de...")
		or	$a0,$t2,$0			#
		li	$v0,print_int10			#
		syscall					# print_int10(dup_counter)
		la	$a0,str3			#
		li	$v0,print_string		#
		syscall					# print_string("Os elementos...")
		li	$t0,0				# i = 0
		la	$t9,dup_array			#
		
for_print:	bge	$t0,$t2,end_pro			# for(i = 0; i < dup_counter,i++)
		beq	$t0,0,forc_print		# if(i != 0)
ifor_print:	la	$a0,str5			#
		li	$v0,print_string		#
		syscall					# print_string(", ")

forc_print:	addu	$t8,$t9,$t0			# 
		lb	$a0,0($t8)			#
		li	$v0,print_char			#
		syscall					# print_char(dup_counter[i]
		addi	$t0,$t0,1			# i++
		j	for_print			# }
							# else{
else:		la	$a0,str4			#
		li	$v0,print_string		#
		syscall					# print_string( " não há...")
		
end_pro:	la	$a0,str6			#
		li	$v0,print_string		#
		syscall					# print_string("\n")
		jr	$ra				# return 0
		

		


	
		
		
					
			
		
