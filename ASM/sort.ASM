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


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
	lea	dx,	messgN
	outstr
	inint	n
	mov	cx,	n
	
	mov	ax,	n
	mov	bx,	2
	mul	bx
	mov	n2,	ax; n2 = 2n

	
	mov	bx,	0
L0:	outch	'x'
	outint 	bx
	outch	'='
	inint	vector[bx]
	add	bx,	2
	loop	L0
;insert
	
		
	mov	bx,	2		 ;	bx = i
L1:	mov	ax,	vector[bx];	ax = buff
	mov	si,	bx		 ;	si = j
	sub	si,	2
	
	
	
L2:	cmp	si,	-2		;	cmp	j,	-2
		jle	L3
	mov	dx,	vector[si];	dx = m[j]
	cmp	dx,	ax		  ;	cmp	m[j],	buff
		jle	L3
	
	;outint	dx,	2	
	add	si,	2
	mov	vector[si],	dx;	m[j+1]=m[j]
	sub	si,	4
	jmp	L2
	
L3:	add	si,	2
	mov	vector[si],	ax;	m[j+1]= buff
	
	add	bx,	2
	cmp	bx,	n2
	jl	L1
;work
	
	newline
	mov	cx,	n
	mov	bx,	0
L4:	outch	'x'
	outint 	bx
	outch	'='
	outint	vector[bx]
	newline
	add	bx,	2
	loop	L4	
;output
		
	
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
