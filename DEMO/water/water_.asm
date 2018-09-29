;
;                 ������������������������������������������
;                 �                                        �
;                 �            -  W a t e r  -             �
;                 �                                        �
;                 �    Copyright: 2003 ��审�஢ �. �.     �
;                 �        email: FloatOk@Yandex.ru        �
;                 �                                        �
;                 ������������������������������������������
;

	PspSize		equ 100h
	StackSize	equ 100h

StackSegment SEGMENT PARA STACK 'STACK'

;����������������������������������������������������������������������
;                         ������� ����
;����������������������������������������������������������������������

	db StackSize dup (?)

;����������������������������������������������������������������������

StackSegment ENDS



DataSegment SEGMENT PARA 'DATA'

;����������������������������������������������������������������������
;                    ��ࠬ���� �������樨...
;����������������������������������������������������������������������
 
	BlurCount	equ 5
	TextColor	equ 255-30*TextScale
	TextShowDelay	equ 100
	TextScale	equ 3
	TextX		equ (MaxX-(TextStringSize-1)*TextScale*BiosFontSize)/2+5
	TextY		equ 90
	MaxX		equ 320
	MaxY		equ 200
	BiosFontSize	equ 8
	BufferSize	equ MaxX*MaxY
	VideoMemory	equ 0a000h
	MaxColor	equ 252
	TextStringSize	equ 14

	TimeToRunScrSav	equ 1

;����������������������������������������������������������������������


;����������������������������������������������������������������������
;                    ���ᠭ�� ������...
;����������������������������������������������������������������������

	String		db '             ', 0
        		db '    Hello    ', 0
		        db '    from     ', 0
		        db 'Sukhoborov A.', 0
		        db '    email :  ', 0
		        db '   FloatOk   ', 0
		        db ' @Yandex.ru  ', 0
			db '             ', 0

	LastString	equ $-offset string
	
	BufferVideo	dw ?
	BufferFirst	dw ?
	BufferSecond	dw ?

	Seed		dw ?
	FontAddr	dd ?

	ExitDelay	db 100
	Exit		db 0
	
	DataSize	equ $-String

;����������������������������������������������������������������������

DataSegment ENDS



CodeSegment SEGMENT PARA 'CODE'
	assume	cs: CodeSegment, ds: DataSegment, ss: StackSegment
.386
Locals

;����������������������������������������������������������������������
;                         ������� ����
;����������������������������������������������������������������������

Main PROC NEAR
;����������������������������������������������������������������������
; ��楤��: ��窠 �室�
;	     �室:  ���
;	     ��室: ���
;����������������������������������������������������������������������

	call	ShowAbout
	
	mov	ah, 4ch
	int	21h

	ret

Main ENDP


ShowAbout proc far
;����������������������������������������������������������������������
; ��楤��: ��䨪�
;	     �室:  ���
;	     ��室: ���
;����������������������������������������������������������������������

	pusha
	push	ds
	push	es
	push	gs

	mov	ah, 4ah
	mov	bx, ProgSizeInPar
	int	21h

	push	DataSegment
	pop	ds
	
; ������ ����� (3 ��㪨)
	mov	cl, 3			; ������⢮ ᮧ�������� ���஢
	mov	di, offset BufferVideo	; � di ᬥ饭�� BufferVideo
	mov	bx, BufferSize shr 4+1	; � bx ࠧ��� ���� � ��ࠣ���
@@CreateBuffers:
	mov	ah, 48h			; �뤥����� ����� ��� ���� 
	int	21h			; 21h - �㭪樨 ��
					; � ax ⥯��� ᥣ����� ���� �뤥������� ����
	push	DataSegment		; ����ࠨ���� es �� ᥣ���� ����
	pop	es
	stosw				; ����뫠�� ᥣ����� ���� �� ax � es:di � 㢥��稢��� di �� 2
	pusha				; ���࠭塞 �� ॣ����� � �⥪�
	mov	es, ax			; ����ࠨ���� es �� �뤥����� ���⮪ �����
	xor	ax, ax			; ���⨬ ॣ����� ax, di
	xor	di, di
	mov	cx, 7d00h		; � cx ����� ����
	rep stosw			; ���樠�����㥬 ��ﬨ 楯��� ᫮� �� ����� ds:si � ������ 7dh (�. �. ����) 
	popa				; ����⠭�������� �ᯮ�짮����� ॣ����� �� �⥪�
	loop	@@CreateBuffers


