; Быков Денис ФПМ 2-й курс 21 группа 2000 г.
JUMPS
ASSUME CS:_Code,DS:_DATA,SS:_Stack

_Stack Segment stack
    db 2048 dup (?)
_Stack EndS
─────────────────────────────────────────────────────────────────────────────
_Data  Segment
       flames       db 32*64 dup (0)	; даём 2 фрейма (чёрненьких (пока))
       new_flames   db 32*64 dup (0)	;
       x            dw 0		; если не понятно - я не виноват
       y            dw 0


_Data  EndS

_Code  Segment

start:
       push ds
       xor  ax,ax
       push ax
       ASSUME ds:_DATA
       mov  ax,_DATA
       mov  ds,ax

       mov  ax,0013h		;переходим в гр. режим 320*200
       int  10h

       mov  dx,03c8h		; дальше устанавливаем палитру
       xor  al,al
       out  dx,al
       inc  dx
       mov  cx,8
@set_red:
       mov  al,16		; комментарии (кому они такие-то нужны?)
       sub  al,cl		; но кроме них и писать то вроде бы и нечего :)
       shl  al,3		; быстрое умножение на 4
       out  dx,al
       xor  al,al		; унуляем ax
       out  dx,al
       out  dx,al
       loop @set_red		; повторяем это 16 раз (а то вы не поняли:)

       mov  cx,16		;теперь жёлтый
@set_yellow:
       mov  al,60
       out  dx,al
       mov  al,16
       sub  al,cl
       shl  al,2
       out  dx,al
       xor  al,al
       out  dx,al
       loop @set_yellow

       mov  cx,16		; белый
@set_white:
       mov  al,60
       out  dx,al
       out  dx,al
       mov  al,16
       sub  al,cl
       shl  al,2
       out  dx,al
       loop @set_white

       mov  cx,208		; какие цвета остались - все белые
       mov  al,63		; и правильно - кому они нужны

@whithey:
       out  dx,al
       out  dx,al
       out  dx,al
       loop @whithey

@WaitESC:

       push ds				; о как извернулся!!!
       pop  es
       cld				;сброс флага назначения (на всякий случай)

       lea  di,flames			;загрузим в di смещение
       mov  si,di
       add  di,64
       add  si,96
       mov  cx,61*16
       rep  movsw			; Scroll the array 1 step up

       inc  di
       add  di,5
       mov  cx,4
@put_hot_spots:
       push di
       push cx
       push di
       mov  ax,20			; дать x для искры (случайный)
       call random
       pop  di
       add  di,ax
       push di
       mov  ax,190                      ; дать y для искры (случайный)
       call random
       pop  di
       pop  cx
       mov  ah,al
       mov  [di],ax			; установить искру
       pop  di
       loop @put_hot_spots		; вставить 4 новых искры

       mov  word ptr x,1
       mov  word ptr y,1
@scanning_flames:			; обсчитываем новый массив
       mov  di,y			; обсчитываем 8 точек вокруг текущей
       shl  di,5
       add  di,x
       xor  ax,ax
       xor  bx,bx
       mov  bl,flames[di-33]
       mov  al,flames[di-32]
       add  bx,ax
       mov  al,flames[di-31]
       add  bx,ax
       mov  al,flames[di-1]
       add  bx,ax
       mov  al,flames[di+1]
       add  bx,ax
       mov  al,flames[di+31]
       add  bx,ax
       mov  al,flames[di+32]
       add  bx,ax
       mov  al,flames[di+33]
       add  bx,ax
       shr  bx,3
       mov  new_flames[di],bl		; сохраняем полученую точку в new_flame
       inc  x
       cmp  word ptr x,32
       jb   @scanning_flames
       mov  word ptr x,1
       inc  y
       cmp  word ptr y,64
       jb   @scanning_flames		; досчитали весь массив

       lea  di,flames
       lea  si,new_flames
       mov  cx,64*16
       rep  movsw			; засунули полученный фрейм в рабочий

       mov  ax,0a000h			; а теперь нарисуем это на экране
       mov  es,ax
       lea  si,flames
       mov  di,320*100+149
       mov  bx,60
@plot_it:
       mov  cx,16
       rep  movsw
       add  di,320-32
       dec  bx
       jnz  @plot_it			; Plot the flames

       mov  dx,03dah
@bettan:
       in   al,dx
       test al,8
       je   @bettan
@bettan2:
       in   al,dx
       test al,8
       jne  @bettan2			; подождём конца вертикальной развёртки


       in   al,60h
       cmp  al,1
       jne  @WaitESC			; а теперь повторяем пока не нажали esc

       mov  ax,0003h			; текстовый режим и выход
       int  10h
       mov  ax,4c00h
       int  21h
;-------------------------------------------------------------------------------
;чья-то процедурка для сл. чисел
;-------------------------------------------------------------------------------
RandSeed        dd       0

Randomize       Proc
                mov      ah,2Ch
                int      21h
                mov      Word ptr cs:[RandSeed],cx
                mov      Word ptr cs:[RandSeed+2],dx
                ret
Randomize       endP

;-------------------------------------------------------------------------------
; In:  AX - Range
; Out: AX - Value within 0 through AX-1
; Destroys: All ?X and ?I registers
Random          proc
                mov      cx,ax          ; save limit
                mov      ax,Word ptr cs:[RandSeed+2]
                mov      bx,Word ptr cs:[RandSeed]
                mov      si,ax
                mov      di,bx
                mov      dl,ah
                mov      ah,al
                mov      al,bh
                mov      bh,bl
                xor      bl,bl
                rcr      dl,1
                rcr      ax,1
                rcr      bx,1
                add      bx,di
                adc      ax,si
                add      bx,62e9h
                adc      ax,3619h
                mov      word ptr cs:[RandSeed],bx
                mov      word ptr cs:[RandSeed+2],ax
                xor      dx,dx
                div      cx
                mov      ax,dx                  ; return modulus
                ret
Random          EndP

_Code  EndS
─────────────────────────────────────────────────────────────────────────────

END	start