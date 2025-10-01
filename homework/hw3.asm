; hw3.asm
; Програма перевіряє, чи є число у AX простим

.model small
.stack 100h
.data
    msgPrime db "Просте", 13, 10, '$'
    msgNotPrime db "Не просте", 13, 10, '$'
    buffer db 6 dup('$')   ; буфер для виводу числа

.code
main proc
    mov ax, @data
    mov ds, ax

    ; ==== ТЕСТОВЕ ЧИСЛО ====
    mov ax, 29        ; тут число для перевірки
    mov bx, ax        ; збережемо його у BX

    ; ==== Вивести число ====
    call print_num
    mov dl, 13        ; \r
    mov ah, 02h
    int 21h
    mov dl, 10        ; \n
    mov ah, 02h
    int 21h

    ; ==== Перевірка на простоту ====
    mov ax, bx        ; число у AX
    call is_prime

    cmp al, 1
    je print_prime
    jmp print_not_prime

print_prime:
    mov dx, offset msgPrime
    mov ah, 09h
    int 21h
    jmp exit

print_not_prime:
    mov dx, offset msgNotPrime
    mov ah, 09h
    int 21h

exit:
    mov ah, 4Ch
    int 21h
main endp

; ---------------------------
; Перевірка чи є число простим
; Вхід: AX = число
; Вихід: AL = 1 якщо просте, 0 якщо ні
; ---------------------------
is_prime proc
    cmp ax, 2
    jl not_prime       ; числа < 2 – не прості
    je prime

    mov cx, 2
check_loop:
    mov dx, 0
    div cx            ; AX / CX
    cmp dx, 0
    je not_prime      ; якщо ділиться – не просте
    inc cx
    mov ax, bx        ; відновлюємо число
    cmp cx, bx
    jl check_loop

prime:
    mov al, 1
    ret
not_prime:
    mov al, 0
    ret
is_prime endp

; ---------------------------
; Вивід числа (AX -> консоль)
; ---------------------------
print_num proc
    mov cx, 0
    mov bx, 10
    mov dx, 0
    mov si, offset buffer + 5 ; вказівник на кінець буфера

next_digit:
    xor dx, dx
    div bx
    add dl, '0'
    dec si
    mov [si], dl
    inc cx
    cmp ax, 0
    jne next_digit

    mov dx, si
    mov ah, 09h
    int 21h
    ret
print_num endp

end main
