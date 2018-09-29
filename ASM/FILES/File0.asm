; �⠥� ⥪��(�� ����� 100 ᨬ�����)
; �� 䠩�� file_in_name(�᫨ 䠩�� ���, �뢮��� ᮮ�饭�� ERR_FileNotFound),
; ᮧ���� 䠩� � ������ file_out_name, �뢮��� � ���� ���⠭�� ⥪��,
; �� �ᯥ譮� �����襭�� �뢮��� ��ப� GoodEnd

MODEL	small

ST1 SEGMENT	; ������� �⥪�

	DB	128	DUP(?)

ST1 ENDS

DATA SEGMENT

 ERR_FileNotFound	DB	'Error. Input file not found.',13,10,'$'
 GoodEnd		DB	'Read and write were successful.',13,10,'$'

 file_in_name		DB	'file.txt',0
 file_out_name		DB	'file_out.txt',0
 file_handler		DW	?	; �࠭�� �����䨪��� 䠩��

 char_buffer_size	EQU	100
 char_buffer		DB	char_buffer_size DUP(?)
 char_buffer_count	DW	0	; ⥪�饥 �᫮ ᨬ����� � ����

DATA ENDS

CODE SEGMENT			; ���뫨 ᥣ���� ����
ASSUME SS:ST1,DS:DATA,CS:CODE	; �易�� ॣ���஢� ᥣ����� � ᥣ���⠬�

Start:
	push	ds
	push	ax

	mov	ax, data	
	mov	ds, ax
;

; ����⨥ �������饣� 䠩��
	mov	ah,3dh
	mov	al,0	; ०�� ����㯠: 0 �⥭��, 1 ������, 2 �⥭��-������
	mov	dx,offset file_in_name	; ������� ���� ����� 䠩��
	int	21h
	mov	file_handler,ax		; ��࠭���� �����䨪��� 䠩��

	jnc	SkipErrNotFound		; ���室 �᫨ 䠩� �������

	; ��ࠡ�⪠ �訡��: �뢮� ERR_FileNotFound �� �࠭
	mov	ax,@data
	mov	dx,offset ERR_FileNotFound
	mov	ah,09h
	int	21h
	jmp	exitin

SkipErrNotFound:

; �⥭�� �� 䠩��
	mov	ah,3fh			; 3fh ��� �⥭��, 40h ��� �����
	mov	bx,file_handler		; ������� �����䨪��� 䠩��
	mov	cx,char_buffer_size	; �᫮ ���뢠���� ���⮢
	mov	dx,offset char_buffer	; ������� ���� ���� �����-�뢮��
	int	21h
	; ax - �᫮ 䠪��᪨ ��⠭���(��� ����ᠭ����) ���⮢

	mov	char_buffer_count,ax

; �����⨥ 䠩��(���� ����� ���� ������)
	mov  ah,3eh
	mov  bx,file_handler	; ������� �����䨪��� ����뢠����� 䠩��
	int  21h

; ᮧ����� 䠩��(�������騩 ��१����뢠����)
	mov	ah,3ch
	mov	cx,0		; ��ਡ�� 䠩��: 0 �����,
	mov	dx,offset file_out_name	; ������� ���� ����� 䠩��
	int	21h
	mov	file_handler,ax	; ��࠭���� �����䨪��� 䠩��

; �뢮� � 䠩�
	mov	ah,40h			; 3fh ��� �⥭��, 40h ��� �����
	mov	bx,file_handler		; ������� �����䨪��� 䠩��
	mov	cx,char_buffer_count	; �᫮ �����뢠���� ���⮢
	mov	dx,offset char_buffer	; ������� ���� ���� �����-�뢮��
	int	21h

; �����⨥ 䠩��(���� ����� ���� ������)
	mov  ah,3eh
	mov  bx,file_handler	; ������� �����䨪��� ����뢠����� 䠩��
	int  21h

	; �뢮� ᮮ�饭�� �� �ᯥ譮� �����襭�� �� �࠭
	mov	ax,@data
	mov	dx,offset GoodEnd
	mov	ah,09h
	int	21h
	jmp	exitin

exitin:
; �������� ������ �� ������
	xor	ax,ax
	int	16h
; �����襭�� �ணࠬ��
	mov	ax,4c00h
	int	21h

;
	pop	ax
	pop	ds

ENDS

END	Start
