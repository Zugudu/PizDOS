input: times 79 db 0
drive: db 0
mesHelp: db 'help - show help page', 13,10
	 db 'halt - halt system',13,10
	 db 'cls  - clear screen',13,10
	 db 'file1 - start first program',13,10
	 db 0
mesHalt: db 'System was halt!',13,10,0
mesInvalid: db 'Enter valid command',13,10,0

get_input:
	push ax
	push bx
	push esi
	mov esi,input
	mov bl,0x07
.loop:
	xor ah,ah
	int 0x16

	cmp al, 0xD ;Enter
	je .enter
	cmp al, 0x8 ;Backspace
	je .back

	mov ah,0x0E
	int 0x10

	mov [esi], al
	inc esi
	cmp esi, input+79
	jge .enter
	jmp .loop
.enter:
	cmp esi,input
	je .loop
	mov [esi],byte 0
	pop esi
	pop bx
	pop ax
	ret
.back:
	cmp esi, input
	je .loop
	mov ah,0xE
	int 0x10
	mov al, ' '
	int 0x10
	mov al,0x8
	int 0x10
	mov [esi], byte 0
	dec esi
	jmp .loop

halt:
	mov esi, mesHalt
	int 0x23
	jmp $
help:
	push esi
	mov esi, mesHelp
	int 0x22
	pop esi
	jmp command_end
jcls:
	int 0x20
	jmp command_end

test:
	mov ax,0xB800
	mov es,ax
	mov di,0x0000
	mov al,0x0A
	mov cx,320
	lp:
	mov [es:di],al
	inc di
	dec cx
	jnz lp
	jmp command_end

file1:
	mov ax,0x0201
	mov cx,0x0004
	mov dh,0x00
	mov dl,[drive]
	xor bx,bx
	mov es,bx
	mov bx,0x0900
	int 0x13
	mov bx,0x0090
	mov ds,bx
	jmp 0x0090:0x0000

c_help: db 'help', 0
c_cls: db 'cls',  0
c_halt: db 'halt', 0
c_test: db 'test', 0
c_file1: db 'file1', 0

command:
	push esi
	push edi

	mov esi,input
	mov edi,c_help
	call cmp_string
	je help

	mov esi,input
	mov edi,c_cls
	call cmp_string
	je jcls

	mov esi,input
	mov edi,c_file1
	call cmp_string
	je file1

	mov esi,input
	mov edi,c_halt
	call cmp_string
	je halt

	mov esi,input
	mov edi,c_test
	call cmp_string
	je test

	mov esi,mesInvalid
	int 0x23
command_end:
	pop edi
	pop esi
	ret
