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
;;Graphickal regim 320*200
	mov ax, 0013h 
	int 10h
;;====Palitra====
    ;mov dx,03c8h
    ;xor al,al
    ;out dx,al
    
    mov ah, 0Bh
    mov bx, 00
    int 10h
    
    mov al, 10; 梥�
    mov cx, 10; ����� x
    mov dx, 10; ���� y
    
    mov ah, 0Ch
    int 10h
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
