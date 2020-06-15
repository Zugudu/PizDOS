mov esi,mes
int 0x22
int 0x21
mes: db 'Oh hello!',13,10,0
