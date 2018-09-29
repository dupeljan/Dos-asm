%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS


DATA SEGMENT
	n		dw	?
	n2		dw	?
	vector	dw	100 dup (?)
	messgN	db	'N=$'
    
    bax dw  ?
    bbx dw  ?
    bcx dw  ?
    bdx dw  ?
    bcs dw  ?
    bip dw  ?
    bsi dw  ?
    buff dw ?
DATA ENDS

    
PROCEDURE SEGMENT
ASSUME CS:PROCEDURE , ds:DATA

;========PROCEDURE INPUT=================
INPUT PROC FAR ; (STACK dw *vector, dw n) 
    ;сохраним регистр
    mov bax,    ax
    mov bbx,    bx
    mov bcx,    cx
    pop bcs
    pop bip
    ;================
    
	pop cx ; cx = длинна массива
	pop bx ; bx = адрес первого эл-та
	
	xor    ax, ax
L0:	outch	'x'
	outint 	ax
	outch	'='
	inint	[bx]
	add	bx,	2
	inc ax
	loop	L0
	
	;Востановим регистры
	mov ax,    bax
	mov bx,    bbx
	mov cx,    bcx
	push bip
	push bcs
	;==================
	RET
INPUT   ENDP

;===============PROCEDURE OUTPUT=========================

OUTPUT PROC FAR; (STACK dw *vector , dw n)
 ;сохраним регистр
    mov bbx,    bx
    mov bcx,    cx
    pop bcs
    pop bip
    ;================
    
	pop cx ; cx = длинна массива
	pop bx ; ax = адрес первого эл-та
	
	
L:
	outint	[bx] , 2
	add	bx,	2
	
	loop	L
	
	;Востановим регистры
	mov bx,    bbx
	mov cx,    bcx
    push bip
    push bcs
	;==================
	newline
	RET
OUTPUT  ENDP

;=============PROCEDURE SORT=============
SORT PROC FAR; (STACK dw *vector , dw n)
    ;сохраним регистр
    mov bax,    ax
    mov bbx,    bx
    mov bcx,    cx
    mov bdx,    dx
    mov bsi,    si
    pop bcs
    pop bip
    ;================
    
    pop cx ; cx = длинна массива
    
    mov	ax,	cx
	mov	bx,	2
	mul	bx
	mov	cx,	ax; 
	
	pop bx; bx = адрес первого эл-та
	add cx, bx
	sub cx, 2; cx = 2(n-1) + bx
	
	mov buff,  bx
	sub buff,  2
    
    
    
    add	bx,	2		 ;	bx = i
L1:	mov	ax,	[bx];	ax = buff
	mov	si,	bx		 ;	si = j
	sub	si,	2
	
	
	
L2:	cmp	si,	buff		;	cmp	j,	-2
		jle	L3
	mov	dx,	[si];	dx = m[j]
	cmp	dx,	ax		  ;	cmp	m[j],	buff
		jle	L3
	
	;outint	dx,	2	
	add	si,	2
	mov	[si],	dx;	m[j+1]=m[j]
	sub	si,	4
	jmp	L2
	
L3:	add	si,	2
	mov	[si],	ax;	m[j+1]= buff
	
	add	bx,	2
	cmp	bx,	cx
	jle	L1
    
    ;Востановим регистры
	mov ax,    bax   
	mov bx,    bbx
	mov cx,    bcx
	mov dx,    bdx
	mov si,    bsi
    push bip
    push bcs
	;==================
	RET
SORT ENDP
;========================================


PROCEDURE ENDS



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
	inint n

	lea ax,    vector

;====call_input=========
    push ax
    push n
    call INPUT
    
;====call_output========    
    push ax
    push n   
    call OUTPUT
    
;====call_sort==========
    push ax
    push n
    call SORT
 
;====call_output_again==
    push ax
    push n   
    call OUTPUT
    
	
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
