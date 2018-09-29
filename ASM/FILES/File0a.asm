; ������ �����(�� ����� 100 ��������)
; �� ����� file_in_name(���� ����� ���, ������� ��������� ERR_FileNotFound),
; ������� ���� � ������ file_out_name, ������� � ���� ����������� �����,
; ��� �������� ���������� ������� ������ GoodEnd

MODEL	small

ST1 SEGMENT	; ������� �����

	DB	128	DUP(?)

ST1 ENDS

DATA SEGMENT

 ERR_FileNotFound	DB	'Error. Input file not found.',13,10,'$'
 GoodEnd		DB	'Read and write were successful.',13,10,'$'

 file_in_name		DB	'file_in.txt',0
 file_out_name		DB	'file_out.txt',0
 file_handler		DW	?	; ������ ������������� �����

 char_buffer_size	EQU	100
 char_buffer		DB	char_buffer_size DUP(?)
 char_buffer_count	DW	0	; ������� ����� �������� � ������

DATA ENDS

CODE SEGMENT			; ������� ������� ����
ASSUME SS:ST1,DS:DATA,CS:CODE	; ������� ����������� �������� � ����������

Start:
	push	ds
	push	ax

	mov	ax, data	
	mov	ds, ax
;

; �������� ������������� �����
	mov	ah,3dh
	mov	al,0	; ����� �������: 0 ������, 1 ������, 2 ������-������
	mov	dx,offset file_in_name	; ������� ������ ����� �����
	int	21h
	mov	file_handler,ax		; ���������� �������������� �����

	jnc	SkipErrNotFound		; ������� ���� ���� ����������

	; ��������� ������: ����� ERR_FileNotFound �� �����
	mov	ax,@data
	mov	dx,offset ERR_FileNotFound
	mov	ah,09h
	int	21h
	jmp	exitin

SkipErrNotFound:

; ������ �� �����
	mov	ah,3fh			; 3fh ��� ������, 40h ��� ������
	mov	bx,file_handler		; ������� �������������� �����
	mov	cx,char_buffer_size	; ����� ����������� ������
	mov	dx,offset char_buffer	; ������� ������ ������ �����-������
	int	21h
	; ax - ����� ���������� ���������(��� �����������) ������

	mov	char_buffer_count,ax

; �������� �����(����� ������ ����� ��������)
	mov  ah,3eh
	mov  bx,file_handler	; ������� �������������� ������������ �����
	int  21h

; �������� �����(������������ ����������������)
	mov	ah,3ch
	mov	cx,0		; ������� �����: 0 �������,
	mov	dx,offset file_out_name	; ������� ������ ����� �����
	int	21h
	mov	file_handler,ax	; ���������� �������������� �����

; ����� � ����
	mov	ah,40h			; 3fh ��� ������, 40h ��� ������
	mov	bx,file_handler		; ������� �������������� �����
	mov	cx,char_buffer_count	; ����� ������������ ������
	mov	dx,offset char_buffer	; ������� ������ ������ �����-������
	int	21h

; �������� �����(����� ������ ����� ��������)
	mov  ah,3eh
	mov  bx,file_handler	; ������� �������������� ������������ �����
	int  21h

	; ����� ��������� �� �������� ���������� �� �����
	mov	ax,@data
	mov	dx,offset GoodEnd
	mov	ah,09h
	int	21h
	jmp	exitin

exitin:
; �������� ������� ����� �������
	xor	ax,ax
	int	16h
; ���������� ���������
	mov	ax,4c00h
	int	21h

;
	pop	ax
	pop	ds

ENDS

END	Start
