\l ../quercus.q
\d .qu

/ types
aT:upr;
cT:plus[upr;digit];
dT:plus[chr",";digit];
hT:plus[range ."AF";digit];
nT:digit;
xT:plus[alphanum;oneof"/–?:().,‘+"];

/ type utils
todec:map[("F"$ssr[;",";"."]::)];
reify:map enlist;
yymmdd:tod times[6;nT];
hhmm:tot times[4;nT];
hhmmss:tot times[6;nT];
ssx:map[(`time$(10*)::)]toj times[2;nT];
YYMMDDSSss:map[sum]seqA yymmdd,hhmmss,opt ssx;
dsh:chr"-";
slsh:chr"/";
kv2d:map[(!). flip::];
seqd:{kv2d seqA key[x] {map[enlist(x,)::]reify y}' value x};
mir:mor:seqA yymmdd,
             (reify times[12;cT]),
             (reify times[3;cT]),
             (toj')times[4;nT],times[6;nT];

/ block
block:{braces bind[{map[y,enlist::]x y}[x]] seql[tos upto[3;alphanum];chr":"]};
field:block;

/ block 1, basic header
.b1.AppID:oneof"AFL";
.b1.ServiceID:plus .(str')("01";"21");
.b1.LTAddress:times[12;xT];
.b1.SessionNumber:toj times[4;nT];
.b1.SequenceNumber:toj times[6;nT];
.sw.1:seqd 1_get`.b1;

/ block 2, application header
.b2I.MessageType:times[3;nT];
.b2I.DestinationAddress:times[12;xT];
.b2I.Priority:opt oneof"SUN";
.b2I.DeliveryMonitoring:opt oneof"123";
.b2I.ObsolescencePeriod:opt plus .(str')("003";"020");
.b2O.MessageType:times[3;nT];
.b2O.InputTime:hhmm;
.b2O.MIR:seqA yymmdd,(reify times[12;cT]),(toj')times[4;nT],times[6;nT];
.b2O.OutputDate:yymmdd;
.b2O.OutputTime:hhmm;
.b2O.Priority:opt oneof"SUN";
.sw.2:bind[seqd 1_get `.b2I`.b2O "O"~ ::]oneof"IO";

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
.sw.3:fil[all `103`121 in key::] kv2d many1 field get`.b3;

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
.sw.4:man seql[map[(!). flip::]many1 seqr[chr"\n";sub];str"\n-"];

/ block 5, trailers
.b5.CHK:times[12;hT];
.b5.TNG:ret();
.b5.PDE:mir;
.b5.DLM:ret();
.b5.MRF:yymmdd,hhmm,mir;
.b5.PDM:mor;
.b5.SYS:mir;
.sw.5:fil[`CHK in key::] kv2d many1 field get`.b5;

/ SWIFT parser
p:seql[many block get`.sw;eof];
swift:rparse[p];
\d .

