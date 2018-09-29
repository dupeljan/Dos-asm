%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    vector db 100 dup (1)
    n   dw  ?
    i   db  ?
    j   db  ?
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
    inint n
    mov cx, n
    mov i,  0
    mov j,  0; ввод
    
L0: push cx     ;внешний цикл n раз
    mov cx, n
    
L1: xor ax, ax  ;if (i < j){
    mov al, i
    cmp al, j
        jge L2
        
   mov al,  i; vector[n*i +j] = 0
   mul  n
   xor  bx, bx
   mov  bl, al
   add  bl, j
   mov  vector[bx] , 0;}
L2:
    inc j 
    loop L1
    inc i
    mov j, 0
    pop cx
    loop    L0

;вывод
    mov cx, n
    mov i, 0
    mov j, 0
L3: push cx
    mov cx, n
L4: xor ax, ax
    mov al,  i; vector[n*i +j] = 0
    mul  n
    xor  bx, bx
    mov  bl, al
    add  bl, j
    xor  dx, dx
    mov  dl, vector[bx]
    outint dx,2
    inc i
    loop    L4
    
    pop    cx
    inc j
    mov i, 0
    newline
    loop    L3
    
    
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
