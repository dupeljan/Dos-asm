%TITLE "��� �������਩ �ணࠬ��"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    vector db 100 dup (1)
    n   dw  ?
    i   db  ?
    j   db  ?
    k   db  ?
    buff db ?
    
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
   outch 'n'
   outch '='
   inint n
    
    mov cx, n
    mov i, 0; ����
    mov j, 0
L3: push cx
    mov cx, n
L4: xor ax, ax
    mov al,  i; out vector[n*i +j] 
    mul  n
    xor  bx, bx
    mov  bl, al
    add  bl, j
    inint dx
    mov  vector[bx] , dl
    inc i
    loop    L4
    
    pop    cx
    inc j
    mov i, 0
    newline
    loop    L3
    
    mov cx, n
    mov i,  0
    mov j,  0; ����
    
L0: 
    push cx     ;���譨� 横� n ࠧ
    mov cx, n
    
L1: xor ax, ax  ;if (i < j){
    mov al, i
    cmp al, j
        jge L2
        
   mov al,  i; vector[n*i +j] = 0
   mul  n
   mov si, ax ; i
   xor  bx, bx
   mov  bl, j  ; j
   mov  al, vector[si][bx] 
   mov  buff, al ;���᫨��  [i,j]
   
   xor ax, ax
   mov al, j
   mul n
   mov si, ax
   xor bx, bx
   mov bl, i
   
   xor dx, dx
   mov dl , vector[si][bx] ; ���᫨�� a��� j,i
   
   
   cmp buff , dl 
    jne FALSE
   
L2:
    inc j 
    loop L1
    inc i
    mov j, 0
    pop cx
    loop    L0

    newline
    outch '+'
    newline
    jmp TRUE
FALSE:
    newline
    outch '-'
    newline
TRUE:
;�뢮�
    mov cx, n
    mov i, 0
    mov j, 0
L30: push cx
    mov cx, n
L40: xor ax, ax
    mov al,  i; out vector[n*i +j] 
    mul  n
    xor  bx, bx
    mov  bl, al
    add  bl, j
    xor  dx, dx
    mov  dl, vector[bx]
    outint dx,2
    inc i
    loop    L40
    
    pop    cx
    inc j
    mov i, 0
    newline
    loop    L30
    
    
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
