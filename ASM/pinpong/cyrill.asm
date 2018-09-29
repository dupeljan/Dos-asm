public _plot, _line, _rect, _circle
code segment byte
include io.asm
assume cs:code
 ;Процедура для отрисовки точки.
 _plot proc far
  ;Сохраняем регистры.
  push bp
  mov bp, sp
  push ax
  push bx
  push cx
  push dx
  ;Получаем цвет из стека.
  mov ax, [bp+6]
  ;Получаем координату x из стека.
  mov cx, [bp+8]
  ;Получаем координату y из стека
  ;И приводим ось OY к логическим координатам.
  mov dx, 199
  sub dx, [bp+10]
  ;Отрисовываем точку на экране.
  mov ah, 0ch
  mov bh, 1
  xor bl, bl
  int 10h
  ;Возвращаем регистры на место.
  pop dx
  pop cx
  pop bx
  pop ax
  mov sp, bp
  pop bp
  ret 6
 _plot endp
 ;Процедура для отрисовки линии по двум точкам.
 x dw 0
 y dw 0
 delta  dw 0
 eror dw 0
 deltax dw 0 
 deltay dw 0 
 signx dw -1 
 signy dw -1 
 mistake dw 0 
 mistake2 dw 0
 _line proc far
  push bp
  mov bp, sp
  push ax
  push bx
  push cx
  mov cx, [bp+10] 
  sub cx, [bp+14]
  abs1: 
   neg cx 
  jl abs1 
  mov deltax, cx 
  mov cx, [bp+8]
  sub cx, [bp+12] 
  abs2: 
   neg cx 
  jl abs2 
  mov deltay, cx 
  mov cx, [bp+14]
  cmp cx, [bp+10] 
  jg sgn1 
   mov signx, 1 
  sgn1: 
  mov cx, [bp+12]
  cmp cx, [bp+8]
  jg sgn2 
   mov signy, 1 
  sgn2: 
  mov cx, deltax 
  sub cx, deltay 
  mov mistake, cx 
  mov ax, [bp+10]
  mov bx, [bp+8]
  push ax
  push bx
  push [bp+6]
  call _plot
  mov ax, [bp+14]
  mov bx, [bp+12]
  dline:
   push ax
   push bx
   push [bp+6]
   call _plot
   mov cx, mistake 
   shl cx, 1 
   mov mistake2, cx 
   mov cx, deltay 
   neg cx 
   cmp mistake2, cx 
   jng ovr1 
    mov cx, mistake 
    sub cx, deltay 
    mov mistake, cx 
    add ax, signx 
   ovr1: 
   mov cx, deltax 
   cmp mistake2, cx 
   jnl ovr2 
    mov cx, mistake 
    add cx, deltax 
    mov mistake, cx 
    add bx, signy 
   ovr2: 
   cmp ax, [bp+10] 
   jne ovr3 
   cmp bx, [bp+8]
   jne ovr3
   jmp over
   ovr3: 
  jmp dline 
  over:
  mov signx, -1
  mov signy, -1
  pop cx
  pop bx
  pop ax
  mov sp, bp
  pop bp
  ret 10
 _line endp
 ;Процедура для отрисовки прямоугольника по двум точкам.
 _rect proc far
  push bp
  mov bp, sp
  push ax
  push bx
  push cx
  push dx
  push [bp+10]
  push [bp+16]
  push [bp+14]
  push [bp+16]
  push [bp+8]
  call _line
  push [bp+14]
  push [bp+12]
  push [bp+14]
  push [bp+16]
  push [bp+8]
  call _line
  push [bp+10]
  push [bp+16]
  push [bp+10]
  push [bp+12]
  push [bp+8]
  call _line
  push [bp+14]
  push [bp+12]
  push [bp+10]
  push [bp+12]
  push [bp+8]
  call _line
  mov ax, [bp+16]
  mov bx, [bp+12]
  cmp ax, bx
  jg ovr4
   xchg ax, bx
  ovr4:
  dec ax
  inc bx
  mov cx, [bp+14]
  mov dx, [bp+10]
  cmp cx, dx
  jg ovr5
   xchg cx, dx
  ovr5:
  dec cx
  inc dx
  drect:
   push cx
   push ax
   push cx
   push bx
   push [bp+6]
   call _line
   dec cx
   cmp cx, dx
   jl ovr6
  jmp drect
  ovr6:
  pop dx
  pop cx
  pop bx
  pop ax
  mov bp, sp
  pop bp
  ret 12
 _rect endp
 ;Процедура для отрисовки окружности.
 _circle proc far
   push bp
   mov bp, sp
   push ax
   push bx
   push cx
   push dx
   mov x, 0
   mov ax, [bp+14]
   mov y, ax
   mov delta, 2
   mov ax, 2
   mov dx, 0
   imul y
   sub delta, ax
   mov eror, 0
   jmp ccicle
   finally:
    pop dx
	pop cx
	pop bx
	pop ax
    mov sp, bp
    pop bp	
    ret 10
   ccicle:
	mov ax, y
	cmp ax, 0
	jl  finally
	mov cx, [bp+12]
	add cx, x
	mov dx, [bp+10]
	add dx, y
	push cx
	push dx
	push [bp+8]
	call _plot
    mov cx, [bp+12]
	add cx, x
	mov dx, [bp+10]
	sub dx, y
	push cx
	push dx
	push [bp+8]
	call _plot
	mov cx, [bp+12]
	sub cx, x
	mov dx, [bp+10]
	add dx, y
	push cx
	push dx
	push [bp+8]
	call _plot
	mov cx, [bp+12]
	sub cx, x
	mov dx, [bp+10]
	sub dx, y
	call _plot
	push cx
	push dx
	push [bp+8]
	mov ax, delta
	mov eror, ax
	mov ax, y
	add eror, ax
	mov ax, eror
	mov dx, 0
	mov bx, 2
	imul bx
	sub ax, 1
	mov eror, ax
	cmp delta, 0
	jg sstep
	je sstep
	cmp eror, 0
	jg  sstep
	inc x
	mov ax, 2
	mov dx, 0
	imul x
	add ax, 1
	add delta, ax
    jmp ccicle
   sstep:
	mov ax, delta
	sub ax, x
	mov bx, 2
	mov dx, 0
	imul bx
	sub ax, 1
	mov eror, ax
	cmp delta, 0
	jg tstep
	cmp eror, 0
	jg tstep
	inc x
	mov ax, x
	sub ax, y
	mov bx, 2
	mov dx, 0
	imul bx
	add delta, ax
    dec y
    jmp ccicle
   tstep:
	dec y
    mov ax, 2
	mov dx, 0
	imul y
	mov bx, 1
	sub bx, ax
	add delta, bx
	jmp ccicle
 _circle endp
code ends
end