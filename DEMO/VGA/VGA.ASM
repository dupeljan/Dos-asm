.model small
.code
org 256
s:	push	cs
	pop	ds
	call	t
db	'ѥ$'
t:	pop	dx
	mov	ah,9
	int	33
	mov	ah,76
	int	33
end s
 byte ptr ss:[bp+10]		;��������
bcol	equ byte ptr ss:[bp+8]		;ᨭ���
cidx	equ byte ptr ss:[bp+6]		;����� 梥�


_vgapal proc far		; ��१����뢠�� 1 梥� ��� ����஬ cidx

	public _vgapal

	push	bp
	mov	bp,sp
ploc_1:
	mov	dx,3dah	;3dah - ॣ���� input status1 (READONLY)
	cli		;����頥� ���뢠���
ploc_2:
	in	al,dx	;����� ������⢨� vertical retrace
	test	al,8	;3-� ��� ࠢ�� 1 �᫨ ���� vertical retrace interval
	jnz	ploc_2

ploc_3:
	in	al,dx
	test	al,8	;����� ��砫� vertical retrace
	jz	ploc_3

	mov	al,cidx ;��襬 � ॣ���� PEL ADDRESS WRITE MODE
	mov	dx,3c8h ;����� ॣ���� 梥� ����� �㤥�
	out	dx,al	;��९ணࠬ��஢���

	inc	dx	;dx:=dx+1 (dx=3c9h)
	mov	al,rcol ;��᫥����⥫쭮 �����뢠��
	out	dx,al	;������ ��᭮��
	mov	al,gcol
	out	dx,al	;��������
	mov	al,bcol
	out	dx,al	;ᨭ���

	sti		;ࠧ�蠥� ���뢠���

	pop	bp
	ret	8	;��ࠬ���� �������� 8 ᫮�

_vgapal endp


segww	equ	word ptr ss:[bp+10]	;segment � offset ⠡���� 梥⮢
offsww	equ	word ptr ss:[bp+8]	;[r1,g1,b1,r2,g2,b2,...,rn,gn,bn]
q	equ	byte ptr ss:[bp+6]	;������⢮ ��१����뢠���� 梥⮢


_vgapalette proc far		;��१����뢠�� q 梥⮢ ��稭�� � 0-��

	public _vgapalette

	push	bp
	mov	bp,sp
	mov	bx,ds			;��࠭塞 ds pascal'a
	mov	ax,segww
	mov	ds,ax			;� ���� ds ��襬 ���� ⠡����

bloc_1:
	mov	dx,3dah ;3dah - ॣ���� input status1 (READONLY)            
	cli             ;����頥� ���뢠���                               
bloc_2:                                                                     
	in	al,dx   ;����� ������⢨� vertical retrace                  
	test	al,8    ;3-� ��� ࠢ�� 1 �᫨ ���� vertical retrace interval
	jnz	bloc_2                                                      
                                                                            
bloc_3:                                                                     
	in	al,dx                                                       
	test	al,8    ;����� ��砫� vertical retrace                      
	jz	bloc_3                                                      

	mov	al,0     ;��襬 � ॣ���� PEL ADDRESS WRITE MODE
	mov	dx,3c8h  ;����� ॣ���� 梥� � ���ண� �㤥�    
	out	dx,al    ;��९ணࠬ��஢��� (=0)
			 ;�� ����� ��।���� 梥� ��� ॣ����
	inc	dx	 ;��⮬���᪨ 㢥��稢����� �� 1
	mov	si,offsww  ;� si offset ⠡����
	xor	cx,cx
	mov	cl,q	   ;cx - ���-�� ��१����뢠���� ॣ���஢
bloc_4:
	mov	al,ds:[si]
	out	dx,al	    ;��襬 red
	inc	si
	mov	al,ds:[si]
	out	dx,al	    ;Green
	inc	si
	mov	al,ds:[si]
	out	dx,al       ;Blue
	inc	si
	loop	bloc_4

	sti		 ;����蠥� ���뢠���

	mov	ds,bx    ;Back to Pascal's  DS

	pop	bp

	ret	6	 ;��ࠬ���� �������� 6 ᫮�

_vgapalette endp

code	ends
endcolors	equ 196


code	segment
	assume cs:code, ds:nothing


rcol	equ byte ptr ss:[bp+12]		;������ ��᭮�� 梥�
gcol	equ byte ptr ss:[bp+10]		;��������
bcol	equ byte ptr ss:[bp+8]		;ᨭ���
cidx	equ byte ptr ss:[bp+6]		;����� 梥�


_vgapal p