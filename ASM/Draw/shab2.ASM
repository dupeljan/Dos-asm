%TITLE "��� �������਩ �ணࠬ��"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT

DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
    mov  AX,11h
    int  10h        ; �����०�� 640x480
    
    mov ah,0Ch ; �㭪�� �ᮢ���� �窨
    mov al,1 ; 梥� �窨
    mov bh,0 ; ����� ��࠭��
    mov cx,50 ; ���न��� X
L1:    
    mov dx,50 ; ���न��� Y
    int 10h ; �맮� ���뢠��� BIOS
    loop L1
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
