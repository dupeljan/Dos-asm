; ����᪠� �ணࠬ�� - ���� ������� 50�50 � ०��� 13h
; � ������ ���室�� ��ਡ�⮢ (��. "��।�����")
; ��室 - �� ������ Esc
; ���� - ���� �., ���_21_1_��.

        .186
        .model tiny
	.code
	org 100h

start:  mov bx,cs         ;� bx - seg ᥣ���� ����
        add bh,20h        ;�ਡ���塞 2000h � bx
        mov ds,bx         ;� ��࠭塞 � ds (⠬ �㤥� ���� ���⨭��)
        mov ax,13h        ;� ax - ����� �����०���
        int 10h           ;����砥� �����०�� 13h

Main:   push ds           ;seg ���� - � �⥪
        pop es            ;� ��⥬ � es
        in ax,40h         ;���� "��砩���" �᫮ (�� ⠩���)
        shl ax,4          ;㬭����� ��� �� 16
        mov di,ax         ;ᬥ饭�� ������ ("��砩���")
        mov al,255        ;梥� ������
        mov bx,50         ;���� = 50

pl:     add di,270        ;di+270 (320-�ਭ�(50))
        mov cx,50         ;50 ���⮢
        rep stosb         ;�����㥬 � ����
        dec bx            ;㬥��訬 bx
        jnz pl            ;� ���� bx �� �⠭�� ���

        mov bh,0FAh       ;� bx 0FA00h (�.� bl=0)

Sglazh: mov al,[bx+1]     ; al <- 梥� �ࠢ�
        mov cl,[bx-1]     ; cl <- 梥� ᫥��
        add ax,cx         ;�ਡ���� ��� � ax
        mov cl,[bx-320]   ; cl <- 梥� ᢥ���
        add ax,cx         ;�ਡ���� ��� ᭮�� � ax
        mov cl,[bx+320]   ; cl <- 梥� ᭨��
        add ax,cx         ;� ᭮�� �ਡ���� ��� � ax
        shr ax,2          ;������� �� 4
        mov [bx],al       ;� ����襬 "ᣫ������" 梥� � ����
        dec bx            ;㬥��訬 bx
        jnz Sglazh        ;� �த������ ���� �� �� 0

                          ;�����㥬 ��㭮� � �����������
        mov ax,0A000h     ;seg VGA
        mov es,ax         ;����襬 � es
        mov ch,0FAh       ;�⮫쪮 ���⮢ ᪮��஢��� � VGA
        xor di,di         ;���㫨� ᬥ饭�� VGA
        xor si,si         ;���㫨� ᬥ饭�� ����
        rep movsb         ;�믮��塞 ����஢����
        in al,60h         ;������ �뫠 �����?
        dec al            ;�� �� Esc?
        jnz Main          ;���, �த������ - ᫥���騩 ������
        ret               ;��, �����稬 ࠡ���

	end start