; ���樠�����㥬 VGA ०�� 13h
	mov	ax, 13h			; 13h - ����᪨� ०�� (320x200x256)
	int	10h			; ������ࢨ� BIOS


; ����祭�� ���� �� ⠡���� ���� � ����楩 ᨬ���� 8x8.
	mov	ax, 1130h               ; ����祭�� 㪠��⥫� �� ⠡���� ᨬ�����
	mov	bh, 03h                 ; � ����楩 ᨬ����� 8x8
	xor	bl, bl                  ;
	int	10h			; ������ࢨ� BIOS
					; � es:bp - 㪠��⥫� �� ⠡���� ᨬ����� � ����楩 8x8
	mov	word ptr FontAddr, bp   ; ����頥� ���쭨� ���� ⠡���� ᨬ����� � ����楩 8x8
	mov	word ptr FontAddr+2, es ; � ������� ᫮�� FontAddr


; ���樠�����㥬 �������
	mov	bl, MaxColor 		; ����� 梥�
	mov	bh, 63       		; RED-��⠢�����
	mov	cl, 63       		; GREEN-��⠢�����
	mov	ch, 63       		; BLUE-��⠢�����
@@Set1:
	dec	bl			; ��⠭�������� ᫥���騩 梥�
	mov	al, bl                  ; � al ����� 梥�
	and	al, 1                   ; �᫨ �� �� ����
	jnz	@@Next1                 ; �� ��� �� @@Next1
	dec	cl                      ; �����蠥� GREEN - ��⠢������ 梥� �� 1
	dec	bh                      ; �����蠥� RED - ��⠢������ 梥� �� 1
@@Next1:
	call	ScreenSetRGBPalette     ; ������塞 梥� � �������
	cmp	bl, 2*63                ; �᫨ ����� 梥� � bl �� ࠢ�� 2*63
	jnz	@@Set1                  ; �� ��� �� @@Set1
@@Set2:
	dec	bl                      ; ��⠭�������� ᫥���騩 梥�
	mov	al, bl                  ; � al ����� 梥�
	and	al, 1                   ; �᫨ �� �� ����
	jnz	@@Next2                 ; �� ��� �� @@Next1
	dec	ch                      ; �����蠥� BLUE - ��⠢������ 梥�
@@Next2:
	call	ScreenSetRGBPalette     ; ������塞 梥� � �������
	test	bl, bl                  ; �᫨ ����� � bl �� ࠢ�� ���
	jnz	@@Set2                  ; �� ���室�� �� @@Set2


	mov	bl, 2			; ����, �⮡� ���� � 横� � ��ࢮ� ��ப� ᮮ�饭��
	xor	di, di			; ���⨬ di
;	push	di                      ; ���࠭塞 di � �⥪�

@@Repeat:
	dec	bl                      ; �����蠥� bl  �� 1
	jnz	@@NotChangeString	; �᫨ �� 0, � ���室�� �� @@NotChangeString
	add	di, TextStringSize	; �᫨ ����, � � di �ਡ���塞 TextStringSize (����� ��ப�)
	cmp	di, LastString		; �᫨ di ����� LastString (����� �ᥣ� ᮮ�饭��)
	jl	@@NotLastString		; �� ���室�� �� @@NotLastString
	xor	di, di			; � ��⨢��� ��砥 ᭮�� �뢮��� ����� ��ப� ᮮ�饭��
@@NotLastString:
   	mov	bl, TextShowDelay	; � bl ����ᨬ ����প� �뢮�� ⥪��
