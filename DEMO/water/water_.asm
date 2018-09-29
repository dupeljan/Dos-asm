;
;                 ██████████████████████████████████████████
;                 █                                        █
;                 █            -  W a t e r  -             █
;                 █                                        █
;                 █    Copyright: 2003 Сухоборов А. А.     █
;                 █        email: FloatOk@Yandex.ru        █
;                 █                                        █
;                 ██████████████████████████████████████████
;

	PspSize		equ 100h
	StackSize	equ 100h

StackSegment SEGMENT PARA STACK 'STACK'

;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;                         СЕГМЕНТ КОДА
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

	db StackSize dup (?)

;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

StackSegment ENDS



DataSegment SEGMENT PARA 'DATA'

;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;                    Параметры компиляции...
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
 
	BlurCount	equ 5
	TextColor	equ 255-30*TextScale
	TextShowDelay	equ 100
	TextScale	equ 3
	TextX		equ (MaxX-(TextStringSize-1)*TextScale*BiosFontSize)/2+5
	TextY		equ 90
	MaxX		equ 320
	MaxY		equ 200
	BiosFontSize	equ 8
	BufferSize	equ MaxX*MaxY
	VideoMemory	equ 0a000h
	MaxColor	equ 252
	TextStringSize	equ 14

	TimeToRunScrSav	equ 1

;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀


;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;                    Описания ДАННЫХ...
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

	String		db '             ', 0
        		db '    Hello    ', 0
		        db '    from     ', 0
		        db 'Sukhoborov A.', 0
		        db '    email :  ', 0
		        db '   FloatOk   ', 0
		        db ' @Yandex.ru  ', 0
			db '             ', 0

	LastString	equ $-offset string
	
	BufferVideo	dw ?
	BufferFirst	dw ?
	BufferSecond	dw ?

	Seed		dw ?
	FontAddr	dd ?

	ExitDelay	db 100
	Exit		db 0
	
	DataSize	equ $-String

;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

DataSegment ENDS



CodeSegment SEGMENT PARA 'CODE'
	assume	cs: CodeSegment, ds: DataSegment, ss: StackSegment
.386
Locals

;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
;                         СЕГМЕНТ КОДА
;▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀

Main PROC NEAR
;──────────────────────────────────────────────────────────────────────
; Процедура: Точка входа
;	     Вход:  нет
;	     Выход: нет
;──────────────────────────────────────────────────────────────────────

	call	ShowAbout
	
	mov	ah, 4ch
	int	21h

	ret

Main ENDP


ShowAbout proc far
;──────────────────────────────────────────────────────────────────────
; Процедура: Графика
;	     Вход:  нет
;	     Выход: нет
;──────────────────────────────────────────────────────────────────────

	pusha
	push	ds
	push	es
	push	gs

	mov	ah, 4ah
	mov	bx, ProgSizeInPar
	int	21h

	push	DataSegment
	pop	ds
	
; Создаём буферы (3 штуки)
	mov	cl, 3			; Количество создаваемых буферов
	mov	di, offset BufferVideo	; В di смещение BufferVideo
	mov	bx, BufferSize shr 4+1	; В bx размер буфера в параграфах
@@CreateBuffers:
	mov	ah, 48h			; Выделение памяти под буфер 
	int	21h			; 21h - функции ОС
					; В ax теперь сегментный адрес выделенного буфера
	push	DataSegment		; Настраиваем es на сегмент кода
	pop	es
	stosw				; Пересылаем сегментный адрес из ax в es:di и увеличиваем di на 2
	pusha				; Сохраняем все регистры в стеке
	mov	es, ax			; Настраиваем es на выделенный участок памяти
	xor	ax, ax			; Чистим регистры ax, di
	xor	di, di
	mov	cx, 7d00h		; В cx длина буфера
	rep stosw			; Инициализируем нулями цепочку слов по адресу ds:si и длиной 7dh (т. е. буфер) 
	popa				; Восстанавливаем использованные регистры из стека
	loop	@@CreateBuffers


