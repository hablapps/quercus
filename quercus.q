/ quercus: parser combinators for q

\d .qu

ret:{enlist(x;y)}; / return
bnd:{raze({(a;s):y;x[a]s}[x]')y@}; / bind
map:{bnd[(ret x::)]}; / map
zer:{[x]()}; / zero
pls:{x[z],y z}; / plus
mny:{pls[bnd[{[x;y;z]map[(z,)][y x]}[x;.z.s];x];ret()]}; / many (stack-unsafe)
mny1:{bnd[{map[(y,)][mny[x]]}[x];x]} / many (at least 1)
itm:{$[""~x;();enlist(first x;1_ x)]}; / item
seq:{bnd[{map[{(x;y)}y][x]}[y]]x}; / sequence
sat:{bnd[{$[x y;ret y;zer]}[x];itm]}; / satisfies?
rng:{sat{(x<=z)&z<=y}[x;y]}; / char range
dig:rng["0";"9"]; / digit
lwr:rng["a";"z"]; / lower-case
upr:rng["A";"Z"]; / upper-case
let:pls[lwr;upr]; / letter
anm:pls[let;dig]; / alpha-numeric
str:{$[x~count[x]#y;enlist(x;count[x]_y);()]}; / string literal
wrd:mny let; / word
num:mny1 dig; / number
c:{[x:`c]sat[(x=)]}; / char
j:map[("J"$)]num; / long
s:map[(`$)]wrd; / symbol

