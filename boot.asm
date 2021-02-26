; 320 - PADDLE_X_SIZE
%define SCREEN_X        315
; 320 - PADDLE_X_SIZE
%define SCREEN_Y        195

; ASCII 'w'
%define KEY_LEFT_UP     119
; ASCII 's'
%define KEY_LEFT_DOWN   115
; ASCII 'p'
%define KEY_RIGHT_UP    112
; ASCII 'l'
%define KEY_RIGHT_DOWN  108

%define PADDLE_Y_STEP   5


%define PRESSED 1
%define RELEASED 0

   
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

        mov ax, 04h         ; Set video mode to graphic
        int 10h

        mov bx, [PADDLE_LEFT_Y_POS]         ; y position
        push bx
        mov bx, [PADDLE_LEFT_X_POS]         ; x position
        push bx
        call print_paddle

        mov bx, [PADDLE_RIGHT_Y_POS]         ; y position
        push bx
        mov bx, [PADDLE_RIGHT_X_POS]         ; x position
        push bx
        call print_paddle

        mov bx, [BALL_Y_POS]         ; y position
        push bx
        mov bx, [BALL_X_POS]         ; x position
        push bx
        call print_ball
        
        mov cx, [BALL_X_POS]
        mov dx, [BALL_Y_POS]

Loop:   
        jmp Loop
        mov ax, 06ffh  ; for speed of delay
Delay2: mov bx, 0FFFFh ; for speed of delay
Delay:  dec bx
        cmp bx, 0h
        jne Delay
        dec ax
        jne Delay2

        call process_key

        call clear_screen
        call ball_step
        
        mov bx, [PADDLE_LEFT_Y_POS]         ; y position
        push bx
        mov bx, [PADDLE_LEFT_X_POS]         ; x position
        push bx
        call print_paddle

        mov bx, [PADDLE_RIGHT_Y_POS]         ; y position
        push bx
        mov bx, [PADDLE_RIGHT_X_POS]         ; x position
        push bx
        call print_paddle


.skip_ball_step:
        jmp Loop            ; Infinite loop

process_key:
;         mov ah, 01h ; Test key BIOS
;         int 16h
;         jz .no_key_event

;         mov ah, 00h
;         int 16h ; int 16h will put ASCII character in al and scan code in AH
        
;         cmp al, KEY_LEFT_UP
;         jne .skip_left_up
;         call paddle_left_up
;         jmp .end_if
; .skip_left_up:
;         cmp ah, KEY_LEFT_DOWN
;         jne .skip_left_down
;         call paddle_left_down
;         jmp .end_if
; .skip_left_down:
;         cmp ah, KEY_RIGHT_UP
;         jne .skip_right_up
;         call paddle_right_up
;         jmp .end_if
; .skip_right_up:
;         cmp ah, KEY_RIGHT_DOWN
;         jne .skip_right_down
;         call paddle_right_down
;         jmp .end_if
; .skip_right_down:

; .end_if:
; .no_key_event:
;         ret

; paddle_left_up:
;         push bp
;         mov bp, sp
;         push ax

;         mov ax, [PADDLE_LEFT_Y_POS]
;         sub ax, PADDLE_Y_STEP
;         mov [PADDLE_LEFT_Y_POS], ax

;         pop ax
;         mov sp, bp
;         pop bp
;         ret

; paddle_left_down:
;         push bp
;         mov bp, sp

;         mov ax, [PADDLE_LEFT_Y_POS]
;         add ax, PADDLE_Y_STEP
;         mov [PADDLE_LEFT_Y_POS], ax

;         mov sp, bp
;         pop bp
;         ret

; paddle_right_up:
;         push bp
;         mov bp, sp

;         mov ax, [PADDLE_RIGHT_Y_POS]
;         sub ax, PADDLE_Y_STEP
;         mov [PADDLE_RIGHT_Y_POS], ax

;         mov sp, bp
;         pop bp
;         ret

; paddle_right_down:
;         push bp
;         mov bp, sp

;         mov ax, [PADDLE_RIGHT_Y_POS]
;         add ax, PADDLE_Y_STEP
;         mov [PADDLE_RIGHT_Y_POS], ax

;         mov sp, bp
;         pop bp
;         ret

