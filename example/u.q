block:{braces bind[{map[y,enlist::]x y}[x]] seql[tos upto[3;alphanum];chr":"]};
field:block;
dec:map[("F"$ssr[;",";"."]::)] among[1;;dT]::;
reify:map enlist;
yymmdd:tod times[6;nT];
hhmm:tot times[4;nT];
hhmmss:tot times[6;nT];
ssx:map[`time$(10*)::]toj times[2;nT];
YYMMDDSSss:map[sum]seqA yymmdd,hhmmss,opt ssx;
dsh:chr"-";
slsh:chr"/";
kv2d:map[(!). flip::];
seqd:{kv2d seqA key[x] {map[enlist(x,)::]reify y}' value x};
lines:{upto[x;seql[y;eol]]};
sl:opt seqr[slsh]::;
party:seql[sl[aT],sl[upto[34;xT]];opt eol];
idcod:seqA ((reify')times[4;aT],times[2;aT],times[2;cT]),opt times[3;cT];
mir:mor:seqA yymmdd,
             (reify times[12;cT]),
             (reify times[3;cT]),
             (toj')times[4;nT],times[6;nT];
nme:seqr[chr":";seql[tos many1 alphanum;chr":"]];
sub:bind[{map[{(x;y)}[x]](get`.b4)x}]nme;
man:fil[all `20`23B in key::];
val:all(1_value get`.val)@\: ::;

