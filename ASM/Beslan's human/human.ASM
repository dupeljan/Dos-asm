comment *
��ࠣ���� ��᫠� 2 ���� 22 ��㯯� 2018 ���
�ணࠬ��:
������� �����⢫�� �������� �����,��ࠢ� � ��릮�, ��������� ����� ��� � ���뢠�� �����.
��������� ����, �� 梥� � 梥� ���� 祫����� �������� ��ࠬ� � ���� "��ࠬ����" ��� ����⨥� Enter(���祭�� ��㬮�砭��).
����� ��࠭����� � 䠩�. �� ������ 祫����� � ����, �� ��������� � 梥� ��������, ��室� �� ��᫥���� ������(���� �� ����୮� ����᪥ �ணࠬ��).
���ଠ�� �� �ࢫ���� �� ��室���� � �㭪� ���� "������".
*
TITLE "��� �������਩ �ணࠬ��"

INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT public

max DB  12
len DB ?
pole db 12 dup ('$')   				; ��� ('$'),�᫨ �� ��ଠ�쭮� �뢮�� ��ப� � ��� , ��� (?),��, �᫨ �� �⮬ �뢥�� ��ப� ��������� ���� � ���, �뢥����� ������⭮ ��
		                               	; ��ਭ樯� � 䠩� �� ࠢ�� �������� �, �� �㦭� ���. �� �� ��直� ��砩, ���� ���⠢��� ($)
read1 db 12 dup('$')

r 	 dw ?                       		; ࠤ��� ���ᮢ뢠���� ���㦭���
x1 	 dw ?                     		; ���न���� ������, ����� ���ண� ��� ���(�� �1)
x2 	 dw ?
y1 	 dw ?
y2 	 dw ?
kv1 	 dw ?                     		; �� ���祭�� �����⮢ ࠤ��� ��㣠 � ��� ���न���
kv2 	 dw ?
kvr 	 dw ?
vosst1   dw ?                  			; ���祭�� ����⠭�������,�.� ���祭��, �� ���஥ ���� ������� ��� , �⮡� ��� 業�� �� � (0,0) � �뫠 �� �ਬ����� ��㫠 x^2 + y^2 = r^2
vosst2   dw ?                			; vosst1 - ���祭�� ����⠭������� �� x , vosst2 - ���祭�� ����⠭������� �� y
nachaly1 dw ?                			; �� � ��砫쭮� ���祭�� �1 � ����� ���� � ��楤���. ��� �㦭� ,�� �� ����⠭����� �� ���祭��, � � � ��楤�� ��� ���﫮��.
xr1 	 dw ?
xr2 	 dw ?
yr1 	 dw ?
yr2 	 dw ?
color 	 db ?
kolL 	 dw 0
kolR 	 dw 0
colorhead db 66
colordoor db 68
Doorx1 dw	240
Doorx2 dw	255 
Doory1 dw	30 
Doory2 dw	200
two	dw 	2 
positions dw ?
buffer dw 0

chis dw 0
ten db 10

message  db '   1. ���',13,10
	 db '   2. ����ன��',13,10
	 db '   3. ������',13,10
	 db '   4. ��室$'

message1 db '��६�襭��: d-��ࠢ�,a-�����',13,10,10
	 db 'Shift+d-���뢠���� ����� � �� 祫�����(�� 㤨����)',13,10,10
	 db 'Shift+a-����� ����뢠����',13,10,10
	 db 'Shift+w-����������� ����� �㪠',13,10,10
	 db 'Space-��릮� ',13,10,10
	 db 'Shift+s-���᪠���� ����� �㪠',13,10,10
	 db '�� �ਡ������� � ���� � �����⨨ �㪨  ��⮬���᪨ ���뢠���� �����$'

message2 db '������ 梥� ����:$'
message3 db '������ 梥� ����:$'
message4 db '������ ��������� ����(� ���浪�:x1,x2,y1,y2):$'


error db 'ERROR!!!$'

names    db 'human.txt',0

DATA ENDS


CODE SEGMENT public            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
macrorect macro xrh1,xrh2,yrh1,yrh2,colorh
	local	Normal1,Normal2

	mov	bl,	colorh
	mov	color,	bl

	mov	bl,	color           ; ᬮ�ਬ, �� ��㥬 ����
	mov	bh,	0
	cmp	bx,	66              ; �᫨ ��, � ���塞 �� 梥� � ᮮ⢥��⢨� � ��⠭������� ���祭���
	jne	Normal1
	mov	bl,	colorhead
	mov	color,	bl
	jmp	Normal2	

Normal1:                                ; �᫨ ���, � ᬮ�ਬ, �� ��㥬 ����
	cmp	bx,	68
	jne	Normal2
	mov	bl,	colordoor       ; �᫨ ��, � ���塞 �� 梥� � ᮮ⢥��⢨� � ��⠭������� ���祭���	
	mov	color,	bl
Normal2:                                ; � १���� ���������� ���祭�� 梥� color
	mov	si,	xrh1
	mov	xr1,	si
	mov	si,	xrh2
	mov	xr2,	si            ; ⥯��� ��⠭�������� ���न���� ��אַ㣮�쭨��
	mov	si,	yrh1
	mov	yr1,	si
	mov	si,	yrh2
	mov	yr2,	si
	call	rectangle               ; ��뢠�� ��楤��� �ᮢ���� ��אַ㣮�쭨��
