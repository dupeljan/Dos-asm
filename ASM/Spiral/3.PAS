const p: byte = 1;
	  ax:byte = 1;
	  bx:shortint = -1;
	  dx:byte = 0;
	  si:byte = 1;
var	mass : array [0..80] of word;  
	cx,dl,i,n : byte;		
begin
	write("n=");
	readln(n);
	cx:=n;
	dl:=-cx;
	while(cx <> 0) do begin
		for i:=1 to cx do begin
			bx:=bx+ax;
			mass[bx]:=p;
			inc(p);
		end;
		if ( dx = 0) then begin
			dec(cx);
			inc(dx);
			dl:=-dl;
			ax:=dl;
		end	else begin
			si:=-si;
			ax:=si;
			dec(dx);
		end;
	end;
	cx:=0;
	for i:=0 to n*n-1 do begin 
			write(mass[i]:4);
			inc(cx);
			if (cx=n) then begin
				writeln;
				cx:=0;
			end;
	end;
end.