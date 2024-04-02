# Motivation

Say you wanted to validate email addresses on your q program. You receive a string as a parameter for your function and then... then what?

An early approach could be to rely on regular expressions, since you can clearly see a pattern of `{local part}@{domain}`, where the domain could be a regular one or an IPv4 address, but then you realize that you either use a _very_ limited set of operators provided by q or you load a C library of sorts using Dynamic Loading...

After some thought, you come to the conclussion that the best option available to you is to leverage the array processing capabilities that q offers and treat the input string as an array. In the end, you may arrive to something like this:

```q
// IPv4

vipv4:{p:"."vs x;$[1<count p;all{255>"J"$x}each p;0b]};

show vipv4 "192.168.1.45";

// Email

ve:{$[2~count(lp;d):"@" vs x;
  [lpc:all lp in .Q.a,.Q.A,.Q.n,"._-";
    dc:((1<count dp:"."vs d)and
         all d in .Q.a,enlist".")or
       vipv4 1_neg[1]_d;
    lpc and dc];
  0b]};

show ve "test@example.com";
```

Seems a bit cumbersome if you ask me. You need to divide the string several times based on a couple of delimiters, and then based on that perform some checks... You start to lose sight of the pattern you were given and begin focusing on the string components themselves.

Querqus provides an abstraction over the string contents and lets you focus on the pattern itself, following the parser combinator principles. If you were to try to detect an email using Querqus, you would need to define the patterns using combinators.

For example, to detect an IPv4 address we could define our pattern like this:

```q
// Subnet (number lower than 255)
// [0-9]{1,3} with validation
sn:.qu.fil[(255>"J"$)][.qu.plus[.qu.times[3;.qu.digit];.qu.plus[.qu.times[2;.qu.digit];.qu.digit]]];
```

Here we can see the first major advantage of using Querqus: we can validate a pattern while it's being processed. On that specific line of code, we are saying "we want a number of either 3, 2 or 1 digits long, and it needs to be lower than 255". That "lower than 255" bit is important, since that cannot be performed using regular expressions so easily. Let's continue with our example:

```q
// IPv4
// xxx.xxx.xxx.xxx
ipv4:.qu.seqf[raze(,).][sn;.qu.times[3;.qu.seq[.qu.chr["."];sn]]]
```

On that line of code we specify that we want a sequence of a subnet `sn`, and then "3 times a literal dot `.` followed by a subnet `sn`".

Finally, to actually match an email, we can do the following:

```q
// Email local part (simple)
// [a-zA-Z0-9\.]+
lp:.qu.many1[.qu.plus[.qu.alphanum;.qu.chr"."]];

// Regular domain name
// \w+\.(?:\.\w+)*\.\w+
dn:(.qu.seqf[raze raze::]/)(.qu.word;.qu.many[.qu.seq[.qu.chr["."];.qu.word]];.qu.chr["."];.qu.word);

// Email IPv4 is surrounded by brackets
eipv4:(.qu.seqf[(,).]/)(.qu.chr["["];ipv4;.qu.chr["]"]);

// Actual email pattern
pe:(.qu.seqf[(,).]/)(lp;.qu.chr["@"];.qu.plus[dn;eipv4]);
```

You may be wondering: "Isn't there a lot more code than before?" and yes, you would be right, but may have noticed as well that we are creating _parsers_, not operating on the string itself, and that we can reuse parsers inside other parsers, combining them (thus the name "parser combinators").

This `pe` pattern that we have developed could be used like so:

```q
le:("local.part@example.com"; / valid
    "a@b@c@example.com"; / non valid
    "local.part@domain.subdomain.tld"; / valid
    "local.part@[192.168.1.2]"); / valid

show .qu.vparse[enlist first pe::] each le;
```

For more examples like this, check out [examples.md]().







