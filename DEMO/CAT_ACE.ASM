
CodeSeg   Segment  PARA
          org 100h
          Assume DS:CodeSeg,CS:CodeSeg
;-----------------------------------
Begin     Proc     Near
          Call      IniTab ; Инициализация таблици значений синуса
          Call      IniScr ; Установка режима Screen 320 * 200 VGA 256 colors
          Call      FillSc ; Заполнение приметивом
          Mov       Line,640 ; \
          Mov       Speed,65 ;  \
          Mov       Color,1  ;    1 sin
          Mov       Point,60 ;  /
          Call      Draw     ; /
          Mov       Line,21760 ; \
          Mov       Speed,255  ;  \
          Mov       Color,2    ;    2 sin
          Mov       Point,120  ;  /
          Call      Draw       ; /
          Mov       Line,42880 ; \
          Mov       Speed,15   ;  \
          Mov       Color,3    ;    3 sin
          Mov       Point,0    ;  /
          Call      Draw       ; /
          call      VertRetrace ; ожидание начала нового кадра 
          mov       Cl,1       ; \
          call      IniDac     ;  установка DAC для записи с 1 цвета
          mov       CX,3       ; \  
Blbl1:    mov       Al,63      ;  \
          out       DX,al      ;   \
          mov       Al,0       ;     1 цвет  RED  ,  2 цвет Green
          out       DX,al      ;     3 цвет Blue  ,  4 цвет Black
          out       DX,al      ;   /
          out       DX,al      ;  /
          loop      Blbl1      ; /
Blbl2:    Call      inicolors  ; установить текущие цвета с приращением 
          Call      SetAll     ;  установить все цвета с новым кадром 
          Mov       Ah,1   ;  \
          Int       16h    ;     если не нажата клавиша повтор
          jz        Blbl2  ;  /
          Call      DoneSc ;  вернутся в текстовый режим 
          Int 20h   ;  вернутся из com-программы
Begin     Endp
;-----------------------------------
IniScr    Proc     Near
          mov      AX,13h
          int      10h
          ret
IniScr    Endp
;-----------------------------------
FillSc    Proc     Near
          mov      BX,OffSet SinTab
          mov      DX,IniFill
          Les      DI,VidBuff
          mov      Ah,200
vlbl1:    mov      Al,Dh
          XLAT
          Add      Al,FirstColor
          mov      CX,160
vlbl2:    Stosb
          inc      Al
          Loop     vlbl2
          mov      CX,160
vlbl3:    Stosb
          dec      Al
          loop     vlbl3
          add      DX,DisFill
          Dec      Ah
          jnz      vlbl1
          Ret
FillSc    Endp
;-----------------------------------
Stop      Proc     Near
          mov Ah,0
          int 16h
          ret
Stop      Endp
;-----------------------------------
VertRetrace  Proc     Near
          mov DX,3DAh
vlbl4:    in  Al,DX
          Test Al,8
          jz  vlbl4
          ret
VertRetrace  Endp
;-----------------------------------
DisColor  Proc     Near
          mov AX,DisRed
          add NowRed,AX
          mov AX,DisGreen
          add NowGreen,AX
          mov AX,DisBlue
          add NowBlue,AX
          ret
DisColor  Endp
;-----------------------------------
SetColor  Proc     Near
          Mov AX,NowRed
          Mov Al,Ah
          XLAT
          Out DX,AL
          Mov AX,NowGreen
          Mov Al,Ah
          XLAT
          Out DX,AL
          Mov AX,NowBlue
          Mov Al,Ah
          XLAT
          Out DX,AL
          ret
SetColor  Endp
;-----------------------------------
IniDac    Proc     Near
          mov DX,3C7h
          in  Al,DX
          Inc DX
          Mov Al,Cl
          Out DX,AL
          Inc DX
          ret
IniDac    Endp
;-----------------------------------
iniColors Proc     Near
          mov AX,IniRed
          mov NowRed,AX
          add AX,DisRed
          mov IniRed,AX
          mov AX,IniGreen
          mov NowGreen,AX
          add AX,DisGreen
          mov IniGreen,AX
          mov AX,iniBlue
          mov NowBlue,AX
          add AX,DisBlue
          mov IniBlue,AX
          Ret
iniColors Endp
;-----------------------------------
SetAll    Proc      Near
          call VertRetrace
          mov Cl,FirstColor
          call IniDac
          mov CX,224
vlbl6:    Call DisColor
          Call SetColor
          Loop vlbl6
          ret
SetAll    Endp
;-----------------------------------
Draw      Proc     Near
          Mov Road,0
          Mov CX,0
          Mov SI,320
Dlbl:     inc Point
          mov Al,Point
          XLAT
          Mov Ah,0
          Mul SI
          Add Ax,CX
          Mov DI,Line
          Add DI,AX
          Mov Al,Color
          stosb
          Mov Al,Speed
          Add Road,Al
          jnc Dlbl
          inc CX
          cmp CX,320
          jnz Dlbl
          ret
Draw      Endp
;-----------------------------------
DoneSc    Proc     Near
          mov AX,3
          int 10h
          ret
DoneSc    Endp
;-----------------------------------
SinStep   Proc     Near
          mov      AX,23
          inc      SI
          mul      SI
          inc      SI
          mul      SI
          mov      BX,AX
          mov      AX,227
          mul      Ampl
          div      BX
          mul      DI
          mov      AX,DX
          mul      DI
          mov      Ampl,DX
          ret
SinStep   Endp
;-----------------------------------
FixSin    Proc     Near
          mov      Res,8
          mov      Ampl,1FF0h
          mov      DI,AX
          mov      SI,0
          mov      CX,3
FSlbl:    call     SinStep
          add      Res,DX
          call     SinStep
          sub      Res,DX
          loop     FSlbl
          ret
FixSin    Endp
;-----------------------------------
MSin      Proc     Near
          DB 60h  ;---pusha---
          call     FixSin
          DB 61h  ;---popa----
          mov      AX,Res
          ret
MSin      Endp
;-----------------------------------
IniTab    Proc     Near
          mov      CX,127
ITlbl:    call     IniOne
          loop     ITlbl
;-----------------------------------
IniOne    Proc     Near
          mov      Ah,Cl
          shl      Ah,1
          mov      AL,0
          call     MSin
          mov      BX,CX
          mov      SinTab[BX],Ah
          mov      DX,4000h
          sub      DX,AX
          mov      SinTab[BX+128],Dh
          ret
IniOne    Endp
;-----------------------------------
IniTab    Endp
;-----------------------------------
VidBuff   Label     DWORD
VBDIS     DW        0
VBSEG     DW        0A000h
IniFill   DW        8
DisFill   DW        0200h
FirstColor db       7
IniRed    DW        3000h
DisRed    DW        200h
IniGreen  DW        4000h
DisGreen  DW        260h
IniBlue   DW        5000h
DisBlue   DW        2e0h
;-----------------------------------
NowRed    DW   ?
NowGreen  DW   ?
NowBlue   DW   ?
Line      DW   ?
Ampl      DW   ?
Res       DW   ?
Road      DB   ?
Speed     DB   ?
Color     DB   ?
Point     DB   ?
SinTab    DB   256 dup(?)
;-----------------------------------
CodeSeg   Ends
          End



