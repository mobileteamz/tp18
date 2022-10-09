global main
extern printf
extern scanf

	msg 	db 'Bienvenido', 10
	msg_2 	db '1. Si quiere ingresar el numero en formato decimal', 10
	msg_3 	db '2. Si quiere ingresar el numero en formato BCDI',10
	msg_4 	db '3. Si quiere ingresar el numero en formato BCDI',10, 0
	len equ $ - msg


	msg_option_1 		db 'Opcion 1.', 0	
	msg_option_len 		equ $ - msg_option_1

	msg_invalido db 'invalido!', 0
	len_msg_invalido equ $ - msg_invalido

section .bss
	name 			resb 	16
	userInputOption	resw	1

section .text
	global main

	mov		rsi, 5

main:
	mov		rdi, msg
	sub		rsp, 8
	call	printf
	add		rsp, 8

user_input_option:		
	sub		rsp, 8
	call	scanf
	add		rsp, 8
	mov 	rdi, userInputOption
	
	
	; Validacion de ingreso de informacion (logica)
	cmp 	rdi, '1'
	je 		user_chose_election_1
	call	_exit
	
	; validacion fisica
	;cmp word[msgInputOption], 1

user_chose_election_1:
	mov		rdi, msg_option_1
	sub		rsp, 8
	call	printf
	add		rsp, 8
	ret


invalido:
	mov		rdi, msg_invalido
	sub		rsp, 8
	call	printf
	add		rsp, 8

_exit:
	mov eax, 1
	int 0x80
	ret