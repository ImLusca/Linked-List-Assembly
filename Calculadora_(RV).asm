	.data
strFstInput:.asciz "Insira a primeira operação: \n"
strInput: 	.asciz "Insira a próxima operação: \n"
strOutMul: 	.asciz "O produto de "
strOutSum: 	.asciz "A soma de "
strOutDiv: 	.asciz "A Divisão entre "
strOutSub: 	.asciz "A subtração entre "
strAnd:			.asciz " e "
strEquals:	.asciz " é igual a: "
	.text
# ====== DEFINIÇOES DO PROGRAMA =======
	.align 2
	.globl main
	
# ============== MACROS =============
	.macro empilhar (%reg)
		addi sp, sp, -4
		sw %reg, (sp)
	.end_macro
	
	.macro desempilhar (%reg)
		addi sp, sp, 4
		lw %reg, (sp)
	.end_macro
	
	.macro criar_slot (%reg, %dado, %endereço)
		add a0, zero, %dado
		add a1, zero, %endereço
		jal list_make_slot
		add %reg, zero, t2
	.end_macro
	
	.macro criar_lista
		jal list_new
	.end_macro
	
	.macro inserir_lista (%novo_valor, %endereço_lista)
		empilhar a0
		add a0, zero, %novo_valor
		add a1, zero, %endereço_lista
		jal list_insert
		desempilhar a0
	.end_macro

# ============= MAIN ===============
main:	
	criar_lista
	add t1, zero, a0
	lb t0, (t1)
	li a7, 1
	add a0, zero, t0
	ecall
	addi t1, t1, 1
	lb t0, (t1)
	add a0, zero, t0
	ecall
	li a7, 10
	ecall
	

# ========= OPERAÇÕES =========

trata_op:
	add t0, zero, zero 				# Reinicia o valor de t0
	li t0, '+' 						# Carrega o caractere '+' em t0
	beq t0, a2, adiciona 			# Se t0 == a2 -> função adiciona
	
	add t0, zero, zero				# Reinicia o valor de t0
	li t0, '-'						# Carrega o caractere '-' em t0
	beq t0, a2, subtrai				# Se t0 == a2 -> função subtrai

	add t0, zero, zero				# Reinicia o valor de t0
	li t0, '*'						# Carrega o caractere '*' em t0
	beq t0, a2, multiplica			# Se t0 == a2 -> função multiplica

	add t0, zero, zero				# Reinicia o valor de t0
	li t0, '/'						# Carrega o caractere '/' em t0
	beq t0, a2, divide				# Se t0 == a2 -> função divide

adiciona:
	addi a0, s0, 0 					# Salva o valor tirado da lista em a0
	add s0, a0, a1 					# Cálculo principal - s0 = a0 + a1
	ret
subtrai:
	addi a0, s0, 0 					# Salva o valor tirado da lista em a0
	sub s0, a0, a1 					# Cálculo principal
	ret
multiplica:
	addi a0, s0, 0 					# Salva o valor tirado da lista em a0
	mul s0, a0, a1 					# Cálculo principal
	ret
divide:
	addi a0, s0, 0 					# Salva o valor tirado da lista em a0
	div s0, a0, a1 					# Cálculo principal
	ret

undo:

finalizar:
	li a7, 10 						# Carrega o serviço de finalização de programa
	ecall							# Chamada do sistema (encerra o programa)

# ========= FUNÇOES DA LISTA ==========
#
#
#		
list_make_slot:
	empilhar ra
	empilhar a0             # guarda o dado (a0) na stack, a0 passa a servir para guardar bytes alocados e depois endereço do espaço alocado
	li a0, 2  # guarda 2 (bytes) em a0
	li a7, 9          # coloca instruçao 9 (aloca quantidade de bytes em a0 e retorna endereço em a0) em a7
	ecall    # executa alocaçao de memoria
	add t2, zero, a0            # copia endereço do espaço alocado para t2 (definitivo)
	add t1, zero, a0  # copia endereço do espaço alocado para t1 (aponta para o NUM)
	desempilhar a0            # a0 volta a guardar o dado
	sb a0, (t1)     # coloca 0 em NUM do primeiro item da lista alocado
	addi t1, t1, 1              # move o endereço do espaço alocado 1 byte (aponta para END)
	sb a1, (t1)       # insere endereço em END 
	#                  *Se for ultimo da lista, END eh -1 (flag para marcar que nao ha proximo endereço)
	desempilhar ra
	ret
	
list_new:
	empilhar ra
	empilhar a0            # guarda a0 na stack
	li a0, 8    # coloca 8 (bytes) em a0
	li a7, 9          # coloca instruçao 9 (aloca quantidade de bytes em a0 e retorna endereço em a0) em a7
	ecall
	add t2, zero, a0      # armazena endereço alocado em t2 (definitivo)
	add t1, zero, a0           # armazena endereço alocado em t1 (acesso de dados)
	criar_slot            # chama funçao para criar um slot zerado
	desempilhar ra
	ret
	