; Инициализируем VGA режим 13h
	mov	ax, 13h			; 13h - графический режим (320x200x256)
	int	10h			; Видеосервис BIOS


; Получение адреса на таблицу шрифта с матрицей символа 8x8.
	mov	ax, 1130h               ; Получение указателя на таблицу символов
	mov	bh, 03h                 ; С матрицей символов 8x8
	xor	bl, bl                  ;
	int	10h			; Видеосервис BIOS
					; В es:bp - указатель на таблицу символов с матрицей 8x8
	mov	word ptr FontAddr, bp   ; Помещаем дальний адрес таблицы символов с матрицей 8x8
	mov	word ptr FontAddr+2, es ; В двойное слово FontAddr


; Инициализируем палитру
	mov	bl, MaxColor 		; Номер цвета
	mov	bh, 63       		; RED-составляющая
	mov	cl, 63       		; GREEN-составляющая
	mov	ch, 63       		; BLUE-составляющая
@@Set1:
	dec	bl			; Устанавливаем следующий цвет
	mov	al, bl                  ; В al номер цвета
	and	al, 1                   ; Если он не чётный
	jnz	@@Next1                 ; То идём на @@Next1
	dec	cl                      ; Уменьшаем GREEN - составляющую цвета на 1
	dec	bh                      ; Уменьшаем RED - составляющую цвета на 1
@@Next1:
	call	ScreenSetRGBPalette     ; Добавляем цвет в палитру
	cmp	bl, 2*63                ; Если номер цвета в bl не равен 2*63
	jnz	@@Set1                  ; То идём на @@Set1
@@Set2:
	dec	bl                      ; Устанавливаем следующий цвет
	mov	al, bl                  ; В al номер цвета
	and	al, 1                   ; Если он не чётный
	jnz	@@Next2                 ; То идём на @@Next1
	dec	ch                      ; Уменьшаем BLUE - составляющую цвета
@@Next2:
	call	ScreenSetRGBPalette     ; Добавляем цвет в палитру
	test	bl, bl                  ; Если номер в bl не равен нулю
	jnz	@@Set2                  ; То переходим на @@Set2


	mov	bl, 2			; Просто, чтобы войти в цикл с первой строки сообщения
	xor	di, di			; Чистим di
;	push	di                      ; Сохраняем di в стеке

@@Repeat:
	dec	bl                      ; Уменьшаем bl  на 1
	jnz	@@NotChangeString	; Если не 0, то переходим на @@NotChangeString
	add	di, TextStringSize	; Если ноль, то к di прибавляем TextStringSize (длину строки)
	cmp	di, LastString		; Если di меньше LastString (длины всего сообщения)
	jl	@@NotLastString		; То переходим на @@NotLastString
	xor	di, di			; В противном случае снова выводим первую строку сообщения
@@NotLastString:
   	mov	bl, TextShowDelay	; В bl заносим задержку вывода текста
@@NotChangeString:
 	push	bx			; Сохраняем используемые регистры
 	push	di

 	push	DataSegment
  	pop 	ds

  	mov 	es, BufferFirst		; Настраиваем es на BufferFirst

  	cmp 	Exit, 0			; Сравниваем с нулём Exit (флаг выхода из программы)
	jnz 	@@Pass			; Если не 0, то переходим на @@Pass

   	mov 	si, offset string	; Помещаем в si смещение сообщения string
   	add	si, di			; В si помещаем смещение текущей строки для вывода
   	mov	cx, TextX		; Помещаем в cx координату X текста
   	mov	dx, TextY		; Помещаем в cx координату Y текста
   	mov	ah, TextColor		; Помещаем в ah цвет выводимой на экран строки
   	mov	bl, TextScale		; Помещаем в bl шкалу текста
   	call	BufferWriteString	; Пишем в буффер строку с заданными атрибутами

