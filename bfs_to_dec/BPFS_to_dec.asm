global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	bpfs_to_dec_main_msg_welcome	db		'Bienvenido, por favor ingrese un numero en formato binario: ', 0		
	bpfs_to_dec_main_msg_response	db		'El numero es (decimal): %d',10,0
	bpfs_to_dec_main_msg_response_binario	db		'El numero es (binario): %b',10,0
	bpfs_to_dec_msg_invalido 		db 		'El numero ingresado no es valido. Por favor, vuelva a ingresar',10,0

	msg_debug_largo					db 		'El largo es: %d',10,0	
	bpfs_to_dec_msg_error			db 		'El formato ingresado es invalido! Por favor, vuelva a ingresar',10,0	

section .bss
	bpfs_to_dec_validar      					resb 	1
	bpfs_to_dec_main_stringIngresadoUsuario		resb 	32
	bpfs_to_dec_inputStringLength				resb	2
	bpfs_to_dec_main_resultado      			resb 	2

section .text
	global main

_bpfs_to_dec_main:
	; Inicializaciones

	mov 	byte [bpfs_to_dec_validar], 'S'
	mov		rdi, bpfs_to_dec_main_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		rdi, bpfs_to_dec_main_stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

	sub		rsp,8
	call	_calcular_largo
	add		rsp,8

	sub 	rsp, 8
	call 	bpfs_to_dec_VALREG
	add 	rsp, 8

	cmp 	byte [bpfs_to_dec_validar], 'N'
	je 		_error_validacion
	
_bpfs_to_dec_continuar:
	mov		cl, [bpfs_to_dec_inputStringLength]
	dec 	cl
	xor		ebx, ebx
	xor		R10D, R10D
_conversion:
	cmp 	cl, 0
	jl		_imprimir_numeros_fin
	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '1'
	je		_sumar_exponente

_continuar_conversion:
	sub		cl, 1
	add		ebx, 1
	jmp		_conversion
	

_sumar_exponente:	
	xor		R8D, R8D
	mov		R8D, 1	
	shl		R8D, cl
	mov 	R10D, [bpfs_to_dec_main_resultado]
	add		R10D, R8D
	mov 	[bpfs_to_dec_main_resultado], R10D
	jmp		_continuar_conversion

	xor		eax, eax
	mov		eax, [bpfs_to_dec_main_resultado]

_imprimir_numeros_fin:
	mov		rdi, bpfs_to_dec_main_msg_response
	mov		esi, [bpfs_to_dec_main_resultado]
	sub		rsp,8
	call	printf
	add		rsp,8

	jmp 	_bpfs_to_dec_exit
ret


 _calcular_largo:
 	xor 	ebx, ebx
 _revisar_numero:
 	cmp   	[bpfs_to_dec_main_stringIngresadoUsuario+ebx], byte 0
 	je 		_terminar
 	
 	inc 	ebx
 	loop 	_revisar_numero
 _terminar:
 	mov		[bpfs_to_dec_inputStringLength], ebx
 ret

bpfs_to_dec_VALREG:
	mov 	rcx, [bpfs_to_dec_inputStringLength]
	xor 	ebx, ebx

revisar_digitos:
	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '1'
	je 		validacion_ok

	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '0'
	je 		validacion_ok

	mov 	byte [bpfs_to_dec_validar], 'N'

validacion_ok:
	inc 	ebx
	loop	revisar_digitos
ret

_error_validacion:
	mov		rdi, bpfs_to_dec_msg_error
	sub		rsp,8
	call	printf
	add		rsp,8

	jmp 	_bpfs_to_dec_main
ret


_bpfs_to_dec_exit:
	jmp main
ret




