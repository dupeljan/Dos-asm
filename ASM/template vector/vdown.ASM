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
    len     dw  ?
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
    inint   n
    
    mov	ax,	n
	add	ax,	ax
	mov	n2,	ax ; n2 = 2*n
	
    sub ax, 2
    mov len,    ax; len = 2*(n-1)
    
    mov cx, n
    dec cx        ; cx = n-1
    
    mov	ax,	n
	mul	n
	mov	nn,	ax ; nn = n*n

L0: mov ax, cx
    mul n2
    mov bx, ax
    push    cx
L1: mov mass[bx],   0
    add bx, 2
    loop    L1
    pop cx
    loop    L0
   
   
	mov	cx,	nn ;�뢮�
	xor	bx,	bx
	xor	dx,	dx
L2:	outint	mass[bx], 2
	add	bx,	2
	add	dx,	2
	cmp	dx,	n2
		jne	L3
	xor	dx,	dx
	newline
L3:	loop	L2	
    
    
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
