global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	bcd_to_dec_msg_welcome				db		'Bienvenido, por favor ingrese un numero en formato BCD buen hombre: ', 0	
	msg_response						db		'El numero ingresado (expresado en formato decimal es): %s',10,0
	msg_response_negativo				db		'El numero ingresado (expresado en formato decimal es): -%s',10,0
	inputFormat							db		"%i", 0
	es_negativo							db 		'es negativo'
	sigue								db 		'el programa sigue'
	_bcd_to_dec_msg_invalido 			db 		'El numero ingresado no es valido. Por favor, vuelva a ingresar',10,0
	msg_error							db 		'El numero ingresado es invalido! Por favor, ingrese otro numero',10,0

	msg_largo							db 		'largo: %d',10,0
	msg_debug							db 		'%c'
	stringSalida						db		'        ',0
	letrasValidas						db 		'ABCDEF123456789'


section .bss
	stringIngresadoUsuario	resb 	4
	numero					resd	1
	validacion				resd	1
	inputStringLength		resb	4	

section .text
	global main


main_bcd_to_dec:
	mov		rdi, bcd_to_dec_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

    mov		rdi, stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

_calcular_largo_bcd_to_dec:
	sub		ebx, ebx
_continuar_calculando:
	cmp 	byte [stringIngresadoUsuario+ebx], 0
	je		_terminar_calculo_largor
	
	add		ebx, 1
	jmp		_continuar_calculando

_terminar_calculo_largor:
	mov		[inputStringLength], ebx
	
	sub		rsp,8	
    call    VALREG 
    add		rsp,8
    cmp 	byte[validacion], 'S'
    je		_continuar
	jmp 	_mostrarError

ret

VALREG:
	mov byte[validacion], 'N'

	cmp byte [inputStringLength], 8
	jge fin_Validacion

	cmp byte [inputStringLength], 0
	je fin_Validacion


	sub		rsp,8	
    call 	validarDigitosIngresados
    add		rsp,8
	cmp 	byte [validacion], 'N'
	jge 	fin_Validacion
	

	mov byte[validacion], 'S'

fin_Validacion:
ret

_mostrarError:
	mov		rdi, msg_error
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	main_bcd_to_dec
ret

validarDigitosIngresados:
	mov		byte [validacion], 'S'
ret

_continuar:
	; Copio los strings
	mov 	rcx, [inputStringLength]
	dec 	rcx
	mov 	rsi, stringIngresadoUsuario
	mov 	rdi, stringSalida	
	repe movsb


_detectar_negativo:
	mov 	ebx, [inputStringLength]
	dec 	ebx
	cmp 	byte [stringIngresadoUsuario+ebx], 'B'
	je 		_print_es_negativo

	cmp 	byte [stringIngresadoUsuario+ebx], 'D'
	je 		_print_es_negativo

	mov		rdi, msg_response
	mov 	rsi, stringSalida
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	_exit_bcd_to_dec
	
_print_es_negativo:	
	mov		rdi, msg_response_negativo
	mov 	rsi, stringSalida
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	_exit_bcd_to_dec
	ret
	
_exit_bcd_to_dec:
	jmp main
ret


