%TITLE "Ваш комментарий программы"

MODEL	small

;ST1 SEGMENT             ;Описали сегмент стека;
;	DB 2 DUP(?)
;ST1 ENDS

DATA SEGMENT
    mass    db  2, 80 dup(?)
    p       db  1
    stepper db  0
    n       db  ?
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;
divTen PROC NEAR
    div p
    add ah, 48
    ret
divTen ENDP
outchar proc NEAR
    mov ah, 2
    int 21h
    ret
outchar ENDP

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
    mov dl, 110
    call outchar
    mov dl, 61
    call outchar
    
    mov ah, 0Ah
    lea dx, mass
    int 21h
    
    xor cx, cx
    mov cl, mass[2]
    sub cl, 48
    mov n, cl    ; ввод
     
    mov ax, 1
    mov bx, -1
    mov si, 1
    

    mov dx,cx
    neg dx
L0: cmp cx, 0
        jle L3
    push cx
    
L1: add bx, ax
    push ax
    xor ax, ax
    mov al, p
    mov mass[bx], al
    pop ax
    inc p
    
    loop    L1
    
    pop cx
    cmp stepper, 0
        jne L2
    dec cx
    inc stepper
    neg dx
    mov ax, dx
    jmp L0    
        
L2: neg si
    mov ax, si
    dec stepper        
    jmp L0

L3:
    ;вывод
    
    mov cl, p
    dec cx ; cx = n*n
    mov p, 10
    
    xor bx, bx
L4: 
;===============================
    xor ax, ax
    mov al, mass[bx]
    call divTen
    
    push ax ; последняя цифра в старшем бите верхушки стека
    xor ah, ah
    call divTen
    
    mov dl, ah
    call outchar
    
    pop ax
    mov dl, ah
    call outchar
    
    mov dl, 32 ; ' '
    call outchar
;===============================    
    inc bx
    mov ax, bx
    div n
    cmp ah, 0
        jne L5
    ;newline
    mov dl, 10
    call outchar
    
    mov dl, 13
    call outchar
L5: loop L4
    


;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
	MOV	AX,4C00h
	INT	21h
ENDS

END	Start
