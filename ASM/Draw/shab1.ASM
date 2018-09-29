%TITLE "Ваш комментарий программы"
INCLUDE IO.ASM

MODEL	small

ST1 SEGMENT             ;Описали сегмент стека;
	DB 128 DUP(?)
ST1 ENDS

DATA SEGMENT

DATA ENDS


CODE SEGMENT            ;открыли сегмент кода;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;связали регистровые сегменты с сегментами;

Start:
	push	ds
	push	ax
	mov	ax, data	
	mov	ds, ax
;========== Ниже пишите Ваш код ==============================
    mov  AX,11h
    int  10h        ; видеорежим 640x480
    MOV  AH,0CH        ;ф-ия установки точки
    MOV  AL,3          ;выбираем цвет 3 палеты
    mov  CX, 100       ;повторений
m1:
    MOV  DL,100        ;строка
    INC   DL
    ;MOV  DH,10        ;столбец
    ;INC   DH
    INT  10H          ;выводим точку
    loop m1
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
