%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small
.286   ; FOR POPA & PUSHA
ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    revers db ?
    collor db ?
    k      dw ?
    error  dw ?
    x0    dw ? 
    y0    dw ? 
    x1    dw ? 
    y1    dw ? 
	x2	  dw ?
	y2    dw ? 	
    
    V  dw 100
       dw 100
       
       dw 110
       dw 500
       
       dw 300
       dw 590
       
       dw 400
       dw 200
       
       dw 350
       dw 50
       
       dw 400
       dw 10
            
       
    
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

SWAP MACRO A, B, C, D
    XCHG A, B
    XCHG C, D
ENDM

VARXCHG MACRO X, Y
    push x
    push y
    pop x
    pop y
ENDM



VARLINE proc ;x0, y0, x1, y1, color
    ;LOCAL L0, L1, L2, L3, L4, L5, L6 ,L7 ,L8, next, main
    pusha

    mov dx, x1 ; dx = dx
    sub dx, x0
    
    mov cx, 1
    cmp dx, 0
        jge L000
    xor cx,cx
    neg dx
L000: ; cx = (dx >=0 )? 1 : 0 ; 
    ; dx = |dx|
    
    mov ax, y1 ; ax = dy
    sub ax, y0
    
    mov bx, 1
    cmp ax, 0
        jge L001
    xor bx, bx
    neg ax
L001:; bx = (ax >=0)? 1 : 0 ;
   ; ax = |ax| 
    
    mov k, -1
    cmp cx, bx
        jne L003
    mov k,  1
L003:; k = (cx == bx)? 1 : -1 ;

    mov revers, 0
    
    cmp ax, dx ; if (dy > dx)
        jle L004
    XCHG ax, dx
    VARXCHG x0, y0
    VARXCHG x1, y1
    mov revers, 1
L004:
    
    
    mov bx, x0
    cmp bx, x1 ; if (x0 > x1)
        jle L005
    VARXCHG x0, x1
    VARXCHG y0, y1
L005:
     mov error, 0
     mov bx, k
main00:
    mov cx, x0 ; for(;x0<=x1; ++x0)
    cmp cx, x1
        jg next00
    
    cmp revers, 0 ; if (revers)
        jne L006
    PutPixel y0, x0, collor
    jmp L007
L006:
    PutPixel x0, y0, collor
L007: 
    add error, ax ; error += dy - наименьшее прирашение
    mov cx, error
    shl cx, 1     ; bx = 2*error
    
    cmp cx, dx  ; if ( 2*error > большего приращения)
        jle L008
    
    add y0, bx ; y0 +- 1
    sub error, dx ; error -= большее приращение 
       
L008:
    inc x0
    jmp main00   
next00:    
    POPA
    RET
    
VARLINE ENDP
	
	
	
LINE_ITERATOR MACRO 
	pusha
	
	
	mov ax, x1  ; first pair of points
	mov bx, y1
	
	mov cx, x0
	mov dx, y0
	
	
	;mov x1, x2   ; second pair of points
	;mov y1, y2
	push x2
	pop  x1
	push y2
	pop  y1
	
	
	call VARLINE
	
	mov x1, ax ; return value
	mov y1, bx
	
	mov x0, cx
	mov y0, dx
	
	popa
ENDM

VARTRANGLE proc ;x0, y0, x1, y1, x2, y2, color
	; x2, y2 - вершина 
    ;LOCAL L0, L1, L2, L3, L4, L5, L6 ,L7 ,L8, next, main
    pusha

    mov dx, x1 ; dx = dx
    sub dx, x0
    
    mov cx, 1
    cmp dx, 0
        jge L100
    xor cx,cx
    neg dx
L100: ; cx = (dx >=0 )? 1 : 0 ; 
    ; dx = |dx|
    
    mov ax, y1 ; ax = dy
    sub ax, y0
    
    mov bx, 1
    cmp ax, 0
        jge L101
    xor bx, bx
    neg ax
L101:; bx = (ax >=0)? 1 : 0 ;
   ; ax = |ax| 
    
    mov k, -1
    cmp cx, bx
        jne L103
    mov k,  1
L103:; k = (cx == bx)? 1 : -1 ;

    mov revers, 0
    
    cmp ax, dx ; if (dy > dx)
        jle L104
    XCHG ax, dx
    VARXCHG x0, y0
    VARXCHG x1, y1
    mov revers, 1
