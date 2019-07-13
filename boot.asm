        org 7C00h

        jmp short Start

Msg:    db "Hello World!"
EndMsg:

Start:  mov bx, 000Fh
        mov cx, 1
        xor dx, dx
        mov ds, dx
        cld

Print:  mov si, Msg

Char:   mov ah, 2
        int 10h
        lodsb

        mov ah, 9
        int 10h

        inc dl

        cmp dl, 80
        jne Skip
        inc dh

        cmp dh, 25
        jne Skip
        xor dh, dh

Skip:   cmp si, EndMsg
        jne Char
Loop:
        jmp Loop

times 0200h - 2 - ($ - $$) db 0

        dw 0AA55h
