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
    ;сохраним регистры
    push bp
    mov bp, sp
    ;pusha  - 3 эл-та в стек
    push ax
    push bx
    push cx
    ;======= спускаемся к переменным
    mov sp, bp     
    add sp, 6 ; sp указывает на преременные
    
	pop cx ; cx = длинна массива
    pop bx ; bx = адрес первого эл-та
	
	;====ATTANTON
	;===перемещаемся в верхушку стека, чтобы
	;===макросы не сожрали ничего из стека
	mov sp,    bp
	sub sp,    6
	;===========================================
	
	xor    ax, ax
L0:	outch	'x'
	outint 	ax
	outch	'='
	inint	[bx]
	add	bx,	2
	inc ax
	loop	L0
	
	;Востановим регистры
	;==стек в вехушке================
    ;popa
    pop cx
    pop bx
    pop ax
    ;=======
    pop bp
    
	RET 4 ;чистим стек    
INPUT   ENDP

;===============PROCEDURE OUTPUT=========================

OUTPUT PROC FAR; (STACK dw *vector , dw n)
;сохраним регистры
    push bp
    mov bp, sp
    ;pusha  - 2 эл-та в стек
    push bx
    push cx
    ;======= спускаемся к переменным
    mov sp, bp     
    add sp, 6 ; sp указывает на преременныe
    
	pop cx ; cx = длинна массива
    pop bx ; bx = адрес первого эл-та
	
	;====ATTANTON
	;===перемещаемся в верхушку стека, чтобы
	;===макросы не сожрали ничего из стека
	mov sp,    bp
	sub sp,    4
	
;==========Собственно процедура===========
L:	outint	[bx] , 2
	add	bx,	2
	loop	L
    newline
;========================================
	;Востановим регистры
	;==стек в вехушке================
    ;popa
    pop cx
    pop bx
    ;=======
    pop bp

	RET 4 ; чистим стек
OUTPUT  ENDP

;=============PROCEDURE SORT=============
SORT PROC FAR; (STACK dw *vector , dw n)
 push bp
    mov bp, sp
    ;pusha  - 5 эл-тов в стек
    push ax
    push bx
    push cx
    push dx
    push si
    ;======= спускаемся к переменным
    mov sp, bp     
    add sp, 6 ; sp указывает на преременныe
    
	pop cx ; cx = длинна массива
    pop bx ; bx = адрес первого эл-та
	
	;====ATTANTON
	;===перемещаемся в верхушку стека, чтобы
	;===макросы не сожрали ничего из стека
	mov sp,    bp
	sub sp,    10 ; const = 2*кол-во сохр регистов
 
;==========Собственно процедура===========
    cmp cx, 1     ; исключительный случай
        je RETURN
        
    mov	ax,	cx
	mov	dx,	2
	mul	dx
	mov	cx,	ax
	
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
 ;========================================
RETURN:
 ;Востановим регистры
	;==стек в вехушке================
    ;popa
    pop si
    pop dx
    pop cx
    pop bx
    pop ax
    ;=======
    pop bp

	RET 4; чистим стек
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
