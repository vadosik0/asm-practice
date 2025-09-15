section .data
    msg db "Hello World", 0xA  ; текст + символ новой строки
    len equ $ - msg             ; длина текста

section .text
    global _start

_start:
    ; write(1, msg, len)
    mov eax, 4      ; системный вызов write
    mov ebx, 1      ; файловый дескриптор stdout
    mov ecx, msg    ; адрес сообщения
    mov edx, len    ; длина сообщения
    int 0x80        ; вызов ядра

    ; exit(0)
    mov eax, 1      ; системный вызов exit
    xor ebx, ebx    ; код выхода 0
    int 0x80
