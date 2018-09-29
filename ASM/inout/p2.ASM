%TITLE "Ваш комментарий программы"


MODEL small

ST1 SEGMENT             ;Описали сегмент стека;
 DB 128 DUP(?)
ST1 ENDS

outstr macro
    mov ah, 9
    int 21h
ENDM

CLS macro 
    mov ax, 0600h;номер ф-ции скролинг
    mov bh, 07    ; атрибут экрана чб
    mov cx, 0000h ; левая верхняя позиция курсора
    mov dx, 184Fh ; правая нижняя позиция курсора
    int 10h
ENDM

pos macro str, stb
    mov ah, 02
    mov bx, 00
    mov dh, str
    mov dl, stb
    int 10h
ENDM

outch MACRO character
    push dx
    push ax
    mov dl, character
    mov ah, 2
    int 21h
    pop ax
    pop dx
ENDM

finish	MACRO

	MOV	AX,4C00h
	INT	21h

ENDM


DATA SEGMENT
;=======cтроки===========
errorstr db 'ERROR$'
mulOnTwo db 'X2$' ; СДВИГ 6
;========пер-ные========
 sign db 0
 numbers_were db 0  
 ten dw 10
 two dw 2
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
    CLS
    pos 0,0
    outch 110
    outch 61
    mov ah, 0Ah
    lea dx, BUFF; имя о-сти ввода
    int 21h ; ввели строку
   
   xor cx, cx
   xor bx, bx
   mov cl, ActLen
L1:xor ax, ax
   mov al, NameFld[bx]
        
   cmp al, 48 ; проверяем значение на число
     jl signExpect
   cmp al, 57
     jg signExpect     ;не число - проверяем на знак
   
   mov numbers_were , 1
   mov  ax, result
   mul ten
   sub ax , 48
   
   xor dx, dx
   mov dl, NameFld[bx]
   add ax , dx
   mov result , ax ; добавляем к результату  это число
   jmp next       ; след итерация

signExpect:     
    cmp sign, 1  ; иначе если знака не было
        je error  
   cmp numbers_were, 1   ; и не было чисел
       je error  ; 
    cmp al, 45   ;  и если сейчас знак
        jne error
    mov sign , 1;    записываем знак
    jmp next
error:
    cmp al, 32   ; иначе если не пробел
        jne wasError ; то ошибка
    
next:

    inc bx
     
   loop L1
   ;искл ситуация - не было цифр
   cmp numbers_were, 1
     jne wasError
     
   cmp sign , 0 ; меняем знак при необходимости
        je res
    neg result
res:  
      ; арифмет действие - умножение на 2
      mov cl , 1
      shl result, cl
      ; выведем строку X2
      ;pos 1,0
      ;mov ax, DATA
      ;mov ds, ax
      ;mov dx, 6 ; сдвиг
      ;outstr
      ;outint result
      pos 1, 0 ; newline
      
      cmp result, 0 ; если меньше нуля
        jge outintt
      outch 45 ; выводим знак
      
      neg result  ;меняем знак
outintt:  
      mov ax, result
      xor bx, bx
L2:   cmp ax, 0
        jle nextOut
      xor dx, dx
      div ten
      
      mov NameFld[bx], dl
      add NameFld[bx], 48
      
      inc bx
      
      jmp L2
nextOut:      
      mov cx, bx
      dec bx
      
L3:   outch NameFld[bx]
      dec bx
      loop L3
      
      
      jmp theEnd
wasError: ;newline
     pos 1,0
     mov ax, DATA
     mov ds,  ax
     mov dx, 0
     outstr
    ;outch 45
theEnd:
;========== Заканчивайте писать Ваш код======================
 pop ax
 pop ds
Exit:
 finish
ENDS

END Start
          
