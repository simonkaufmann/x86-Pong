        org 7C00h
        bits 16

        jmp short Start

Start:  mov ax, 0           ; Stack initialisation
        mov ds, ax
        mov es, ax
        mov ax, 7E00h
        mov ss, ax
        mov sp, 4096
        mov bp, 4096

        mov ax, 13h         ; Set video mode to graphic
        int 10h

        mov bx, 15          ; print a pixel
        push bx
        mov bx, 100
        push bx
        mov bx, 100
        push bx
        call print_pixel

        mov bx, 50         ; y position
        push bx
        mov bx, 20         ; x position
        push bx
        call print_paddle

Loop:   jmp Loop            ; Infinite loop

print_pixel: ; arguments: x coordinate (2 byte), y coordinate (2 byte), color (2 bytes)
        push bp
        mov bp, sp

        mov cx, [bp+4] ; x
        mov dx, [bp+6] ; y
        mov ax, [bp+8] ; color
        mov ah, 0Ch
        int 10h

        mov sp, bp
        pop bp
        ret

print_paddle: ; arguments: x coordinate (2 byte), y coordinate (2 byte)
        push bp
        mov bp, sp

        sub esp, 4

        ; for x to x + 10
        ; for y to y + 50
        ; print pixel

        mov [bp-2], word 0 ;  i = 0
.for_x: 
        
        mov [bp-4], word 0
.for_y:
        mov cx, 15
        push cx
        mov bx, [bp-4]      ; y = index_y + y argument of print paddle
        add bx, [bp+6]
        push bx
        mov ax, [bp-2]      ; x = index_x + x argument of prind paddle
        add ax, [bp+4]
        push ax
        call print_pixel

        mov ax, [bp-4]      ; increment index_y by 1
        add ax, 1
        mov [bp-4], ax

        mov ax, [bp-4]
        cmp ax, [PADDLE_Y_SIZE]     ; check index_y < PADDLE_Y_SIZE
        jle .for_y
.end_for_y:

        mov ax, [bp-2]
        add ax, 1
        mov [bp-2], ax

        mov ax, [bp-2]
        cmp ax, [PADDLE_X_SIZE]     ; check index_x < PADDLE_X_SIZE
        jle .for_x
.end_for_x:


        add esp, 4

        mov sp, bp
        pop bp
        ret

PADDLE_LEFT_X_POS:
5
PADDLE_RIGHT_X_POS:
635
PADDLE_LEFT_Y_POS:
4
PADDLE_RIGHT_Y_POS:
17
PADDLE_X_SIZE:
dw 7
PADDLE_Y_SIZE:
dw 40
COLOR:
dw 15
