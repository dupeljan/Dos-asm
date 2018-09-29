%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    mass    dw  10 dup( 10 dup (1) )
    n       dw  ?
    n2      dw  ?
    nn      dw  ?
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
	inint	n
	
	mov	ax,	n
	add	ax,	ax
	mov	n2,	ax ; n2 = 2*n

	
    mov cx, n
    dec cx  ; cx = n-1
    
    xor bx, bx
    xor si, si
L0: push cx
L1: mov mass[bx][si], 0
    add si, 2
    loop    L1
    pop cx
    add bx, n2
    xor si, si
    loop    L0
    
    mov	ax,	n
	mul	n
	mov	nn,	ax ; nn = n*n
	
    xor bx, bx; вывод
    xor si, si
    mov cx, n
L3: push    cx
    mov cx, n
L2: outint mass[bx][si],   2
    add si, 2
    loop    l2
    newline
    pop cx
    mov si, 0
    add bx, n2
    loop    L3
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
