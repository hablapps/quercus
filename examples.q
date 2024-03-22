// make sure you are on the proper path
\l quercus.q

// -----------------------
// IPv4 address validated as it's being consumed
// Subnet: 3 digits lower than 255 combined
sn:.qu.fil[(255>"J"$)][.qu.plus[.qu.times[3;.qu.digit];.qu.plus[.qu.times[2;.qu.digit];.qu.times[1;.qu.digit]]]];
/ fil[(255>"J"$)][((plus/)times[;digit] each 3 2 1)]

// \[\d{3}(?:\.\d{3})\] with subnet validation
ipv4:.qu.seqf[raze(,).][sn;.qu.times[3;.qu.seq[.qu.chr["."];sn]]]

// -----------------------
// Matching an email with the following parts:
// {local_part}@{domain}
// where {domain} should be either a regular domain or an IPv4 address

// Email local part (simple)
// [a-zA-Z0-9\.]+
lp:.qu.many1[.qu.plus[.qu.alphanum;.qu.c"."]];

// Regular domain name
// \w+\.(?:\.\w+)*\.\w+
dn:(.qu.seqf[raze raze::]/)(.qu.word;.qu.many[.qu.seq[.qu.chr["."];.qu.word]];.qu.chr["."];.qu.word);

// Email ipv4 is surrounded by brackets
eipv4:(.qu.seq/)(.qu.c["["];ipv4;.qu.c["]"]);

// Email pattern
pe:lp seq .qu.c["@"] seq .qu.plus[dn;eipv4];

// Evaluating
show pe"oscar.nydza@habla.dev"; / valid
show pe"a@b@c@example.com"; / non valid
show pe"oscar.nydza@domain.subdomain.tld"; / valid

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

show dnip each ids;

// -----------------------
// ISIN
isin:"AU0000XVGZA3"
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
show .qu.fil[(luhn toBase10::)][isinp] isin