endm
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
macrocircle macro rc1,xc1,xc2,yc1,yc2,vosst1c,vosst2c,colorc
	local	Norm1

	mov	bl,	colorc
	mov	color,	bl

	mov	bl,	color         ; ᬮ�ਬ, �� ��㥬 ����
	mov	bh,	0
	cmp	bx,	66            ; �᫨ ��, � ���塞 �� 梥� � ᮮ⢥��⢨� � ��⠭������� ���祭���
	jne	Norm1
	mov	bl,	colorhead
	mov	color,	bl
                                      ; � १���� ���������� ���祭�� 梥� color
Norm1:	
	mov	si,	rc1
	mov	r,	si           ; ��⠭�������� ࠤ��� ��㣠
	mov	si,	xc1
	mov	x1,	si           ; ��⠭�������� ���न���� ��אַ㣮�쭨��, � ����� �㤥� ���ᠭ ���
	mov	si,	xc2
	mov	x2,	si
	mov	si,	yc1
	mov	y1,	si
	mov	si,	yc2
	mov	y2,	si
	mov	si,	vosst1c
	mov	vosst1,	si       ; ��⠭�������� ���祭�� ����⢠�������� ���न��� ��� �ᯮ�짮����� ���� ��㣠
	mov	si,	vosst2c
	mov	vosst2,	si
	call	circle	             	

endm
;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
Obrabotka1 macro
	push	ax
	push	ax

	mov	bx,	ax
	mov	ah,	42h
	mov	cx,	0
	mov	dx,	positions
	mov	al,	0
	int	21h

	pop	ax

	mov	bx,	ax              ; � bx ���ਯ�� 䠩��
	mov	ah,	3fh             ; ०�� �⥭�� �� 䠩��
	Lea	dx,	read1           ; ���� ���� ������, �㤠 ��ᨬ���쭮 ���� �����뢠���� ���⠭�� �����
	mov	cl,	4	        ; ������⢮ ����, ���஥ �㦭� ������
	mov	ch,	0
	int	21h                     ; १���� � ax - ॠ�쭮 ���⠭��� ������⢮ ���⮢
	call	strtoint
endm
;------------------------------------------------------------------------------------------------------------------------------------------------------------
        mov  ax,0013h			;���室�� � ��. ०�� 320*200
        int  10h
	
	mov	ah,	0BH     	; ����ਬ, �� ᥩ�� �㤥� ��⠭�������� 梥�
	mov	bx,	00      	; ����� ����� ��࠭��� (������ , 梥� � �) �� 㬮�砭�� 00
	int	10h
;------------------------------------------------------------------------------------------------------------------------------------------------------------
;###################################################################################################################
Menu:	
	macrorect 0,320,0,200,0         ; ��頥� ��࠭
	
	mov	ah,	02              ; ��⭠������� ������ �����(���᪠�� ��)
	mov	bh,	00
	mov	dh,	10
	mov	dl,	0
	int	10h
	
	mov	ah,	9               ; �뢮��� �㭪�� ����
	LEA	dx,	message
	int	21h 
	jmp	Menu2
;-------------------------
Menu1:	jmp	Menu
;-------------------------	
Menu2:	mov	ah,	02              ; ����⠭�������� ������ ����� 
	mov	bh,	00
	mov	dh,	0
	mov	dl,	0
	int	10h		

	mov	ah,	1               ; ���� ������ ᨬ���� ������ �� �㭪⮢ ����
	int	21h

	macrorect 0,320,0,200,0         ; ��頥� ��࠭
	
	cmp	al,	31h             ; �᫨ �� ������ "1", � ����᪠�� ��襣� 祫���窠
	jne	No1
	jmp	Main
No1:	cmp	al,	32h             ; �᫨ "2", � � ������� 䠩��� ����ࠨ���� 梥�(���� ������ � ����.��� �ਬ�� ���� ⠪)
	je	file01
	cmp	al,	33h             ; �᫨ "3", � �뢮��� ���ଠ�� �� �ࠢ�����
	jne	No2
	jmp	help
No2:	cmp	al,	34h             ; �᫨ "4", � ��室�� �� �ணࠬ��
	jne	Menu1
	jmp	Ex2	
