/ SWIFT message parser

\l ../quercus.q
\d .qu

/ types
aT:upr;
cT:plus[upr;digit];
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
ioid:oneof"IO"
tpe:toj times[3;nT];
add:tos times[12;xT];
pri:tos oneof["SUN"];
del:{$[x~`U;oneof"13";x~`N;chr"2";zero]};
bind[(opt del::);pri];
ahd:seqA ioid,tpe,add,bind[(opt del::);pri];

/ block 3, user header
kl:103 113 108 119 115!((times . ::)')((3;aT);(4;xT);(16;xT);(8;cT);(32;xT));
uhd:many field kl;

/ block 4, text
txt:zero;

/ SWIFT parser
p:seql[many block 1 2 3 4!bhd,ahd,uhd,txt;eof];
swift:rparse[p];

\d .