@@NotChangeString:
 	push	bx			; ���࠭塞 �ᯮ��㥬� ॣ�����
 	push	di

 	push	DataSegment
  	pop 	ds

  	mov 	es, BufferFirst		; ����ࠨ���� es �� BufferFirst

  	cmp 	Exit, 0			; �ࠢ������ � ��� Exit (䫠� ��室� �� �ணࠬ��)
	jnz 	@@Pass			; �᫨ �� 0, � ���室�� �� @@Pass

   	mov 	si, offset string	; ����頥� � si ᬥ饭�� ᮮ�饭�� string
   	add	si, di			; � si ����頥� ᬥ饭�� ⥪�饩 ��ப� ��� �뢮��
   	mov	cx, TextX		; ����頥� � cx ���न���� X ⥪��
   	mov	dx, TextY		; ����頥� � cx ���न���� Y ⥪��
   	mov	ah, TextColor		; ����頥� � ah 梥� �뢮����� �� �࠭ ��ப�
   	mov	bl, TextScale		; ����頥� � bl 誠�� ⥪��
   	call	BufferWriteString	; ��襬 � ����� ��ப� � ������묨 ��ਡ�⠬�

; ������㥬 ��砩��� �᫮ � ax � �।���� [0..BufferSize-MaxX*2]
	mov	cx, BufferSize-MaxX*2   ; � cx BufferSize-MaxX*2
   	mov	ax, Seed	        ; � ax �।��饥 ��砩��� �᫮
   	add	ax, 1234                ; ������塞 � ax �᫮ 1234
	xor	al, ah                  ; �믮��塞 ��ࠧ�來�� �㬬�஢���� �� ����� 2 ��� ����訬 � ���訬 ���⠬� ॣ���� ᫮�� � ॣ���� ax
	add	ax, 4321                ; ������塞 � ax �᫮ 4321
   	xor	al, ah                  ; �믮��塞 ��ࠧ�來�� �㬬�஢���� �� ����� 2 ��� ����訬 � ���訬 ���⠬� ॣ���� ᫮�� � ॣ���� ax
   	mov	Seed, ax                ; ���������� ����祭��� ��砩��� �᫮ � Seed
   	xor	edx, edx                ; ���⨬ edx
   	div	cx			; ����� ��砩��� �᫮ � dx:ax �� cx
   	mov	byte ptr es:[edx+MaxX], 255; ����뫠�� 255 � ���� �� ����� [edx+MaxX], ��� edx ᮤ�ন� ���⮪ �� �������
@@Pass:
   	push	es			; ����ன�� ds �� BufferFirst
   	pop	ds
	
	push    DataSegment
	pop	gs

	mov	es, gs:BufferSecond	; ����ன�� es �� BufferSecond

; �ਬ��塞 � ����ࠬ ᫥���騩 ������ ("��㣨 �� ����")
;                   
;
; 	BufferFirst (���⮪):      BufferSecond (���⮪):
; 	�������������������Ŀ       �������������������Ŀ
;	�   �   �   �   �   �       �   �   �   �   �   �
;	�������������������Ĵ       �������������������Ĵ
;	�   �   � a �   �   �       �   �   �   �   �   �
;	�������������������Ĵ       �������������������Ĵ
;	�   � b � i � d �   �       �   �   � j �   �   �
;	�������������������Ĵ       �������������������Ĵ
;	�   �   � c �   �   �       �   �   �   �   �   �
;	�������������������Ĵ       �������������������Ĵ
;	�   �   �   �   �   �       �   �   �   �   �   �
; 	���������������������       ���������������������
;
; 	����� i - ��ࠡ��뢠��� ���ᥫ ([i] - 梥�) � BufferFirst
;	      j - ᮮ⢥�����騩 ��� ���ᥫ ([j] - 梥�) �� BufferSecond
;	      a, b, c, d - ���ᥫ�, �ᥤ��� � i (�. ��㭮�)
;	      [a], [b], [c], [d] - �� 梥�
;
;       1) W = ([a] + [b] + [c] + [d]) div 2 - [j]
;	2) �᫨ W < [j], � [j]:=0
;	 	         ���� [j]:= LowByte (W)
;
;	i,j=MaxX..SizeBuffer-MaxX
;	
;	�뢮��� ᮤ�ন��� ��ࢮ�� ���� � ���塞 ����� ஫ﬨ.
;	�த��뢠�� � ���ࠬ� ���, ��� ���ᠭ� ���.
;

	mov	si, MaxX		; �ய�᪠�� ����� ��ப� ����, �⮡� �� �뫥�� �� �࠭��� ����
@@Water:                                
	xor	ah, ah		        ; ���⨬ ah
   	mov	al, [si+1]	        ; � al 梥��ᥤ���� �ࠢ� ���ᥫ�
   	mov	bx, ax                  ; ����頥� ��� � bx
   	mov	al, [si-1]              ; � al 梥��ᥤ���� ᫥�� ���ᥫ�
   	add	bx, ax                  ; �ਡ���塞 ��� � bx
   	mov 	al, [si+MaxX]           ; � al 梥��ᥤ���� ᭨�� ���ᥫ�
   	add 	bx, ax                  ; �ਡ���塞 ��� � bx
   	mov 	al, [si-MaxX]           ; � al 梥��ᥤ���� ᢥ��� ���ᥫ�
 	add 	ax, bx                  ; �ਡ���塞 � ���� ����������� �㬬�
   	shr 	ax, 1                   ; ����� ax �� 2
   	mov 	bl, byte ptr es:[si]    ; � bl 梥� 業�ࠫ쭮�� ���� �� ��ண� ����
   	xor 	bh, bh                  ; ���⨬ ������ �������� bx
   	sub 	ax, bx                  ; �� ����������� �㬬� �⭨���� 梥� 業�ࠫ쭮�� ����
   	jns 	@@Move                  ; �᫨ ax < bx
    	xor 	ax, ax                  ; ���⨬ ax
@@Move:                                 
	mov	byte ptr es:[si], al	; � ���� �� ����� es:si ����頥� ᮤ�ন��� al
	inc 	si			; �����稢��� si  �� 1
	cmp 	si, 64000-MaxX		; �᫨ �� ���⨣��� ���祭�� 64000-MaxX
	jnz 	@@Water			; �� ���室�� �� @@Water
	mov 	es, gs:BufferVideo	; � es ���� BufferVideo
	call 	BufferMove              ; ��६�頥� BufferFirst � VideoBuffer

	push 	DataSegment			; ����ࠨ���� ds �� ᥣ���� ����
	pop 	ds

	cmp 	Exit, 0			; �ࠢ������ exit � ���
	jnz 	@@PassWrite		; �᫨ �� 0, � ��� �� @@PassWrite

	pop 	di			; ����⠭�������� di
	mov 	si, offset string	; � si ����뫠�� ᬥ饭�� String
	add 	si, di			; � si ᬥ饭�� ⥪�饩 ��ப� ��� �뢮��
	mov 	cx, TextX		; � cx X ���न���� ⥪��
	mov 	dx, TextY		; � cx Y ���न���� ⥪��
	xor 	ah, ah			; � ah 梥� ��ப�
	mov 	bl, TextScale		; � bl 誠�� ⥪��
	call 	BufferWriteString	; ��襬 ��ப� � ������묨 ��ਡ�⠬� � �����

	push 	di			; ���࠭塞 ᮤ�ন��� di
@@PassWrite:
	push 	es			; ����ࠨ���� ds �� BufferVideo
	pop 	ds

; �ਬ��塞 � ����ࠬ ᫥���騩 ������ ("��䥪� ࠧ����")
;                   
;
; 	BufferFirst (���⮪):      
; 	�������������������Ŀ       
;	�   �   �   �   �   �       
;	�������������������Ĵ       
;	�   �   � a �   �   �       
;	�������������������Ĵ       
;	�   � b � i � d �   �       
;	�������������������Ĵ       
;	�   �   � c �   �   �       
;	�������������������Ĵ       
;	�   �   �   �   �   �       
; 	���������������������       
;
; 	����� i - ��ࠡ��뢠��� ���ᥫ ([i] - 梥�) � BufferFirst
;	      a, b, c, d - ���ᥫ�, �ᥤ��� � i (�. ��㭮�)
;	      [a], [b], [c], [d] - �� 梥�
;
;       1) W = (([a] + [b] + [c] + [d]) div 4 + [i]) div 2
;	2) [i]:= LowByte (W)
;
;	i=MaxX..SizeBuffer-MaxX
;	
;	�뢮��� ᮤ�ন��� ��ࢮ�� ���� � ���塞 ����� ஫ﬨ.
;	�த��뢠�� � ���ࠬ� ���, ��� ���ᠭ� ���.
;
	mov	cl, BlurCount		; � cl ������⢮ �ਬ������ ��䥪� ࠧ����
