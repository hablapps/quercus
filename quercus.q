/ quercus: parser combinators for q

\d .qu

ret:{enlist(x;y)};
bind:{raze({(a;s):y;x[a]s}[x]')y@};
map:{bind[(ret x::)]};
zero:{[x]()};
plus:{x[z],y z};
many:{plus[bind[{map[(enlist[z],)]y x}[x;.z.s];x];ret()]};
many1:{bind[{map[(enlist[y],)]many x}[x];x]};
item:{$[""~x;();enlist(first x;1_ x)]};
seq:{bind[{map[{(x;y)}y][x]}[y]]x};
sat:{bind[{$[x y;ret y;zero]}[x];item]}; / satisfies?
range:{sat{(x<=z)&z<=y}[x;y]};
digit:range ."09";
lwr:range ."az";
upr:range ."AZ";
letter:plus[lwr;upr];
alphanum:plus[letter;digit];
str:{$[x~count[x]#y;enlist(x;count[x]_y);()]};
word:many letter;
num:many1 digit;
c:{[x:`c]sat[(x=)]}; / char
j:map[("J"$)]num; / long
s:map[(`$)]word; / symbol

