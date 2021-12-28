.data
title:.asciiz "Ingrese el numero entero:"
delimitador:.asciiz "================================================"
presentacion:.asciiz "==========Conversor de Sistema Romano==========="
opcion1:.asciiz "1.-Convertir de decimal a romano"
opcion2:.asciiz "2.-Convertir de romano a decimal"
pedirOpcion:.asciiz "Ingrese una opción:"
opcionValida:.asciiz "¡¡¡INGRESE UNA OPCIÓN VÁLIDA!!"
tituloOpcion1:.asciiz "======Convierte numeros de 3999 hasta abajo====="
salir:.asciiz "3.-Salir"
newLine:.asciiz "\n"
fout:.asciiz "D:\\Users\\moise\\Documents\\Docs\\2021-1T\\Organizzación de computadoras\\Ayudantia\\viernes 25junio\\romanos.txt"
buffer: .space 100

.text

.globl main

	
main:	#Se presenta el menu al usuario
	li $v0,4
	la $a0, newLine
	syscall
	la $a0,delimitador
	syscall
	la $a0, newLine
	syscall
	la $a0,presentacion
	syscall
	la $a0, newLine
	syscall
	la $a0, delimitador
	syscall
	la $a0, newLine
	syscall
	la $a0,opcion1
	syscall
	la $a0, newLine
	syscall
	la $a0,opcion2
	syscall
	la $a0, newLine
	syscall
	la $a0,salir
	syscall
	la $a0, newLine
	syscall
	la $a0,pedirOpcion #le pedimos el número al usuario
	syscall
	li $v0,5
	syscall
	move $s0,$v0
	
while:
	addi $t5,$0,1 #El valor inicial con el cual se va a comparar
	beq $s0,$t5,primero #Si la opción ingresada es el 1, lo manda a la primera función, de no ser así sigue comparando con la otra opción
	addi $t5,$t5,1 #Se agrega 1 al valor inicial para luego comparar si es la opción 2
	beq $s0,$t5,segundo #Si la opción ingresada es el 2, lo manda a la segunda función, de no ser así sigue comparando con la otra opción
	addi $t5,$t5,1 #Se agrega 1 al valor inicial para luego comparar si es la opción 3
	beq $s0,$t5,final #Si la opción ingresada es el 3, finaliza el programa, de no ser así sigue comparando con cualquier otra opción ingresada
	li $v0,4
	la $a0,opcionValida #Se muestra una alerta que la opción ingresada no es correcta
	syscall
	la $a0, newLine
	syscall
	j main #Se vuelve a presentar el menú por que la opción ingresada no está entre las opciones mostradas
segundo:
	jal romanoDecimal
	j main	
primero:
	#Se imprime un encabezado 
	li $v0,4
	la $a0,delimitador
	syscall
	la $a0, newLine
	syscall
	la $a0,tituloOpcion1
	syscall
	la $a0, newLine
	syscall
	la $a0,delimitador
	syscall
	la $a0, newLine
	syscall
	la $a0,title #le pedimos el número al usuario
	syscall
	li $v0,5
	syscall
	move $s0,$v0
	move $a3,$s0 #numero decimal

	move $a2,$0 #columna en donde se va a buscar en el archivo dependiendo de si corresponde a un millara, decena,centena o unidad
	addi $t7,$0,1
	addi $t3,$0,1000 #Valor inicial por el cual se va a dividir y obtener el digito correspondiente
bucle:
	slti $t1,$t7,5 #Compara si la iteración es menor a 5, dado a que se debe iterar 4 veces sobre el archivo, en busca del millar, centena,decena o unidad correspondiente
	beq $t1,$0,main #Si finaliza la comparación de todos los digitos correspondientes vuelve al menú principal
	
	move $s0,$a3 #numero decimal
	div $s0,$t3 #divide el numero entre 1000,100,10,1 para obtener los millarres, centenas,decenas y unidades respectivos
	mflo $s6 #se obtiene el cuociente de dicha division, el cual es el primer digito a encontrar en el archivo
	move $a3,$s6 #la unidad, decena,centena o millar correspondiente
	jal conversion #esta funcion imprime el numero romano correspondiente al numero del registro $a3
	addi $t7,$t7,1 #Se aumenta en una unidad pasar a la siguiente iteración
	mfhi $s6 #se obtiene el modulo de la divison anterior
	move $a3,$s6 #Se guarda en el registro $a3
	addi $t1,$0,10 #Se setea el valor temporal para llevar a cabo la division entre 10
	div $t3,$t1 #se deivide el $t3 para 10, para pasarlo a centena, decena o unidad
	mflo $t3 #se guarda el cuociente de la división
	j bucle

