    {$S-;$I-;$R-;$Q-;$D-;$W-;$A-;$Y-}
  procedure WriteChar(c: Byte);
  begin
    asm
      mov ah, $02
      mov dl, c
      int 21h
    end;
  end;
const
  n=9;
var
  i, j, k, l, m, p: Integer;
  A: Array[1..n,1..n] of Byte;
 
begin
  i:=1;
  j:=0;
  k:=1;
  m:=n;
  l:=1;
  while k<=n*n do
  begin
    p:=1;
    while p<=m do
    begin
      Inc(j, l);
      A[i,j]:=k;
      Inc(k);
      Inc(p);
    end;
    Dec(m);
    p:=1;
    while p<=m do
    begin
      Inc(i, l);
      A[i,j]:=k;
      Inc(k);
      Inc(p);
    end;
    l:=-l;
  end;
  i:=1;
  repeat
    j:=1;
    repeat
      WriteChar($20);
      if A[i,j] div 10=0 then WriteChar($20)
      else WriteChar(A[i,j] div 10+48);
      WriteChar(A[i,j] mod 10+48);
      Inc(j);
    until j>n;
    WriteChar($A);
    WriteChar($D);
    Inc(i);
  until i>n;
  asm
    mov ah, $01
    int 21h
  end;
end.