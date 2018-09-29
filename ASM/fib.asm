%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
	messN		db	'Enter n'
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
	inint ax

	mov	bx,	1
	xor	cx,	cx
	xor	dx,	dx

l1:	cmp	ax,	0
		jle	endd
		
		add	dx,	bx
		mov	bx,	cx
		mov	cx,	dx

		outint	dx
		outint	0
		

		dec	ax
		jmp	l1

endd:	
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start