; Генерируем случайное число в ax в пределах [0..BufferSize-MaxX*2]
	mov	cx, BufferSize-MaxX*2   ; В cx BufferSize-MaxX*2
   	mov	ax, Seed	        ; В ax предыдущее случайное число
   	add	ax, 1234                ; Добавляем к ax число 1234
	xor	al, ah                  ; Выполняем поразрядное суммирование по модулю 2 над младшим и старшим байтами регистра слова в регистре ax
	add	ax, 4321                ; Добавляем к ax число 4321
   	xor	al, ah                  ; Выполняем поразрядное суммирование по модулю 2 над младшим и старшим байтами регистра слова в регистре ax
   	mov	Seed, ax                ; Запоминаем полученное случайное число в Seed
   	xor	edx, edx                ; Чистим edx
   	div	cx			; Делим случайное число в dx:ax на cx
   	mov	byte ptr es:[edx+MaxX], 255; Пересылаем 255 в байт по адресу [edx+MaxX], где edx содержит остаток от деления
@@Pass:
   	push	es			; Настройка ds на BufferFirst
   	pop	ds
	
	push    DataSegment
	pop	gs

	mov	es, gs:BufferSecond	; Настройка es на BufferSecond

; Применяем к буфферам следующий алгоритм ("Круги на воде")
;                   
;
; 	BufferFirst (участок):      BufferSecond (участок):
; 	┌───┬───┬───┬───┬───┐       ┌───┬───┬───┬───┬───┐
;	│   │   │   │   │   │       │   │   │   │   │   │
;	├───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┤
;	│   │   │ a │   │   │       │   │   │   │   │   │
;	├───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┤
;	│   │ b │ i │ d │   │       │   │   │ j │   │   │
;	├───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┤
;	│   │   │ c │   │   │       │   │   │   │   │   │
;	├───┼───┼───┼───┼───┤       ├───┼───┼───┼───┼───┤
;	│   │   │   │   │   │       │   │   │   │   │   │
; 	└───┴───┴───┴───┴───┘       └───┴───┴───┴───┴───┘
;
; 	Здесь i - обрабатываемый пиксел ([i] - цвет) в BufferFirst
;	      j - соответствующий ему пиксел ([j] - цвет) из BufferSecond
;	      a, b, c, d - пикселы, соседние с i (см. рисунок)
;	      [a], [b], [c], [d] - их цвета
;
;       1) W = ([a] + [b] + [c] + [d]) div 2 - [j]
;	2) если W < [j], то [j]:=0
;	 	         иначе [j]:= LowByte (W)
;
;	i,j=MaxX..SizeBuffer-MaxX
;	
;	Выводим содержимое первого буфера и меняем буферы ролями.
;	Проделываем с буферами всё, как описано выше.
;

	mov	si, MaxX		; Пропускаем первую строку буфера, чтобы не вылезти за границы буфера
@@Water:                                
	xor	ah, ah		        ; Чистим ah
   	mov	al, [si+1]	        ; В al цветсоседнего справа пиксела
   	mov	bx, ax                  ; Помещаем его в bx
   	mov	al, [si-1]              ; В al цветсоседнего слева пиксела
   	add	bx, ax                  ; Прибавляем его к bx
   	mov 	al, [si+MaxX]           ; В al цветсоседнего снизу пиксела
   	add 	bx, ax                  ; Прибавляем его к bx
   	mov 	al, [si-MaxX]           ; В al цветсоседнего сверху пиксела
 	add 	ax, bx                  ; Прибавляем к нему накопленную сумму
   	shr 	ax, 1                   ; Делим ax на 2
   	mov 	bl, byte ptr es:[si]    ; В bl цвет центрального байта из второго буфера
   	xor 	bh, bh                  ; Чистим верхнюю половину bx
   	sub 	ax, bx                  ; Из накопленной суммы отнимаем цвет центрального байта
   	jns 	@@Move                  ; Если ax < bx
    	xor 	ax, ax                  ; Чистим ax
