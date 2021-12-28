.data

mensaje1:.asciiz "Inserte el numero romano:"
mensaje2:.asciiz "Numero invalido"

#representaciones_romanos
uno: .asciiz "I"
cinco: .asciiz "V"
diez : .asciiz "X"
cincuenta: .asciiz "L"
cien: .asciiz "C"
quinientos: .asciiz "D"
mil: .asciiz "M"

numero: .space 20
arreglo: .space 20

.text
.globl romanoDecimal

romanoDecimal:

	addi $sp, $sp, -64
	sw $ra,60($sp)
	sw $a0,56($sp)
	sw $a1,52($sp)
	sw $a2,48($sp)
	sw $a3,44($sp)
	sw $s0,40($sp)
	sw $s1,36($sp)
	sw $s2,32($sp)
	sw $s3,28($sp)
	sw $s4,24($sp)
	sw $t0,20($sp)
	sw $t1,16($sp)
	sw $t2,12($sp)
	sw $t3,8($sp)
	sw $t4,4($sp)
	sw $t5,($sp)

	#Pedir el número romano
	li $v0,54 #carga 4 en V0   
	la $a0,mensaje1 #carga el mensaje 1 en a0
	la $a1,numero
	addi $a2,$zero,20
	syscall 	
	
	#llamar a la función de obtener el decimal
	jal obtenerDecimal  #obtiene el decimal a partir del número dado

	#imprimir decimal
	li $v0,56  
	add $a1,$s0, $zero
	syscall
	
	lw $t5,($sp)
	lw $t4,4($sp)
	lw $t3,8($sp)
	lw $t2,12($sp)
	lw $t1,16($sp)
	lw $t0,20($sp)
	lw $s4,24($sp)
	lw $s3,28($sp)
	lw $s2,32($sp)
	lw $s1,36($sp)
	lw $s0,40($sp)
	lw $a3,44($sp)
	lw $a2,48($sp)
	lw $a1,52($sp)
	lw $a0,56($sp)
	lw $ra,60($sp)
	addi $sp, $sp, 64
	
	jr $ra
	
