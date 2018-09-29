
var
	m : array [1..9,1..9] of word;
	i,j,r,p,n,k,way,b:word;
begin
	readln(k);
	n:=k;// max for auto;
	b:=k*k;
	i:=1;
	j:=1;
	r:=1;//for inc
	p:=1;// min for auto
	repeat
	// way for auto
		way:=0;
		repeat
			m[i,j]:= r;
			if ( ( i = p ) and ( j = n) ) or ( ( i = n) and ( j = n ) ) or ( (i = n) and ( j = p ) ) or ( (i = p+1) and (j = p) ) then
				inc(way);
				
			case way of
				0,4: inc(j);  //right
				1: inc(i);  //down
				2: dec(j); //left
				3: dec(i); //up
			end;
			inc(r);

		until( (way = 4) or (r > b) );
		
		dec(n);
		inc(p);

	until(r > b);


	for i:=1 to k do begin
		writeln;
		for j:=1 to k do 
			write(m[i,j]:3, ' ');
	end;
	writeln;
end.