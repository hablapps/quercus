/ quercus: parser combinators for q
\d .qu

ret:{enlist(x;y)};
bind:{raze({(a;s):y;x[a]s}[x]')y@};
map:{bind[(ret x::)]};
trav:{({bind[{map[{raze(x;y)}[y]][x]}[y]]x}/)(x')y};
seqA:trav[::];
zero:{[x]()};
plus:{{x[z],y z}[x;y]};
mget:{enlist(x;x)};
mset:{[x;y]enlist(();x)};
mmod:{enlist(();x y)};
fil:{bind[{(zero;ret y)x y}[x]][y]};
opt:{plus[x;ret()]};
many:{plus[bind[{map[(enlist[z],)]y x}[x;.z.s];x];ret()]};
many1:{bind[{map[(enlist[y],)]many x}[x];x]};
upto:{fil[{x>=count y}[x]]many y};
times:{$[x<1;ret();seqA x#y]};
sep1:{bind[{map[{enlist[x],y}[z]]many seqr[x;y]}[y;x]]x};
sep:{plus[sep1[x;y];ret()]};
skip:map zero;
item:{$[""~x;();enlist(first x;1_ x)]};
seqf:{bind[{map[{x(y;z)}[x;z]][y]}[x;z]]y};
seql:seqf[first];seqr:seqf[last];seq:seqf[enlist .];
sat:{bind[{$[x y;ret y;zero]}[x];item]};
oneof:{sat in[;x]};
noneof:{sat(not in[;x]::)};
between:{seqr[x;seql[z;y]]};
range:{sat{(x<=z)&z<=y}[x;y]};
digit:range ."09";
lwr:range ."az";
upr:range ."AZ";
letter:plus[lwr;upr];
alphanum:plus[letter;digit];
str:{{$[x~count[x]#y;enlist(x;count[x]_y);()]}[x]};
word:many1 letter;
num:many1 digit;
chr:{[x:`c]sat[(x=)]};
spaces:skip many space:chr" ";
eof:{$[""~x;ret[()]x;zero x]};
parens:between[chr"(";chr")"];
braces:between[chr"{";chr"}"];
tod:map("D"$);
tof:map("F"$);
toj:map("J"$);
tos:map(`$);
tot:map("T"$);
c:item;
j:toj num;
s:tos word;

rparse:{$[()~r:x y;'`parse;1<count r;'`ambig;[(a;s):r 0;not ""~s];'`spare;a]};
vparse:{.[{[x]1b}rparse::;(x;y);0b]};
\d .

