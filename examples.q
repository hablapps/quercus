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
lp:.qu.many1[.qu.plus[.qu.anm;.qu.c"."]];

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
pe"oscar.nydza@habla.dev" / valid
pe"a@b@c@example.com" / non valid
pe"oscar.nydza@domain.subdomain.tld" / valid

