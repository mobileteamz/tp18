global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	dec_to_bcd_msg_welcome						db		'Bienvenido, por favor ingrese un numero en formato decimal: ', 0	
	dec_to_bcd_msg_response						db		'El numero ingresado (expresado en formato BCD es): %iA',10,0
	dec_to_bcd_main_msg_response_negativo		db		'El numero ingresado (expresado en formato BCD es): %iB',10,0
	dec_to_bcd_main_inputFormat					db		"%d", 0
	dec_to_bcd_msg_error						db 		'El numero ingresado es invalido! Por favor, ingrese otro numero',10,0
	dec_to_bcd_inputFormat						db		"%d", 0
	dec_to_bcd_numero_letrasValidas				db 		'123456789'


section .bss
	dec_to_bcd_stringIngresadoUsuario				resb 	4
	dec_to_bcd_numero								resd	1
	dec_to_bcd_validacion							resd	1
	dec_to_bcd_inputStringLength					resb	4	

section .text
	global main


 _dec_to_bcd_main:
	mov		rdi, dec_to_bcd_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

    mov		rdi, dec_to_bcd_stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

_calcular_largo_dec_to_bcd:
	sub		ebx, ebx
_continuar_calculando_dec_to_bcd:
	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], 0
	je		_terminar_calculo_largor_dec_to_bcd
	
	add		ebx, 1
	jmp		_continuar_calculando_dec_to_bcd

_terminar_calculo_largor_dec_to_bcd:
	mov		[dec_to_bcd_inputStringLength], ebx
	
	sub		rsp,8	
    call    VALREG_dec_to_bcd 
    add		rsp,8
    
    cmp 	byte[dec_to_bcd_validacion], 'S'
    je		_continuar_dec_to_bcd
	jmp 	_mostrarError_dec_to_bcd

ret

VALREG_dec_to_bcd:
	mov 	byte[dec_to_bcd_validacion], 'S'

	cmp 	byte [dec_to_bcd_inputStringLength], 8
	jge 	error_Validacion_dec_to_bcd

	cmp 	byte [dec_to_bcd_inputStringLength], 0
	je 		error_Validacion_dec_to_bcd


	sub		rsp,8	
    call 	validarDigitosIngresados_dec_to_bcd
    add		rsp,8
	
	cmp 	byte [dec_to_bcd_validacion], 'S'
	jge 	fin_Validacion_dec_to_bcd
	
error_Validacion_dec_to_bcd:
	mov 	byte[dec_to_bcd_validacion], 'N'
fin_Validacion_dec_to_bcd:	
ret

_mostrarError_dec_to_bcd:
	mov		rdi, dec_to_bcd_msg_error
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	main
ret

validarDigitosIngresados_dec_to_bcd:
	mov 	rcx, [dec_to_bcd_inputStringLength]
	xor 	ebx, ebx

revisar_digitos_dec_to_bcd:
	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '0'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '1'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '2'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '3'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '4'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '5'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '6'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '7'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '8'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '9'
	je 		validacion_ok_dec_to_bcd

	cmp 	byte [dec_to_bcd_stringIngresadoUsuario+ebx], '-'
	je 		validacion_ok_dec_to_bcd

	mov 	byte [dec_to_bcd_validacion], 'N'

validacion_ok_dec_to_bcd:
	inc 	ebx
	loop	revisar_digitos_dec_to_bcd
ret

_continuar_dec_to_bcd:
	mov     rdi, dec_to_bcd_stringIngresadoUsuario 	; Todo el input del usuario (entero)
    mov     rsi, dec_to_bcd_inputFormat 				; "%li" osea, string a int
	mov		rdx, dec_to_bcd_numero			 			; aca guarda el resultado
	sub		rsp,8
	call	sscanf
	add		rsp,8
	
	mov		eax, [dec_to_bcd_numero]
	cmp	 	eax, 0
	jl 		_print_es_negativo_dec_to_bcd

	mov		rdi, dec_to_bcd_msg_response
	mov 	rsi, [dec_to_bcd_numero]
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp 	_exit_dec_to_bcd
	ret
	
_print_es_negativo_dec_to_bcd:	
	mov 	ebx, [dec_to_bcd_numero]
	imul 	ebx, ebx, -1
	mov 	[dec_to_bcd_numero], ebx

	mov		rdi, dec_to_bcd_main_msg_response_negativo
	mov 	rsi, [dec_to_bcd_numero]
	sub		rsp,8
	call	printf
	add		rsp,8
	
_exit_dec_to_bcd:
	jmp main
ret