final:	
	li $v0,10
	syscall
	
	
conversion:
	#guardamos espacio en la memoria
	addi $a2,$a2,1 
	addi $sp,$sp,-20
	sw $ra, ($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	sw $a2,12($sp)	
	sw $a3,16($sp)

	#se llama a la función que abre el archivo
	jal abrirArchivo
	move $s1,$v0 #fd
	
	
	move $a0,$s1 #fd
	la $a1,buffer
	#se llama a la función que lee el archivo
	jal leerArchivo
	
	
	move $a0,$s1
	#se llama a la función que abre el archivo
	jal cerrarArchivo
	#liberamos espacio de la memoria
	lw $ra, ($sp)
	lw $a0,4($sp)
	lw $a1, 8($sp)
	lw $a2, 12($sp)
	lw $a3, 16($sp)
	addi $sp,$sp,20
	jr $ra	
	
abrirArchivo:
	#guardamos espacio en la memoria
	addi $sp, $sp,-12
	sw $ra,($sp)
	sw $a0,4($sp)
	sw $a1,8($sp)
	li $v0,13
	la $a0,fout
	la $a1,0 #read:0, write:1
	syscall
	
		
	#liberamos espacio de la memoria
	lw $ra,($sp)
	lw $a0,4($sp)
	lw $a1,8($sp)	
	addi $sp, $sp,12
	jr $ra
	
cerrarArchivo:
	#guardamos espacio en la memoria
	addi $sp, $sp,-4
	sw $ra,($sp)
	
	li $v0,16
	syscall
	
		
	#liberamos espacio de la memoria
	lw $ra,($sp)
	addi $sp, $sp,4
	jr $ra

leerArchivo:
	#guardamos espacio en la memoria
	addi $sp, $sp,-28
	sw $ra,($sp)
	sw $s0,4($sp)
	sw $s1,8($sp)
	sw $s2,12($sp)
	sw $s3,16($sp)
	sw $s4,20($sp)
	sw $s5,24($sp)
	move $s0,$a3#numero a encontrar en el archivo
	move $s1,$a0 #fd
	move $s2,$a1 #buffer
	move $s5,$a2 #columna dependiendo si es un millar, centena,decena o unidad
	li $t0,0#contador de lineas
	li $t4,0# contador de comas
	
	addi $t6,$s5,-1
	li $s3,10#codigo correspondiente al \n
	li $s4,44 #codigo correspondiente a la coma
	leer:
		slt $t1,$t0,$s0 #se compara si el contador de lineas es menor al numero a comparar
		beq $t1,0,return #termina la lectura del archivo si ya se llegó a linea correspondiente
		
		
		li $v0,14 #permite leer el archivo
		move $a0, $s1
		la $a1,buffer
		li $a2,1
		syscall
		
		#cargar un byte dentro de un registro (lb)
		lb $t1,($s2)
		beq $t1,$s3,sumar
		addi $t2,$s0,-1
		slt $t2,$t0,$t2
		beq $t2,1,leer
		beq $t1,$s4,sumaComa #comparar la coma
		beq $t4,$t6,imprimir #se manda a imprimir
		j leer
		
		#imprime el primer byte a la representación en romano correspondiente
		imprimir:
			li $v0,4
			move $a0,$s2
			syscall
			j leer
		
		sumar:
			addi,$t0,$t0,1
			j leer
		sumaComa:
			beq $t4,$s5,return
			addi,$t4,$t4,1
			j leer
	
	return:
	#liberamos espacio de la memoria
	lw $ra,($sp)
	lw $s0,4($sp)
	lw $s1,8($sp)
	lw $s2,12($sp)	
	lw $s3,16($sp)
	lw $s4,20($sp)
	lw $s5,24($sp)
	addi $sp, $sp,28
	jr $ra
