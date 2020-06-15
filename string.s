print_err:
	push bx
	mov bl,0x0C
	call print_string
	pop bx
	iret

print_mes:
	push bx
	mov bl,0x07
	call print_string
	pop bx
	iret

print_string: ;string in esi
	pusha
	push bx
	mov ah,0x3
	xor bh,bh
	int 0x10
	push dx
	mov ah,0xE
.print_l:
	mov al,[esi]
	cmp al,0
	je .print_end
	int 0x10
	inc esi
	jmp .print_l
.print_end:
	mov ah,0x3
	int 0x10
	pop bx
	sub dl,bl
	sub dh,bh
	jnz .not_zero
	mov dh,1
	dec bh
.not_zero:
	mov al,dh
	mov ah,80
	mul ah
	xor dh,dh
	add ax,dx
	mov cx,ax

	mov al,bh
	mov ah,80
	mul ah
	xor bh,bh
	add ax,bx
	shl ax,1
	inc ax
	mov bx,ax

	mov ax,0xB800
	mov es,ax
	pop ax
.attr:
	mov [es:bx],al
	add bx,2
	dec cx
	jnz .attr
	popa
	ret

newline: ;print new line
	push ax
	mov ax, 0x0E0A
	int 0x10
	mov al,13
	int 0x10
	pop ax
	ret

pointer: ;print >
	push ax
	mov ax,0x0E3E
	int 0x10
	pop ax
	ret

cls:	;clear screen
	pusha
	mov bx,0xB800
	mov es,bx
	xor bx,bx
	mov cx,2000
.loop:
	mov [es:bx],word 0x0720
	add bx,2
	dec cx
	jnz .loop
	mov ah,0x02
	xor bh,bh
	xor dx,dx
	int 0x10
	popa
	iret

cmp_string: ;compare string in si and di ret: set ZF
	push ax
	.cmpl:
		mov al, [esi]
		cmp al, [edi]
		jne .end_cmp
		cmp al, 0
		je .good
		inc esi
		inc edi
		jmp .cmpl

	.good:
		jmp .end_cmp
	.end_cmp:
		pop ax
		ret
