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
;;Graphickal regim 320*200
	mov ax, 0013h 
	int 10h
;;====Palitra====
    ;mov dx,03c8h
    ;xor al,al
    ;out dx,al
    
    mov ah, 0Bh
    mov bx, 00
    int 10h
    
    mov al, 10; цвет
    mov cx, 10; коодр x
    mov dx, 10; коорд y
    
    mov ah, 0Ch
    int 10h
;========== Заканчивайте писать Ваш код======================
	pop	ax
	pop	ds
Exit:
	finish
ENDS

END	Start
