// make sure you are on the proper path
\l quercus.q

// -----------------------
// IPv4 address validated as it's being consumed
// Subnet: 3 digits lower than 255 combined
sn:.qu.fil[(255>"J"$)][.qu.plus[.qu.times[3;.qu.digit];.qu.plus[.qu.times[2;.qu.digit];.qu.times[1;.qu.digit]]]];
/ fil[(255>"J"$)][((plus/)times[;digit] each 3 2 1)]

// \[\d{3}(?:\.\d{3})\] with subnet validation
ipv4:.qu.seqf[raze(,).][sn;.qu.times[3;.qu.seq[.qu.chr["."];sn]]]

lc:("192.168.1.1";
    "45.75.4.75";
    "156.255.1.27");
show .qu.vparse[enlist first ipv4::] each lc;


// -----------------------
// Matching an email with the following parts:
// {local_part}@{domain}
// where {domain} should be either a regular domain or an IPv4 address

// Email local part (simple)
// [a-zA-Z0-9\.]+
lp:.qu.many1[.qu.plus[.qu.alphanum;.qu.chr"."]];

// Regular domain name
// \w+\.(?:\.\w+)*\.\w+
dn:(.qu.seqf[raze raze::]/)(.qu.word;.qu.many[.qu.seq[.qu.chr["."];.qu.word]];.qu.chr["."];.qu.word);

// Email ipv4 is surrounded by brackets
eipv4:(.qu.seqf[(,).]/)(.qu.chr["["];ipv4;.qu.chr["]"]);

// Email pattern
pe:(.qu.seqf[(,).]/)(lp;.qu.chr["@"];.qu.plus[dn;eipv4]);

// Evaluating
le:("local.part@habla.dev"; / valid
    "a@b@c@example.com"; / non valid
    "local.part@domain.subdomain.tld"; / valid
    "local.part@[192.168.1.2]"); / valid

show .qu.vparse[enlist first pe::] each le;

// -----------------------
v:til[23]!"TRWAGMYFPDXBNJZSQVHLCKE";

// Spanish ID pattern with validation on the fly
// \d{8}[A-Z]
dnip:.qu.fil[{x[1]~v x[0]mod 23}].qu.seq[.qu.j;.qu.upr];

ids:("78187169A";
     "97404065P";
     "50625576T";
     "00148482V";
     "40548751G";
     "40548251G");

show .qu.vparse[dnip] each ids;

// -----------------------
// ISIN
isins:("US0378331005";
       "US0373831005";
       "U50378331005";
       "US03378331005";
       "AU0000XVGZA3";
       "AU0000VXGZA3";
       "FR0000988040");
// Validation functions
toBase10:{raze string .Q.nA?x};
luhn:{
  r:reverse x;
  oddN:("J"$)each r where odd:count[r]#10b;
  evenN:("J"$)each raze string 2*("J"$) each r where not odd;
  0=(sum oddN, evenN)mod 10};

// ISIN
// [A-Z]{2}\w{9}\d
isinp:(.qu.seqf[(,).]/)(.qu.times[2;.qu.upr];.qu.times[9;.qu.alphanum];.qu.digit);

// Validate on the fly
show .qu.vparse[.qu.fil[(luhn toBase10::)][isinp]] each isin;