;###############################################################################################################	
;------------------------------------------------------------------------------------------------------------------------------------------------------------
mainhuman macro hrad,hx1,hx2,hy1,hy2,hvosst1,hvosst2,hcolor
	
	macrocircle hrad,hx1,hx2,hy1,hy2,hvosst1,hvosst2,hcolor         		 ; ������         		(17,110,144,50,84,127,67,66)
	                                                 
	macrorect hx1-5,hx2+7,hy1+3,hy2-26,24                      		 ; ��� ���            	(105,151,53,58,24)

	macrorect hx1+2,hx2,hy1-17,hy2-31,24                      		 ; ���� ���           	(112,144,33,53,24)

	macrorect hx1-6,hx2+6,hy1+34,hy2+56,33                     	         ; ⥫�                 	(104,150,84,140,33)

	macrocircle hrad-13,hx1+7,hx2-19,hy1+8,hy2-18,hvosst1-6,hvosst2-5,15	         ; �ࠢ� ����          	(4,117,125,58,66,121,62,15)

	macrocircle hrad-13,hx1+22,hx2-4,hy1+8,hy2-18,hvosst1+9,hvosst2-5,15	         ; ���� ����           	(4,132,140,58,66,136,62,15)

	macrorect hx1+11,hx2-20,hy1+11,hy2-20,0                      	  	 ; �ࠢ� ��箪        	(121,124,61,64,0)
	                                                                           
	macrorect hx1+26,hx2-5,hy1+11,hy2-20,0                      		 ; ���� ��箪         	(136,139,61,64,0)
	                                                                                     
	macrorect hx1+18,hx2-12,hy1+25,hy2-8,0                    		 ; ��                  	(128,132,75,76,0)

	macrorect hx1-1,hx2-19,hy1+90,hy2+106,24                  		 ; �ࠢ�� ������ ����   	(109,125,140,190,24)

	macrorect hx1+19,hx2+1,hy1+90,hy2+106,24                  		 ; ����� ������ ����    	(129,145,140,190,24)

	macrorect hx1+21,hx2-2,hy1+140,hy2+116,hcolor	                  		 ; ᠬ� ����� ���� �� ������    (131,142,190,200,66)

	macrorect hx1+21,hx2+4,hy1+144,hy2+116,1                   		 ; ����� ����                  (131,148,194,200,1)
	                                                                                   
	macrorect hx1+1,hx2-22,hy1+140,hy2+116,hcolor	                  		 ; ᠬ� �ࠢ�� ���� �� ������   (111,122,190,200,66)

	macrorect hx1+1,hx2-16,hy1+144,hy2+116,1                   		 ; �ࠢ�� ����                 (111,128,194,200,1)

	macrorect hx1-6,hx2-31,hy1+34,hy2+61,26                   		 ; ������ �ࠢ�� �㪨           (104,113,84,145,26)
	
	macrorect hx1-5,hx2-33,hy1+95,hy2+66,hcolor	                		 ; ᠬ� �ࠢ�� �㪠 �� ������   (105,111,145,150,66)
	                         
	macrorect hx1+36,hx2+10,hy1+34,hy2+61,26                  		 ; ������ ����� �㪨            (146,154,84,145,26)

	macrorect hx1+37,hx2+9,hy1+95,hy2+66,hcolor	               			 ; ᠬ� ����� �㪠 �� ������    (147,153,145,150,66)

endm
;-------------------------------------
;###############################################################################################################
file01:	
	mov	ah,	9
	mov	dx,	offset	message2
	int	21h
	
	mov	buffer,	0
	mov	positions,	0
	call	input                         ; ����� ��楤�� ����� ��ࠬ��஢(᫮��), ����� � ��������� � ⥪�⮢� 䠩�
	mov	buffer,	1
	cmp	pole[0],	0Dh           ; �᫨ ����� "Enter",� ��⠢�塞 ���祭�� �� 㬮�砭��
	je	Setting1                      ; �஢����, �� � 䠩� ����ᠭ� ����� ������� ����, ����� ���� 䠩� "FileParameters.txt", ��� �� �ணࠬ���
	cmp	chis,	0
	je	Setting1

	mov	ax,	chis
	mov	ah,	0
	mov	colorhead,	al
	jmp	Setting3                                   

Setting1:
	mov	pole[1],	36h
	mov	pole[2],	36h
	call	input
;###################################################################################
Setting3:	
	macrorect 0,320,0,200,0
	
	mov	ah,	9
	mov	dx,	offset	message3
	int	21h
	
	add	positions,	4		
	call	input                         ; ����� ��楤�� ����� ��ࠬ��஢(᫮��), ����� � ��������� � ⥪�⮢� 䠩�

	cmp	pole[0],	0Dh           ; �᫨ ����� "Enter",� ��⠢�塞 ���祭�� �� 㬮�砭��
	je	Setting2                      ; �஢����, �� � 䠩� ����ᠭ� ����� ������� ����, ����� ���� 䠩� "FileParameters.txt", ��� �� �ணࠬ���	
	cmp	chis,	0
	je	Setting2

	mov	ax,	chis
	mov	ah,	0
	mov	colordoor,	al
	jmp	Setting4
		
Setting2:
	mov	pole[1],	36h
	mov	pole[2],	38h
	call	input
Setting4:
	macrorect 0,320,0,200,0

	mov	ah,	9
	mov	dx,	offset	message4
	int	21h

IRP p, <Doorx1,Doorx2,Doory1,Doory2>
	local	SetNo5,SetNoo5	

	add	positions,	4
	call	input
	cmp	pole[0],	0Dh
	jne	SetNo5
	jmp	Setting5
SetNo5:
	cmp	chis,	0

	jne	SetNoo5
	jmp	Setting5
SetNoo5:
		
	mov	ax,	chis
	mov	p,	ax

	mov	dl,	13
	mov	ah,	2
	int	21h
endm
	jmp	Setting6

Setting5:
	mov	pole[1],	32h
	mov	pole[2],	34h
	mov	pole[3],	30h
	call	input
	add	positions,	4

	mov	pole[1],	32h
	mov	pole[2],	35h
	mov	pole[3],	35h
	call	input
	add	positions,	4

	mov	pole[1],	33h
	mov	pole[2],	30h
	mov	pole[3],	10h
	call	input
	add	positions,	4

	mov	pole[1],	32h
	mov	pole[2],	30h
	mov	pole[3],	30h
	call	input
	add	positions,	4
Setting6:	
	jmp	Menu
;###################################################################################
;-------------------------------------	
help:	                                     
	LEA	dx,	message1             ; �뢮��� ᮮ�饭�� �� �ࠢ�����
	mov	ah,	9
	int	21h