obtenerDecimal:
	#establecer numero inicialmente en 0
	add $s0, $zero, $zero
	
	#establecer numero a comparar primeramente como 0
	add $s1, $zero, $zero
	add $s2, $zero, $zero
	add $s3, $zero, $zero
	add $s4, $zero, $zero
	
	#coloca en a0 el numero romano
	la $a0, numero
	#coloca en s5 el arreglo
	la $a1, arreglo
	
	#carga un contador del numero de elementos
	add $t0,$zero,$zero
	#referencia a la posicion del numero
	add $t1,$zero,$a0
	#referencia a la posicion del arreglo
	add $t2,$zero,$a1
	
	llenarArreglo:
		lb $t3,($t1) #carga en t3 el numero romano
		sb $t3,($t2) #almacena la letra en el arreglo
		addi $t0,$t0,1 #aumenta el contador del numero de elementos
		beqz $t3,recorrerArreglo #verifica si el numero romano ya llego a su fin
		addi $t1,$t1,1  #avanza al siguiente letra
		addi $t2,$t2,1  #avanza al siguiente lugar del arreglo
		j llenarArreglo
		
	recorrerArreglo:
		beqz $t0, arregloCompletado
		lb $t3,($t2) #selecciona un elemento del arreglo
		bnez $t3,llamarRecorrido #si t3 no es cero hay un carácter
		addi $t2,$t2,-1  #retrocede un lugar en arreglo
		addi $t0,$t0,-1   #le restamos 1 al contador de elementos
		j recorrerArreglo	
		
	llamarRecorrido:
		addi $sp, $sp, -4
		sw $ra,0($sp)
		add $s2, $t3, $zero
		jal recorrido
		lw $ra,0($sp)
		addi $sp, $sp, 4
		beq $s0, -1 , arregloCompletado
		addi $t2,$t2,-1  #retrocede un lugar en arreglo
		addi $t0,$t0,-1	 #le restamos 1 al contador de elementos	
		j recorrerArreglo
		
	arregloCompletado:
		jr $ra
		
	recorrido:
		lb $t4, uno #carga en t4 el uno romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5,esUno #si son iguales irá a one
		
		lb $t4, cinco #carga en t4 el cinco romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5,esCinco #si son iguales irá a five
		
		lb $t4, diez #carga en t4 el diez romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5,esDiez #si son iguales irá a ten
		
		lb $t4, cincuenta #carga en t4 el cinco romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5, esCincuenta #si son iguales irá a fifty
		
		lb $t4, cien #carga en t4 el cien romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5, esCien #si son iguales irá a oneHundred
		
		lb $t4, quinientos #carga en t4 el quinientos romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5,esQuinientos #si son iguales irá a fiveHundred
		
		lb $t4, mil #carga en t4 el mil romano
		seq $t5,$t3,$t4  #compara las dos letras
		bnez $t5,esMil #si son iguales irá a oneThousand
		
		jr $ra
	

	esUno:
		#guardar ra 
		addi $sp, $sp, -4
		sw $ra,0($sp)
		#llamar funcion para trabajar con el 1
		jal calcularEsUno
		#recuperar ra
		lw $ra,0($sp)
		addi $sp, $sp, 4
		#retornar
		jr $ra
		
	calcularEsUno: 
		addi $s2,$zero,1
		j calcular
	
	esCinco: 
		addi $sp, $sp, -4
		sw $ra,($sp)
		jal calcularEsCinco
		lw $ra,($sp)
		addi $sp, $sp, 4
		jr $ra
		
	calcularEsCinco: 
		addi $s2,$zero,5
		j calcular
		
	esDiez:	
		addi $sp, $sp, -4
		sw $ra,($sp)
		jal calcularEsDiez
		lw $ra,($sp)
		addi $sp, $sp, 4
		jr $ra
		
	calcularEsDiez: 
		addi $s2,$zero,10
		j calcular
		
	esCincuenta:
		addi $sp, $sp, -4
		sw $ra,($sp)
		jal calcularEsCincuenta
		lw $ra,($sp)
		addi $sp, $sp, 4
		jr $ra
	
	calcularEsCincuenta: 
		addi $s2,$zero,50
		j calcular
		
	esCien:
		addi $sp, $sp, -4
		sw $ra,($sp)
		jal calcularEsCien
		lw $ra,($sp)
		addi $sp, $sp, 4
		jr $ra
		
	calcularEsCien: 
		addi $s2,$zero,100
		j calcular
		
	esQuinientos:
		addi $sp, $sp, -4
		sw $ra,($sp)
		jal calcularEsQuinientos
		lw $ra,($sp)
		addi $sp, $sp, 4
		jr $ra
		
	calcularEsQuinientos: 
		addi $s2,$zero,500
		j calcular
		
	esMil:
		addi $sp, $sp, -4
		sw $ra,($sp)
		jal calcularEsMil
		lw $ra,($sp)
		addi $sp, $sp, 4
		jr $ra
		
	calcularEsMil: 
		addi $s2,$zero,1000
		j calcular
	
	calcular:	
		beq $s2,$s1,iguales
		bgt $s2,$s1,suma
		blt $s2,$s1,resta
		
	iguales:
		beq $s3,$s4, validacionIguales
		j suma
		
	validacionIguales:
		beqz $s3, suma
		j ultimaValidacion
		
	ultimaValidacion:
		bne $s3,$s1,suma
		j noAceptado
	
	suma:
		beq $s2, 5 , sumaValidacion
		beq $s2, 50 , sumaValidacion
		beq $s2, 500 , sumaValidacion
		add $s0, $s0, $s2
		j actualizarDatos
		
	sumaValidacion:
		beq $s1,$s2 noAceptado
		add $s0, $s0, $s2
		j actualizarDatos
		
	resta:
		beq $s2, 5 , noAceptado
		beq $s2, 50 , noAceptado
		beq $s2, 500 , noAceptado
		sub $s0, $s0, $s1 #le resto al total la cantidad añadida anteriormente
		sub $s1, $s1 ,$s2 
		add $s0, $s0, $s1
		j actualizarDatos
	
	actualizarDatos:
		#Para validar que no hayan más de 4 M,C,X,I seguidas
		add $s4, $s3,$zero
		add $s3, $s1, $zero
		#Dis variables para las operaciones
		add $s1, $s2, $zero
		add $s2, $zero, $zero
		jr $ra
		
	noAceptado:
		add $s0,$zero,-1
		jr $ra

