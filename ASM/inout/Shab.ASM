%TITLE "��� �������਩ �ணࠬ��"
INCLUDE IO.ASM

MODEL small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
 DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
 sign db 0
 allowEnter db 0
 ten db 10
;=========��६����� ��� �뢮��====
 result dw 0
;=========���ᨢ ��� �����=====
 BUFF DB 30 ; ��� ���-��
 ActLen DB ? ; ⥪�饥 ���-��
 NameFld DB 30 DUP (?) ; ���� �����
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
 push ds
 push ax
 mov ax, data 
 mov ds, ax
;========== ���� ���� ��� ��� ==============================
    xor cx, cx
    xor bx, bx
    mov cl, buff
L0: mov  NameFld[bx], 0
    inc bx
    loop L0
    
    mov ah, 0Ah
    lea dx, BUFF; ��� �-�� �����
    int 21h ; ����� ��ப�
   
   xor bx, bx
   xor cx, cx
   mov cl, ActLen
L: xor ax, ax
   mov al, NameFld[bx]
   newline
   outint ax
   inc bx
   loop L
 
   newline
   newline
   
   xor cx, cx
   xor bx, bx
   mov cl, ActLen
L1:xor ax, ax
   mov al, NameFld[bx]

   cmp al, 48
     jl next
   cmp al, 57
     jg next
   
   mov  ax, result
   mul ten
   add al , NameFld[bx]
   sub al , 48 
   mov result, ax
   
next: inc bx
     
  loop L1

    outint result
    
;========== �����稢��� ����� ��� ���======================
 pop ax
 pop ds
Exit:
 finish
ENDS

END Start