;-------------------------------------	
Yet:	mov	ah,	1
	int	21h                          ; ��室 �� �⮣� �㭪� ⮫쪮 ������ Escape
	cmp	al,	1bh
	jne	Yet
	jmp	Menu
;-------------------------------------
;########################################################################################################################
Main:
	mov	positions,	0
	mov	len,	4
	
	cmp	buffer,	1
	je	F1
	
F2F: 	mov	ah,	3Dh             ; ०�� ������ 䠩��
	mov	al,	0               ; ०�� ����� � 䠩�(al=2-�⥭�� � ������;al=1-������;al=0-�⥭��)       
	Lea	dx,	names           ; ���� ����� 䠩��, ���஥ �㦭� ������
	int	21h

	Obrabotka1	

	mov	ax,	chis
	mov	ah,	0
	mov	colorhead,	al
	mov	ah,	0
	jmp	F1F

F1:	cmp	pole[0],	0Dh
	je	F2F


F1F:	mainhuman 17,110,144,50,84,127,67,colorhead	      ; ��㥬 祫�����

	cmp	buffer,1
	jne	F3
	jmp	F2

F3:	
	add	positions,	4
	                                              ; ��������
	pop	ax

	Obrabotka1

	mov	ax,	chis
	mov	ah,	0
	mov	ColorDoor,	al
	jmp	F3F	

F2:	cmp	pole[0],	0Dh
	je	F3	

F3F:	cmp	buffer,	1
	jne	F5
	jmp	F4
F5:
	add	positions,	4
	pop	ax

	Obrabotka1	

	mov	ax,	chis
	mov	Doorx1,	ax

	add	positions,	4
	pop	ax

	Obrabotka1	

	mov	ax,	chis
	mov	Doorx2,	ax

	add	positions,	4
	pop	ax

	Obrabotka1	

	mov	ax,	chis
	mov	Doory1,	ax

	add	positions,	4
	pop	ax

	Obrabotka1	

	mov	ax,	chis
	mov	Doory2,	ax
	jmp	F5F

F4:	cmp	pole[0],	0Dh
	jne	F5F
	jmp	F5
	
F5F:	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor

	mov	ax,	Doory2
	sub	ax,	Doory1
	mov	dx,	0
	div	two
	add	ax,	Doory1
	mov	dx,	ax
	sub	dx,	2

	mov	cx,	5

Door:	
	push	cx
	mov	ah,	0Ch
	mov	al,	6           ; �ᮢ���� �窨
	mov	cx,	Doorx1
	sub	cx,	2
	int	10h
	inc	dx
	pop	cx
	loop	Door

	mov	ax,	Doory2
	sub	ax,	Doory1
	mov	dx,	0
	div	two
	add	ax,	Doory1
	mov	dx,	ax

	mov	ah,	0Ch
	mov	al,	6           ; �ᮢ���� �窨
	mov	cx,	Doorx1
	dec	cx
	int	10h

	cmp	buffer,	1
	je	F6
	mov	ah,	3Eh             ; ०�� ������� 䠩��
	int	21h
F6:	
;--------------------------------------
;########################################################################################################################
;########################################################################################################################
Knopk:	
	mov	ah,	1
	int	21h                                    ; ���� ������ ������


	cmp	al,	1bh  ; ascii code of input character                           ; �᫨ �� Escape , � ��室�� � ����
	jne	Esc1
	jmp	Menu

;########################################################################################################################
;########################################################################################################################
Esc1:	cmp	al,	44h                            ; �᫨ �� Shift+d , � ���뢠�� ����� 
	je	Esc3
	jmp	Er1
Esc3:	
	push	ax
	sub	Doorx1,	2
	add	Doory1,	1
	macrorect Doorx1,Doorx2,Doory1,Doory2,0                     ; ���ᮢ�� �०���� ��������� ����
	add	Doorx1,	2
	mov	ax,	Doorx2
	sub	ax,	Doorx1
	add	Doorx1,	ax
	add	Doorx2,	30	
	macrorect Doorx1,Doorx2,Doory1,Doory2,68                    ; ���ᮢ�� ������ ��������� ����(����� �����)
	mov	di,	ax	
	mov	ax,	Doory2
	sub	ax,	Doory1
	mov	dx,	0
	div	two	
	add	Doory1,	ax
	sub	Doory2,	ax
	add	Doory2,	4
	sub	Doory1,	4
	add	Doorx1,	20
	sub	Doorx2,	2
	mov	cx,	Doorx1
	add	cx,	4
	mov	dx,	Doory1
	add	dx,	4
	macrocircle 4,Doorx1,Doorx2,Doory1,Doory2,cx,dx,6        ; ���ᮢ�� ��窨 ����(����� �� �����)
	sub	Doorx1,	di
	sub	Doorx1,	20
	add	Doorx2,	2
	sub	Doorx2,	30
	sub	Doory1,	ax
	add	Doory1,	3
	add	Doory2,	ax
	sub	Doory2,	4	

	                   

	cmp	kolL,	0                              ; ᬮ�ਬ, �� ���⢨� ᮢ��襭� � 業��, �ࠢ�� ��� ����� 業��
	je	Uno1                                   
	cmp	kolL,	1     
	jne	U2
	jmp	U1
