bits 16
org 0x7C00
	mov ax,0x0003
	int 0x10

	mov bx,0x0070
	mov ss,bx
	mov sp,0x0200

mes_boot:
	mov esi,mesAns
	xor bh,bh
	call print_string

	xor eax,eax
	mov edi,varDrive
read_boot:
	mov ah,0x00
	int 0x16

drive_test:
	sub al,'a'
	cmp al,3 ;number of load option
	jge read_boot
	xor ah,ah
	mov dl,[edi+eax]

	mov esi,mesApprove
	call print_string

load_os:
	mov bx,0x0050
	mov es,bx
	xor bx,bx

	mov ah,0x02
	mov al,0x02	;Count of readsectors
	mov ch,0x00	;Cylinder
	mov cl,0x02	;Sector
	mov dh,0x00	;Head
	;mov dl,0x80	;Drive
	int 0x13

	jnc goto_os
	mov esi,mesError
	mov bl,0x0C
	call print_string
	jmp mes_boot
	
goto_os:
	mov bx,0x0050
	mov ds,bx
	jmp 0x0050:0x0000


print_string: ;string in esi
	push ax
	mov ah,0x0E
	xor bh,bh
.print_l:
	mov al,[esi]
	cmp al,0
	je .print_end
	int 0x10
	inc esi
	jmp .print_l
.print_end:
	pop ax
	ret

	;DATA
	mesAns: db 'Select boot device',13,10,'a.Floppy',13,10,'b.CD',13,10,'c.HDD',13,10,0
	mesApprove: db 'Method selected, running system...',13,10,0
	mesError: db 'Cannot load OS! Check the device or choose another one',13,10,0
	varDrive: db 0x00,0xE0,0x80
	times 510-($-$$) db 0
	dw 0xAA55
