bits 16

mov [drive],dl

%include "irq.s"

int 0x20
mov esi, mesStart
int 0x22

lm:
	call pointer
	call get_input
	call newline
	call command
	jmp lm
%include "string.s"
%include "system.s"

;int 0x21 - exit from program
i21:
	pop ax
	pop ax
	pop ax
	mov ax,0x0050
	mov ds,ax
	jmp lm

mesStart:
	db '             /',13,10
	db 'Welcome to PiZDOS 0.8.1!', 13, 10
	db '             /',13,10,0
