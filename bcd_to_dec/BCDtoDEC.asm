global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	bcd_to_dec_msg_welcome				db		'Bienvenido, por favor ingrese un numero en formato BCD buen hombre: ', 0	
	msg_response						db		'El numero ingresado (expresado en formato decimal es): %i ', 10,0
	msg_response_negativo				db		'El numero ingresado (expresado en formato decimal es): -%i ', 10,0
	inputFormat							db		"%li", 0
	es_negativo							db 		'es negativo'
	sigue								db 		'el programa sigue'
	_bcd_to_dec_msg_invalido 			db 		'El numero ingresado no es valido. Por favor, vuelva a ingresar',10,0

section .bss
	stringIngresadoUsuario	resb 	4
	numero					resd	1
	signo					resb	1	; P = Positivo, N = Negativo

	digito_1				resb	4
	digito_2				resb	4
	digito_3				resb	4
	digito_4				resb	4

section .text
	global main

	mov		rsi, 5

main_bcd_to_dec:
	mov		rdi, bcd_to_dec_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

    mov		rdi, stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

	; User input formatting
	mov     rdi, stringIngresadoUsuario 	; Todo el input del usuario (entero)
    mov     rsi, inputFormat 			; "%hi%hi%hi" osea, string a int
	mov		rdx, numero			 		; aca guarda el resultado
	sub		rsp,8
	call	sscanf
	add		rsp,8

	; jmp 	_VALREG_bcd_to_dec

	; busco el ultimo caracter (para determinar el signo)
	mov		byte[signo], 'P'	; inicializamos en Positivo
	mov 	eax, stringIngresadoUsuario
	mov		ebx, 0

_buscar_signo:
	cmp 	byte[eax+ebx], 'B' 		; Indicador de negativo en formato BCD	
	je		_setear_numero_negativo 

	cmp 	byte[eax+ebx], 'D' 		; Indicador de negativo en formato BCD	
	je		_setear_numero_negativo 

	cmp 	ebx, 3
	je		_conseguir_digitos

	add		ebx, 1
	jmp		_buscar_signo

_conseguir_digitos:

	; consigo el primer digito
	mov		edx, 0
	mov 	eax, [numero]
	mov		ebx, 100
	div 	ebx 
	mov 	[digito_1], eax ; resto en EDX y cociente en EAX

	; 2do digito 
	mov 	eax, edx ; resto en EDX y cociente en EAX
 	mov		edx, 0
	mov		ebx, 10
	div 	ebx
	mov 	[digito_2], eax 

	; 3er digito
	mov 	[digito_3], edx 

	mov 	eax, [digito_1]
	mov		ebx, 256
	imul 	eax, ebx
	mov		[digito_1], eax

	mov 	eax, [digito_2] 
	mov		ebx, 16
	imul 	eax, ebx
	mov		[digito_2], eax

	mov		eax, 0
	add		eax, [digito_1]
	add		eax, [digito_2]
	add		eax, [digito_3]

	; Print variable
	cmp 	byte[signo], 'N'
	je 		imprimir_numero_negativo
	
	mov		rdi, msg_response
	jmp		imprimir_numero
	
imprimir_numero_negativo:
	mov		rdi, msg_response_negativo

imprimir_numero:
	mov		esi, eax
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	_userInputString_exit

_setear_numero_negativo:	
	mov		[signo], byte 'N'
	jmp 	_conseguir_digitos
	ret 

_VALREG_bcd_to_dec:
	; cmp rax, 1
	je	_bcd_to_dec_invalido
	ret

_bcd_to_dec_invalido:
	mov		rdi, _bcd_to_dec_msg_invalido
	sub		rsp, 8
	call	printf
	add		rsp, 8
	jmp		main_bcd_to_dec
	ret

_userInputString_exit:
	mov eax, 1
	int 0x80
	ret
