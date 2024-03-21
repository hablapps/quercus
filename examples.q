// make sure you are on the proper path
\l quercus.q

// Matching an email with the following parts:
// {local_part}@{domain}
// where {domain} should be either a regular domain or an IPv4 address

// Make seq and times available with infix notation:
.q.set:.qu.seq;
.q.times:.qu.times;

// Email local part (simple)
// [a-zA-Z0-9\.]+
lp:.qu.many1[.qu.plus[.qu.alphanum;.qu.c"."]];

// Regular domain name
// \w+\.(?:\.\w+)*\.\w+
dn:.qu.word seq .qu.many[.qu.c["."] seq .qu.word] seq .qu.c["."] seq .qu.word;

// IPv4 address validated as it's being consumed
// Subnet: 3 digits lower than 255 combined
sn:.qu.fil[.qu.j][(255>)];
// \[\d{3}(?:\.\d{3})\] with subnet validation
ipv4:.qu.c["["] seq sn seq (3 times .qu.c["."] seq sn) seq .qu.c["]"];

// Email pattern
pe:lp seq .qu.c["@"] seq .qu.plus[dn;ipv4];

// Evaluating
show pe"oscar.nydza@habla.dev"; / valid
show pe"a@b@c@example.com"; / non valid
show pe"oscar.nydza@domain.subdomain.tld"; / valid


// Spanish ID
// given this list of ids, validate them:
ids:("78187169A";
     "97404065P";
     "50625576T";
     "00148482V";
     "40548751G";
     "40548251G");

v:til[23]!"TRWAGMYFPDXBNJZSQVHLCKE";

// DNI pattern with validation on the fly
dnip:.qu.bind[{[x;y;v]$[v[x mod 23]=first y;.qu.ret[string[x],y;""];()]}[;;v]][.qu.j];

// validate each DNI
show dnip each ids;