L104:
    
    
    mov bx, x0
    cmp bx, x1 ; if (x0 > x1)
        jle L105
    VARXCHG x0, x1
    VARXCHG y0, y1
L105:
     mov error, 0
     mov bx, k
	 
main10:
    mov cx, x0 ; for(;x0<=x1; ++x0)
    cmp cx, x1

;=========================================
		jg next100
	jmp forLonJump
	
next100:
	jmp next10	
forLonJump:    

;==========================================
    cmp revers, 0 ; if (revers)
        jne L106
	;==comit==========================================	
    
	PutPixel y0, x0, collor ;before
	;comment *
	VARXCHG x0, y0 ; change pair
	
	LINE_ITERATOR

	VARXCHG x0, y0
	;*
    
	;=======================================================
	jmp L107
L106:
	;==comit============================================	
    
	PutPixel x0, y0, collor ;before
	
	LINE_ITERATOR
	
	;=================================================
L107: 
	
    add error, ax ; error += dy - наименьшее прирашение
    mov cx, error
    shl cx, 1     ; bx = 2*error
    
    cmp cx, dx  ; if ( 2*error > большего приращения)
        jle L108
    
    add y0, bx ; y0 +- 1
    sub error, dx ; error -= большее приращение 
       
L108:
    inc x0
    jmp main10   
next10:    
    POPA
    RET
    
VARTRANGLE ENDP

TRANGLE_COOL_FILL MACRO  x_0, y_0, x_1, y_1, x_2, y_2, color
	mov x0, x_0
    mov y0, y_0
    mov x1, x_1
    mov y1, y_1
	mov x2, x_2
    mov y2, y_2
    mov collor, color 
	call VARTRANGLE
ENDM

TRANGLE_FILLED  MACRO x_0, y_0, x_1, y_1, x_2, y_2, color
	TRANGLE_COOL_FILL x_0 y_0, x_1 y_1, x_2 y_2 color
	;TRANGLE_COOL_FILL x_2 y_2, x_0 y_0, x_1 y_1 color
	;TRANGLE_COOL_FILL x_1 y_1, x_2 y_2, x_0 y_0 color
ENDM

LINE MACRO x_0, y_0, x_1, y_1, color
    mov x0, x_0
    mov y0, y_0
    mov x1, x_1
    mov y1, y_1
    mov collor, color
    call VARLINE
ENDM

RECTANGLE MACRO x_0, y_0, x_1, y_1, color
    line x_0 y_0 x_0 y_1 color
    line x_0 y_1 x_1 y_1 color
    line x_1 y_1 x_1 y_0 color
    line x_1 y_0 x_0 y_0 color
ENDM

;VECTOR ТИПА DW
LINELOOP MACRO VECTOR, LEN, COLOR
    LOCAL L0
    pusha
    
    mov cx, len
    dec cx
    xor bx, bx
L0:    
    mov ax, VECTOR[bx]
    mov x0,  ax
    mov ax, VECTOR[bx+2]
    mov y0, ax
    mov ax, VECTOR[bx+4]
    mov x1, ax
    mov ax, VECTOR[bx+6]
    mov y1, ax
    mov collor, COLOR
    CALL VARLINE
    add bx , 4
    loop L0
    
    popa 
ENDM

CLOSED_LINELOOP MACRO VECTOR, LEN, COLOR
LOCAL L0, L1
    pusha
    
    mov collor, COLOR
    mov cx, len
    
    mov dx, cx
    shl dx, 2; dx = длинна массива - 4
    sub dx, 4
    
    xor bx, bx
L0:    
    mov ax, VECTOR[bx]
    mov x0, ax
    mov ax, VECTOR[bx+2]
    mov y0, ax
    cmp bx, dx
        jne L1
    mov bx, -4
L1:
    mov ax, VECTOR[bx+4]
    mov x1, ax
    mov ax, VECTOR[bx+6]
    mov y1, ax
    CALL VARLINE
    add bx, 4
    loop L0

    popa 
ENDM

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
    VIDEO_INIT
    ;PutPixel 100 100 3
comment *    mov cx,400
    line 300 300 cx 400 2
    line 300 300 400 cx 2
    line  cx 100 300 300 2
    line  100 cx 300 300 2
    RECTANGLE 300 100 400 500 3
    
    ;LINELOOP V 3 3
   ; CLOSED_LINELOOP v 4 3
    mov cx, 3
L1:
    CLOSED_LINELOOP v cx 3
    loop L1
	*
	TRANGLE_FILLED 100 100 300 100 300 200 3
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
