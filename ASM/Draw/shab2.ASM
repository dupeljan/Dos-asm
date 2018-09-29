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
    
    mov ah,0Ch ; функция рисования точки
    mov al,1 ; цвет точки
    mov bh,0 ; видео страница
    mov cx,50 ; координата X
L1:    
    mov dx,50 ; координата Y
    int 10h ; вызов прерывания BIOS
    loop L1
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
