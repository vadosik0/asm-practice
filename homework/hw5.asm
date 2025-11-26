section .data
    AH      equ 30         ; ширина конверта
    AL      equ 12         ; высота конверта

    star    db '*'
    space   db ' '
    nl      db 10

section .text
    global _start

; -------- print one char in AL ----------
print_char:
    mov [esp-1], al
    lea ecx, [esp-1]
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    int 0x80
    ret

; -------- print '*' ----------
print_star:
    mov al, [star]
    call print_char
    ret

; -------- print ' ' ----------
print_space:
    mov al, [space]
    call print_char
    ret

; -------- print N stars (ECX) ----------
print_n_stars:
.loop_s:
    cmp ecx, 0
    je .done_s
    call print_star
    dec ecx
    jmp .loop_s
.done_s:
    ret

; -------- print N spaces (ECX) ----------
print_n_spaces:
.loop_sp:
    cmp ecx, 0
    je .done_sp
    call print_space
    dec ecx
    jmp .loop_sp
.done_sp:
    ret

; ----------------------------------------
; MAIN
; ----------------------------------------
_start:

    ; ---- top border ----
    mov ecx, AH
    call print_n_stars
    mov al, [nl]
    call print_char

    ; ---- middle ----
    mov esi, AL        ; loop AL rows

middle_loop:
    cmp esi, 0
    je bottom

    ; i = AL - esi
    mov eax, AL
    sub eax, esi
    mov edi, eax       ; i

    ; left border "*"
    call print_star

    ; L = 2*i пробелов
    mov ecx, edi
    shl ecx, 1
    call print_n_spaces

    ; диагональ слева "*"
    call print_star

    ; M = AH - 4 - 4*i
    mov eax, AH
    sub eax, 4
    mov ebx, edi
    shl ebx, 2
    sub eax, ebx
    mov ecx, eax
    call print_n_spaces

    ; диагональ справа "*"
    call print_star

    ; снова L пробелов
    mov ecx, edi
    shl ecx, 1
    call print_n_spaces

    ; правая рамка "*"
    call print_star

    ; newline
    mov al, [nl]
    call print_char

    dec esi
    jmp middle_loop

bottom:
    ; ---- bottom border ----
    mov ecx, AH
    call print_n_stars
    mov al, [nl]
    call print_char

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80