@@Move:                                 
	mov	byte ptr es:[si], al	; В байт по адресу es:si помещаем содержимое al
	inc 	si			; Увеличиваем si  на 1
	cmp 	si, 64000-MaxX		; Если не достигнуто значение 64000-MaxX
	jnz 	@@Water			; То переходим на @@Water
	mov 	es, gs:BufferVideo	; В es адрес BufferVideo
	call 	BufferMove              ; Перемещаем BufferFirst в VideoBuffer

	push 	DataSegment			; Настраиваем ds на сегмент кода
	pop 	ds

	cmp 	Exit, 0			; Сравниваем exit с нулём
	jnz 	@@PassWrite		; Если не 0, то идём на @@PassWrite

	pop 	di			; Восстанавливаем di
	mov 	si, offset string	; В si пересылаем смещение String
	add 	si, di			; В si смещение текущей строки для вывода
	mov 	cx, TextX		; В cx X координату текста
	mov 	dx, TextY		; В cx Y координату текста
	xor 	ah, ah			; В ah цвет строки
	mov 	bl, TextScale		; В bl шкалу текста
	call 	BufferWriteString	; Пишем строку с заданными атрибутами в буффер

	push 	di			; Сохраняем содержимое di
@@PassWrite:
	push 	es			; Настраиваем ds на BufferVideo
	pop 	ds

; Применяем к буфферам следующий алгоритм ("Эффект размытия")
;                   
;
; 	BufferFirst (участок):      
; 	┌───┬───┬───┬───┬───┐       
;	│   │   │   │   │   │       
;	├───┼───┼───┼───┼───┤       
;	│   │   │ a │   │   │       
;	├───┼───┼───┼───┼───┤       
;	│   │ b │ i │ d │   │       
;	├───┼───┼───┼───┼───┤       
;	│   │   │ c │   │   │       
;	├───┼───┼───┼───┼───┤       
;	│   │   │   │   │   │       
; 	└───┴───┴───┴───┴───┘       
;
; 	Здесь i - обрабатываемый пиксел ([i] - цвет) в BufferFirst
;	      a, b, c, d - пикселы, соседние с i (см. рисунок)
;	      [a], [b], [c], [d] - их цвета
;
;       1) W = (([a] + [b] + [c] + [d]) div 4 + [i]) div 2
;	2) [i]:= LowByte (W)
;
;	i=MaxX..SizeBuffer-MaxX
;	
;	Выводим содержимое первого буфера и меняем буферы ролями.
;	Проделываем с буферами всё, как описано выше.
;
	mov	cl, BlurCount		; В cl количество применений эффекта размытия
@@Blur:    
	mov	di, MaxX		; Пропускаем первую строку буфера, чтобы не вылезти за пределы буфера
	xor 	ah, ah			; Чистим ah
@@B:
	mov 	al, [di+MaxX]		; В al цвет соседнего снизу пиксела
	mov 	bx, ax                  ; Помещаем его в bx
	mov 	al, [di-MaxX]		; В al цвет соседнего сверху пиксела
	add 	bx, ax                  ; Прибавляем его к bx
	mov 	al, [di+1]		; В al цвет соседнего справа пиксела
	add 	bx, ax                  ; Прибавляем его к bx
	mov 	al, [di-1]		; В al цвет соседнего слева пиксела
	add 	bx, ax                  ; Прибавляем его к bx
	shr 	bx, 2			; Делим содержимое bx на 4
	mov 	al, [di]		; Пересылаем в al цвет центрального пиксела
	add 	bx, ax			; К bx добавляем ax
	shr 	bx, 1			; Делим содержимое bx на 2
	mov 	[di], bl		; Пересылаем в [di], содержимое регистра bl
	inc 	di			; Увеличиваем содержимое регистра di на 2
	cmp 	di, BufferSize-MaxX	; Сравниваем di с BufferSize-MaxX
	jnz 	@@B			; Если не равно, то идём на @@B
	loop 	@@Blur			; Повторяем цикл

	mov	ds, gs:BufferVideo	; Настраиваем ds на BufferVideo
	push 	VideoMemory		; Настраиваем es на VideoMemory
	pop 	es
	call 	BufferMove		; Перемещаем BufferVideo в VideoMemory

	push 	DataSegment		; Настройка ds на сегмент кода
	pop 	ds

	mov 	ax, BufferFirst		; Меняем ролями буфферы BufferFirst и BufferSecond
	mov 	bx, BufferSecond
	mov 	BufferFirst, bx
	mov 	BufferSecond, ax

	pop 	di			; Восстанавливаем содержимое регистров di и bx
	pop 	bx

	cmp 	Exit, 0ffh		; Сравниваем флаг выхода со значением 0ffh (TRUE)
	jnz 	@@NotExit		; Если не равно, то идём на @@NotExit

	dec 	ExitDelay		; Уменьшаем ExitDelay (задержка при выходе) на 1
	jnz 	@@Repeat		; Если результат не 0, то идём на @@Repeat

	jmp 	@@RealExit		; Иначе выходим из программы
