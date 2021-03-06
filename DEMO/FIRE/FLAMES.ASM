; �몮� ����� ��� 2-� ���� 21 ��㯯� 2000 �.
JUMPS
ASSUME CS:_Code,DS:_DATA,SS:_Stack

_Stack Segment stack
    db 2048 dup (?)
_Stack EndS
�����������������������������������������������������������������������������
_Data  Segment
       flames       db 32*64 dup (0)	; ��� 2 �३�� (��୥�쪨� (����))
       new_flames   db 32*64 dup (0)	;
       x            dw 0		; �᫨ �� ����⭮ - � �� �������
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

       mov  ax,0013h		;���室�� � ��. ०�� 320*200
       int  10h

       mov  dx,03c8h		; ����� ��⠭�������� �������
       xor  al,al
       out  dx,al
       inc  dx
       mov  cx,8
@set_red:
       mov  al,16		; �������ਨ (���� ��� ⠪��-� �㦭�?)
       sub  al,cl		; �� �஬� ��� � ����� � �த� �� � ��祣� :)
       shl  al,3		; ����஥ 㬭������ �� 4
       out  dx,al
       xor  al,al		; ��塞 ax
       out  dx,al
       out  dx,al
       loop @set_red		; �����塞 �� 16 ࠧ (� � �� �� ���﫨:)

       mov  cx,16		;⥯��� ����
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

       mov  cx,16		; ����
@set_white:
       mov  al,60
       out  dx,al
       out  dx,al
       mov  al,16
       sub  al,cl
       shl  al,2
       out  dx,al
       loop @set_white

       mov  cx,208		; ����� 梥� ��⠫��� - �� ����
       mov  al,63		; � �ࠢ��쭮 - ���� ��� �㦭�

@whithey:
       out  dx,al
       out  dx,al
       out  dx,al
       loop @whithey

@WaitESC:

       push ds				; � ��� ��������!!!
       pop  es
       cld				;��� 䫠�� �����祭�� (�� ��直� ��砩)

       lea  di,flames			;����㧨� � di ᬥ饭��
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
       mov  ax,20			; ���� x ��� ���� (��砩��)
       call random
       pop  di
       add  di,ax
       push di
       mov  ax,190                      ; ���� y ��� ���� (��砩��)
       call random
       pop  di
       pop  cx
       mov  ah,al
       mov  [di],ax			; ��⠭����� ����
       pop  di
       loop @put_hot_spots		; ��⠢��� 4 ����� ����

       mov  word ptr x,1
       mov  word ptr y,1
@scanning_flames:			; �����뢠�� ���� ���ᨢ
       mov  di,y			; �����뢠�� 8 �祪 ����� ⥪�饩
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
       mov  new_flames[di],bl		; ��࠭塞 ����祭�� ��� � new_flame
       inc  x
       cmp  word ptr x,32
       jb   @scanning_flames
       mov  word ptr x,1
       inc  y
       cmp  word ptr y,64
       jb   @scanning_flames		; ����⠫� ���� ���ᨢ

       lea  di,flames
       lea  si,new_flames
       mov  cx,64*16
       rep  movsw			; ����㫨 ����祭�� �३� � ࠡ�稩

       mov  ax,0a000h			; � ⥯��� ����㥬 �� �� ��࠭�
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
       jne  @bettan2			; ������� ���� ���⨪��쭮� ࠧ���⪨


       in   al,60h
       cmp  al,1
       jne  @WaitESC			; � ⥯��� �����塞 ���� �� ������ esc

       mov  ax,0003h			; ⥪�⮢� ०�� � ��室
       int  10h
       mov  ax,4c00h
       int  21h
;-------------------------------------------------------------------------------
;���-� ��楤�ઠ ��� �. �ᥫ
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
�����������������������������������������������������������������������������

END	start