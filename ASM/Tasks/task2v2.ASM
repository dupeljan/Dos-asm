%TITLE "��� �������਩ �ணࠬ��"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    X   dw  20 dup( 2 dup(?) )    
    messgIns    db  '������ ��� �$'
    messgX      db  'x=$'
    messgY      db  'y=$'
    messgANS    db  '�⢥��$'
    abscissa    dw  ?
    ordinate    dw  ?
    buff        dw  0
    ans         dw  2 dup(0)
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
    mov cx,     20
    xor bx,     bx
L1: lea dx,     messgIns
    outstr
    outint      bx
    
    lea dx,     messgX
    outstr
    inint       X[bx]
    
    lea dx,     messgY
    outstr
    inint       X[bx][2]
    
    add bx,     4
    loop        L1
    
    ;���� ���ᨢ�� X,Y
   
    mov cx,     19 ; for (i=0;i<19;i++)
    xor bx,     bx
L01:mov dx,     bx
    add dx,     2  ; for(j=i+1;j<20;J++)
    
L2: 
    mov ax,           X[bx]
    mov abscissa,     ax
    dec abscissa,     X[dx]
    mov ax,           abscissa
    mul abscissa     ;abscissa = (x[bx] - x[dx] )^2
    mov abscissa,     ax  
    
    mov ax,           X[bx][2]  
    mov ordinate,     ax
    dec ordinate,     X[dx][2]
    mov ax,           ordinate
    mul ordinate      ;bx = (y[bx] - y[dx] )^2 
    
    add ax,     abscissa
    cmp ax,     buff; if ( a^2 + b^2 > buff)
        jle     L3  ;   buff = a^2 + b^2
    mov buff,   ax  
    mov ans,    bx
    mov ans[2], dx  ;ans = ��� �祪
    
    
L3: add dx,     4
    cmp dx,     40
        jle     L2
    
    add bx,     4
    loop    L01
    
    lea dx,     messgANS
    outstr
    outint  ans,    4
    outint  ans[2], 4
    
;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