ball_step:
        push bp
        mov bp, sp

        mov ax, [BALL_X_POS]
        add ax, [BALL_SPEED_X]
        mov [BALL_X_POS], ax

        mov ax, [BALL_Y_POS]
        add ax, [BALL_SPEED_Y]
        mov [BALL_Y_POS], ax

        call check_boundaries

        mov ax, [BALL_Y_POS]         ; y position
        push ax
        mov ax, [BALL_X_POS]         ; x position
        push ax
        call print_ball

        mov sp, bp
        pop bp
        ret

check_boundaries:
        push bp
        mov bp, sp

        mov ax, [BALL_X_POS]
        cmp ax, SCREEN_X
        jl .skip_cap_top_x
        mov ax, SCREEN_X
        mov cx, [BALL_SPEED_X]
        imul cx, -1
        mov [BALL_SPEED_X], cx
.skip_cap_top_x:
        cmp ax, 0
        jg .skip_cap_bottom_x
        mov ax, 0
        mov cx, [BALL_SPEED_X]
        imul cx, -1
        mov [BALL_SPEED_X], cx
.skip_cap_bottom_x:
        mov [BALL_X_POS], ax

        mov ax, [BALL_Y_POS]
        cmp ax, SCREEN_Y
        jl .skip_cap_top_y
        mov ax, SCREEN_Y
        mov cx, [BALL_SPEED_Y]
        imul cx, -1
        mov [BALL_SPEED_Y], cx
.skip_cap_top_y:
        cmp ax, 0
        jg .skip_cap_bottom_y
        mov ax, 0
        mov cx, [BALL_SPEED_Y]
        imul cx, -1
        mov [BALL_SPEED_Y], cx
.skip_cap_bottom_y:
        mov [BALL_Y_POS], ax

        mov sp, bp
        pop bp
        ret

clear_screen:
        push bp
        mov bp, sp

        mov ax, 04h         ; Set video mode to graphic will clear screen
        int 10h

        mov sp, bp
        pop bp
        ret

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

print_ball: ; arguments x coordinate (2 byte), y coordinate (2 byte)
    push bp
    mov bp, sp

    mov ax, [BALL_SIZE]     ; y size
    push ax
    mov ax, [BALL_SIZE]     ; x size
    push ax
    mov ax, [bp+6]              ; y coord
    push ax
    mov ax, [bp+4]              ; x coord
    push ax
    call print_box

    mov sp, bp
    pop bp
    ret

print_paddle: ; arguments: x coordinate (2 byte), y coordinate (2 byte)
    push bp
    mov bp, sp

    mov ax, [PADDLE_Y_SIZE]     ; y size
    push ax
    mov ax, [PADDLE_X_SIZE]     ; x size
    push ax
    mov ax, [bp+6]              ; y coord
    push ax
    mov ax, [bp+4]              ; x coord
    push ax
    call print_box

    mov sp, bp
    pop bp
    ret

print_box: ; arguments: x coord, y coord, x size, y size (2 bytes each)
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
        mov ax, [bp-2]      ; x = index_x + x argument of print paddle
        add ax, [bp+4]
        push ax
        call print_pixel

        mov ax, [bp-4]      ; increment index_y by 1
        add ax, 1
        mov [bp-4], ax

        mov ax, [bp-4]
        mov bx, [bp+10]
        cmp ax, bx     ; check index_y < y_size
        jle .for_y
.end_for_y:

        mov ax, [bp-2]
        add ax, 1
        mov [bp-2], ax

        mov ax, [bp-2]
        cmp ax, [bp+8]     ; check index_x < x_size
        jle .for_x
.end_for_x:

        mov sp, bp
        pop bp
        ret

PADDLE_LEFT_X_POS:
dw 5
PADDLE_RIGHT_X_POS:
dw 625
PADDLE_LEFT_Y_POS:
dw 4
PADDLE_RIGHT_Y_POS:
dw 17
PADDLE_X_SIZE:
dw 7
PADDLE_Y_SIZE:
dw 40
BALL_SIZE:
dw 5
BALL_X_POS:
dw 150
BALL_Y_POS:
dw 100;
BALL_SPEED_X:
dw 5
BALL_SPEED_Y:
dw 5