;*****************************************************************************
;���� ���� � ���孮��⥫� �஥��- ����⨭ �������
;(� ᢮�� ᮠ����⢥ �஬�� 㬠�稢��)
;*****************************************************************************



.286
MODEL   small
STACK   256
;****************************************************************************
SETPALETTE   MACRO    ; 0-80h 梥� �� �୮�� �� ���⮣�
;****************************************************************************
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
ENDM
;****************************************************************************

        DATASEG
ExCode  DB      0
cnt     DB      0

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
       SETPALETTE
        xor  dx,dx
LINE:
        mov     di,si          ; ����ᨬ � es:di=(A000:si)
        mov     ax,80h         ; 80h=����� 梥�
        stosb                  ;

; ����p�� ��p����.
Flame: cmp     SI,0FA00H       ; �ᥢ����砩��� �窠 � �p������ ��p���?
       jae     short NxtP      ; �᫨ H�� - ��p�� ᫥������.
       lodsb                   ; ���뢠�� �� 梥�.
       or      AL,AL           ; ��窠 �p���? (��p��� ��祬�?)
       jz      short NxtP      ; �᫨ �� - ��p�� ᫥������.
       dec     AX              ; ���⮬ �� ������� ����訬
       mov     [SI-2],AL       ;    �⠢�� ��� ᫥��,
       mov     [SI],AL         ;    �p���,
       mov     [SI+13Fh],AL    ;    ᭨��
       mov     ds:[SI-141h],AL ;    � ᢥp��.
       ;mov     ds:[SI-281h],AL ;    � ᢥp��.
       ;mov     ds:[SI-500h],AL ;    � ᢥp��.
NxtP:  add     SI,DX           ; ��p�� ᫥������
       add     DX,1            ;    �ᥢ����砩��� ���.
       jnz     Flame           ; � ⠪ 65536 p��.

; ��室�� �� ����⮬� ESC, ��� �p�������� p�ᮢ���.
       in      AL,60h
       cmp     AL,1
       jne     LINE
       mov     AX,3
       int     10h

EXIT:   mov ah, 04Ch
        mov al, [ExCode]
        int     21h
        END     START