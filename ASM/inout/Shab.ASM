%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL small

ST1 SEGMENT             ;Описали сегмент стека;
 DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT
 sign db 0
 allowEnter db 0
 ten db 10
;=========переменная для вывода====
 result dw 0
;=========массив для ввода=====
 BUFF DB 30 ; мах кол-во
 ActLen DB ? ; текущее кол-во
 NameFld DB 30 DUP (?) ; поле ввода
DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
 push ds
 push ax
 mov ax, data 
 mov ds, ax
;========== Ниже пишите Ваш код ==============================
    xor cx, cx
    xor bx, bx
    mov cl, buff
L0: mov  NameFld[bx], 0
    inc bx
    loop L0
    
    mov ah, 0Ah
    lea dx, BUFF; имя о-сти ввода
    int 21h ; ввели строку
   
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
    
;========== Заканчивайте писать Ваш код======================
 pop ax
 pop ds
Exit:
 finish
ENDS

END Start
