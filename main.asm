global 	main
extern 	printf
extern 	sscanf
extern 	gets
extern	puts

%include "bcd_to_dec/BCDtoDEC.asm"
%include "bfs_to_dec/BPFS_to_dec.asm"
%include "dec_to_bcd/dec_to_bcd.asm"
%include "dec_to_bfp/dec_a_bfp.asm"

section	.data
	msg_welcome				db		'========================================================',10, 'Bienvenido, elija el formato con el que desea trabajar:', 10,10, '1. Si quiere la configuracion hexadecimal numeros BCD de 4 bytes y convertirlo a Decimal', 10, '2. Si quiere ingresar la configuracion binaria de un binario de punto fijo (BFP) con signo de 32 bits',10, '3. Si quiere ingresar el numero en base 10 y convertir a BCD en Base 2,4 u 8',10,'4. Si quiere ingresar un numero en base 10 y convetirlo a binario de punto fijo con signo (BPF) en Base 2,4 u 8 ',10,10,'========================================================',10,0	
	msjErrorInput       	db  	"Los datos ingresados son inválidos.  Intente nuevamente."	
	continuar				db 		'Por favor, ingrese el numero '	
	msg_invalido 			db 		'La opcion que ingreso no es valida!!! Por favor, vuelva a ingresar:',10, 0
	formatInputFilCol		db		"%hi",0

section .bss
	name 					resb 	16
	userInputOption			resb	50
	inputUseroption			resb	50
	userInputString			resw	1

section .text
	global main

	mov		rsi, 5

main:
	mov		rdi,msg_welcome
	sub		rsp,8
	call	printf
	add		rsp,8

    mov		rdi,inputUseroption	
	sub		rsp,8	
    call    gets    
	add		rsp,8

	; User input formatting
	mov     rdi,inputUseroption 	; Todo endero
    mov     rsi,formatInputFilCol 	; "%hi" osea, string a int
	mov		rdx,userInputString 	; aca guarda el resultado
	sub		rsp,8
	call	sscanf
	add		rsp,8

	cmp		word[userInputString],1
	je		user_chose_election_1

	cmp		word[userInputString],2
	je		user_chose_election_2

	cmp		word[userInputString],3
	je		user_chose_election_3

	cmp		word[userInputString],4	
	je		user_chose_election_4

	jmp		main_invalido
	ret
	
user_chose_election_1:
    jmp		main_bcd_to_dec
    ret

user_chose_election_2:
	jmp 	_bpfs_to_dec_main
    ret

user_chose_election_3:
	jmp 	_dec_to_bcd_main
	ret

user_chose_election_4:
	jmp 	_dec_to_bfp_main	
    add     rsp,8

main_invalido:
	mov		rdi, msg_invalido
	sub		rsp, 8
	call	printf
	add		rsp, 8
	jmp		main
	ret

_exit:
	mov eax, 1
	int 0x80
	ret