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
    k   db  ?
    buff db ?
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
   outch 'n'
   outch '='
   inint n
    
    mov cx, n
    mov i, 0; ввод
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
    mov j,  0; ввод
    
L0: 
    push cx     ;внешний цикл n раз
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
   
   mov  buff, bl ;вычислили  [i,j]
   
   xor ax, ax
   mov al, j
   mul n
   xor bx, bx
   mov bl, al
   add bl, i ; вычислили aдрес j,i
   
   xor dx, dx
   mov dl, vector[bx] ; v[j,i]
   xor bx, bx
   mov bl , buff
   cmp vector[bx], dl 
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
;вывод
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
    
    
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
