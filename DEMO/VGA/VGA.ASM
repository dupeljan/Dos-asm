.model small
.code
org 256
s:	push	cs
	pop	ds
	call	t
db	'╤е$'
t:	pop	dx
	mov	ah,9
	int	33
	mov	ah,76
	int	33
end s
 byte ptr ss:[bp+10]		;зеленого
bcol	equ byte ptr ss:[bp+8]		;синего
cidx	equ byte ptr ss:[bp+6]		;номер цвета


_vgapal proc far		; перезаписывает 1 цвет под номером cidx

	public _vgapal

	push	bp
	mov	bp,sp
ploc_1:
	mov	dx,3dah	;3dah - регистр input status1 (READONLY)
	cli		;запрещаем прерывания
ploc_2:
	in	al,dx	;ловим отсутствие vertical retrace
	test	al,8	;3-й бит равен 1 если идет vertical retrace interval
	jnz	ploc_2

ploc_3:
	in	al,dx
	test	al,8	;ловим начало vertical retrace
	jz	ploc_3

	mov	al,cidx ;пишем в регистр PEL ADDRESS WRITE MODE
	mov	dx,3c8h ;номер регистра цвета который будем
	out	dx,al	;перепрограммировать

	inc	dx	;dx:=dx+1 (dx=3c9h)
	mov	al,rcol ;последовательно записываем
	out	dx,al	;индекс красного
	mov	al,gcol
	out	dx,al	;зеленого
	mov	al,bcol
	out	dx,al	;синего

	sti		;разрешаем прерывания

	pop	bp
	ret	8	;параметры занимают 8 слов

_vgapal endp


segww	equ	word ptr ss:[bp+10]	;segment и offset таблицы цветов
offsww	equ	word ptr ss:[bp+8]	;[r1,g1,b1,r2,g2,b2,...,rn,gn,bn]
q	equ	byte ptr ss:[bp+6]	;количество перезаписываемых цветов


_vgapalette proc far		;перезаписывает q цветов начиная с 0-го

	public _vgapalette

	push	bp
	mov	bp,sp
	mov	bx,ds			;сохраняем ds pascal'a
	mov	ax,segww
	mov	ds,ax			;в новый ds пишем адрес таблицы

bloc_1:
	mov	dx,3dah ;3dah - регистр input status1 (READONLY)            
	cli             ;запрещаем прерывания                               
bloc_2:                                                                     
	in	al,dx   ;ловим отсутствие vertical retrace                  
	test	al,8    ;3-й бит равен 1 если идет vertical retrace interval
	jnz	bloc_2                                                      
                                                                            
bloc_3:                                                                     
	in	al,dx                                                       
	test	al,8    ;ловим начало vertical retrace                      
	jz	bloc_3                                                      

	mov	al,0     ;пишем в регистр PEL ADDRESS WRITE MODE
	mov	dx,3c8h  ;номер регистра цвета с которого будем    
	out	dx,al    ;перепрограммировать (=0)
			 ;при записи очередного цвета этот регистр
	inc	dx	 ;автоматически увеличивается на 1
	mov	si,offsww  ;в si offset таблицы
	xor	cx,cx
	mov	cl,q	   ;cx - кол-во перезаписываемых регистров
bloc_4:
	mov	al,ds:[si]
	out	dx,al	    ;Пишем red
	inc	si
	mov	al,ds:[si]
	out	dx,al	    ;Green
	inc	si
	mov	al,ds:[si]
	out	dx,al       ;Blue
	inc	si
	loop	bloc_4

	sti		 ;Разрешаем прерывания

	mov	ds,bx    ;Back to Pascal's  DS

	pop	bp

	ret	6	 ;Параметры занимают 6 слов

_vgapalette endp

code	ends
endcolors	equ 196


code	segment
	assume cs:code, ds:nothing


rcol	equ byte ptr ss:[bp+12]		;индекс красного цвета
gcol	equ byte ptr ss:[bp+10]		;зеленого
bcol	equ byte ptr ss:[bp+8]		;синего
cidx	equ byte ptr ss:[bp+6]		;номер цвета


_vgapal p