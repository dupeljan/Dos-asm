%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small
.286   ; FOR POPA & PUSHA
ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    revers db ?
    k      dw ?
    error  dw ?
    x_0    dw ? 
    y_0    dw ? 
    x_1    dw ? 
    y_1    dw ? 
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;
VIDEO_INIT MACRO
    mov  AX,11h
    int  10h        ; видеорежим 640x480
ENDM


PUTPIXEL MACRO x , y ,color
    pusha
    
    mov ah,0Ch ; функция рисования точки
    mov al, color ; цвет точки
    mov bh,0 ; видео страница
    mov cx, x ; координата X   
    mov dx, y ; координата Y
    int 10h ; вызов прерывания BIOS
    
    popa
ENDM

SWAP MACRO X0, Y0, X1, Y1
    XCHG X0, Y0
    XCHG X1, Y1
ENDM

VARXCHG MACRO X, Y
    push x
    push y
    pop x
    pop y
ENDM

VARLINE MACRO x0, y0, x1, y1, color
    LOCAL L0, L1, L2, L3, L4, L5, L6 ,L7 ,L8, next, main
    pusha

    mov dx, x1 ; dx = dx
    sub dx, x0
    
    mov cx, 1
    cmp dx, 0
        jge L0
    xor cx,cx
    neg dx
L0: ; cx = (dx >=0 )? 1 : 0 ; 
    ; dx = |dx|
    
    mov ax, y1 ; ax = dy
    sub ax, y0
    
    mov bx, 1
    cmp ax, 0
        jge L1
    xor bx, bx
    neg ax
L1:; bx = (ax >=0)? 1 : 0 ;
   ; ax = |ax| 
    
    mov k, -1
    cmp cx, bx
        jne L3
    mov k,  1
L3:; k = (cx == bx)? 1 : -1 ;

    mov revers, 0
    
    cmp ax, dx ; if (dy > dx)
        jle L4
    XCHG ax, dx
    VARXCHG x0, y0
    VARXCHG x1, y1
    mov revers, 1
L4:
    
    
    mov bx, x0
    cmp bx, x1 ; if (x0 > x1)
        jle L5
    VARXCHG x0, x1
    VARXCHG y0, y1
L5:
     mov error, 0
     mov bx, k
main:
    mov cx, x0 ; for(;x0<=x1; ++x0)
    cmp cx, x1
        jg next
    
    cmp revers, 0 ; if (revers)
        jne L6
    PutPixel y0, x0, color
    jmp L7
L6:
    PutPixel x0, y0, color
L7: 
    add error, ax ; error += dy - наименьшее прирашение
    mov cx, error
    shl cx, 1     ; bx = 2*error
    
    cmp cx, dx  ; if ( 2*error > большего приращения)
        jle L8
    
    add y0, bx ; y0 +- 1
    sub error, dx ; error -= большее приращение 
       
L8:
    
    inc x0
    jmp main   
next:
    
    
    POPA
    
ENDM

LINE MACRO x0, y0, x1, y1, color
    mov x_0, x0
    mov y_0, y0
    mov x_1, x1
    mov y_1, y1
    VARLINE x_0,y_0,x_1,y_1,color
ENDM
Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
    VIDEO_INIT
    ;PutPixel 100 100 3
    mov cx,500

    line 300 300 cx 400 3

;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
