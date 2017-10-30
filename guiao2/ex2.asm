	.data
	.text
	.globl main

main:	sll $t2,$t0,4	# $t0 é inicializado na janela
	srl $t3,$t0,4	# "Registers" do MARS
	sra $t4,$t0,4	#
	jr  $ra		# EOP		