# Luiz Henrique Mosmann
# T1 - ORG ARQ I

.data 
	vet:     .word -5 -1 5 9 12 15 21 29 31 58 250 325
	first:   .word 4
	last:    .word 11
	num:     .word 31
	message: .asciiz "\nPosição do número no vetor: " 
	
.text
main:
	subiu $sp, $sp, 24 # abre a Pilha com 6 posições
	
	# Endereço das variáveis fixas nos $s:
	la $s0, vet   # $s0 <- vet
	la $s1, first # $s1 <- first
	la $s2, last  # $s2 <- last
	la $s3, num   # $s3 <- num
	
	# Valores das variáveis:
	lw $s1, ($s1)
	lw $s2, ($s2)
	lw $s3, ($s3)
	
	# Salvando os valores na Pilha:
	sw $ra, 16($sp)
	sw $s0, 12($sp)
	sw $s1, 8($sp)
	sw $s2, 4($sp)
	sw $s3, 0($sp)
	
	li $v0, 4
	la $a0, message # irá exibir na tela a posição do elemento procurado
	syscall
	
	jal binSearch
	
	addiu $sp, $sp, 20 # deixa somente uma posição na pilha que é onde será guardada a resposta
	lw $v0, ($sp)          # aqui
	move $a0, $v0
	li $v0, 1
	syscall
	addiu $sp, $sp, 4 # encerra a pilha
	
	li $v0, 10
	syscall
	
 binSearch:
 	ble $s1, $s2, ciclo # (s1 < s2 == true) => ciclo
 	j outVet
 	
 ciclo: 
 	addu $s4, $s1, $s2 
 	srl  $s4, $s4, 1  # para pegar a posição do meio do vetor ($s4 / 2)
 	
 	lw   $t0, 12($sp)
 	
 	sll  $s5, $s4, 2 # t0 * 4
 	add  $t0, $t0, $s5
 	lw   $t0, 0($t0)
 	
 	beq $s3, $t0, find # Caso para ==
 	beq $s1, $s2, outVet
 	
 	bgt $s3, $t0, bigger # Caso para >
 	
 	bgt $t0, $s3, smaller # Caso para <
 	
 
	jr $ra
  	 	
 find:
 	move $v0, $s4
 	sw   $v0, 20($sp)
 	jr   $ra  	 	
  	 	
 outVet:
 	li $v0, -1
 	sw $v0, 20 ($sp)
 	jr $ra
 	
 bigger:
 	add $s4, $s4, 1
 	sw  $s4, 8($sp)
 	lw  $s1, 8($sp)
 	j binSearch
 	
 smaller:
 	subiu $s4, $s4, 1
 	sw $s4, 4($sp)
 	lw $s2, 4($sp)
 	j binSearch
	