@@Blur:    
	mov	di, MaxX		; �ய�᪠�� ����� ��ப� ����, �⮡� �� �뫥�� �� �।��� ����
	xor 	ah, ah			; ���⨬ ah
@@B:
	mov 	al, [di+MaxX]		; � al 梥� �ᥤ���� ᭨�� ���ᥫ�
	mov 	bx, ax                  ; ����頥� ��� � bx
	mov 	al, [di-MaxX]		; � al 梥� �ᥤ���� ᢥ��� ���ᥫ�
	add 	bx, ax                  ; �ਡ���塞 ��� � bx
	mov 	al, [di+1]		; � al 梥� �ᥤ���� �ࠢ� ���ᥫ�
	add 	bx, ax                  ; �ਡ���塞 ��� � bx
	mov 	al, [di-1]		; � al 梥� �ᥤ���� ᫥�� ���ᥫ�
	add 	bx, ax                  ; �ਡ���塞 ��� � bx
	shr 	bx, 2			; ����� ᮤ�ন��� bx �� 4
	mov 	al, [di]		; ����뫠�� � al 梥� 業�ࠫ쭮�� ���ᥫ�
	add 	bx, ax			; � bx ������塞 ax
	shr 	bx, 1			; ����� ᮤ�ন��� bx �� 2
	mov 	[di], bl		; ����뫠�� � [di], ᮤ�ন��� ॣ���� bl
	inc 	di			; �����稢��� ᮤ�ন��� ॣ���� di �� 2
	cmp 	di, BufferSize-MaxX	; �ࠢ������ di � BufferSize-MaxX
	jnz 	@@B			; �᫨ �� ࠢ��, � ��� �� @@B
	loop 	@@Blur			; �����塞 横�

	mov	ds, gs:BufferVideo	; ����ࠨ���� ds �� BufferVideo
	push 	VideoMemory		; ����ࠨ���� es �� VideoMemory
	pop 	es
	call 	BufferMove		; ��६�頥� BufferVideo � VideoMemory

	push 	DataSegment		; ����ன�� ds �� ᥣ���� ����
	pop 	ds

	mov 	ax, BufferFirst		; ���塞 ஫ﬨ ������ BufferFirst � BufferSecond
	mov 	bx, BufferSecond
	mov 	BufferFirst, bx
	mov 	BufferSecond, ax

	pop 	di			; ����⠭�������� ᮤ�ন��� ॣ���஢ di � bx
	pop 	bx

	cmp 	Exit, 0ffh		; �ࠢ������ 䫠� ��室� � ���祭��� 0ffh (TRUE)
	jnz 	@@NotExit		; �᫨ �� ࠢ��, � ��� �� @@NotExit

	dec 	ExitDelay		; �����蠥� ExitDelay (����প� �� ��室�) �� 1
	jnz 	@@Repeat		; �᫨ १���� �� 0, � ��� �� @@Repeat

	jmp 	@@RealExit		; ���� ��室�� �� �ணࠬ��
@@NotExit:
	in 	al, 60h			; ��������� � al ��᫥���� SCAN-��� ����������
	dec 	al
	jnz	@@Repeat		; �᫨ � al �� 1, � ����� �� ������ Esc, ��� �� @@Repeat
	mov 	Exit, 0ffh		; ������ �뫠 �����, ��⠭�������� �ਧ��� ��室� �� �ணࠬ��
	jmp 	@@Repeat		; ��� �� @@Repeat
@@RealExit:

	mov 	ax, 0003h		; ���室 � ⥪�⮢� ०�� (80x25)
	int 	10h			; ������ࢨ� BIOS

	pop	gs
	pop	es
	pop	ds
	popa

	ret

ShowAbout ENDP


