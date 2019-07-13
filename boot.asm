        org 7C00h
        bits 16

        jmp short Start

Start:  mov ax, 0
        mov ds, ax
        mov es, ax
        mov ax, 7E00h
        mov ss, ax
        mov sp, 4096
        mov bp, 4096

        mov ax, 13h
        int 10h

        mov bx, 12
        push bx
        mov bx, 100
        push bx
        mov bx, 100
        push bx
        call print_pixel

Loop:   jmp Loop

print_pixel: ; arguments: x coordinate (2 byte), y coordinate (2 byte), color (2 bytes)
        ;push bp
        ;mov bp, sp

;        mov ax, [bp-2] ; color
;        mov dx, [bp-4] ; y
;        mov cx, [bp-6] ; x
        pop ax
        pop cx
        pop dx
        pop ax
        mov ah, 0Ch
;        mov al, 12
;        mov ah, 0Ch
;        mov cx, 100
;        mov dx, 100
        int 10h

        ;mov sp, bp
        ;pop bp
        ret

          