# FUNCAO INSERT LIST ---------
# a0 - valor inserido
# a1 - endereço da lista
# t0 - cabeça da lista (1o byte do endereço da lista)
# t1 - cauda da lista (2o byte do endereço da lista)
# t2 - endereço do novo slot da lista

list_insert:
	empilhar raa	ww t0, (a1   # guarda em t0 o endereço da cabeça da lista)	add a1, a1,41    # passa para o segundoendereçoe da lista (cauda
lw t1, (a1)    # guarda em t1 o endereço da cauda da lista
add a1, a1, -44    # retorna a1 para o primeiro byte da lista (cabeça)


criar_slot t2, a0, t1  # cria um slot novo que ganha o valor inserido (a0) como valor armazenado, 
#                       o endereço do slot anterior (t1) como endereço do ant e tem seu endereço
#                       guardado em t2

add 
	desempilhar ra


# ========= FUNÇOES DE IO ==========
#
#

 #FUNÇÃO READ FIRST INPUT -----------
 #Lê o primeiro e segundo, armazenando em a1 e a2 e a operação em a0
lerPrimeiroInput:
	li a7, 4						# Carrega o serviço de printar string
	la a0, strFstInput  # Carrega a string como argumento
	ecall								# Chama o serviço

	li a7, 5						# Carrega o serviço de ler inteiro
	ecall								# Chama o Serviço
	add t0, zero, a0		# Armazena em t0 o resultado da primeira leitura

	li a7, 12						# Carrega o serviço de ler string
	ecall								# Chama o Serviço
	add t1, zero, a0		# Armazena em t1 o resultado da leitura da operação

	li a7, 5						# Carrega o serviço de ler inteiro
	ecall								# Chama o Serviço
	add t2, zero, a0		# Armazena em t2 o resultado da segunda leitura

	add  a0, zero, t1		# Armazena em a0 a opração
	add  a1, zero, t0		# Armazena em a1 o primeiro valor
	add  a2, zero, t2		# Armazena em a2 o segundo valor	

#FUNÇÃO DE READ INPUT --------------
# Lê o próximo comando, se for uma operação aritimética, também lê o próximo número
# Se for uma operação aritimética, retorna em a0 a operação e em a1 o próximo operador
lerInput:
	li a7, 4						# Carrega o serviço de printar string
	la a0, strInput  		# Carrega a string como argumento
	ecall								# Chama o serviço

	jal leOperacao			# Função para ler operação
	
	li t0, 177					# Armazena 'u' em t0 para comparar
	li t1, 102					# Armazena 'f' em t0 para comparar
	beq t0, a0, naoEhAritimetica
	beq t1, a0, naoEhAritimetica # Se o char lido for u ou f, retorna sem ler o próximo número

	add t0, zero, a0		# Armazena em t0 a operação 

	li a7, 5						# Carrega o serviço de ler inteiro
	ecall								# Chama o Serviço
	add t1, zero, a0		# Armazena em t1 o valor da operação

	add a0, zero, t0		# Armazena em a0 a operação
	add a1, zero, t1		# Armazena em a1 o valor da operação
	jalr zero, 0(ra)		#	retorna

leOperacao:
	li a7, 12						# Carrega o serviço de ler string
	ecall								# Chama o Serviço
	add t1, zero, a0		# Armazena em t1 o resultado da leitura da operação

	li t0, 32						# Compara o valor 32(caractere ' ') para comparar
	beq a0, t0, leOperacao # Se ler espaço, lê novamnete

	jalr
naoEhAritimetica:
	jalr zero, 0(ra)
	
#FUNÇÃO OUTPUT ---------------------
# Recebe em a0 a operação e em a1 e a2 o primeiro e segundo valor e em a3 o resultado
printaResultado:
	li a7, 4						# Carrega o serviço de printar string
	
	li t0, 42 					# Carrega o Char '+' em t0 para comparacao
	beq t0, a0, soma    # Se for soma, vai para rotina
	
	li t0, 43 					# Carrega o Char '*' em t0 para comparacao
	beq t0, a0, mult    # Se for multiplicacao, vai para rotina
	
	li t0, 47 					# Carrega o Char '/' em t0 para comparacao
	beq t0, a0, soma    # Se for divisão, vai para rotina

	la a0, strOutSub		# Se não for nenhum dos anteriores, é uma subtração
	ecall
	li a7, 1						# Carrega Serviço de printa inteiro
	add a0, zero, a1		# 

	la a0, strEquals		# Carrega a string " e "
	ecall

soma:
	la a0, strOutSum
	ecall


