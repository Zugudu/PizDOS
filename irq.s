xor bx,bx
mov es,bx
mov bx,0x0080 ;set int 0x20
mov [es:bx],word cls
add bx,2
mov [es:bx],word 0x0050

add bx,2
mov [es:bx],word i21
add bx,2
mov [es:bx],word 0x0050

add bx,2
mov [es:bx],word print_mes
add bx,2
mov [es:bx],word 0x0050

add bx,2
mov [es:bx],word print_err
add bx,2
mov [es:bx],word 0x0050
