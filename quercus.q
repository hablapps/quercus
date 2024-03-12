/ quercus: parser combinators for q

\d .qu

l:{$[x~count[x]#y;(count[x]_y;x);()]} / literal
c:{[x:`c;y]$[x~first y;(1_y;x);()]} / char
rep:{r:();while[not ()~()a:x y;y:a 0;r,:a 1];(y;r)} / repeat
cin:{$[(y1:first y)in x;(1_y;y1);()]} / char in
num:{@[rep[cin["0123456789"]][x];1;"J"$]} / number
par:{$[()~r:x z;y z;r]} / parallel
end:{$[x~"";("";());()]} / $
bnd:{$[()~r:x z;r;y[r 1][r 0]]} / monadic bind
ret:{(y;x)} / return
map:{bnd[y;(ret x::)][z]} / map
seq:{(s0;a):x z;(s1;b):y s0;(s1;(a;b))} / sequence TODO use bnd
e:{$[()~r:x y;'`parse;not ""~r 0;'`remainder;r 1]} / eval