U2:	jmp	Ujump1
;------------------
Uno1:	jmp	U	
;------------------
Ujump1:
	pop	ax	
	mainhuman 17,125,159,50,84,142,67,colorhead	       ; ��㥬 ����� ��������� (�ࠢ�� 業��)
	macrocircle 4,141,142,72,73,145,76,0           ; ���ᮢ뢠��(���뢠��) ��� �� �ࠢ�� 業��

	cmp	al,	57h
	je	U6
	jmp	U5

U6:	macrorect 161,169,84,150,0                     ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(�ࠢ�� 業��)
       	macrorect 161,222,84,92,26                     ; ��㥬 ����� ��������� ������ �㪨
	macrorect 222,227,85,91,66                     ; ��㥬 ����� ��������� ᠬ�� �㪨
		
U5:	jmp	Knopk

U1:	
       	mainhuman 17,95,129,50,84,112,67,colorhead	       ; ��㥬 ����� ��������� (����� 業��)
	macrocircle 4,111,112,72,73,115,76,0           ; ���ᮢ뢠��(���뢠��) ��� �� ����� 業��
	jmp	Knopk

U:	
	mainhuman 17,110,144,50,84,127,67,colorhead	      ; ��㥬 祫�����
	macrocircle 4,126,127,72,73,130,76,0           ; ���ᮢ뢠��(���뢠��) ��� �� � 業��
	jmp	Knopk
;########################################################################################################################
Er1:	cmp	al,	20h                            ; �᫨ ����� Space, � ��룠��
	je	Esc2
	jmp	Er2

Esc2:	
	cmp	kolL,	0                              ; ��।��塞, ��� ��룠��(� 業��, ����� ��� �ࠢ��)
	jne	P2
	jmp	P
P2:	cmp	kolL,	1
	jne	P3
	jmp	P1
P3:	macrorect 117,170,50,200,0                      ; ���ᮢ뢠�� �०��� ���������(��) �ࠢ�� 業��
	mainhuman 17,125,159,40,74,142,57,colorhead	       ; ��㥬 ����� ���������(���� ���) ⠪�� �ࠢ�� 業��

	macrorect 117,170,10,190,0                      ; ���ᮢ뢠�� ����� ���������
	mainhuman 17,125,159,50,84,142,67,colorhead	       ; ��㥬 ��஥ ��������� �ࠢ�� 業��
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor

	jmp	Knopk                                  ; ��릮� ᮢ��襭

P:
	macrorect 100,200,30,200,0                      ; ���ᮢ뢠�� �०��� ���������(��) � 業��
	mainhuman 17,110,144,40,74,127,57,colorhead	       ; ��㥬 ����� ���������(���� ���) ⠪�� � 業��

	macrorect 100,200,20,200,0                      ; ���ᮢ뢠�� ����� ���������
	mainhuman 17,110,144,50,84,127,67,colorhead	       ; ��㥬 ��஥ ��������� � 業��
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	jmp	Knopk                                  ; ��릮� ᮢ��襭

P1:     
	macrorect 75,200,30,200,0                      ; ���ᮢ뢠�� �०��� ���������(��) ����� 業��
	mainhuman 17,95,129,40,74,112,57,colorhead	       ; ��㥬 ����� ���������(���� ���) ⠪�� ����� 業��

	macrorect 75,200,20,200,0                      ; ���ᮢ뢠�� ����� ���������
	mainhuman 17,95,129,50,84,112,67,colorhead	       ; ��㥬 ��஥ ��������� ����� 業��
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	jmp	Knopk	                               ; ��릮� ᮢ��襭
;########################################################################################################################
Er2:    cmp	al,	64h                            ; �᫨ ����� d, � ������ ��६�饭�� ��ࠢ�
	je	Esc4
	jmp	Er3

Esc4:                                                  ; ��।��塞, ������ �� ��६�饭�� � ����� ���
	cmp	kolR,	0
	je	T
	cmp	kolR,	-1
	jne	T2
	jmp	T1
T2:	jmp	Knopk                                  ; �᫨ 祫���� � ⠪ �ࠢ�� 業��, � �� ����� �� �� ������

T:	
	macrorect 90,164,30,200,0	                       ; ���ᮢ뢠�� ��஥ ���������(業��)
	mainhuman 17,125,159,50,84,142,67,colorhead	       ; ��㥬 ����� ��������� (�ࠢ�� 業��)
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	inc	kolR                                   ; KolR(KolL) ������ ��� 祫����: � 業��-��� �� 0 , ����� 業�� = -1(+1) , �ࠢ�� 業�� = +1(-1) 
	dec	kolL                                   ; ����� �� ��।��塞 �� � ᮮ⢥��⢨� � ��६�饭���
	jmp	Knopk                                  ; ��६�饭�� ��ࠢ� ᮢ��襭�

T1:
	macrorect 85,179,30,200,0                        ; ���ᮢ뢠�� ��஥ ���������(����� 業��)
	mainhuman 17,110,144,50,84,127,67,colorhead           ; ��㥬 ����� ��������� (� 業��)
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	inc	kolR                                   ; KolR(KolL) ������ ��� 祫����: � 業��-��� �� 0 , ����� 業�� = -1(+1) , �ࠢ�� 業�� = +1(-1)
	dec	kolL	                               ; ����� �� ��।��塞 �� � ᮮ⢥��⢨� � ��६�饭���
	jmp	Knopk		                       ; ��६�饭�� ��ࠢ� ᮢ��襭�
;########################################################################################################################
Er3:    cmp	al,	61h                            ; �᫨ ����� a, � ������ ��६�饭�� �����
	je	Esc5
	jmp	Er4