@@NotExit:
	in 	al, 60h			; Извлекаем в al последний SCAN-код клавиатуры
	dec 	al
	jnz	@@Repeat		; Если в al не 1, то нажата не клавиша Esc, идём на @@Repeat
	mov 	Exit, 0ffh		; Клавиша была нажата, устанавливаем признак выхода из программы
	jmp 	@@Repeat		; Идём на @@Repeat
@@RealExit:

	mov 	ax, 0003h		; Переход в текстовый режим (80x25)
	int 	10h			; Видеосервис BIOS

	pop	gs
	pop	es
	pop	ds
	popa

	ret

ShowAbout ENDP


ScreenSetRGBPalette PROC NEAR
;──────────────────────────────────────────────────────────────────────
; Процедура: Установка цвета в палитре
;            Вход:  bl - номер цвета
;                   bh - RED составляющая
;		    cl - GREEN составляющая
;                   ch - BLUE составляющая
;	     Выход: нет
;──────────────────────────────────────────────────────────────────────

	push	ax			; Сохраняем используемые регистры
	push    bx
	push	dx
	push	cx

	mov 	dx, 3c8h		; В порт 3c8h посылаем номер цвета
	mov 	al, bl
	out 	dx, al

	mov 	dx, 3c9h		; В порт 3c9h посылаем последовательно 

	mov 	al, bh			; RED - составляющие цвета
	out 	dx, al

	mov 	al, cl			; GREEN - составляющие цвета
	out 	dx, al

	mov 	al, ch			; BLUE - составляющие цвета
	out 	dx, al

	pop	cx			; Восстанавливаем изменённые регистры
	pop     dx
	pop     bx
	pop	ax

	ret				; Возвращаемся в точку вызова

ScreenSetRGBPalette ENDP


BufferMove PROC NEAR
;──────────────────────────────────────────────────────────────────────
; Процедура: Перемещение буферов
;            Вход:  ds    - адрес буфера источника
;                   es    - адрес буфера приёмника
;	     Выход: нет
;──────────────────────────────────────────────────────────────────────

	push	cx			; Сохраняем используемые регистры
	push	si
	push	di
	
	xor 	si, si			; Чистим индексы буферов
	xor	di, di

	mov	cx, 7d00h		; Пересылаем 32000 слов из буфера по адресу ds:si в буфер по адресу es:di
	rep movsw

	pop	di			; Восстанавливаем содержимое регистров до вызова
	pop	si
	pop	cx

	ret				; Возвращаемся в точку вызова

BufferMove ENDP


BufferWriteString PROC NEAR
;──────────────────────────────────────────────────────────────────────
; Процедура: Запись строки в буфер
;            Вход:  es    - адрес буфера
;		    ds:si - адрес строки
;		    ah	  - цвет
;		    bl    - шкала текста
;                   cx    - X координата строки
;		    dx    - Y координата строки
;	     Выход: нет
;──────────────────────────────────────────────────────────────────────

	pusha				; Сохраняем используемые регистры

