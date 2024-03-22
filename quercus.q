/ quercus: parser combinators for q

\d .qu

ret:{enlist(x;y)};
bind:{raze({(a;s):y;x[a]s}[x]')y@};
map:{bind[(ret x::)]};
trav:{({bind[{map[{raze(x;y)}[y]][x]}[y]]x}/)(x')y};
seqA:trav[::];
zero:{[x]()};
plus:{x[z],y z};
many:{plus[bind[{map[(enlist[z],)]y x}[x;.z.s];x];ret()]};
many1:{bind[{map[(enlist[y],)]many x}[x];x]};
times:{$[x<1;ret();seqA x#y]};
sep1:{bind[{map[{enlist[x],y}[z]]many seqr[x;y]}[y;x]]x};
sep:{plus[sep1[x;y];ret()]};
item:{$[""~x;();enlist(first x;1_ x)]};
seq:{bind[{map[{(x;y)}y][x]}[y]]x};
seql:map[first]seq::;seqr:map[last]seq::;
sat:{bind[{$[x y;ret y;zero]}[x];item]};
range:{sat{(x<=z)&z<=y}[x;y]};
digit:range ."09";
lwr:range ."az";
upr:range ."AZ";
letter:plus[lwr;upr];
alphanum:plus[letter;digit];
str:{$[x~count[x]#y;enlist(x;count[x]_y);()]};
word:many letter;
num:many1 digit;
chr:{[x:`c]sat[(x=)]};
c:item;
j:map[("J"$)]num;
s:map[(`$)]word;