ScreenSetRGBPalette PROC NEAR
;����������������������������������������������������������������������
; ��楤��: ��⠭���� 梥� � ������
;            �室:  bl - ����� 梥�
;                   bh - RED ��⠢�����
;		    cl - GREEN ��⠢�����
;                   ch - BLUE ��⠢�����
;	     ��室: ���
;����������������������������������������������������������������������

	push	ax			; ���࠭塞 �ᯮ��㥬� ॣ�����
	push    bx
	push	dx
	push	cx

	mov 	dx, 3c8h		; � ���� 3c8h ���뫠�� ����� 梥�
	mov 	al, bl
	out 	dx, al

	mov 	dx, 3c9h		; � ���� 3c9h ���뫠�� ��᫥����⥫쭮 

	mov 	al, bh			; RED - ��⠢���騥 梥�
	out 	dx, al

	mov 	al, cl			; GREEN - ��⠢���騥 梥�
	out 	dx, al

	mov 	al, ch			; BLUE - ��⠢���騥 梥�
	out 	dx, al

	pop	cx			; ����⠭�������� ������� ॣ�����
	pop     dx
	pop     bx
	pop	ax

	ret				; �����頥��� � ��� �맮��

ScreenSetRGBPalette ENDP


BufferMove PROC NEAR
;����������������������������������������������������������������������
; ��楤��: ��६�饭�� ���஢
;            �室:  ds    - ���� ���� ���筨��
;                   es    - ���� ���� ��񬭨��
;	     ��室: ���
;����������������������������������������������������������������������

	push	cx			; ���࠭塞 �ᯮ��㥬� ॣ�����
	push	si
	push	di
	
	xor 	si, si			; ���⨬ ������� ���஢
	xor	di, di

	mov	cx, 7d00h		; ����뫠�� 32000 ᫮� �� ���� �� ����� ds:si � ���� �� ����� es:di
	rep movsw

	pop	di			; ����⠭�������� ᮤ�ন��� ॣ���஢ �� �맮��
	pop	si
	pop	cx

	ret				; �����頥��� � ��� �맮��

BufferMove ENDP


BufferWriteString PROC NEAR
;����������������������������������������������������������������������
; ��楤��: ������ ��ப� � ����
;            �室:  es    - ���� ����
;		    ds:si - ���� ��ப�
;		    ah	  - 梥�
;		    bl    - 誠�� ⥪��
;                   cx    - X ���न��� ��ப�
;		    dx    - Y ���न��� ��ப�
;	     ��室: ���
;����������������������������������������������������������������������

	pusha				; ���࠭塞 �ᯮ��㥬� ॣ�����

@@Write:
	lodsb				; ��㧨� ���� (ᨬ���) � al �� 楯�窨 (��ப�) �� ����� � ds:si
	test	al, al			; �᫨ ��।��� ���� "���" (�ਧ��� ���� ��ப�)
	jz	@@Exit			; �� ��室��

	push	bx			; ���࠭塞 ���, �� �㤥� ��������
	pusha
	push	ds

	lds	si, FontAddr		; � ds:si ���� FontAdr

	push	ax			; ���࠭窱 ax 

	xor	ah, ah			; ���⨬ ah
	shl	ax, 3			; �������� ax (��� �뢮������ ᨬ����) �� 8 (�. �. ����� ᨬ���� 8x8) � �ਡ���塞 � si
	add	si, ax			; ������ � si ᬥ饭�� ������ �뢮������ ᨬ���� �⭮�⥫쭮 ��砫� ⠡���� ᨬ�����

	xor 	di, di			; ���⨬ di
	mov	ax, MaxX		; � ax ����頥� ������⢮ ���ᥫ�� � ��ப� �࠭�
	mul	dx			; �������� ���न���� Y �� ������⢮ ���ᥫ�� � ��ப� �࠭�
	mov	di, ax			; � di ����頥� १���� 㬭������
	add 	di, cx			; ������塞 � di ᮤ�ন��� cx (�. �. X ���न����)
					; ������ � di ᬥ饭�� � ����, ᮮ⢥�����饥 ���न��⠬ (X, Y) �뢮������ ⥪��

	pop 	ax			; ����⠭�������� ax

	mov 	dl, bl			; � dl 誠�� ⥪��
	mov 	bh, BiosFontSize	; � bh ࠧ��� ����
	xor 	dh, dh			; ���⨬ dh
