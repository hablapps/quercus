\l ../quercus.q
\d .qu

/ types
aT:upr;
cT:plus[upr;digit];
dT:plus[chr",";digit];
nT:digit;
xT:plus[alphanum;oneof"/–?:().,‘+"];

/ type utils
todec:map[("F"$ssr[;",";"."]::)];
reify:map enlist;
yymmdd:tod times[6;nT];
hhmmss:tot times[6;nT];
ssx:map[(`time$(10*)::)]toj times[2;nT];
YYMMDDSSss:map[sum]seqA yymmdd,hhmmss,opt ssx;
dsh:chr"-";
slsh:chr"/";

/ block
block:{braces bind[{map[(y,enlist::)]x y}[x]] seql[tos upto[3;alphanum];chr":"]};
field:block;

/ block 1, basic header
k1:`AppID`ServiceID`LTAddress`SessionNumber,`$"Sequence Number";
aid:oneof"AFL";
sid:plus .(str')("01";"21");
lt:times[12;xT];
sesn:times[4;nT];
secn:times[6;nT];
bhd:map[k1!]seqA((tos')aid,sid),reify[lt],(toj')sesn,secn;

/ block 2, application header
ioid:oneof"IO";
tpe:toj times[3;nT];
add:tos times[12;xT];
pri:tos oneof["SUN"];
del:{$[x~`U;oneof"13";x~`N;chr"2";zero]};
ahd:seqA ioid,tpe,add,bind[(opt del::);pri];

/ block 3, user header
.b3.103:times[3;aT];
.b3.113:times[4;xT];
.b3.108:times[16;xT];
.b3.119:upto[8;cT];
.b3.423:YYMMDDSSss;
.b3.106:seqA yymmdd,((reify times . ::)')((12;xT);(3;cT);(4;nT);(6;nT));
.b3.424:upto[16;xT];
.b3.111:times[3;nT];
.b3.121:seqA times[8;xT],dsh,
             times[4;xT],dsh,
             chr["4"],times[3;xT],dsh,
             oneof["89ab"],times[15;xT];
.b3.115:upto[32;xT];
.b3.165:seqA slsh,times[3;cT],slsh,upto[34;xT];
.b3.433:seqA slsh,times[3;aT],opt seqr[slsh;upto[20;xT]];
.b3.434:seqA slsh,times[3;aT],opt seqr[slsh;upto[20;xT]];
uhd:fil[all `103`121 in key::] map[(!). flip::] many1 field get`.b3;

/ block 4, text
p20:upto[16;xT];
p23B:times[4;cT];
p32A:seqA times[6;nT],times[3;aT],todec upto[15;dT];
p53A:seqA(times[4;aT];times[2;aT];times[2;cT];opt times[3;cT]);
p53B:upto[32;xT];
p53D:upto[4;seql[upto[35;xT];chr"\n"]];
kl4:`20`23B`32A`53A`53B`53D!p20,p23B,p32A,p53A,p53B,p53D;
nme:seqr[chr":";seql[tos many1 alphanum;chr":"]];
sub:bind[{map[{(x;y)}[x]] kl4 x}]nme;
man:fil[all `20`23B in key::];
txt:man seql[map[(!). flip::]many1 seqr[chr"\n";sub];str"\n-"];

/ SWIFT parser
p:seql[many block `1`2`3`4!bhd,ahd,uhd,txt;eof];
swift:rparse[p];
\d .