@@Write:
	lodsb				; Грузим байт (символ) в al из цепочки (строки) по адресу в ds:si
	test	al, al			; Если очередной байт "нуль" (признак конца строки)
	jz	@@Exit			; То выходим

	push	bx			; Сохраняем всё, что будет изменено
	pusha
	push	ds

	lds	si, FontAddr		; В ds:si адрес FontAdr

	push	ax			; Сохранякм ax 

	xor	ah, ah			; Чистим ah
	shl	ax, 3			; Умножаем ax (код выводимого символа) на 8 (т. к. матрица символа 8x8) и прибавляем к si
	add	si, ax			; Теперь в si смещение матрицы выводимого символа относительно начала таблицы символов

	xor 	di, di			; Чистим di
	mov	ax, MaxX		; В ax помещаем количество пикселов в строке экрана
	mul	dx			; Умножаем координату Y на количество пикселов в строке экрана
	mov	di, ax			; В di помещаем результат умножения
	add 	di, cx			; Добавляем к di содержимое cx (т. е. X координату)
					; Теперь в di смещение в буфере, соответствующее координатам (X, Y) выводимого текста

	pop 	ax			; Восстанавливаем ax

	mov 	dl, bl			; В dl шкалу текста
	mov 	bh, BiosFontSize	; В bh размер шрифта
	xor 	dh, dh			; Чистим dh
@@DrawChar:
	lodsb				; Грузим из цепочки матрицы символа очередную битовую строку
	mov 	bl, BiosFontSize	; В bl размер шрифта
@@DrawLine:         
	shl 	al, 1			; Помещаем в cf очередной бит из битовой строки
	inc 	ah			; Увеличиваем ah на 1 (в ah сейчас цвет)
	jnc 	@@Next			; Если cf<>1, то идём на @@Next

	push 	ax			; Сохраняем ax и di (они будут изменены)
	push 	di

	xchg 	ah, al			; Помещаем в al содержимое ah (цвет), а затем в ah содержимое dl (шкалу текста)
        mov 	ah, dl
@@Draw:
        mov	cl, dl			; В cx шкалу текста
        xor	ch, ch

        rep stosb			; Иинициализируем буфер, а точнее первые cx (шкала текста) байт по адресу es:di цветом из al

        add 	di, MaxX		; К di прибавляем MaxX. 
        sub 	di, dx			; Отнимаем от di шкалу текста в dx
					; К следующей строке масштабированного пиксела

        dec 	ah			; Уменьшаем количество подлежащих выводу строк масштабированного пиксела на 1
        jnz 	@@Draw			; Если не 0 то бежим на @@Draw

        pop 	di			; Восстанавливаем di и ax 
        pop 	ax

@@Next:
        add 	di, dx			; В dx сейчас шкала текста. Её-то мы и добавим к di
        dec 	bl			; В bl сейчас размер шрифта. Уменьшаем его на 1.
        jnz 	@@DrawLine		; Если не 0, то продолжаем выводить остальные масштабированные пикселы

	push	ax                      ; Сохраняем ax
        push 	dx			; Сохраняем dx (будет изменён) в нём сейчас шкала текста
	mov	ax, MaxX-BiosFontSize	; В ax MaxX-BiosFontSize
	mul	dx                      ; Умножаем на шкалу текста
	add	di, ax                  ; В di - смещение следующего символа в буфере 
       	pop 	dx			; Восстанавливаем dx
        pop 	ax			; Восстанавливаем ax

        dec 	bh			; Уменьшаем количество не выведенных линий символа на 1
        jnz 	@@DrawChar		; Если не 0 идём на @@DrawChar. Рисовать следующую линию символа

        pop 	ds			; Восстанавливаем, всё как было до вызова (за исключением si и al)
        popa
        pop 	bx

	push	ax			; Сохраняем ax
	mov	al, BiosFontSize        ; В ax BiosFontSize
	mul	bl                      ; Умножаем на шкалу текста в bx
	add	cx, ax                  ; Результат прибавляем к cx, т. о. в cx - X координата следующего выводимого символа
	pop	ax			; Восстанавливаем ax

      	jmp 	@@Write			; Идём на @@Write
@@Exit:
        popa				; Восстанавливаем содержимое регистров до вызова
        ret				; Возвращаемся в точку вызова

BufferWriteString ENDP

	ProgSizeInPar equ (PspSize + StackSize + DataSize + ($-Main) ) shr 4 + 4

CodeSegment ENDS

end Main
