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
	messgN	db	'N=$'
	
DATA ENDS

;============Макросы!=============
MUL_ON_TWO MACRO A,B
    ;==========
    push ax
    push bx
    ;==========
    mov	ax,	A
	add    ax,	ax
	mov	B,	ax
	;==========
	pop bx
	pop ax
	;==========
ENDM

INPUT MACRO V , LEN 
    LOCAL   L
    ;==========
    push ax
    push bx
    ;==========
    lea	dx,	messgN
	outstr
	inint	LEN
	mov	cx,	LEN
	
	xor ax, ax
	xor bx, bx
L:	outch	'x'
	outint 	ax
	outch	'='
	inint	V[bx]
	add	bx,	2
	inc ax
	loop	L
	
    ;==========
	pop bx
	pop ax
	;==========
ENDM

OUTPUT MACRO V, LEN
    LOCAL L
	;==========
    push bx
    push cx
    ;==========
    newline
	mov	cx,	LEN
	mov	bx,	0
	
L:	outint	V[bx],2
	add	bx,	2
	loop	L	
	
	;==========
	pop cx
	pop bx
	;==========
ENDM

SORT MACRO V, LEN , BUFF
   LOCAL L1, L2, L3
   MUL_ON_TWO LEN, BUFF
   ;==========
   push ax
   push bx
   push cx
   push dx
   push si
   ;==========
   
    mov	bx,	2		 ;	bx = i
L1:	mov	ax,	V[bx];	ax = buff
	mov	si,	bx		 ;	si = j
	sub	si,	2
	
	
	
L2:	cmp	si,	-2		;	cmp	j,	-2
		jle	L3
	mov	dx,	V[si];	dx = m[j]
	cmp	dx,	ax		  ;	cmp	m[j],	buff
		jle	L3
	
	
	add	si,	2
	mov	V[si],	dx;	m[j+1]=m[j]
	sub	si,	4
	jmp	L2
	
L3:	add	si,	2
	mov	V[si],	ax;	m[j+1]= buff
	
	add	bx,	2
	cmp	bx,	BUFF
	jl	L1
   ;==========
   pop si
   pop dx
   pop cx
   pop bx
   pop ax
   ;==========
ENDM

CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
	INPUT vector, n
	OUTPUT vector, n
	SORT vector, n, n2
	OUTPUT vector, n
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
