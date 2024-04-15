\d .qu

\l ../quercus.q
\l tpe.q
\l u.q
\l b1.q
\l b2.q
\l b3.q
\l b4.q
\l b5.q

block:{braces bind[{map[y,enlist::]x y}[x]] seql[tos upto[3;alphanum];chr":"]};
field:block;

.sw.1:seqd 1_get`.b1;
.sw.2:bind[seqd 1_get `.b2I`.b2O "O"~ ::]oneof"IO";
.sw.3:fil[all `103`121 in key::] kv2d many1 field get`.b3;
.sw.4:man seql[kv2d many1 seqr[opt chr"\n";sub];str"\n-"];
.sw.5:fil[`CHK in key::] kv2d many1 field get`.b5;

p:kv2d seql[many block get`.sw;eof];
swift:rparse[p];
\d .

