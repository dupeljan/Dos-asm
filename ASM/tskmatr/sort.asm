%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
	vector	dw	100 dup (?)
	n		dw	?
	n2		dw	?
	n1  dw  ?
	buff    dw  ?
	messgN	db	'N=$'
	
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
;insert	
	lea	dx,	messgN
	outstr
	inint	n
	mov	cx,	n
	
	mov	ax,	n
	mov	bx,	2
	mul	bx
	mov	n2,	ax; n2 = 2n
	
    mov n1, ax
    add n1, 2 ; n1= 2(n+1)s  

	xor si, 0
	xor ax, ax
L:  xor bx, bx
    push    cx
    
    outint  ax
    newline
    
    mov cx, n
L0:	mov dx, bx
    shr dx, 1
    outch	'x'
	outint 	dx
	outch	'='
	
	inint	vector[si][bx]
	add	bx,	2
	loop	L0
	
	pop    cx
	add    si, n2
    inc    ax
	
	loop   L
;work====================================
	
		
		
	mov	bx,	1		 ;	bx = i
L1: 
;====================
    mov ax, bx
    mul n1
    mov di, ax
;====================

    mov ax, vector[di]; buff = vector[bx]
	mov buff,  ax
	
	mov	si,	bx		 ;	si = j
	dec si           ; j = i-1  
	
	
	
L2:	cmp	si,	-1		;	cmp	j,	-2
		jle	L3
	
;====================
	mov ax, si
    mul n1
    mov di, ax
;====================
	
	mov	ax,	vector[di];	dx = m[j]
	cmp	ax,	buff		  ;	cmp	m[j],	buff
		jle	L3
	

	inc si

;====================
    push ax
	mov ax, si
    mul n1
    mov di, ax
    pop ax
;====================
    
	mov	vector[di],	ax;	m[j+1]=m[j]
	sub    si, 2
	
	jmp	L2
	
L3:	inc si

;====================
    mov ax, si
    mul n1
    mov di, ax
;====================
    
    mov ax,     buff
	mov vector[di],    ax;	m[j+1]= buff
	
	inc bx
	cmp	bx,	n
	jl	L1

;output=================================================
	
    mov cx, n; вывод
    xor bx, bx
L5: push    cx
    xor si, si
    mov cx, n
L6: outint vector[bx][si],   2
    add si, 2
    loop    l6
   
    newline
    pop cx
    add bx, n2
    loop    L5
;output=================================================

		
	
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
