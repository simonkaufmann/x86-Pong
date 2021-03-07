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

%define PADDLE_Y_STEP   10

%define DELAY_1         0FFFFh
%define DELAY_2         06ffh

%define BALL_SIZE       5
%define PADDLE_Y_SIZE   40
%define PADDLE_X_SIZE   7
   
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

Loop:   
        ; Start of delay code
        mov ax, DELAY_2  ; for speed of delay
Delay2: mov bx, DELAY_1 ; for speed of delay
Delay:  dec bx
        cmp bx, 0h
        jne Delay
        dec ax
        jne Delay2
        ; End of delay code

        ; call process_key

        ; clear screen
        mov ax, 04h         ; Set video mode to graphic will clear screen
        int 10h

        mov dx, [PADDLE_LEFT_Y_POS]         ; y position
        mov cx, [PADDLE_LEFT_X_POS]         ; x position
        call print_paddle

        mov dx, [PADDLE_RIGHT_Y_POS]         ; y position
        mov cx, [PADDLE_RIGHT_X_POS]         ; x position
        call print_paddle

        call ball_step
        
        jmp Loop            ; Game Loop

; process_key:
;         mov ah, 01h ; Test key BIOS
;         int 16h
;         jz .no_key_event

;         mov ah, 00h
;         int 16h ; int 16h will put ASCII character in al and scan code in AH
        
;         cmp al, KEY_LEFT_UP
;         jne .skip_left_up

;         mov bx, [PADDLE_LEFT_Y_POS]
;         sub bx, PADDLE_Y_STEP

;         cmp bx, 0
;         jl .clamp_left_up
;         mov [PADDLE_LEFT_Y_POS], bx
;         jmp .end_if
; .clamp_left_up:
;         mov word [PADDLE_LEFT_Y_POS], 0
;         jmp .end_if

; .skip_left_up:
;         cmp al, KEY_LEFT_DOWN
;         jne .skip_left_down

;         mov bx, [PADDLE_LEFT_Y_POS]
;         add bx, PADDLE_Y_STEP

;         cmp bx, 155
;         jg .clamp_left_down
;         mov [PADDLE_LEFT_Y_POS], bx
;         jmp .end_if
; .clamp_left_down:
;         mov word [PADDLE_LEFT_Y_POS], 155
;         jmp .end_if

; .skip_left_down:
;         cmp al, KEY_RIGHT_UP
;         jne .skip_right_up

;         mov bx, [PADDLE_RIGHT_Y_POS]
;         sub bx, PADDLE_Y_STEP

;         cmp bx, 0
;         jl .clamp_right_up
;         mov [PADDLE_RIGHT_Y_POS], bx
;         jmp .end_if
; .clamp_right_up:
;         mov word [PADDLE_RIGHT_Y_POS], 0
;         jmp .end_if

; .skip_right_up:
;         cmp al, KEY_RIGHT_DOWN
;         jne .skip_right_down

;         mov bx, [PADDLE_RIGHT_Y_POS]
;         add bx, PADDLE_Y_STEP

;         cmp bx, 155
;         jg .clamp_right_down
;         mov [PADDLE_RIGHT_Y_POS], bx
;         jmp .end_if
; .clamp_right_down:
;         mov word [PADDLE_RIGHT_Y_POS], 155
;         jmp .end_if

;         jmp .end_if
; .skip_right_down:

; .end_if:
; .no_key_event:
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

        ; print_ball
        mov dx, [BALL_Y_POS]
        mov cx, [BALL_X_POS]
        mov si, BALL_SIZE
        add si, cx
        mov di, BALL_SIZE
        add di, dx
        call print_box

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

print_paddle: ; cx: x coordinate, dx: y coordinate
    push bp
    mov bp, sp

    mov si, PADDLE_X_SIZE
    add si, cx
    mov di, PADDLE_Y_SIZE
    add di, dx
    call print_box

    mov sp, bp
    pop bp
    ret

print_box: ; arguments: x coord, y coord, x size, y size (2 bytes each)
        ; cx: x coordinate
        ; dx: y coordinate
        ; si: end x coordinate
        ; di: end y coordinate

        ; for x to x + 10
        ; for y to y + 50
        ; print pixel

        mov bx, cx ; store original y position
.for_x:
.for_y:
        ; for print pixel (uses cx and dx as parameter)
        mov al, 0fh
        mov ah, 0Ch
        int 10h

        add cx, 1
        cmp cx, si
        jne .for_y
.end_for_y:
        mov cx, bx ; reset y start position

        add dx, 1
        cmp dx, di
        jne .for_x
.end_for_x:
        ret

PADDLE_LEFT_X_POS:
dw 5
PADDLE_RIGHT_X_POS:
dw 625
PADDLE_LEFT_Y_POS:
dw 4
PADDLE_RIGHT_Y_POS:
dw 17
BALL_X_POS:
dw 150
BALL_Y_POS:
dw 100;
BALL_SPEED_X:
dw 5
BALL_SPEED_Y:
dw 5