%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
	ans dw 0
	n   dw ?
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
	inint	ax
	
	mov	n,	ax	
	mov	bx,	10

l1:	cmp	n,	0
		jle endd	
	
	mov	ax,	ans	
	mul	bx		; ax=ans*ten
	mov	ans,	ax	; ans *=10 
	
	xor	dx,	dx
	mov	ax,	n	
	div	bx		; dx= n mod ten
	add	ans,	dx	;ans += n mod ten
	
	mov	n,	ax	;n = n div 10
				;ax = ax div bx
	
	jmp	l1
endd:	outint	ans
	
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start