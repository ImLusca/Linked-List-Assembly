	.data
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
		add %reg, 
	.end_macro
	
	.macro criar_lista
		jal list_new
	.end_macro
	
	.macro inserir_lista (%novo_valor)
		empilhar a0
		add a0, zero, %novo_valor
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
	criar_slot      # chama funçao para criar um slot zerado
	desempilhar ra
	ret
	
list_insert:
	empilhar ra
	
	desempilhar ra
	ret
	
	

	
	
	
