%TITLE "��� �������਩ �ணࠬ��"


MODEL small

ST1 SEGMENT             ;���ᠫ� ᥣ���� �⥪�;
 DB 128 DUP(?)
ST1 ENDS

outstr macro
    mov ah, 9
    int 21h
ENDM

CLS macro 
    mov ax, 0600h;����� �-樨 �஫���
    mov bh, 07    ; ��ਡ�� ��࠭� �
    mov cx, 0000h ; ����� ������ ������ �����
    mov dx, 184Fh ; �ࠢ�� ������ ������ �����
    int 10h
ENDM

pos macro str, stb
    mov ah, 02
    mov bx, 00
    mov dh, str
    mov dl, stb
    int 10h
ENDM

outch MACRO character
    push dx
    push ax
    mov dl, character
    mov ah, 2
    int 21h
    pop ax
    pop dx
ENDM

finish	MACRO

	MOV	AX,4C00h
	INT	21h

ENDM


DATA SEGMENT
;=======c�ப�===========
errorstr db 'ERROR$'
mulOnTwo db 'X2$' ; ����� 6
;========���-��========
 sign db 0
 numbers_were db 0  
 ten dw 10
 two dw 2
 ;=========��६����� ��� �뢮��====
 result dw 0
;=========���ᨢ ��� �����=====
 BUFF DB 30 ; ��� ���-��
 ActLen DB ? ; ⥪�饥 ���-��
 NameFld DB 30 DUP (?) ; ���� �����
DATA ENDS


CODE SEGMENT            ;���뫨 ᥣ���� ����;
ASSUME SS:ST1,DS:DATA,CS:CODE    ;�易�� ॣ���஢� ᥣ����� � ᥣ���⠬�;

Start:
 push ds
 push ax
 mov ax, data 
 mov ds, ax
;========== ���� ���� ��� ��� ==============================
    CLS
    pos 0,0
    outch 110
    outch 61
    mov ah, 0Ah
    lea dx, BUFF; ��� �-�� �����
    int 21h ; ����� ��ப�
   
   xor cx, cx
   xor bx, bx
   mov cl, ActLen
L1:xor ax, ax
   mov al, NameFld[bx]
        
   cmp al, 48 ; �஢��塞 ���祭�� �� �᫮
     jl signExpect
   cmp al, 57
     jg signExpect     ;�� �᫮ - �஢��塞 �� ����
   
   mov numbers_were , 1
   mov  ax, result
   mul ten
   sub ax , 48
   
   xor dx, dx
   mov dl, NameFld[bx]
   add ax , dx
   mov result , ax ; ������塞 � १�����  �� �᫮
   jmp next       ; ᫥� �����

signExpect:     
    cmp sign, 1  ; ���� �᫨ ����� �� �뫮
        je error  
   cmp numbers_were, 1   ; � �� �뫮 �ᥫ
       je error  ; 
    cmp al, 45   ;  � �᫨ ᥩ�� ����
        jne error
    mov sign , 1;    �����뢠�� ����
    jmp next
error:
    cmp al, 32   ; ���� �᫨ �� �஡��
        jne wasError ; � �訡��
    
next:

    inc bx
     
   loop L1
   ;�᪫ ����� - �� �뫮 ���
   cmp numbers_were, 1
     jne wasError
     
   cmp sign , 0 ; ���塞 ���� �� ����室�����
        je res
    neg result
res:  
      ; ��䬥� ����⢨� - 㬭������ �� 2
      mov cl , 1
      shl result, cl
      ; �뢥��� ��ப� X2
      ;pos 1,0
      ;mov ax, DATA
      ;mov ds, ax
      ;mov dx, 6 ; ᤢ��
      ;outstr
      ;outint result
      pos 1, 0 ; newline
      
      cmp result, 0 ; �᫨ ����� ���
        jge outintt
      outch 45 ; �뢮��� ����
      
      neg result  ;���塞 ����
outintt:  
      mov ax, result
      xor bx, bx
L2:   cmp ax, 0
        jle nextOut
      xor dx, dx
      div ten
      
      mov NameFld[bx], dl
      add NameFld[bx], 48
      
      inc bx
      
      jmp L2
nextOut:      
      mov cx, bx
      dec bx
      
L3:   outch NameFld[bx]
      dec bx
      loop L3
      
      
      jmp theEnd
wasError: ;newline
     pos 1,0
     mov ax, DATA
     mov ds,  ax
     mov dx, 0
     outstr
    ;outch 45
theEnd:
;========== �����稢��� ����� ��� ���======================
 pop ax
 pop ds
Exit:
 finish
ENDS

END Start
          