Esc5:
	cmp	kolL,	0                              ; ��।��塞, ������ �� ��६�饭�� � ����� ���
	je	B
	cmp	kolL,	-1
	jne	B2
	jmp	B1                                     ; �᫨ 祫���� � ⠪ ����� 業��, � �� ����� �� �� ������
B2:	jmp	Knopk
B:
	macrorect 80,174,30,200,0                        ; ���ᮢ뢠�� ��஥ ���������(業��)
	mainhuman 17,95,129,50,84,112,67,colorhead	       ; ��㥬 ����� ��������� (����� 業��)
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	inc	kolL                                   ; KolR(KolL) ������ ��� 祫����: � 業��-��� �� 0 , ����� 業�� = -1(+1) , �ࠢ�� 業�� = +1(-1)
	dec	kolR                                   ; ����� �� ��।��塞 �� � ᮮ⢥��⢨� � ��६�饭���
	jmp	Knopk                                  ; ��६�饭�� ����� ᮢ��襭�

B1:	
	macrorect 60,170,30,200,0                        ; ���ᮢ뢠�� ��஥ ���������(�ࠢ��)
	mainhuman 17,110,144,50,84,127,67,colorhead	       ; ��㥬 ����� ��������� (� 業��)
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	inc	kolL                                   ; KolR(KolL) ������ ��� 祫����: � 業��-��� �� 0 , ����� 業�� = -1(+1) , �ࠢ�� 業�� = +1(-1)
	dec	kolR                                   ; ����� �� ��।��塞 �� � ᮮ⢥��⢨� � ��६�饭���
	jmp	Knopk	                               ; ��६�饭�� ����� ᮢ��襭�
;########################################################################################################################
Er4:	cmp	al,	57h                            ; �᫨ ����� Shift+w - ��������� ����� ���

	je	N
	jmp	Er5
	                                               ; ��।��塞 � ����� ��� �� ��������� ����� ���
N:	cmp	kolL,	0
	jne	N3
	jmp	N1
N3:	cmp	KolL,	1
	je	N2no1
	macrorect 161,169,84,150,0                     ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(�ࠢ�� 業��)
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
	jmp	N2jump1
;------------------------------------                  ; ����訥 ��릪�
N2no1:	jmp	N2
;------------------------------------
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
N2jump1:
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	macrorect 161,222,84,92,26                     ; ��㥬 ����� ��������� ������ �㪨
	macrorect 222,227,85,91,66                     ; ��㥬 ����� ��������� ᠬ�� �㪨
	jmp	Esc3                                   ; ����� �㪠 ������

N2:	
       	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	macrorect 131,139,84,150,0                     ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(����� 業��)
	macrorect 131,192,84,92,26                     ; ��㥬 ����� ��������� ������ �㪨
	macrorect 192,197,85,91,66                     ; ��㥬 ����� ��������� ᠬ�� �㪨
	jmp	Knopk 	                               ; ����� �㪠 ������

N1:	
       	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	macrorect 146,154,84,150,0                     ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(� 業��)
	macrorect 146,207,84,92,26                     ; ��㥬 ����� ��������� ������ �㪨
	macrorect 207,212,85,91,66                     ; ��㥬 ����� ��������� ᠬ�� �㪨
	jmp	Knopk                                  ; ����� �㪠 ������
;########################################################################################################################
Er5:	cmp	al,	41h                            ; �᫨ ����� Shift+a , � ����� ����뢠����
	je	I
	jmp	Er6

I:
;	macrorect 240,255,40,200,68                    ; ���ᮢ뢠���� ������ �����
;	macrorect 255,310,40,200,0                     ; ������ ������� �����
	macrorect Doorx1,Doorx2,Doory1,Doory2,68

	add	Doory1,	1
	mov	ax,	Doorx2
	sub	ax,	Doorx1
	add	Doorx1,	ax
	add	Doorx2,	30

	macrorect Doorx1,Doorx2,Doory1,Doory2,0

	sub	Doory1,	1
	sub	Doorx1,	ax
	sub	Doorx2,	30

	mov	ax,	Doory2
	sub	ax,	Doory1
	mov	dx,	0
	div	two
	add	ax,	Doory1
	mov	dx,	ax
	sub	dx,	2

	mov	cx,	5

Door1:	
	push	cx
	mov	ah,	0Ch
	mov	al,	6           ; �ᮢ���� �窨
	mov	cx,	Doorx1
	sub	cx,	2
	int	10h
	inc	dx
	pop	cx
	loop	Door1

	mov	ax,	Doory2
	sub	ax,	Doory1
	mov	dx,	0
	div	two
	add	ax,	Doory1
	mov	dx,	ax

	mov	ah,	0Ch
	mov	al,	6           ; �ᮢ���� �窨
	mov	cx,	Doorx1
	dec	cx
	int	10h

	cmp	kolL,	0
	je	I4
	jmp	I1	
	
I4:	mainhuman 17,110,144,50,84,127,67,colorhead	      ; ��㥬 祫�����(� 業��)
	jmp	I3

I1:	cmp	kolL,	-1
	je	I5
	jmp	I2

I5:	mainhuman 17,125,159,50,84,142,67,colorhead	       ; ��㥬 ����� ��������� (�ࠢ�� 業��)
	jmp	I3

I2:	
	mainhuman 17,95,129,50,84,112,67,colorhead	       ; ��㥬 ����� ��������� (����� 業��)
