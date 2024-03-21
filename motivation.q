// DNI

ids:("78187169A";
     "97404065P";
     "50625576T";
     "00148482V";
     "40548751G";
     "40548251G")

v:til[23]!"TRWAGMYFPDXBNJZSQVHLCKE"

i:"78187169A"

validate:{[i;v]v[("J"$neg[1]_i)mod 23]~last[i]}[;v]

validate each ids

// ISIN

toBase10:{ raze string .Q.nA?x }

luhn:{ 
    r: reverse x; 
    oddN: ("J"$) each r where odd:count[r]#10b; 
    evenN: ("J"$) each raze string 2*("J"$) each r where not odd; 
    0 = (sum oddN, evenN) mod 10} 

validateISIN:{ (luhn toBase10 x) and (all x[0 1] in .Q.A) and ((last x) in .Q.n) and (12 >= count x) }


icases:("US0378331005";
        "US0373831005";
        "U50378331005";
        "US03378331005";
        "AU0000XVGZA3";
        "AU0000VXGZA3";
        "FR0000988040")
all 1000111b=validateISIN each icases


// FIX
s:"8=FIX.4.2|9=178|35=8|49=PHLX|56=PERS|52=20071123-05:30:00.000|11=ATOMNOCCC9990900|20=3|150=E|39=E|55=MSFT|167=CS|54=1|38=15|40=2|44=15|58=PHLX EQUITY TESTING|59=0|47=C|32=0|31=0|151=15|14=0|6=0|10=128|"
sep:"|"

i:8 9 35 49 56 52 11 20 150 39 55 167 54 38 40 44 58 59 47 32 31 151 14 6 10 34 98 108
t:`BeginString`BodyLength`MsgType`SenderCompID`TargetCompID`SendingTime`ClOrdID,
  `ExecTransType`ExecType`OrdStatus`Symbol`SecurityType`Side`OrderQty`OrdType,
  `Price`Text`TimeInForce`Rule80A`LastShares`LastPx`LeavesQty`CumQty`AvgPx`CheckSum,
  `MsgSeqNum`EncryptMethod`HeartBtInt

d:i!t

bd:{[s;sep]
  l:sep vs s;
  p:flip {"="vs x} each $[last[l]~"";neg[1]_l;l];
  (d["J"$first[p]])!last p}

bd[s;sep]

cs:{[s;sep]
  ((sum[cs]+count[cs:{sum"j"$x}each neg[2]_sep vs s])mod 256)="J"$neg[1]_(3+(first s ss "10="))_s}

e:"8=FIX.4.2|9=65|35=A|49=SERVER|56=CLIENT|34=177|52=20090107-18:15:16|98=0|108=30|10=062|"

cs[s;sep]
cs[e;sep]

