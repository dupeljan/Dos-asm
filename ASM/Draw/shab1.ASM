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
    MOV  AH,0CH        ;�-�� ��⠭���� �窨
    MOV  AL,3          ;�롨ࠥ� 梥� 3 ������
    mov  CX, 100       ;����७��
m1:
    MOV  DL,100        ;��ப�
    INC   DL
    ;MOV  DH,10        ;�⮫���
    ;INC   DH
    INT  10H          ;�뢮��� ���
    loop m1
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
