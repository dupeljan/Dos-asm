%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    x   dw  10
    k   db  2
    a   db  3 dub(0)
    a_for_pow   db  3   dub(?)
    lim dw  ?  
    flag    db  0
    ten db  10
    n   db  ?
    sum dw  ?
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
L1: mov ax  ,   x
    mul ten
    mov lim ,   ax
    ; lim = x * 10
L2: mov ax, x
    cmp ax, lim
        jge L3
    ;while ( x < lim ){        
    
    mov flag,   0
;   flag = false

    mov cx, k
    mov bx, 0;
L4: xor dx, dx;for ( int i = 0, buff = x;  i < k ; i++){
    div ten ;            a[i] = buff % 10;
    mov a[bx], dx;        buff = buff / 10 ;
    
    
    
    
    cmp dx, 2  
        jne L5
    mov flag,   1
L5:
    ;            if( a[i]> 2) flag = true;
    ;       }
    inc bx
    loop    L4
    
    cmp flag,   1 ; if ( flag) {
        jne L5
    mov n,  1
    mov sum,    0
    
L6:             ; do{
   
    mov bx, 0
    mov cx  ,   3 ; int a_for_pow [3] = { a[0] , a[1] , a[2] };
L7:
    mov ax, a[bx]
    mov a_for_pow[bx],  ax
    inc bx
    Loop    L7
    
L8  mov     for ( int i = 0 ; i < n; i ++){


    
    mov ax, x   ;while (ax < sum);
    cmp sum,    ax 
        jl  L6
    
L5:;}
    
    inc x
    jmp L2; } 
L3:
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