I3:
	jmp	Knopk                                  ; ����� ������
;########################################################################################################################	
Er6:	cmp	al,	53h                            ; �᫨ ����� Shift+s , � ���᪠�� ����� ���
	je	O
	jmp	Knopk

O:	cmp	kolL,	0                              ; ��।��塞 � ����� ��� �� ���᪠�� ����� ���
	jne	O3
	jmp	O1
O3:	cmp	kolL,	-1
	je	O2no1

	macrorect 131,197,84,92,0                      ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(����� 業��)
	jmp	O2jump1
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
;------------------------------------
O2no1:	jmp	O2                   ; ����让 ��릮�
;------------------------------------
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
O2jump1:macrorect 131,139,84,145,26                    ; ��㥬 ����� ��������� ������ �㪨
	macrorect 132,138,145,150,66	               ; ��㥬 ����� ��������� ᠬ�� �㪨
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	jmp	Knopk                                  ; ����� �㪠 ���饭�
	
O2:	macrorect 161,227,84,92,0                      ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(�ࠢ�� 業��)
	macrorect 161,169,84,145,26                    ; ��㥬 ����� ��������� ������ �㪨
	macrorect 162,168,145,150,66	               ; ��㥬 ����� ��������� ᠬ�� �㪨
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	jmp	I                                      ; ����� �㪠 ���饭�

O1:	
	macrorect 146,212,84,92,0                      ; ���ᮢ뢠�� ��஥ ��������� ����� �㪨(� 業��)
	macrorect 146,154,84,145,26                    ; ��㥬 ����� ��������� ������ �㪨
	macrorect 147,153,145,150,66	               ; ��㥬 ����� ��������� ᠬ�� �㪨
	macrorect Doorx1,Doorx2,Doory1,Doory2,ColorDoor
	jmp	Knopk                                  ; ����� �㪠 ���饭�
;########################################################################################################################
Ex1:    
	mov	ah,	1
	int	21h
	
Ex2:	mov  ax,0003h			; ⥪�⮢� ०�� � ��室
        int  10h

        mov  ax,4c00h           	; ��室 �� �ணࠬ��
        int  21h
	
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
circle proc 
push	ax
push	bx
push	cx
push	dx
push	x1                  		; ����᫨ � �⥪ ���祭�� ���न���, �⮡� �� ��室� �� ��楤��� ��� �� ����������
push	y1                  		; � � � ᠬ�� ��楤�� ��� ��������
push	x2
push	y2

	mov	si,	r
	add	si,	si
        
	mov	bx,	y1
	mov	nachaly1,	bx

	mov	cx,	si         	; �஢��塞 ������ ࠧ��஬ 10*10 (���譨� �� x, ����७��� �� y)
M:	
	push	cx                 	; ����ᨬ � �⥪ , �⮡� ᮧ���� ����७��� 横�
	mov	cx,	si        	; ����७��� 横�

M1:	push	cx	             	; ����ᨬ � �⥪, �⮡� ��࠭��� ���稪 横��(� � ����� 横�� cx �������)
	mov	ax,	x1            	; ����⠥� �� ��㫥 X^2 + Y^2 = R^2
	sub	ax,	vosst1         	; �.� � ��� ������ �� � 業�� , � ��६�頥� ��� � 業�� (0;0) � ������� "sub ax, vosst1" � "sub ax, vosst2"
	mul	ax                      ; vosst1, vosst2 - ����稭� , �� ����� �㦭� ������� ��ᬠ�ਢ���� ������ �� x(vosst1)  � �� y(vosst2)
	mov	kv1,	ax             	; kv1 = (X-vosst1)^2

	mov	ax,	y1             	; vosst1 � vosst2 ࠢ�� �.� �� ������
	sub	ax,	vosst2        	; ⠬ �� ����⨫� ������ �� x , � ᥩ�� ���᪠�� ������ �� y
	mul	ax
	mov	kv2,	ax            	; kv2 = (Y-vosst2)^2
	                   	
	mov	ax,	r             	; r - ࠤ��� ���㦭���
	mul	r
	mov	kvr,	ax            	; kvr = R^2
	
	mov	ax,	kv1
	add	ax,	kv2           	; ⥯��� �ࠢ������ ( (x-vosst1)^2 + (y-vosst2)^2 ) � r^2
	cmp	ax,	kvr           	;�᫨ ����� ���� ࠢ�� ,� ��㥬 ���(����७����� ���㦭���)
	jge	M2                    	; ���� , ��祣� �� ������ � ���� ����� ᬮ����

	mov	ah,	0Ch
	mov	al,	color           ; �ᮢ���� �窨
	mov	cx,	x1
	mov	dx,	y1
	int	10h


M2:	inc	y1                      ; �������� �� y (����७��� 横�)
	pop	cx                      ; ���⠭�������� ���稪 ����७���� 横��
	loop	M1
	inc	x1                      ; ��� ⮫쪮 �����稫� �������� �� y, � 㢥��稢��� x(�த������� ���譨� 横��� �� x) 
	                                ; ����⠭�������� ��砫쭮� ���祭�� y(nachaly1) � ���� �����
	mov	bx,	nachaly1
	mov	y1,	bx
	
	pop	cx                      ; ����� 横��. ����⠭�������� ���稪 ���譥�� 横��
	loop	M

pop	y2                       	; ����⠭����� ���祭�� ���न���
pop	x2
pop	y1
pop	x1
pop	dx                            	; � ॣ�����
pop	cx
pop	bx
pop	ax

