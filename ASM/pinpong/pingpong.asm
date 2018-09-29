dosseg
;Макросы для удобной работы с графикой.
include libcyr.asm
.model huge
.stack 200h
.data
 ;Copyright(c) 20
 ;Скорость реакции компьютера.
 reaction equ 100
 ;Радиус шарика.
 radius equ 5
 ;Финальный счёт.
 final equ 15
 ;Скорость движения ракеток.
 speed1 dw 5
 speed2 dw 5
 ;Надпись однопользовательского режима.
 oneuser db '1 - one player.$'
 ;Надпись для режима двух игроков.
 twouser db '2 - two players.$'
 ;Помощь для режима одного игрока
 helpone db "You're blue. Use up and down arrows.$"
 ;Помощь для режима двух игроков.
 helptwo db "Blue uses up and down arrows.",13,10,"          Orange uses W and S.$"
 ;Просьба сэникеить.
 anykey db 'Press any key to continue.$'
 ;Надпись для выхода из игры.
 quit db 'Escape - leave the game.$'
 ;Надпись в случае победы оранжевого игрока.
 owin db 'ORANGE HAS WON!!!$'
 ;Надпись в случае победы голубого игрока.
 bwin db 'BLUE HAS WON!!!$'
 ;Надпись в случае победы одного из игроков.
 win db 'Press R to restart the game.$'
 ;Надпись в случае нажатия escape во время игры.
 con db 'Press R to return.$'
 ;Информация для игроков.
 info db 'Press escape to exit to menu.$'
 ;Заголовок игры.
 pong db 'PINGpong$'
 ;Надпись, вопрошающая, хочет ли игрок покинуть сию дивную игру, превосходящуюю по графике любой крайзис.
 bye db 'Do you realy want to quit the game?(Y/N)$'
 ;Выводимый на экран счёт.
 score1 db '00$'
 score2 db '00$'
 ;Скорость движения шарика по x.
 cspeedx dw -3
 ;Скорость движения шарика по y.
 cspeedy dw 0
 ;Стартовые координаты шарика.
 cirx dw 159
 ciry dw 97
 ;Стартовые координаты оранжевой ракетки.
 r1x1 dw 10
 r1y1 dw 75
 r1x2 dw 15
 r1y2 dw 118
 ;Стартовые координаты голубой ракетки.
 r2x1 dw 309
 r2y1 dw 75
 r2x2 dw 304
 r2y2 dw 118
 ;Данные о счёте каждого из игроков.
 s1 dw 0
 s2 dw 0
 ;Режим игры.
 mode dw 0
