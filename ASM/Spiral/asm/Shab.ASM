%TITLE "��� �������਩ �ணࠬ��"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
	DB 2 DUP(?)
ST1 ENDS

DATA SEGMENT
    mass    db  2, 80 dup(?)
    p       db  1
    stepper db  0
    n       db  ?
    ten     db  10
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;
divTen PROC NEAR
    div ten
    add ah, 48
    ret
divTen ENDP
outchar proc NEAR
    mov ah, 2
    int 21h
    ret
outchar ENDP
MyOut PROC NEAR
    xor ax, ax
    mov al, mass[bx]
    ;div ten
    ;add ah, 48
    call divTen
    
    push ax ; ��᫥���� ��� � ���襬 ��� �����誨 �⥪�
    xor ah, ah
    ;div ten
    ;add ah, 48
    call divTen
    
    mov dl, ah
    ;mov ah, 2
    ;int 21h ; �뢥�� ������ ����
    call outchar
    
    pop ax
    mov dl, ah
    ;mov ah,2
    ;int 21h   ; �뢥�� ������� ���� 
    call outchar
    
    mov dl, 32 ; ' '
    ;mov ah, 2
    ;int 21h   ; �뢥�� �஡��
    call outchar
    RET
MyOut ENDP
Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== ���� ���� ��� ��� ==============================
    mov ah, 0Ah
    lea dx, mass
    int 21h
    
    xor cx, cx
    mov cl, mass[2]
    sub cl, 48
    mov n, cl    ; ����
     
    mov ax, 1
    mov bx, -1
    mov si, 1
    

    mov dx,cx
    neg dx
L0: cmp cx, 0
        jle L3
    push cx
    
L1: add bx, ax
    push ax
    xor ax, ax
    mov al, p
    mov mass[bx], al
    pop ax
    inc p
    
    loop    L1
    
    pop cx
    cmp stepper, 0
        jne L2
    dec cx
    inc stepper
    neg dx
    mov ax, dx
    jmp L0    
        
L2: neg si
    mov ax, si
    dec stepper        
    jmp L0

L3:
    ;�뢮�
    
    mov cl, p
    dec cx ; cx = n*n
    mov si, 10
    
    xor bx, bx
    xor dx, dx
L4: call MyOut
    inc bx
    mov ax, bx
    div n
    cmp ah, 0
        jne L5
    newline
L5: loop L4
    


;========== �����稢��� ����� ��� ���======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
