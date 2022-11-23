global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	bpfs_to_dec_main_msg_welcome	db		'Bienvenido, por favor ingrese un numero en formato binario: ', 0		
	bpfs_to_dec_main_msg_response	db		'El numero es (decimal): %hi',10,0
	bpfs_to_dec_msg_invalido 		db 		'El numero ingresado no es valido. Por favor, vuelva a ingresar',10,0

section .bss
	bpfs_to_dec_main_stringIngresadoUsuario		resb 	32	
	bpfs_to_dec_inputStringLength				resb	2
	bpfs_to_dec_main_resultado      			resb 	2

	bpfs_to_dec_validar      					resb 	1

section .text
	global main

	; Inicializaciones	
_bpfs_to_dec_main:
	mov		rdi, bpfs_to_dec_main_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		rdi, bpfs_to_dec_main_stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

	jmp		_calcular_largo

	; TODO: ESTO VA ACA!!
	; _bpfs_to_dec_continuar.
	; Sacar el otro q esta mal puesto
	; TODO: !!!!

	jmp 	VALREG_bpfs_to_dec

	cmp		byte [bpfs_to_dec_validar], 'N'
	jmp		_ingreso_invalido
	
_bpfs_to_dec_continuar:
	mov		cl, [bpfs_to_dec_inputStringLength]
	sub		ebx, ebx
	sub		R10D, R10D
_conversion:
	cmp 	cl, 0
	jl		_terminar
	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '1'
	je		_sumar_exponente

_continuar_conversion:
	sub		cl, 1
	add		ebx, 1
	jmp		_conversion
	

_sumar_exponente:	
	sub		R8D, R8D
	mov		R8D, 1	
	shl		R8D, cl
	mov 	R10D, [bpfs_to_dec_main_resultado]
	add		R10D, R8D
	mov 	[bpfs_to_dec_main_resultado], R10D
	jmp		_continuar_conversion

	sub		eax, eax
	mov		eax, [bpfs_to_dec_main_resultado]

_terminar:
	mov		rdi, bpfs_to_dec_main_msg_response
	mov		esi, [bpfs_to_dec_main_resultado]
	sub		rsp,8
	call	printf
	add		rsp,8
	ret

_calcular_largo:
	sub		ebx, ebx
_revisar_numero:	
	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '1'
	je		_revisar_siguiente_digito

	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '0'
	je		_revisar_siguiente_digito

	dec		ebx
	mov		[bpfs_to_dec_inputStringLength], ebx
	jmp		_bpfs_to_dec_continuar
	ret

_revisar_siguiente_digito:
	add		ebx, 1
	jmp		_revisar_numero
	ret	

VALREG_bpfs_to_dec:
	sub		ebx, ebx
	mov 	cl, [bpfs_to_dec_inputStringLength]
	mov		byte [bpfs_to_dec_validar], 'S'

_validar_caracteres:
	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '1'
	je		_validar_siguiente_digito

	cmp 	byte [bpfs_to_dec_main_stringIngresadoUsuario+ebx], '0'
	je		_validar_siguiente_digito

	mov		byte [bpfs_to_dec_validar], 'N'
	ret

_validar_siguiente_digito:
	add		ebx, 1
	loop	_validar_caracteres	

_ingreso_invalido:
	mov		rdi, bpfs_to_dec_msg_invalido
	sub		rsp,8
	call	printf
	add		rsp,8	
	jmp		_bpfs_to_dec_exit

_bpfs_to_dec_exit:
	mov eax, 1
	int 0x80
	ret




