%TITLE "��� �������਩ �ணࠬ��"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    mass    dw  10 dup( 10 dup (1) )
    n       dw  ?
    n2      dw  ?
    nn      dw  ?
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
	inint	n
	
	mov	ax,	n
	add	ax,	ax
	mov	n2,	ax ; n2 = 2*n

	
    mov cx, n
    dec cx  ; cx = n-1
    
    xor bx, bx
    mov si, 2
L0: push si
    push cx
L1: mov mass[bx][si], 0
    add si, 2
    loop    L1
    pop cx
    pop si
    add bx, n2
    add si, 2
    loop    L0
    
    mov	ax,	n
	mul	n
	mov	nn,	ax ; nn = n*n
	
    xor bx, bx; �뢮�
    mov cx, n
L3: push    cx
    xor si, si
    mov cx, n
L2: outint mass[bx][si],   2
    add si, 2
    loop    l2
    newline
    pop cx
;    mov si, 0
    add bx, n2
    loop    L3
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
