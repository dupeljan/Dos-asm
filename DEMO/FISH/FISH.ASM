Stack1 Segment STACK
  dw 1024 dup (?)
Stack1 ends

Data1 Segment
  handler dw ?
  block db 3072 dup (?)
  filename db 'fish.pcx',0
  fileblock db 2263 dup (?)
Data1 ends

Code1 segment
 Assume CS:code1,DS:data1,SS:stack1
 .286
Start:
      mov ax,Data1
      mov DS,ax
      mov ax,13h     ;устанавливаем графический режим
      int 10h

      mov ax,3d00h
      lea dx,filename
      int 21h         ;открываем файл с картинкой
      jnc Noexit
      jmp Exit

Noexit:
       mov handler,ax
       mov ax,3f00h
       mov cx,2263
       mov bx,handler
       lea dx,fileblock
       int 21h          ;читаем
       jnc No1exit
       jmp Exit

No1exit:
       cmp ax,cx
       je No2Exit
       jmp Exit

No2Exit:
       mov ax,3e00h
       mov bx,handler
       int 21h

St0:
       xor ax,ax
       int 16h
       cmp al,13
       jne St0
 
       mov dx,03C8h     ;заменяем белый на черный
       mov al,0fh
       out dx,al
       inc dx
       xor ax,ax
       out dx,al
       out dx,al
       out dx,al
       xor dx,dx
       lea si,fileblock
       lea di,block
       add si,128       ;убираем служебную информацию

Recode:
       mov al,[si]
       inc si
       cmp al,192  
       ja temp
       mov [di],al
       inc di
       inc dx
       cmp dx,3072
       jne Recode
       jmp Graph

Temp:
       sub al,192
       xor cx,cx
       mov cl,al
       mov al,[si]
       inc si

Temploop:
       mov [di],al
       inc di
       inc dx
       cmp dx,3072
       je Graph
       loop Temploop
       jmp Recode

Graph:
       mov ax,0a000h    ;устанавливаем ES на видеосегмент
       mov ES,ax
       xor di,di
       mov cx,256       ;количество сдвигов изображения

S3:
       push cx
       inc di
       push di
       lea si,block
       mov cx,48

C1Graph:
       push cx
       mov cx,64

C2Graph:
       mov al,[si]
       mov es:[di],al
       inc si
       inc di
       loop C2Graph

       add di,256
       pop cx
       loop C1Graph

       pop di
       mov ah,86h       ;задержка
       mov cx,1
       int 15h
       pop cx
       mov ah,1
       int 16h
       jnz St1

St2:
       loop S3
StdExit:
       xor ax,ax
       int 16h

Exit:
      mov ax,3      ;восстанавливаем видеорежим
       int 10h
       mov ax,4c00h   ;закрытие программы
       int 21h
St1:
       cmp al,32
       je StdExit
       jmp St2		 

Code1 ends
End Start