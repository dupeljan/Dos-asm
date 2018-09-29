%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    X   dw  20 dup(?)
    Y   dw  20 dup(?)
    messgIns    db  'Введите точку №$'
    messgX      db  'x=$'
    messgY      db  'y=$'
    messgANS    db  'Отвеет$'
    buffBx      dw  ?
    abscissa    dw  ?
    ordinate    dw  ?
    change      dw  ?
    buff        dw  0
    ans         dw  2 dup(0)
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
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
    inint       Y[bx]
    
    add bx,     2
    loop        L1
    
    ;Ввод массивов X,Y
   
    mov cx,     19 ; for (i=0;i<19;i++)
    xor bx,     bx
L01:mov si,     bx
    add si,     2  ; for(j=i+1;j<20;J++)
    
L2: 
    mov ax,           X[bx]
    mov dx,           x[si]
    mov abscissa,     ax  
    sub abscissa,     dx; //[si]
    mov ax,           abscissa
    mul abscissa     ;abscissa = (x[bx] - x[change] )^2
    mov abscissa,     ax  
    
    mov ax,           Y[bx]
    mov dx,           Y[si]  
    mov ordinate,     ax
    sub ordinate,     dx
    mov ax,           ordinate
    mul ordinate      ;bx = (y[bx] - y[si] )^2 
    
    add ax,     abscissa
    cmp ax,     buff; if ( a^2 + b^2 > buff)
        jle     L3  ;   buff = a^2 + b^2
    mov buff,   ax  
    mov ans,    bx
    mov ans[2], si  ;ans = пара точек
    
    
L3: add si,     2
    cmp si,     40
        jle     L2
    
    add bx,     2
    loop    L01
    
    lea dx,     messgANS
    outstr
    outint  ans,    4
    outint  ans[2], 4
    
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
