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
L: mov  NameFld[bx], 0
    inc bx
    loop L
 
 inagain: mov ah, 0Ah
    lea dx, BUFF; ��� �-�� �����
    int 21h ; ����� ��ப�
   
 
   
   xor cx, cx
   xor bx, bx
   mov cl, ActLen
L1:xor ax, ax
   mov al, NameFld[bx]
   cmp sign, 1  ; �᫨ ����� �� ���
        je num
   cmp al, 45   ; �஢��塞, ���� �� ��
       jne num
    mov sign , 1
        
num:  cmp al, 48 ; �஢��塞 ���祭�� �� �᫮
     jl next
   cmp al, 57
     jg next
   

   mov  allowEnter, 1
   
   mov  ax, result
   mul ten
   add al , NameFld[bx]
   sub al , 48 
   mov result, ax
   
next: inc bx
     
  loop L1
   newline 
   cmp allowEnter , 0
        je inagain  ; �᫨ �� ����� �� ����� ���� - ���� ������
    cmp sign , 0
        je res
    neg result
res:  outint result
    
;========== �����稢��� ����� ��� ���======================
 pop ax
 pop ds
Exit:
 finish
ENDS

END Start