@@DrawChar:
	lodsb				; ��㧨� �� 楯�窨 ������ ᨬ���� ��।��� ��⮢�� ��ப�
	mov 	bl, BiosFontSize	; � bl ࠧ��� ����
@@DrawLine:         
	shl 	al, 1			; ����頥� � cf ��।��� ��� �� ��⮢�� ��ப�
	inc 	ah			; �����稢��� ah �� 1 (� ah ᥩ�� 梥�)
	jnc 	@@Next			; �᫨ cf<>1, � ��� �� @@Next

	push 	ax			; ���࠭塞 ax � di (��� ���� ��������)
	push 	di

	xchg 	ah, al			; ����頥� � al ᮤ�ন��� ah (梥�), � ��⥬ � ah ᮤ�ন��� dl (誠�� ⥪��)
        mov 	ah, dl
@@Draw:
        mov	cl, dl			; � cx 誠�� ⥪��
        xor	ch, ch

        rep stosb			; ����樠�����㥬 ����, � �筥� ���� cx (誠�� ⥪��) ���� �� ����� es:di 梥⮬ �� al

        add 	di, MaxX		; � di �ਡ���塞 MaxX. 
        sub 	di, dx			; �⭨���� �� di 誠�� ⥪�� � dx
					; � ᫥���饩 ��ப� ����⠡�஢������ ���ᥫ�

        dec 	ah			; �����蠥� ������⢮ ��������� �뢮�� ��ப ����⠡�஢������ ���ᥫ� �� 1
        jnz 	@@Draw			; �᫨ �� 0 � ����� �� @@Draw

        pop 	di			; ����⠭�������� di � ax 
        pop 	ax

@@Next:
        add 	di, dx			; � dx ᥩ�� 誠�� ⥪��. ��-� �� � ������� � di
        dec 	bl			; � bl ᥩ�� ࠧ��� ����. �����蠥� ��� �� 1.
        jnz 	@@DrawLine		; �᫨ �� 0, � �த������ �뢮���� ��⠫�� ����⠡�஢���� ���ᥫ�

	push	ax                      ; ���࠭塞 ax
        push 	dx			; ���࠭塞 dx (�㤥� ������) � �� ᥩ�� 誠�� ⥪��
	mov	ax, MaxX-BiosFontSize	; � ax MaxX-BiosFontSize
	mul	dx                      ; �������� �� 誠�� ⥪��
	add	di, ax                  ; � di - ᬥ饭�� ᫥���饣� ᨬ���� � ���� 
       	pop 	dx			; ����⠭�������� dx
        pop 	ax			; ����⠭�������� ax

        dec 	bh			; �����蠥� ������⢮ �� �뢥������ ����� ᨬ���� �� 1
        jnz 	@@DrawChar		; �᫨ �� 0 ��� �� @@DrawChar. ��ᮢ��� ᫥������ ����� ᨬ����

        pop 	ds			; ����⠭��������, ��� ��� �뫮 �� �맮�� (�� �᪫�祭��� si � al)
        popa
        pop 	bx

	push	ax			; ���࠭塞 ax
	mov	al, BiosFontSize        ; � ax BiosFontSize
	mul	bl                      ; �������� �� 誠�� ⥪�� � bx
	add	cx, ax                  ; ������� �ਡ���塞 � cx, �. �. � cx - X ���न��� ᫥���饣� �뢮������ ᨬ����
	pop	ax			; ����⠭�������� ax

      	jmp 	@@Write			; ��� �� @@Write
@@Exit:
        popa				; ����⠭�������� ᮤ�ন��� ॣ���஢ �� �맮��
        ret				; �����頥��� � ��� �맮��

BufferWriteString ENDP

	ProgSizeInPar equ (PspSize + StackSize + DataSize + ($-Main) ) shr 4 + 4

CodeSegment ENDS

end Main
