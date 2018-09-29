%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    X   dw  20 dup(?)
    Y   dw  20 dup(?)
    messgIns    db  'Введите точку  $'
    messgX      db  'x=$'
    messgY      db  'y=$'
    messgANS    db  'Отвеет$'
    abscissa    dw  ?
    ordinate    dw  ?
    buff        dw  0
    ans         dw  2 dup(0)
    two         dw  2
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
    
    xor dx,     dx
    mov ax,     bx
    div two
    outint      ax
    newline
    
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
    sub ax,           X[si]  
    mul ax
    mov abscissa,     ax  
    
    mov ax,           Y[bx]
    sub ax,           Y[si]  
    mul ax 
    
    add ax,     abscissa
    cmp ax,     buff; if ( a^2 + b^2 > buff)
        jle     L3  ;   buff = a^2 + b^2
    mov buff,   ax  
    mov ans,    bx
    mov ans[2], si  ;ans = пара точек
    
    
    
L3: add si,     2
    cmp si,     40
        jl     L2
    
    add bx,     2
    loop    L01
    
    lea dx,     messgANS
    outstr
    
    xor dx,     dx
    mov ax,     ans
    div two
    outint  ax,    4
    
    xor dx,     dx
    mov ax,     ans[2]
    div two
    outint  ax, 4
    
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