.code
 mov ax, @data
 mov ds, ax
 jmp start
 ;Процедура возвращающая переменным их начальные значения.
 reset proc
  mov s1, 0
  mov s2, 0
  mov cirx, 159
  mov ciry, 97
  mov r1x1, 10
  mov r1y1, 75
  mov r1x2, 15
  mov r1y2, 118
  mov r2x1, 309
  mov r2y1, 75
  mov r2x2, 304
  mov r2y2, 118
  mov bx, 1
  mov score1, 48
  mov score2, 48
  mov score1[bx], 48
  mov score2[bx], 48
  mov cspeedx, -2
  mov cspeedy, 0
  mov speed1, 3
  mov speed2, 3
  ret
 reset endp
 ;Процедура для поднятия оранжевой ракетки.
 uporange proc
    ;Устанавливем начальную скорость движения ракетки. 
   mov bx, speed1
   ;Проверяем её нахождение у верхнего бортика, и,
   ;если ракетка упёрлась, то блокируем движение вверх.
   cmp r1y2, 182
   je notup1
    ;Смещаем ракетку вверх.
    mov ax, r1y2
    add ax, bx
	;Проверяем её выход за верхний бортик.
	cmp ax, 182
	jng fix1
	 ;Корректируем её положение.
	 sub ax, 182
	 sub bx, ax
	 mov ax, r1y2
	 add ax, bx
	fix1:
	;Меняем координаты ракетки на новые.
    mov r1y2, ax
    mov ax, r1y1
    add ax, bx
	;Закрашиваем часть старой позиции чёрным прямоугольником.
    rect r1x1, r1y1, r1x2, ax, 0, 0
    mov r1y1, ax 
   notup1:
   ret
 uporange endp
 ;Процедура для опускания оранжевой ракетки.
 downorange proc
   mov bx, speed1
   cmp r1y1, 16
   je notdown1
    mov ax, r1y1
    sub ax, bx
	cmp ax, 16
	jnl fix2
	 sub ax, 16
	 add bx, ax
	 mov ax, r1y1
	 sub ax, bx
	fix2:
	mov r1y1, ax
	mov ax, r1y2
    sub ax, bx
    rect r1x1, r1y2, r1x2, ax, 0, 0
    mov r1y2, ax
   notdown1:
   ret
 downorange endp
 ;Начинаем игру.
 start:
 ;Инициализируем графику VGA 320x200
 initgraph 13h
 ;Выводим меню игры.
 print pong 5, 16
 print oneuser, 11, 11
 print twouser, 12, 11
 print quit, 13, 8
 cycle3:
  mov ah, 00h
  int 16h
  cmp ax, 283
  jne left
   jmp endgame
  left:
  cmp ax, 20224
  je oneu
  cmp ax, 561
  je oneu
  jmp one
   oneu:
   mov mode, 1
   initgraph 13h
   print helpone, 12, 2
   print anykey 13, 7
   mov ah, 00h
   int 16h
   jmp next2
  one:
  cmp ax, 20480
  je twou
  cmp ax, 818
  je twou
  jmp two
   twou:
   mov mode, 2
   initgraph 13h
   print helptwo, 11, 5
   print anykey 13, 7
   mov ah, 00h
   int 16h
   jmp next2
  two:
 jmp cycle3
 next2:
 initgraph 13h
 ;Начинаем игру.
 game:
  ;Отрисовываем зелёный шарик.
  circle radius, cirx, ciry, 10, 16
  ;Выводим заголовок игры.
  print pong 0, 16
  ;Вывод информации для игроков.
  print info 24, 1
  ;Вывод счёта игроков.
  print score1, 1, 9
  print score2, 1, 29
  ;Отрисовываем верхнюю границу поля.
  line 0, 183, 319, 183, 15
  ;Отрисовываем нижнюю границу поля.
  line 0, 15, 319, 15, 15
  ;Отрисовываем сетку посередине.
  mov ax, 19
  mov bx, 26
  mov cx, 12
  grid:
   line 159, ax, 159, bx, 15
   add ax, 14
   add bx, 14
  loop grid
  ;Отрисовываем оранжевую ракетку.
  rect r1x1, r1y1, r1x2, r1y2, 66, 42
  ;Отрисовываем голубую ракетку.
  rect r2x1, r2y1, r2x2, r2y2, 53, 54
  ;Считываем нажатые клавиши.
  mov ah, 01h
  int 16h
  ;Если клавиша была нажата, то начинаем её обработку.
  ;Если нет, то обрабатываем движение шарика.
  jz proceedkey
   jmp workkey
  proceedkey:
  ;Закрашиваем старую позицию шарика чёрным шариком.
  circle radius, cirx, ciry, 0, 0
  ;Сдвигаем шарик по оси x.
  mov cx, cirx
  add cx, cspeedx
  mov cirx, cx  
  ;Проверяем пересечение с вертикалью оранжевой ракетки.
  cmp cirx, 20
  jl hitorange
  ;Проверяем пересечение с вертикалью голубой ракетки.
  cmp cirx, 299
  jg hitblue
  ;Обработка столкновения с ракетками.  
  jmp hitb
   ;Обрабатываем столкновение с голубой ракеткой.
   hitblue:
    ;Проверяем вписывается ли шарик в ракетку.
    mov ax, ciry
	cmp ax, r2y2
    jnl hitb
	cmp ax, r2y1
	jng hitb
	;Если вписался, то определяем угол отскока.
	;Берём текущее положение шарика и вычитаем 
	;из него нижню границу ракетки.
	mov ax, ciry
	sub ax, r2y1
	;Высота ракеток 42. Отнимаем половину + 1 пиксель.
	;Таким образом, если шарик попал в центр, то его скорость
	;по y станет равной нулю, иначе взависимости от удалённости
	;от центра ракетки и в верхнюю или нижнюю ракетку попал шарик,
	;шарик получает отрицательную или положительную скорость по y.
	sub ax, 22
	mov bx, 4
	mov cx, 1
	abs1:
	 neg cx
	 neg ax
	jl abs1
	xor dx, dx
	div bx
	imul cx
	;Смещаем по x в сторону от ракетки.
	mov cspeedy, ax
    mov cirx, 304 - 2*radius
	jmp donex
   ;Код аналогичен голубой ракетке.
   hitorange:
    mov ax, ciry
	cmp ax, r1y2
    jnl hitb
	cmp ax, r1y1
	jng hitb
	mov ax, ciry
	sub ax, r1y1
	sub ax, 22
	mov bx, 4
	mov cx, 1
	abs2:
	 neg cx
	 neg ax
	jl abs2
	xor dx, dx
	div bx
	imul cx
	mov cspeedy, ax
    mov cirx, 20 + 2*radius
   donex:
   mov cx, cspeedx
   neg cx
   mov cspeedx, cx
  hitb:
  ;Сдвигаме шарик по оси y.
  mov cx, ciry
  add cx, cspeedy
  mov ciry, cx
  ;Проверяем столкновение с нижним бортиком.
  cmp ciry, 20
  jnl hitdown
   ;Возвращаем шарик на несколько позиций назад.
   mov ciry, 20 + 2* radius
   jmp doney
  hitdown:
  ;Проверяем столкновение с верхним бортиком.
  cmp ciry, 178
  jng hitup
   ;Возвращаем шарик на несколько позиций назад.
   mov ciry, 178 -2* radius
   jmp doney
  hitup:
  ;Меняем направление скорости по оси y на противоположное.
  jmp hitl
   doney:
   mov cx, cspeedy
   neg cx
   mov cspeedy, cx
  hitl:
  ;Обрабатываем счёт.
  ;Если после всех преобразований траектори шарика,
  ;он всё равно оказался за вертикалью одной из ракеток,
  ;То происходит засчитывание попадания.
  cmp cirx, 5
  ;Засчитываем попадание голубому игроку.
  jnl addblue
   mov bx, 1
   mov al, score2[bx]
   ;Если необходим переход по десяткам.
   cmp al, '9'
   jne nine1
    ;Увеличвыем десятки.
    mov al, score2
    inc al
	;Обнуляем единицы.
	mov score2, al
	mov score2[bx], 47
   nine1:
   ;Увеличиваем единицы.
   mov al, score2[bx]
   inc al
   mov score2[bx], al
   ;Увеличваем счёт голубому игроку.
   mov ax, s2
   inc ax
   mov s2, ax
   ;Ставим шарик в центр поля, сохраняя его траекторию.
   mov ciry, 97
   mov cirx, 159
  addblue:
  ;Здесь всё происходит аналогично голубому игроку.
  cmp cirx, 315
  jng addorange
   mov bx, 1
   mov al, score1[bx]
   cmp al, '9'
   jne nine2
    mov al, score1
    inc al
	mov score1, al
	mov score1[bx], 47
   nine2:
   mov al, score1[bx]
   inc al
   mov score1[bx], al
   mov ax, s1
   inc ax
   mov s1, ax
   mov ciry, 97
   mov cirx, 159
  addorange:
  ;Выводим сообщение о победе одного из игрков
  ;Если победил оранжевый игрок.
  cmp s1, final
  jne noto
   initgraph 13h
   print owin, 11, 11
  jmp restart
  noto:
  ;Если победил голубой игрок.
  cmp s2, final
  jne notb
   initgraph 13h
   print bwin, 11, 13
  jmp restart
  notb:
  ;Здесь прописан разум для компьютера-игрока.
  ;Он будет двигать ракетку начиная с некоторого
  ;расстояни до шарика.
  mov bx, cirx
  sub bx, r1x2
  cmp bx, reaction
  jnl orangework
  cmp mode, 1
  jne orangework
   mov speed1, 4
   mov speed2, 6
   mov bx, ciry
   add bx, 10
   cmp r1y2, bx
   jnl ai1
    call uporange
   ai1:
   mov bx, ciry
   sub bx, 10
   cmp r1y1, bx
   jng ai2
    call downorange
   ai2:
  orangework:
 jmp game
 ;Обрабатываем нажатие клавиши.
 workkey:
  ;Считываем нажатую клавишу.
  mov ah, 00h
  int 16h
  cmp mode, 2
  jne notorange
  ;Обрабатываем управление оранжевой ракеткой.
  ;Если была нажата буква w.
  cmp ax, 4471
  jne up1
   call uporange
  up1:
  ;На все остальные клавиши идёт аналогично.
  ;Буква s.
  cmp ax, 8051
  jne down1
	call downorange
  down1:
  notorange:
  ;Обрабатываем управление голубой ракеткой.
  ;Стрелка вверх.
  cmp ax, 18432
  jne up2
   mov bx, speed2
   cmp r2y2, 182
   je notup2
    mov ax, r2y2
    add ax, bx
	cmp ax, 182
	jng fix3
	 sub ax, 182
	 sub bx, ax
	 mov ax, r2y2
	 add ax, bx
	fix3:
    mov r2y2, ax
    mov ax, r2y1
    add ax, bx
    rect r2x1, r2y1, r2x2, ax, 0, 0
    mov r2y1, ax 
   notup2:
  up2:
  ;Стрелка вниз.
  cmp ax, 20480
  jne down2
   mov bx, speed2
   cmp r2y1, 16
   je notdown2
    mov ax, r2y1
    sub ax, bx
	cmp ax, 16
	jnl fix4
	 sub ax, 16
	 add bx, ax
	 mov ax, r2y1
	 sub ax, bx
	fix4:
	mov r2y1, ax
	mov ax, r2y2
    sub ax, bx
    rect r2x1, r2y2, r2x2, ax, 0, 0
    mov r2y2, ax
   notdown2:
  down2:
  ;Если была нажат escape.
  cmp ax, 283
  jne continue
   ;Выводим сообщение с предложением выйти или продолжить игру.
   initgraph 13h
   print con, 12, 11
   print info, 13, 5
   ;Если r, то возврат в игру, escape - выход в меню.
   cycle2:
    mov ah, 00h
    int 16h
    cmp ax, 283
    jne endg1
	 call reset
	 jmp start
	endg1:
    cmp ax, 4978
    je next
   jmp cycle2
   next:
   initgraph 13h
  continue:
 jmp game
 gameover:
 jmp endgame
  restart:
  ;Выводим сообщение с предложением выйти или начать игру занаво.
  print win, 12, 6
  print info, 13, 5
  ;Если r, то перезапуск, escape - выход в меню.
  cycle1:
   mov ah, 00h
   int 16h
   cmp ax, 283
   jne endg2
    call reset
    jmp start
   endg2:
   cmp ax, 4978
   je rerun
  jmp cycle1
  rerun:
  ;Перезапускаем игру, возвращая исходные значения всех переменных.
  initgraph 13h
  call reset
  jmp game
 endgame:
 initgraph 13h
 ;Спрашиваем игрока - хочет ли он выйти из игры.
 print bye, 12, 0
 cycle4:
  mov ah, 00h
  int 16h
  cmp ax, 5497
  jne yes
   jmp goodbye
  yes:
  cmp ax, 12654
  jne no
   jmp start
  no:
 jmp cycle4
 goodbye:
 ;Возвращаемся к исходному видеорежиму.
 initgraph 3
 ;Выходим из игры.
 mov ah, 4ch
 int 21h
end