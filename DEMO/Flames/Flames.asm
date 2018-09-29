	%TITLE ""

        IDEAL
        MODEL	small
        STACK	1024

        INCLUDE 'gr.inc'

;сегмент для первого фрейма--------------------------------------
SEGMENT	F1Seg Word Public 'Fr1Data'
	Frame1	db	32000 dup(?)	;1-й
ends F1Seg

;сегмент для второго фрейма--------------------------------------
SEGMENT	F2Seg Word Public 'Fr2Data'
	Frame2	db	32000 dup(?)	;2-й
ends F2Seg

;сегмент данных================================================
	DATASEG

	seed	dd	?	;зерно жара

	pal	db	0,0,0		;палитра

	i=1
	rept	7
		db	0, 0, i*2
		i=i+1
	endm

	i=0
	rept	8
		db	i*2, 0, 16-2*i
		i=i+1
	endm

	i=0
	rept	16
		db	16+47*i/16, 0, 0
		i=i+1
	endm

	i=0
	rept	24
		db	63, 21*i/8, 0
		i=i+1
	endm

	i=0
	rept	24
		db	63, 63, 21*i/8
		i=i+1
	endm

	db	179*3 dup(63)		;доделали палитру

	CODESEG
P486
Start:
	GoGraph
;---------------------------здесь пишем код---------------------------

        call	randomize
	mov	ax, @data               ; устанавливаем палитру
	mov	ds, ax
	mov	dx, 3c8h		; устанавливаем палитру
	xor	al, al
	out	dx, al
	inc	dx
	mov	cx, 256*3
	mov	si, offset pal

	align   2
@@p1:
        mov     al, [si]
        out     dx, al
        inc     si
	loop	@@p1

        cld

	mov     ax, F1Seg	; установим в доп. сегментные регистры
	mov     fs, ax		; наши сегменты (только 386 и выше)
        mov     ax, F2Seg
        mov     gs, ax

	push    fs                      ; очистим первый фрейм
        pop     es
        xor     di, di
        xor     eax, eax
        mov     cx, 320*50
        rep stosd

        push    gs                      ; очистим второй фрейм
        pop     es
        xor     di, di
        xor     eax, eax
        mov     cx, 320*50
        rep stosd

        align   2
@@l0:
        push    fs
        pop     ds
        mov     si, 321
        push    gs
        pop     es
        mov     di, 1
        mov     cx, 320*100-322
        xor     bl, bl

        align   2
@@l1:
        xor     ax, ax
        add     al, [si-320]
        adc     ah, bl
        add     al, [si+320]
        adc     ah, bl
        add     al, [si-1]
        adc     ah, bl
        add     al, [si+1]
        adc     ah, bl
        add     al, [si-321]
        adc     ah, bl
        add     al, [si+321]
        adc     ah, bl
        add     al, [si-319]

        adc     ah, bl
        add     al, [si+319]
        adc     ah, bl
        shr     ax, 3

        or      ax, ax
        je      short @@l2
        dec     al
        align   2

@@ddd:

@@l2:
        mov     [es:[di]], al
        inc     di
        inc     si
	loop	@@l1

        mov     edx, 69069
        mov     di, 320*98
        mov     cx, 320
        mov     ax, @data
        mov     ds, ax
        mov     eax, [seed]
        align   2

@@l3:
        imul    eax, edx
        inc     eax
        mov     bl, ah
        and     bl, 0fh
        add     bl, 64
        mov    	[es:[di-320]], bl
        imul    eax, edx
        inc     eax
        mov     bl, ah
        and     bl, 0fh
        add     bl, 64
        mov     [es:[di]], bl
        imul    eax, edx
        inc     eax
        mov     bl, ah
        and     bl, 0fh
        add     bl, 128
        mov     [es:[di+320]], bl
        inc     di
 	loop	@@l3

        imul    eax, edx
        inc     eax
        mov     cl, al
        and     cx, 000fh
        mov     si, 320*98
        align   2
@@l4:
        imul    eax, edx
        inc     eax
        mov     ebx, eax
        mov     bl, bh
        xor     bh, bh
        mov     di, si
        add     di, bx
        add     di, 32
        xor     bl, bl
        not     bl
        mov     [es:[di-320]], bl
        mov     [es:[di+320]], bl
        mov     [es:[di-1]], bl
        mov     [es:[di+1]], bl
        mov     [es:[di]], bl
        mov     [es:[di-319]], bl
        mov     [es:[di+319]], bl
        mov     [es:[di-321]], bl
        mov     [es:[di+321]], bl
	loop	@@l4

;        mov	eax, 11;77
;        call	Random			;без них лучше

	mov     [seed], eax		; сохранить случ. зерно

       	cld

	mov	ax, 0a000h
        mov	es, ax
        mov	di, 320*100
        push    gs
	pop     ds
        xor	si, si
	mov     cx, 320*25
	rep movsd

	push    fs                      ; сменить фреймы
	pop     ax
	push    gs
	pop     fs
	push	ax
	pop	gs

        in	al,60h
	cmp	al,1
	jne	@@l0			; а теперь повторяем пока не нажали esc


;----------------------------------------------------------------------
        GoText
Exit:
	mov	ax, 4c00h
	int	21h
;==============================================================
;-------------------------------------------------------------------------------
;чья-то процедурка для сл. чисел
;-------------------------------------------------------------------------------
RandSeed        dd       0

Proc Randomize
                mov      ah,2Ch
                int      21h
                mov      [Word ptr cs:[RandSeed]],cx
                mov      [Word ptr cs:[RandSeed+2]],dx
                ret
endP Randomize

;-------------------------------------------------------------------------------
; In:  AX - Range
; Out: AX - Value within 0 through AX-1
; Destroys: All ?X and ?I registers
proc Random
                mov      ecx,eax          ; save limit
                mov      ax,[Word ptr cs:[RandSeed+2]]
                mov      bx,[Word ptr cs:[RandSeed]]
                mov      esi,eax
                mov      edi,ebx
                mov      dl,ah
                mov      ah,al
                mov      al,bh
                mov      bh,bl
                xor      bl,bl
                rcr      dl,1
                rcr      eax,1
                rcr      ebx,1
                add      ebx,edi
                adc      eax,esi
                add      ebx,62e9h
                adc      eax,3619h
                mov      [word ptr cs:[RandSeed]],bx
                mov      [word ptr cs:[RandSeed+2]],ax
                xor      edx,edx
                div      ecx
                mov      eax,edx                  ; return modulus
                ret
EndP Random

	END	Start
