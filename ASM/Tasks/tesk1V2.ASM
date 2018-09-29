%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
    messgA   db  'Введите a$'
    messgB   db  'Введите b$'
    A        dw   ?
    B        dw   ?
    x   dw  1
    k   dw  1
    lim dw  ? 
    sum dw  0
    n   dw  ?
    ten dw  10
    buffCX  dw  ?
    space   db  ' $'
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
    lea dx,     messgA
    outstr
    inint       A
    
    lea dx,     messgB
    outstr
    inint       B
    
L1: ;do
    mov ax,     x
    mul ten
    mov lim,    ax
; lim = x * 10
    
L2: mov ax,     x 
    cmp ax,     lim
        jge L10
;while ( x < lim )        
    mov sum,    0 ; sum = 0
    
    mov cx,     k; for ( int i = 0, buff = x;  i < k ; i++)  
L3: xor dx,     dx ; ax == x
    div ten        ; ax = x div 10 , dx = x mod 10
    mov bx,     ax; bx = x div 10
    mov n,      dx; n = x mod 10
    

    mov buffCX,  cx
    mov cx,      k

    mov ax,     1
L4: mul n;  ax = ax * n
    loop L4; ax == n^k
    
    add sum,    ax
    mov cx,     buffCX
    mov ax,     bx; ax = x div 10 
    
    loop        L3
    
    mov ax,     x
    cmp ax,     sum; if ( sum == x)
        jne     L5
    
    cmp ax,     A
        jl      L5
    cmp ax,     B
        jg      L5

    outint  x,  5
            ; cout<<x<<'\n';
        
L5:    
    add x,      1
    jmp L2 ; end while 
L10:
    add k,      1
    cmp k,  4 ; 4 значное число
        jle L1; end do
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
