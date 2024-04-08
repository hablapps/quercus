\l ../quercus.q
\d .qu

/ types
aT:upr;
cT:plus[upr;digit];
dT:plus[chr",";digit];
nT:digit;
xT:plus[alphanum;oneof"/–?:().,‘+"];

/ block
block:{braces bind[x] seql[j;chr":"]};
field:block;

/ block 1, basic header
aid:oneof"AFL";
sid:(plus/)(str')("01";"03";"21");
lt:seq .(times[;aT]')4 2;
lcd:3#cT;
loc:seqA((tos')lcd,times[3;aT]),((toj times[;digit]::)')4 6;
bhd:seqA((tos')aid,sid,lt),loc;

/ block 2, application header
ioid:oneof"IO";
tpe:toj times[3;nT];
add:tos times[12;xT];
pri:tos oneof["SUN"];
del:{$[x~`U;oneof"13";x~`N;chr"2";zero]};
ahd:seqA ioid,tpe,add,bind[(opt del::);pri];

/ block 3, user header
kl3:103 113 108 119 115!((times . ::)')((3;aT);(4;xT);(16;xT);(8;cT);(32;xT));
uhd:many field kl3;

/ block 4, text
p20:upto[16;xT];
p23B:times[4;cT];
p32A:seqA times[6;nT],times[3;aT],upto[15;dT];
p53A:seqA(times[4;aT];times[2;aT];times[2;cT];opt times[3;cT]);
p53B:upto[32;xT];
p53D:upto[4;seql[upto[35;xT];chr"\n"]];
kl4:`20`23B`32A`53A`53B`53D!p20,p23B,p32A,p53A,p53B,p53D;
nme:seqr[chr":";seql[tos many1 alphanum;chr":"]];
sub:bind[{map[{(x;y)}[x]] kl4 x}]nme;
man:fil[(all `20`23B in key::)];
txt:man seql[map[((!). flip::)]many1 seqr[chr"\n";sub];str"\n-"];

/ SWIFT parser
p:seql[many block 1 2 3 4!bhd,ahd,uhd,txt;eof];
swift:rparse[p];
\d .

