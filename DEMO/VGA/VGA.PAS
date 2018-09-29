begin
write('╤е');
end.
t,graph;
const
colors=196;
type
ppp=array [1..colors*3] of byte;
var
   r,g,b,i,u:integer;
   f:boolean;
   driver,mode:integer;
   midx,midy:integer;
   palette:ppp;
   m:pointer;
   v:char;

procedure _vgapal(rcol,gcol,bcol,cidx:byte);far;external;
{$L vga.obj}

procedure _vgapalette(segww,offsww:word; q:byte);far;external;

procedure svgadrv;external;
{$L svga256.obj}

begin

  Driver := InstallUserDriver('SVGA256', nil);
  if registerbgidriver(@svgadrv)<0 then halt(1);
  if Driver = grError then
    Halt(1);
  Mode := 0;
  InitGraph(Driver, Mode, '');
  randomize;
  midx:=getmaxx div 2;
  midy:=getmaxy div 2;
{Рисуем окружности уменьшающегося радиуса и цвета}

  for i:=colors downto 1 do begin
    setcolor(i);
    circle(midx, midy,i);
    setfillstyle(solidfill,i);
    floodfill(midx,midy,i);
  end;

palette[1]:=random(62); {первый цвет берем random}
palette[2]:=random(62);
palette[3]:=random(62);

{Генерируем палитру}

  for i:=4 to colors*3 do begin

    if palette[i-3]=63 then
    palette[i]:=random(62) else
    palette[i]:=palette[i-3]+1;

    if palette[i-2]=63 then
    palette[i+1]:=random(62) else
    palette[i+1]:=palette[i-2]+1;

    if palette[i-1]=63 then
    palette[i+2]:=random(62) else
    palette[i+2]:=palette[i-1]+1;

    i:=i+2;

  end;

  u:=0;

{Программируем палитру}

  for  i:=1 to colors*3 do begin

  _vgapal(palette[i],palette[i+1],palette[i+2],u);
  u:=u+1;
  i:=i+2
  end;

  repeat
{копируем n-1 цвет в n-й а 1му присваеваем следующий либо random}

for i:=1 to colors*3 do begin
palette[colors*3-i+1]:=palette[colors*3-i+1-3];
palette[colors*3-i+1-1]:=palette[colors*3-i+1-3-1];
palette[colors*3-i+1-2]:=palette[colors*3-i+1-3-2];
i:=i+2;
end;

if palette[4]=63 then palette[1]:=random(62) else palette[1]:=palette[4]+1;
if palette[5]=63 then palette[2]:=random(62) else palette[2]:=palette[5]+1;
if palette[6]=63 then palette[3]:=random(62) else palette[3]:=palette[6]+1;

{программируем палитру}
  _vgapalette(seg(palette),ofs(palette),colors);

  until keypressed;  v:=readkey;

f:=true;

{Так называемый fader effect}
while f do begin

      f:=false;

      for i:=1 to colors*3 do begin
          if palette[i]>0 then begin
          palette[i]:=palette[i]-1;
          f:=true;
          end;

      end;

  _vgapalette(seg(palette),ofs(palette),colors);

end;


  Closegraph;
  ClrScr;

  writeln('');
  writeln('Kewl DeM0! v. 0.99alpha');
  writeln('WriTten By EuGeNe Gridasov, 2:5063/41@FidoNet');
  writeln('Bye....');
end.program vgaeffect;
uses crt,graph;
const
colors=196;
type
ppp=array [1..colors*3] of byte;
var
   r,g,b,i,u:integer;
   f:boolean;
   driver,mode:integer;
   midx,midy:integer;
   palette:ppp;
   m:pointer;
   v:char;

procedure _vgapal(rcol