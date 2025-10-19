.model small
.stack 100h
.data
msg1 db 'Enter number: $'
msg2 db 0Dh,0Ah,'Factorial: $'
.code

fact proc
    mov cx, ax
    mov ax, 1
again:
    mul cx
    loop again
    ret
fact endp

main proc
    mov ax, @data
    mov ds, ax

    mov ah, 9
    lea dx, msg1
    int 21h

    mov ah, 1
    int 21h
    sub al, '0'
    mov ah, 0

    call fact

    mov bx, ax

    mov ah, 9
    lea dx, msg2
    int 21h

    mov ax, bx
    call print_num

    mov ah, 4Ch
    int 21h
main endp

print_num proc
    push ax
    push bx
    push cx
    push dx
    mov cx, 0
    mov bx, 10
next:
    xor dx, dx
    div bx
    push dx
    inc cx
    cmp ax, 0
    jne next
show:
    pop dx
    add dl, '0'
    mov ah, 2
    int 21h
    loop show
    pop dx
    pop cx
    pop bx
    pop ax
    ret
print_num endp

end main
