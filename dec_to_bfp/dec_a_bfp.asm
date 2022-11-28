global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	_dec_a_bfp_msg_welcome				db		'Bienvenido, por favor ingrese un numero en formato decimal: ', 0	
	_dec_a_bfp_msg_response				db		'El numero ingresado (expresado en formato BCD es): %lX ', 0 ; %b = binario lx = hexadecimal
	_dec_a_bfp_inputFormat				db		"%li", 0
	_dec_a_bfp_msg_elija_formato		db		'Por favor elija el formato de salida:  1) binario 2) Base 4 3) base 8 4) Hexadecimal:',10, 0
	msg_response_binario				db		'El numero ingresado en formato BFP con signo es: %b ', 10,0
	_bcd_positivo						db 		'A',10,0
	_bcd_negativo						db 		'D',10,0
	inputFormato						resb	1

	msg_response_base_4					db		'El numero ingresado en formato BFP con signo es: %b ', 10,0
	msg_response_base_8					db		'El numero ingresado en formato BFP con signo es: %o ', 10,0
	_dec_a_bfp_msg_error				db 		'El numero ingresado es invalido! Por favor, ingrese otro numero',10,0

section .bss
	_dec_a_bfp_stringIngresadoUsuario	resb 	4
	_dec_a_bfp_numero					resd	1

	_dec_a_bfp_digito_1					resb	4
	_dec_a_bfp_digito_2					resb	4
	_dec_a_bfp_digito_3					resb	4
	_dec_a_bfp_digito_4					resb	4
	_dec_a_bfp_signo					resd	1	

	_dec_a_bfp_validacion				resd	1
	_dec_a_bfp_inputStringLength		resb	4	

section .text
	global main

	mov		rsi, 5

_dec_to_bfp_main:
	mov		rdi, _dec_a_bfp_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		rdi, _dec_a_bfp_stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

	sub		rsp,8
	call	_dec_a_bfp_calcular_largo
	add		rsp,8

	; User input formatting
	mov     rdi, _dec_a_bfp_stringIngresadoUsuario 	; Todo el input del usuario (entero)
    mov     rsi, _dec_a_bfp_inputFormat 				; "%li" osea, string a int
	mov		rdx, _dec_a_bfp_numero			 			; aca guarda el resultado
	sub		rsp,8
	call	sscanf
	add		rsp,8
	mov		eax, [_dec_a_bfp_numero]


	sub 	rsp, 8
	call 	dec_to_bcd_VALREG
	add 	rsp, 8

	cmp 	byte[_dec_a_bfp_validacion], 'S'
    je		_fin_conversion_binario
	jmp 	_dec_a_bfp_mostrarError


	; jmp		_fin_conversion_binario
	

_fin_conversion_binario:	
	mov		ebx, [_dec_a_bfp_numero]
	mov		rdi, _dec_a_bfp_msg_elija_formato
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		rdi, inputFormato	
	sub		rsp,8	
    call    gets    
	add		rsp,8


	cmp 	byte [inputFormato], '1'
	je 		_dec_a_bfp_formato_binario

	cmp 	byte [inputFormato], '2'
	je 		_dec_a_bfp_formato_base_4

	cmp 	byte [inputFormato], '3'
	je 		_dec_a_bfp_formato_base_8

	cmp 	byte [inputFormato], '4'
	je 		_dec_a_bfp_formato_base_16

_dec_a_bfp_formato_binario:
	mov		rdi, msg_response_binario
	mov		esi, [_dec_a_bfp_numero]	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp		_dec_to_bfp_number_exit
	ret

_dec_a_bfp_formato_base_4:
	mov		rdi, msg_response_base_4
	mov		esi, [_dec_a_bfp_numero]	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp		_dec_to_bfp_number_exit
	ret

_dec_a_bfp_formato_base_8:
	mov		rdi, msg_response_base_8
	mov		esi, [_dec_a_bfp_numero]	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp		_dec_to_bfp_number_exit
	ret

_dec_a_bfp_formato_base_16:
	mov		rdi, _dec_a_bfp_msg_response
	mov		esi, [_dec_a_bfp_numero]	
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		eax, [_dec_a_bfp_numero]
	cmp 	eax, 0
	jg		_dec_a_bfp_es_positivo

	jmp 	_dec_to_bfp_number_exit
	

_dec_a_bfp_es_positivo:
	mov		rdi, _bcd_positivo	
	sub		rsp,8
	call	printf
	add		rsp,8
ret


dec_to_bcd_VALREG:
	mov 	byte[_dec_a_bfp_validacion], 'S'

	cmp 	byte [_dec_a_bfp_inputStringLength], 8
	jge 	dec_to_bcd_error_Validacion

	cmp 	byte [_dec_a_bfp_inputStringLength], 0
	je 		dec_to_bcd_error_Validacion

	sub		rsp,8	
    call 	_validarDigitosIngresados_dec_a_bfp
    add		rsp,8

	jmp		dec_to_bcd_fin_Validacion

dec_to_bcd_error_Validacion:
	mov 	byte[_dec_a_bfp_validacion], 'N'
dec_to_bcd_fin_Validacion:	
ret

_validarDigitosIngresados_dec_a_bfp:
	mov 	rcx, [_dec_a_bfp_inputStringLength]
	xor 	ebx, ebx

_revisar_digitos_dec_a_bfp:
	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '0'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '1'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '2'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '3'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '4'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '5'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '6'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '7'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '8'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '9'
	je 		_validacion_ok_dec_a_bfp

	cmp 	byte [_dec_a_bfp_stringIngresadoUsuario+ebx], '-'
	je 		_validacion_ok_dec_a_bfp

	mov 	byte [_dec_a_bfp_validacion], 'N'

_validacion_ok_dec_a_bfp:
	inc 	ebx
	loop	_revisar_digitos_dec_a_bfp
ret

_dec_a_bfp_calcular_largo:
 	xor 	ebx, ebx
 _dec_a_bfp_revisar_numero:
 	cmp   	[_dec_a_bfp_stringIngresadoUsuario+ebx], byte 0
 	je 		_dec_a_bfp_terminar
 	
 	inc 	ebx
 	loop 	_dec_a_bfp_revisar_numero
 _dec_a_bfp_terminar:
 	mov		[_dec_a_bfp_inputStringLength], ebx
 ret

_dec_a_bfp_mostrarError:
	mov		rdi, _dec_a_bfp_msg_error	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	_dec_to_bfp_main
ret


_dec_to_bfp_number_exit:
	jmp main
ret