ret

endp	
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
rectangle proc
push	ax
push	bx
push	cx
push	dx

	mov	bx,	xr2             ; ��।��塞 ����� ��אַ㣮�쭨��
	sub	bx,	xr1

	mov	si,	yr2             ; ��।��塞 ����� ��אַ㣮�쭨��
	sub	si,	yr1

	
	mov	cx,	si              ; ���譨� 横� �� �����(Y)
R1:	
	push	cx
	mov	cx,	bx              ; ����७��� 横� �� �����(X)
R2:	
	push	cx
	mov	ah,	0Ch             ; ��᫥����⥫쭮 ��室� ��אַ㣮�쭨� ��㥬 �窨
	mov	al,	color
	mov	cx,	xr1
	mov	dx,	yr1
	int	10h

	inc	xr1                     ; �������� �� �����
	pop	cx
	loop	R2
	inc	yr1                     ; �������� �� ����
	sub	xr1,	bx              ; ����⠭������� ��砫쭮�� ��������� ��室� �� �����
	pop	cx
	loop	R1

pop	dx
pop	cx
pop	bx
pop	ax

ret

endp
;$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
input proc
push	ax
push	bx
push	cx
push	dx
	
	mov	dl,	13              ; newline 2 ࠧ�
	mov	ah,	2
	int	21h

	mov	dl,	10
	mov	ah,	2
	int	21h

	mov	dl,	10
	mov	ah,	2
	int	21h
	
	MOV  ah, 0Ah                    ; ���頥��� � �㭪樨 0Ah ���뢠��� 21h
	LEA DX,  max                    ;��� ������ ����� � dx (���ᨬ��쭮� �᫮ �������� ᨬ�����)
	iNT  21h                        ;��뢠�� ���뢠��� 21h ��� ����� �᫠
        	                        ; ��ࠧ������� ��������� ���� ��ப� pole, ࠧ��� �� ��� max
E3:	cmp	buffer,	0
	jg	E1	
	mov	ah,	3Ch             ; ०�� ᮧ����� 䠩��
	lea	dx,	names           ; ��� 䠩��
	xor	cx,	cx              ; cx=0 ����� ����� 䠩�
	int	21h
	newline
	outint	cx
	jmp	E2

E1: 	mov	ah,	3Dh             ; ०�� ������ 䠩��
	mov	al,	1               ; ०�� ����� � 䠩�(al=2-�⥭�� � ������;al=1-������;al=0-�⥭��)       
	Lea	dx,	names           ; ���� ����� 䠩��, ���஥ �㦭� ������
	int	21h

E2:	push	ax

	mov	bx,	ax
	mov	ah,	42h
	mov	cx,	0
	mov	dx,	positions
	mov	al,	0
	int	21h

	pop	ax	

	mov	bx,	ax              ; � bx ���ਯ�� 䠩��(㭨���쭮� ��� ���)
	mov	ah,	40h             ; ०�� ����� � 䠩�
	mov	al,	1               ; ०�� ����� � 䠩�(al=2-�⥭�� � ������;al=1-������;al=0-�⥭��)
	Lea	dx,	pole            ; � dx ���� ���� ������, ����� ���� �������
	mov	cl,	4               ; � cx � ������⢮ ���⮢(len), ���஥ ����室��� ������� � 䠩�
	mov	ch,	0
	int	21h

	mov	ah,	3Eh             ; ०�� ������� 䠩��
	int	21h

	mov	ah,	3Dh             ; ०�� ������ 䠩��
	mov	al,	0               ; ०�� ����� � 䠩�(al=2-�⥭�� � ������;al=1-������;al=0-�⥭��)       
	Lea	dx,	names           ; ���� ����� 䠩��, ���஥ �㦭� ������
	int	21h

	push	ax

	mov	bx,	ax
	mov	ah,	42h
	mov	cx,	0
	mov	dx,	positions
	mov	al,	0
	int	21h
 
	pop	ax	

	mov	bx,	ax              ; � bx ���ਯ�� 䠩��
;*
	push	bx
;*
	mov	ah,	3fh             ; ०�� �⥭�� �� 䠩��
	mov	al,	0
	Lea	dx,	read1           ; ���� ���� ������, �㤠 ��ᨬ���쭮 ���� �����뢠���� ���⠭�� �����
	mov	cl,	4	        ; ������⢮ ����, ���஥ �㦭� ������ (len)
	mov	ch,	0
	int	21h                     ; १���� � ax - ॠ�쭮 ���⠭��� ������⢮ ���⮢

	call	strtoint
;*
	pop	bx
;*
	mov	ah,	3Eh             ; ०�� ������� 䠩��
	int	21h

E:
pop	dx
pop	cx
pop	bx
pop	ax
ret
endp                      

strtoint proc                                   ; ��ॢ�� �᫠ � ��ப�
pushf

 	mov	chis,	0
	mov	cl,	len
	mov	ch,	0
	mov	bx,	0
Perev:	
	mov	ax,	chis
	mov	dl,	read1[bx]
	mov	dh,	0
	cmp	dx,	30h
	jl	Perev2
	cmp	dx,	39h
	jg	Perev2
	mul	ten
	mov	chis,	ax
	sub	dx,	30h
	add	chis,	dx
Perev2:	
	inc	bx
	loop	Perev
Perev3:
popf
ret
endp

ENDS

END	Start