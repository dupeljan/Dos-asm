.286
INCLUDE IO.ASM

        MODEL   small
        STACK   256

        DATASEG
ExCode  DB      0
cnt     DW      1

        CODESEG
START:
        mov     ax,@data
        mov     ds,ax

; ����砥� �p�䨪�, ����p������ p�����p�
       mov     AX,13h
       int     10h
       mov     BX,140h
       push    0A000h
       pop     ES
       push    ES
       pop     DS
       lodsb

        mov     ax,1010h
        mov     bx,1h
        mov     dh,0h ;R
        mov     ch,0h ;G
        mov     cl,0h ;B
L1:
        int     10h
        inc     bx
        inc     dh
        cmp     dh,40h
        jne     L1

        mov     dh,111111b
L2:
        int     10h
        inc     bx
        inc     ch
        cmp     ch,40h
        jne     L2
LINE:
        mov     cx,80h
        mov     dx,0A4h
        mov     bh,0
L3:
        mov     ah,0Ch
        mov     al,cl
        add     cl,30
        int     10h
        sub     cl,30
        loop    L3

        mov     cx,80h
        mov     ax,0A000h
        mov     es,ax
        mov     di,0CD9Fh
M1:
        mov     ax,cx
        stosb
        loop    M1

; _�H���H��_! ����� ᠬ�� ���p�᭮�.
; ����p�� ��p����.
Flame: cmp     SI,0FA00H       ; �ᥢ����砩��� �窠 � �p������ ��p���?
       jae     short NxtP      ; �᫨ H�� - ��p�� ᫥������.
       lodsb                   ; ���뢠�� �� 梥�.
       or      AL,AL           ; ��窠 �p���? (��p��� ��祬�?)
       jz      short NxtP      ; �᫨ �� - ��p�� ᫥������.
       dec     AX              ; ���⮬ �� ������� ����訬
       mov     [SI-2],AL       ;    �⠢�� ��� ᫥��,
       mov     [SI],AL         ;    �p���,
       ;mov     [BX+SI-1],AL    ;    ᭨��
       mov     ds:[SI-141h],AL ;    � ᢥp��.
       mov     ds:[SI-281h],AL ;    � ᢥp��.
       mov     ds:[SI-500h],AL ;    � ᢥp��.
NxtP:  add     SI,DX           ; ��p�� ᫥������
       inc     DX              ;    �ᥢ����砩��� ���.
       jnz     Flame           ; � ⠪ 65536 p��.

; ��室�� �� ����⮬� ESC, ��� �p�������� p�ᮢ���.
       in      AL,60h
       cmp     AL,1
       jne     LINE
       mov     AX,3
       int     10h

;pause
        ;mov     ah,08
        ;int     21h
;����-� ⥪��. ०���
        ;mov     ax,3h
        ;int     10h

EXIT:   mov ah, 04Ch
        mov al, [ExCode]
        int     21h
;**************************************
PUTPXL  PROC ; CX=x,DX=y,AL=color
;**************************************

        pusha

        mov     ah,0Ch
        int     10h

        popa

        ret
ENDP

        END     START