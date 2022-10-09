global main
extern printf

bits 64
section .data
	msg 	db 'Bienvenido', 0xa
	msg_2 	db '1. Si quiere ingresar el numero en formato decimal', 0xa
	msg_3 	db '2. Si quiere ingresar el numero en formato BCDI', 0xa
	len equ $ - msg

section .bss
	name resb 16

section .text
	global main

; _inputText:
; 	mov rax, 0
; 	mov rdi, 0
; 	mov rdx, 16
; 	mov rsi, name
; 	syscall
; 	ret

main:
	call _printInitialMessage
	; call _inputText
	; call _printInputedText	

_exit:
	mov eax, 1
	int 0x80
	ret

_printInitialMessage:
	mov		rdi, msg
	sub		rsp, 8
	call	printf
	add		rsp, 8
	; mov edx, len
	; mov ecx, msg
	; mov ebx, 1
	; mov eax, 4
	; int 0x80
	; ret

_printName:
	mov edx, 5
	mov ecx, name
	mov ebx, 1
	mov eax, 4
	int 0x80
	ret

_user_option_1:
	call _printInitialMessage
	ret

_printInputedText:
	;call _printInitialMessage
	mov eax, '1'
	mov ebx, name
	cmp eax, name
	je _printInitialMessage
	;call _exit
	mov rax, 1
	mov rdi, 1
	mov rsi, name
	mov rdx, 10
	syscall
	ret



