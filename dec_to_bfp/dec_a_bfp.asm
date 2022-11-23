global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

section	.data
	_dec_to_bfp_msg_welcome		db		'Bienvenido, por favor ingrese un numero en formato decimal: ', 0		
	msg_elija_formato			db		'Por favor elija el formato de salida:  1. binario 2. Base 4 3. base 8:',10, 0
	msg_response_binario		db		'El numero ingresado en formato BFP con signo es: %b ', 10,0
	msg_response_base_4			db		'El numero ingresado en formato BFP con signo es: %b ', 10,0
	msg_response_base_8			db		'El numero ingresado en formato BFP con signo es: %o ', 10,0
	_dec_to_bfp_formatInput		db		"%d",0

section .bss
	_dec_to_bfp_stringIngresadoUsuario	resb 	32
	inputFormato						resb	1
	_dec_to_bfp_number					resw	2



section .text
	global main

	; Inicializaciones	
_dec_to_bfp_main:
	mov		rdi, _dec_to_bfp_msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		rdi, _dec_to_bfp_stringIngresadoUsuario	
	sub		rsp,8	
    call    gets    
	add		rsp,8

	; User input formatting
	mov     rdi,_dec_to_bfp_stringIngresadoUsuario 	; Todo entero
    mov     rsi,_dec_to_bfp_formatInput				; "%hi" osea, string a int
	mov		rdx,_dec_to_bfp_number 					; aca guarda el resultado
	sub		rsp,8
	call	sscanf
	add		rsp,8

	sub		eax, eax
	mov		eax, [_dec_to_bfp_number]	
	jmp		_amostrar_numero
	ret

_amostrar_numero:
	
	mov		rdi, msg_elija_formato
	sub		rsp,8
	call	printf
	add		rsp,8

	mov		rdi, inputFormato	
	sub		rsp,8	
    call    gets    
	add		rsp,8


	cmp 	byte [inputFormato], '1'
	je 		_formato_binario

	cmp 	byte [inputFormato], '2'
	je 		_formato_base_4

	cmp 	byte [inputFormato], '3'
	je 		_formato_base_8



_formato_binario:
	mov		rdi, msg_response_binario
	mov		esi, [_dec_to_bfp_number]	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp		_dec_to_bfp_number_exit
	ret

_formato_base_4:
	mov		rdi, msg_response_base_4
	mov		esi, [_dec_to_bfp_number]	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp		_dec_to_bfp_number_exit
	ret

_formato_base_8:
	mov		rdi, msg_response_base_8
	mov		esi, [_dec_to_bfp_number]	
	sub		rsp,8
	call	printf
	add		rsp,8
	jmp		_dec_to_bfp_number_exit
	ret

_dec_to_bfp_number_exit:
	mov eax, 1
	int 0x80
	ret




